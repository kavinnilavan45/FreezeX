from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from pydantic import BaseModel
from datetime import datetime, timezone, timedelta
import httpx
import uuid

from database import Base, engine, SessionLocal
import models
from security import hash_password, verify_password


# ============================================================
# DATABASE
# ============================================================

Base.metadata.create_all(bind=engine)


# ============================================================
# FASTAPI APP
# ============================================================

app = FastAPI(
    title="FreezeX API",
    description="Backend API for FreezeX cross-border payments",
    version="1.5.0",
)


# ============================================================
# CORS
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# DATABASE SESSION
# ============================================================

def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


# ============================================================
# BASIC ROUTES
# ============================================================

@app.get("/")
def root():
    return {
        "message": "FreezeX API is running",
        "status": "success",
        "version": "1.5.0",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


# ============================================================
# SIGNUP
# ============================================================

class SignupRequest(BaseModel):
    name: str
    email: str
    password: str
    role: str
    country: str = ""
    phone: str = ""
    company_name: str = ""
    company_type: str = ""
    business_description: str = ""
    skills: str = ""
    experience: str = ""
    about: str = ""
    looking_for: str = ""


@app.post("/signup")
def signup(
    data: SignupRequest,
    db: Session = Depends(get_db)
):
    role = data.role.lower().strip()

    if role not in ["client", "freelancer"]:
        raise HTTPException(
            status_code=400,
            detail="Role must be client or freelancer"
        )

    if not data.name.strip():
        raise HTTPException(
            status_code=400,
            detail="Name is required"
        )

    if not data.email.strip():
        raise HTTPException(
            status_code=400,
            detail="Email is required"
        )

    if not data.password.strip():
        raise HTTPException(
            status_code=400,
            detail="Password is required"
        )

    existing_user = (
        db.query(models.User)
        .filter(models.User.email == data.email)
        .first()
    )

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )

    user = models.User(
        name=data.name.strip(),
        email=data.email.strip(),
        password=hash_password(data.password),
        role=role,
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    profile = models.Profile(
        user_id=user.id,
        country=data.country.strip(),
        phone=data.phone.strip(),
        company_name=data.company_name.strip(),
        company_type=data.company_type.strip(),
        business_description=data.business_description.strip(),
        skills=data.skills.strip(),
        experience=data.experience.strip(),
        about=data.about.strip(),
        looking_for=data.looking_for.strip(),
    )
    db.add(profile)
    if role == "client":
        db.add(models.Subscription(client_id=user.id, status="ACTIVE"))
    db.commit()

    return {
        "message": "Account created successfully",
        "user_id": user.id,
        "name": user.name,
        "email": user.email,
        "role": user.role,
    }


# ============================================================
# LOGIN
# ============================================================

class LoginRequest(BaseModel):
    email: str
    password: str
    role: str


@app.post("/login")
def login(
    data: LoginRequest,
    db: Session = Depends(get_db)
):
    role = data.role.lower().strip()

    if role not in ["client", "freelancer"]:
        raise HTTPException(
            status_code=400,
            detail="Role must be client or freelancer"
        )

    user = (
        db.query(models.User)
        .filter(models.User.email == data.email)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    if not verify_password(data.password, user.password):
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    if user.role != role:
        raise HTTPException(
            status_code=403,
            detail=f"This account is registered as {user.role}"
        )

    return {
        "message": "Login successful",
        "user_id": user.id,
        "name": user.name,
        "email": user.email,
        "role": user.role,
    }


# ============================================================
# LIVE USD / INR FX RATE
# ============================================================

@app.get("/fx/usd-inr")
async def get_usd_inr_rate():

    try:
        url = "https://open.er-api.com/v6/latest/USD"

        async with httpx.AsyncClient(timeout=10) as client:
            response = await client.get(url)

        response.raise_for_status()

        data = response.json()

        if "rates" not in data:
            raise Exception("Rates not found in FX response")

        if "INR" not in data["rates"]:
            raise Exception("INR rate not found")

        rate = float(data["rates"]["INR"])

        return {
            "currency_pair": "USD/INR",
            "rate": rate,
            "source": "ExchangeRate-API",
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    except Exception as e:

        raise HTTPException(
            status_code=502,
            detail=f"Unable to fetch FX rate: {str(e)}",
        )


# ============================================================
# KYC VERIFICATION
# ============================================================

class KYCRequest(BaseModel):
    name: str
    email: str
    country: str
    identity_verified: bool


@app.post("/kyc/verify")
def verify_kyc(data: KYCRequest):

    if data.identity_verified:

        return {
            "status": "VERIFIED",
            "kyc_passed": True,
            "name": data.name,
            "email": data.email,
            "country": data.country,
            "provider": "FreezeX KYC Prototype",
            "simulation": True,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    return {
        "status": "REVIEW REQUIRED",
        "kyc_passed": False,
        "name": data.name,
        "email": data.email,
        "country": data.country,
        "provider": "FreezeX KYC Prototype",
        "simulation": True,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# AML CHECK
# ============================================================

class AMLRequest(BaseModel):
    name: str
    country: str
    wallet_address: str = ""


@app.post("/compliance/aml-check")
def aml_check(data: AMLRequest):

    # Prototype AML logic
    aml_passed = True
    risk_level = "LOW"

    return {
        "status": "CLEAR" if aml_passed else "REVIEW",
        "aml_passed": aml_passed,
        "risk_level": risk_level,
        "name": data.name,
        "country": data.country,
        "wallet_address": data.wallet_address,
        "provider": "FreezeX AML Prototype",
        "simulation": True,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# FRAUD CHECK
# ============================================================

class FraudRequest(BaseModel):
    amount_usd: float
    identity_verified: bool
    kyc_passed: bool
    aml_passed: bool


@app.post("/fraud/check")
def fraud_check(data: FraudRequest):

    if data.amount_usd <= 0:
        raise HTTPException(
            status_code=400,
            detail="Amount must be greater than zero"
        )

    risk_score = 0
    reasons = {}

    # Identity check
    if not data.identity_verified:
        risk_score += 30
        reasons["identity"] = "Identity not verified"

    # KYC check
    if not data.kyc_passed:
        risk_score += 30
        reasons["kyc"] = "KYC failed"

    # AML check
    if not data.aml_passed:
        risk_score += 40
        reasons["aml"] = "AML check failed"

    # Amount risk
    if data.amount_usd >= 10000:
        risk_score += 20
        reasons["amount"] = "High transaction amount"

    elif data.amount_usd >= 5000:
        risk_score += 10
        reasons["amount"] = "Medium transaction amount"

    # Decision
    if risk_score >= 70:
        decision = "BLOCK"
        approved = False

    elif risk_score >= 30:
        decision = "REVIEW"
        approved = False

    else:
        decision = "APPROVE"
        approved = True

    return {
        "amount_usd": data.amount_usd,
        "risk_score": risk_score,
        "decision": decision,
        "approved": approved,
        "reasons": reasons,
        "provider": "FreezeX Fraud Engine",
        "simulation": True,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# COMBINED COMPLIANCE CHECK
# ============================================================

class ComplianceRequest(BaseModel):
    name: str
    email: str
    country: str
    identity_verified: bool


@app.post("/compliance/check")
def compliance_check(data: ComplianceRequest):

    kyc_passed = data.identity_verified

    aml_passed = True

    approved = kyc_passed and aml_passed

    return {
        "approved": approved,
        "status": "APPROVED" if approved else "REVIEW REQUIRED",
        "identity_verified": data.identity_verified,
        "kyc_passed": kyc_passed,
        "aml_passed": aml_passed,
        "provider": "FreezeX Compliance Prototype",
        "simulation": True,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# PAYMENT DATABASE HELPERS
# ============================================================

def payment_to_dict(payment):
    """Convert a Payment ORM row into the frontend-friendly response shape."""
    return {
        "payment_id": payment.payment_id,
        "client_id": payment.client_id,
        "freelancer": {
            "name": payment.freelancer_name,
            "email": payment.freelancer_email,
            "country": payment.freelancer_country,
            "wallet_address": payment.freelancer_wallet or "",
        },
        "project": payment.project,
        "payment": {
            "amount_usd": float(payment.amount_usd),
            "amount_inr": float(payment.amount_inr or 0),
            "currency_from": "USD",
            "currency_to": "INR",
        },
        "fx": {
            "pair": "USD/INR",
            "rate": float(payment.fx_rate or 0),
            "locked_rate": float(payment.locked_fx_rate or 0),
            "markup": 0.0,
            "source": payment.fx_source or "ExchangeRate-API",
            "status": "LOCKED" if payment.rate_status == "LOCKED" else "AVAILABLE_FOR_LOCK",
        },
        "compliance": payment.compliance_data or {},
        "fraud": payment.fraud_data or {},
        "fees": payment.fees_data or {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },
        "route": payment.route_data or {},
        "lock": payment.lock_data or {},
        "contract": payment.contract_data or {},
        "blockchain": payment.blockchain_data or {},
        "settlement": payment.settlement_data or {},
        "status": payment.status,
        "simulation": True,
        "created_at": payment.created_at.isoformat() if payment.created_at else None,
        "updated_at": payment.updated_at.isoformat() if payment.updated_at else None,
    }


def save_payment(db: Session, values: dict):
    payment = models.Payment(**values)
    db.add(payment)
    db.commit()
    db.refresh(payment)
    return payment


def get_payment_or_404(db: Session, payment_id: str):
    payment = (
        db.query(models.Payment)
        .filter(models.Payment.payment_id == payment_id)
        .first()
    )
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    return payment

# ============================================================
# PAYMENT CREATION / ORCHESTRATION
# ============================================================

class PaymentCreateRequest(BaseModel):
    client_id: int
    freelancer_name: str
    freelancer_email: str
    country: str
    amount_usd: float
    project: str
    identity_verified: bool = True
    wallet_address: str = ""


@app.post("/payments/create")
async def create_payment(
    data: PaymentCreateRequest,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # BASIC VALIDATION
    # --------------------------------------------------------

    if data.amount_usd <= 0:

        raise HTTPException(
            status_code=400,
            detail="Payment amount must be greater than 0",
        )

    if not data.freelancer_name.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer name is required",
        )

    if not data.freelancer_email.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer email is required",
        )

    if not data.country.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer country is required",
        )

    if not data.project.strip():

        raise HTTPException(
            status_code=400,
            detail="Project name is required",
        )

    # --------------------------------------------------------
    # 1. KYC
    # --------------------------------------------------------

    kyc_passed = data.identity_verified

    # --------------------------------------------------------
    # 2. AML
    # --------------------------------------------------------

    aml_passed = True
    aml_risk_level = "LOW"

    # --------------------------------------------------------
    # 3. FRAUD
    # --------------------------------------------------------

    risk_score = 0
    fraud_reasons = {}

    if not data.identity_verified:

        risk_score += 30
        fraud_reasons["identity"] = "Identity not verified"

    if not kyc_passed:

        risk_score += 30
        fraud_reasons["kyc"] = "KYC failed"

    if not aml_passed:

        risk_score += 40
        fraud_reasons["aml"] = "AML check failed"

    if data.amount_usd >= 10000:

        risk_score += 20
        fraud_reasons["amount"] = "High transaction amount"

    elif data.amount_usd >= 5000:

        risk_score += 10
        fraud_reasons["amount"] = "Medium transaction amount"

    if risk_score >= 70:

        fraud_decision = "BLOCK"
        fraud_approved = False

    elif risk_score >= 30:

        fraud_decision = "REVIEW"
        fraud_approved = False

    else:

        fraud_decision = "APPROVE"
        fraud_approved = True

    # --------------------------------------------------------
    # STOP PAYMENT IF COMPLIANCE / FRAUD FAILS
    # --------------------------------------------------------

    if not kyc_passed:

        return {
            "payment_id": f"FX-{uuid.uuid4().hex[:10].upper()}",
            "status": "REVIEW REQUIRED",
            "reason": "KYC verification failed",
            "kyc": "FAILED",
            "aml": "CLEAR",
            "fraud": fraud_decision,
            "risk_score": risk_score,
            "simulation": True,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    if not aml_passed:

        return {
            "payment_id": f"FX-{uuid.uuid4().hex[:10].upper()}",
            "status": "BLOCKED",
            "reason": "AML screening failed",
            "kyc": "PASSED",
            "aml": "FAILED",
            "fraud": fraud_decision,
            "risk_score": risk_score,
            "simulation": True,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    if not fraud_approved:

        return {
            "payment_id": f"FX-{uuid.uuid4().hex[:10].upper()}",
            "status": "REVIEW REQUIRED",
            "reason": "Fraud engine requires review",
            "kyc": "PASSED",
            "aml": "CLEAR",
            "fraud": fraud_decision,
            "risk_score": risk_score,
            "fraud_reasons": fraud_reasons,
            "simulation": True,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    # --------------------------------------------------------
    # 4. GET LIVE FX RATE
    # --------------------------------------------------------

    try:

        fx_url = "https://open.er-api.com/v6/latest/USD"

        async with httpx.AsyncClient(timeout=10) as client:

            fx_response = await client.get(fx_url)

        fx_response.raise_for_status()

        fx_data = fx_response.json()

        if "rates" not in fx_data:

            raise Exception("FX rates unavailable")

        if "INR" not in fx_data["rates"]:

            raise Exception("INR rate unavailable")

        fx_rate = float(fx_data["rates"]["INR"])

    except Exception as e:

        raise HTTPException(
            status_code=502,
            detail=f"Unable to fetch live FX rate: {str(e)}",
        )

    # --------------------------------------------------------
    # 5. CALCULATE INR PAYOUT
    # --------------------------------------------------------

    inr_amount = round(
        data.amount_usd * fx_rate,
        2
    )

    # --------------------------------------------------------
    # 6. ROUTE OPTIMIZATION
    # --------------------------------------------------------

    routes = [
        {
            "route": "USA → USDC → INDIA",
            "infrastructure_cost": 4.20,
            "estimated_minutes": 3,
            "risk": 6.5,
        },
        {
            "route": "USA → UAE → INDIA",
            "infrastructure_cost": 10.40,
            "estimated_minutes": 10,
            "risk": 8.0,
        },
        {
            "route": "USA → INDIA",
            "infrastructure_cost": 18.00,
            "estimated_minutes": 2880,
            "risk": 10.0,
        },
    ]

    def route_score(route):

        return (
            route["infrastructure_cost"] * 5
            + route["estimated_minutes"] * 0.01
            + route["risk"] * 2
        )

    routes.sort(key=route_score)

    best_route = routes[0]

    # --------------------------------------------------------
    # 7. PAYMENT ID
    # --------------------------------------------------------

    payment_id = (
        f"FX-{datetime.now(timezone.utc).strftime('%Y%m%d')}-"
        f"{uuid.uuid4().hex[:8].upper()}"
    )

    # --------------------------------------------------------
    # 8. SAVE PAYMENT TO POSTGRESQL
    # --------------------------------------------------------

    payment_row = save_payment(db, {
        "payment_id": payment_id,
        "client_id": data.client_id,
        "freelancer_name": data.freelancer_name.strip(),
        "freelancer_email": data.freelancer_email.strip(),
        "freelancer_country": data.country.strip(),
        "freelancer_wallet": data.wallet_address.strip(),
        "project": data.project.strip(),
        "amount_usd": round(data.amount_usd, 2),
        "amount_inr": inr_amount,
        "fx_rate": fx_rate,
        "locked_fx_rate": None,
        "fx_source": "ExchangeRate-API",
        "rate_status": "AVAILABLE",
        "status": "READY_FOR_RATE_LOCK",
        "compliance_data": {
            "identity_verified": data.identity_verified,
            "kyc": "PASSED",
            "aml": "CLEAR",
            "aml_risk": aml_risk_level,
        },
        "fraud_data": {
            "risk_score": risk_score,
            "decision": fraud_decision,
            "approved": fraud_approved,
            "reasons": fraud_reasons,
        },
        "fees_data": {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },
        "route_data": {
            "selected": best_route["route"],
            "infrastructure_cost": best_route["infrastructure_cost"],
            "estimated_minutes": best_route["estimated_minutes"],
            "risk": best_route["risk"],
        },
    })

    # --------------------------------------------------------
    # 9. FINAL PAYMENT RESPONSE
    # --------------------------------------------------------

    return {

        "payment_id": payment_id,

        "status": "READY_FOR_RATE_LOCK",

        "client_id": data.client_id,

        "freelancer": {
            "name": data.freelancer_name,
            "email": data.freelancer_email,
            "country": data.country,
            "wallet_address": data.wallet_address,
        },

        "project": data.project,

        "payment": {
            "amount_usd": round(data.amount_usd, 2),
            "amount_inr": inr_amount,
            "currency_from": "USD",
            "currency_to": "INR",
        },

        "fx": {
            "pair": "USD/INR",
            "rate": fx_rate,
            "markup": 0.0,
            "source": "ExchangeRate-API",
            "status": "AVAILABLE_FOR_LOCK",
        },

        "compliance": {
            "identity_verified": data.identity_verified,
            "kyc": "PASSED",
            "aml": "CLEAR",
            "aml_risk": aml_risk_level,
        },

        "fraud": {
            "risk_score": risk_score,
            "decision": fraud_decision,
            "approved": fraud_approved,
            "reasons": fraud_reasons,
        },

        "fees": {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },

        "route": {
            "selected": best_route["route"],
            "infrastructure_cost": best_route["infrastructure_cost"],
            "estimated_minutes": best_route["estimated_minutes"],
            "risk": best_route["risk"],
        },

        "next_step": "LOCK_FX_RATE",

        "simulation": True,

        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# FX RATE LOCK
# ============================================================

class RateLockRequest(BaseModel):
    amount_usd: float
    fx_rate: float


@app.post("/payments/{payment_id}/lock-rate")
def lock_fx_rate(
    payment_id: str,
    data: RateLockRequest,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VALIDATION
    # --------------------------------------------------------

    if not payment_id.strip():

        raise HTTPException(
            status_code=400,
            detail="Payment ID is required"
        )

    if data.amount_usd <= 0:

        raise HTTPException(
            status_code=400,
            detail="Amount must be greater than zero"
        )

    if data.fx_rate <= 0:

        raise HTTPException(
            status_code=400,
            detail="FX rate must be greater than zero"
        )

    # --------------------------------------------------------
    # CALCULATE LOCKED INR AMOUNT
    # --------------------------------------------------------

    locked_inr_amount = round(
        data.amount_usd * data.fx_rate,
        2
    )

    # --------------------------------------------------------
    # CREATE LOCK ID
    # --------------------------------------------------------

    lock_id = (
        f"LOCK-"
        f"{datetime.now(timezone.utc).strftime('%Y%m%d')}-"
        f"{uuid.uuid4().hex[:8].upper()}"
    )

    # --------------------------------------------------------
    # LOCK TIME
    # --------------------------------------------------------

    locked_at = datetime.now(timezone.utc)

    # Lock is valid for 15 minutes
    expires_at = locked_at + timedelta(minutes=15)

    payment = get_payment_or_404(db, payment_id)
    payment.locked_fx_rate = round(data.fx_rate, 6)
    payment.amount_inr = locked_inr_amount
    payment.rate_status = "LOCKED"
    payment.status = "FX_RATE_LOCKED"
    payment.lock_data = {
        "lock_id": lock_id,
        "locked_at": locked_at.isoformat(),
        "expires_at": expires_at.isoformat(),
        "valid_for_minutes": 15,
    }
    db.commit()

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {

        "payment_id": payment_id,

        "lock_id": lock_id,

        "status": "FX_RATE_LOCKED",

        "payment": {
            "amount_usd": round(data.amount_usd, 2),
            "amount_inr": locked_inr_amount,
            "currency_from": "USD",
            "currency_to": "INR",
        },

        "fx": {
            "pair": "USD/INR",
            "locked_rate": round(data.fx_rate, 6),
            "markup": 0.0,
            "status": "LOCKED",
        },

        "fees": {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },

        "lock": {
            "locked_at": locked_at.isoformat(),
            "expires_at": expires_at.isoformat(),
            "valid_for_minutes": 15,
        },

        "next_step": "SMART_CONTRACT",

        "simulation": True,

        "timestamp": datetime.now(
            timezone.utc
        ).isoformat(),
    }


# ============================================================
# SMART CONTRACT CREATION
# ============================================================

class SmartContractRequest(BaseModel):
    amount_usd: float
    amount_inr: float
    fx_rate: float
    freelancer_name: str
    freelancer_email: str
    project: str
    client_wallet: str = ""
    freelancer_wallet: str = ""


@app.post("/payments/{payment_id}/smart-contract")
def create_smart_contract(
    payment_id: str,
    data: SmartContractRequest,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VALIDATION
    # --------------------------------------------------------

    if not payment_id.strip():

        raise HTTPException(
            status_code=400,
            detail="Payment ID is required"
        )

    if data.amount_usd <= 0:

        raise HTTPException(
            status_code=400,
            detail="USD amount must be greater than zero"
        )

    if data.amount_inr <= 0:

        raise HTTPException(
            status_code=400,
            detail="INR amount must be greater than zero"
        )

    if data.fx_rate <= 0:

        raise HTTPException(
            status_code=400,
            detail="FX rate must be greater than zero"
        )

    if not data.freelancer_name.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer name is required"
        )

    if not data.freelancer_email.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer email is required"
        )

    if not data.project.strip():

        raise HTTPException(
            status_code=400,
            detail="Project is required"
        )

    # --------------------------------------------------------
    # VERIFY USD / INR / FX CALCULATION
    # --------------------------------------------------------

    calculated_inr = round(
        data.amount_usd * data.fx_rate,
        2
    )

    if abs(calculated_inr - data.amount_inr) > 0.05:

        raise HTTPException(
            status_code=400,
            detail="USD amount, INR amount and FX rate do not match"
        )

    # --------------------------------------------------------
    # CREATE SMART CONTRACT ID
    # --------------------------------------------------------

    contract_id = (
        f"SC-"
        f"{datetime.now(timezone.utc).strftime('%Y%m%d')}-"
        f"{uuid.uuid4().hex[:10].upper()}"
    )

    # --------------------------------------------------------
    # SIMULATED BLOCKCHAIN VALUES
    # --------------------------------------------------------

    transaction_hash = (
        "0x"
        + uuid.uuid4().hex
        + uuid.uuid4().hex
    )

    contract_address = (
        "0x"
        + uuid.uuid4().hex
        + uuid.uuid4().hex[:8]
    )

    created_at = datetime.now(timezone.utc)

    payment = get_payment_or_404(db, payment_id)
    payment.contract_data = {
        "contract_id": contract_id,
        "contract_address": contract_address,
        "network": "Polygon Amoy Testnet",
        "status": "CREATED",
        "created_at": created_at.isoformat(),
    }
    payment.blockchain_data = {
        "network": "Polygon Amoy Testnet",
        "transaction_hash": transaction_hash,
        "contract_address": contract_address,
        "confirmation_status": "SIMULATED",
    }
    payment.status = "SMART_CONTRACT_CREATED"
    db.commit()

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {

        "payment_id": payment_id,

        "contract": {
            "contract_id": contract_id,
            "contract_address": contract_address,
            "network": "Polygon Amoy Testnet",
            "status": "CREATED",
        },

        "payment": {
            "amount_usd": round(data.amount_usd, 2),
            "amount_inr": round(data.amount_inr, 2),
            "currency_from": "USD",
            "currency_to": "INR",
        },

        "fx": {
            "pair": "USD/INR",
            "locked_rate": round(data.fx_rate, 6),
            "markup": 0.0,
            "status": "LOCKED",
        },

        "parties": {
            "freelancer_name": data.freelancer_name,
            "freelancer_email": data.freelancer_email,
            "client_wallet": data.client_wallet,
            "freelancer_wallet": data.freelancer_wallet,
        },

        "project": data.project,

        "fees": {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },

        "blockchain": {
            "network": "Polygon Amoy Testnet",
            "transaction_hash": transaction_hash,
            "contract_address": contract_address,
            "confirmation_status": "SIMULATED",
        },

        "conditions": {
            "fx_rate_locked": True,
            "payment_amount_locked": True,
            "freelancer_verified": True,
            "compliance_verified": True,
            "fraud_check_passed": True,
        },

        "created_at": created_at.isoformat(),

        "next_step": "SETTLEMENT",

        "simulation": True,

        "timestamp": datetime.now(
            timezone.utc
        ).isoformat(),
    }


# ============================================================
# SETTLEMENT
# ============================================================

class SettlementRequest(BaseModel):
    amount_usd: float
    amount_inr: float
    fx_rate: float
    freelancer_name: str
    freelancer_email: str
    project: str
    contract_id: str
    transaction_hash: str = ""
    freelancer_wallet: str = ""


@app.post("/payments/{payment_id}/settle")
def settle_payment(
    payment_id: str,
    data: SettlementRequest,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VALIDATION
    # --------------------------------------------------------

    if not payment_id.strip():

        raise HTTPException(
            status_code=400,
            detail="Payment ID is required"
        )

    if data.amount_usd <= 0:

        raise HTTPException(
            status_code=400,
            detail="USD amount must be greater than zero"
        )

    if data.amount_inr <= 0:

        raise HTTPException(
            status_code=400,
            detail="INR amount must be greater than zero"
        )

    if data.fx_rate <= 0:

        raise HTTPException(
            status_code=400,
            detail="FX rate must be greater than zero"
        )

    if not data.contract_id.strip():

        raise HTTPException(
            status_code=400,
            detail="Contract ID is required"
        )

    if not data.freelancer_name.strip():

        raise HTTPException(
            status_code=400,
            detail="Freelancer name is required"
        )

    if not data.project.strip():

        raise HTTPException(
            status_code=400,
            detail="Project is required"
        )

    # --------------------------------------------------------
    # VERIFY PAYMENT CALCULATION
    # --------------------------------------------------------

    calculated_inr = round(
        data.amount_usd * data.fx_rate,
        2
    )

    if abs(calculated_inr - data.amount_inr) > 0.05:

        raise HTTPException(
            status_code=400,
            detail="USD amount, INR amount and FX rate do not match"
        )

    # --------------------------------------------------------
    # CREATE SETTLEMENT ID
    # --------------------------------------------------------

    settlement_id = (
        f"SET-"
        f"{datetime.now(timezone.utc).strftime('%Y%m%d')}-"
        f"{uuid.uuid4().hex[:10].upper()}"
    )

    # --------------------------------------------------------
    # SIMULATED TRANSACTION HASH
    # --------------------------------------------------------

    settlement_hash = (
        data.transaction_hash
        if data.transaction_hash.strip()
        else "0x"
        + uuid.uuid4().hex
        + uuid.uuid4().hex
    )

    # --------------------------------------------------------
    # SETTLEMENT TIME
    # --------------------------------------------------------

    settled_at = datetime.now(timezone.utc)

    payment = get_payment_or_404(db, payment_id)
    payment.settlement_data = {
        "settlement_id": settlement_id,
        "status": "COMPLETED",
        "settled_at": settled_at.isoformat(),
    }
    payment.blockchain_data = {
        "network": "Polygon Amoy Testnet",
        "transaction_hash": settlement_hash,
        "confirmation_status": "SIMULATED",
    }
    payment.contract_data = {
        "contract_id": data.contract_id,
        "status": "EXECUTED",
    }
    payment.locked_fx_rate = round(data.fx_rate, 6)
    payment.amount_inr = round(data.amount_inr, 2)
    payment.rate_status = "LOCKED"
    payment.status = "COMPLETED"
    db.commit()

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {

        "payment_id": payment_id,

        "settlement": {
            "settlement_id": settlement_id,
            "status": "COMPLETED",
            "settled_at": settled_at.isoformat(),
        },

        "payment": {
            "amount_usd": round(data.amount_usd, 2),
            "amount_inr": round(data.amount_inr, 2),
            "currency_from": "USD",
            "currency_to": "INR",
        },

        "fx": {
            "pair": "USD/INR",
            "locked_rate": round(data.fx_rate, 6),
            "markup": 0.0,
            "status": "LOCKED",
        },

        "freelancer": {
            "name": data.freelancer_name,
            "email": data.freelancer_email,
            "wallet_address": data.freelancer_wallet,
        },

        "project": data.project,

        "contract": {
            "contract_id": data.contract_id,
            "status": "EXECUTED",
        },

        "blockchain": {
            "network": "Polygon Amoy Testnet",
            "transaction_hash": settlement_hash,
            "confirmation_status": "SIMULATED",
        },

        "fees": {
            "client_fee": 0.0,
            "freelancer_fee": 0.0,
            "fx_markup": 0.0,
            "hidden_charges": 0.0,
        },

        "compliance": {
            "identity": "VERIFIED",
            "kyc": "PASSED",
            "aml": "CLEAR",
            "fraud": "APPROVED",
        },

        "route": {
            "selected": "USA → USDC → INDIA",
            "status": "OPTIMIZED",
        },

        "next_step": "TRANSACTION_COMPLETE",

        "simulation": True,

        "timestamp": datetime.now(
            timezone.utc
        ).isoformat(),
    }


# ============================================================
# TRANSACTION STATUS
# ============================================================

@app.get("/payments/{payment_id}/status")
def payment_status(
    payment_id: str,
    db: Session = Depends(get_db),
):
    payment = get_payment_or_404(db, payment_id)

    stages = [
        {"step": "PAYMENT_CREATED", "status": "COMPLETED"},
        {"step": "COMPLIANCE", "status": "PASSED"},
        {"step": "FRAUD_CHECK", "status": "APPROVED"},
        {
            "step": "FX_RATE_LOCK",
            "status": "COMPLETED" if payment.locked_fx_rate else "PENDING",
        },
        {
            "step": "SMART_CONTRACT",
            "status": "CREATED" if payment.contract_data else "PENDING",
        },
        {
            "step": "SETTLEMENT",
            "status": "COMPLETED" if payment.settlement_data else "PENDING",
        },
    ]

    return {
        "payment_id": payment.payment_id,
        "status": payment.status,
        "stages": stages,
        "payment": payment_to_dict(payment),
        "simulation": True,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ============================================================
# TRANSACTION HISTORY / DETAILS
# ============================================================

@app.get("/payments/client/{client_id}")
def client_transaction_history(
    client_id: int,
    db: Session = Depends(get_db),
):
    rows = (
        db.query(models.Payment)
        .filter(models.Payment.client_id == client_id)
        .order_by(models.Payment.created_at.desc())
        .all()
    )

    return {
        "client_id": client_id,
        "count": len(rows),
        "transactions": [payment_to_dict(row) for row in rows],
        "simulation": True,
    }


@app.get("/payments/freelancer/{freelancer_email}")
def freelancer_transaction_history(
    freelancer_email: str,
    db: Session = Depends(get_db),
):
    rows = (
        db.query(models.Payment)
        .filter(models.Payment.freelancer_email == freelancer_email.strip())
        .order_by(models.Payment.created_at.desc())
        .all()
    )

    return {
        "freelancer_email": freelancer_email,
        "count": len(rows),
        "transactions": [payment_to_dict(row) for row in rows],
        "simulation": True,
    }


@app.get("/payments/{payment_id}")
def transaction_details(
    payment_id: str,
    db: Session = Depends(get_db),
):
    payment = get_payment_or_404(db, payment_id)
    return payment_to_dict(payment)


@app.get("/dashboard/client/{client_id}")
def client_dashboard_stats(
    client_id: int,
    db: Session = Depends(get_db),
):
    rows = (
        db.query(models.Payment)
        .filter(models.Payment.client_id == client_id)
        .all()
    )

    total_usd = sum(float(row.amount_usd or 0) for row in rows)
    total_inr = sum(float(row.amount_inr or 0) for row in rows)
    completed = sum(1 for row in rows if row.status == "COMPLETED")
    pending = sum(1 for row in rows if row.status != "COMPLETED")

    return {
        "client_id": client_id,
        "transaction_count": len(rows),
        "completed_count": completed,
        "pending_count": pending,
        "total_usd": round(total_usd, 2),
        "total_inr": round(total_inr, 2),
        "user_fees": 0.0,
        "fx_markup": 0.0,
        "simulation": True,
    }


@app.get("/dashboard/freelancer/{freelancer_email}")
def freelancer_dashboard_stats(
    freelancer_email: str,
    db: Session = Depends(get_db),
):
    rows = (
        db.query(models.Payment)
        .filter(models.Payment.freelancer_email == freelancer_email.strip())
        .all()
    )

    total_usd = sum(float(row.amount_usd or 0) for row in rows)
    total_inr = sum(float(row.amount_inr or 0) for row in rows)
    completed = sum(1 for row in rows if row.status == "COMPLETED")
    pending = sum(1 for row in rows if row.status != "COMPLETED")

    return {
        "freelancer_email": freelancer_email,
        "transaction_count": len(rows),
        "completed_count": completed,
        "pending_count": pending,
        "total_usd": round(total_usd, 2),
        "total_inr": round(total_inr, 2),
        "received_fees": 0.0,
        "fx_markup": 0.0,
        "simulation": True,
    }


# ============================================================
# API STATUS
# ============================================================

@app.get("/api/status")
def api_status():

    return {
        "application": "FreezeX",
        "backend": "FastAPI",
        "database": "PostgreSQL",
        "fx": "ExchangeRate-API",
        "kyc": "FreezeX KYC Prototype",
        "aml": "FreezeX AML Prototype",
        "fraud": "FreezeX Fraud Engine",
        "payment_orchestration": "ACTIVE",
        "fx_rate_lock": "ACTIVE",
        "smart_contract": "SIMULATION",
        "blockchain": "Polygon Amoy Testnet SIMULATION",
        "settlement": "SIMULATION",
        "transaction_status": "ACTIVE",
        "postgresql_persistence": "ACTIVE",
        "transaction_history": "ACTIVE",
        "dashboard_statistics": "ACTIVE",
    }

# ============================================================
# ADMIN AUTH + PLATFORM MANAGEMENT
# ============================================================

class AdminLoginRequest(BaseModel):
    email: str
    password: str


@app.post("/admin/login")
def admin_login(data: AdminLoginRequest):
    # Demo admin credentials for the hackathon prototype.
    if data.email.strip().lower() != "admin@freezex.com" or data.password != "Admin@123":
        raise HTTPException(status_code=401, detail="Invalid admin credentials")
    return {"message": "Admin login successful", "role": "admin", "name": "FreezeX Admin"}


@app.get("/admin/overview")
def admin_overview(db: Session = Depends(get_db)):
    clients = db.query(models.User).filter(models.User.role == "client").all()
    freelancers = db.query(models.User).filter(models.User.role == "freelancer").all()
    subscriptions = db.query(models.Subscription).all()
    projects = db.query(models.Project).all()
    payments = db.query(models.Payment).all()
    return {
        "clients": len(clients),
        "freelancers": len(freelancers),
        "subscriptions": len(subscriptions),
        "active_subscriptions": sum(1 for s in subscriptions if s.status == "ACTIVE"),
        "projects": len(projects),
        "posted_projects": sum(1 for p in projects if p.status == "POSTED"),
        "payments": len(payments),
        "completed_payments": sum(1 for p in payments if str(p.status).upper() == "COMPLETED"),
    }


@app.get("/admin/clients")
def admin_clients(db: Session = Depends(get_db)):
    users = db.query(models.User).filter(models.User.role == "client").all()
    result = []
    for u in users:
        sub = db.query(models.Subscription).filter(models.Subscription.client_id == u.id).first()
        control = db.query(models.AccountControl).filter(models.AccountControl.user_id == u.id).first()
        result.append({"id": u.id, "name": u.name, "email": u.email, "subscription": sub.status if sub else "NONE", "status": control.status if control else "ACTIVE"})
    return {"clients": result}


@app.get("/admin/freelancers")
def admin_freelancers(db: Session = Depends(get_db)):
    users = db.query(models.User).filter(models.User.role == "freelancer").all()
    result = []
    for u in users:
        profile = db.query(models.Profile).filter(models.Profile.user_id == u.id).first()
        control = db.query(models.AccountControl).filter(models.AccountControl.user_id == u.id).first()
        result.append({"id": u.id, "name": u.name, "email": u.email, "skills": profile.skills if profile else "", "experience": profile.experience if profile else "", "status": control.status if control else "ACTIVE"})
    return {"freelancers": result}


@app.get("/admin/subscriptions")
def admin_subscriptions(db: Session = Depends(get_db)):
    subs = db.query(models.Subscription).all()
    result = []
    for s in subs:
        u = db.query(models.User).filter(models.User.id == s.client_id).first()
        result.append({"id": s.id, "client_id": s.client_id, "client_name": u.name if u else "Unknown", "email": u.email if u else "", "plan": s.plan, "amount": s.amount, "status": s.status})
    return {"subscriptions": result}


class SubscriptionStatusRequest(BaseModel):
    status: str


@app.put("/admin/subscriptions/{subscription_id}")
def admin_update_subscription(subscription_id: int, data: SubscriptionStatusRequest, db: Session = Depends(get_db)):
    sub = db.query(models.Subscription).filter(models.Subscription.id == subscription_id).first()
    if not sub:
        raise HTTPException(status_code=404, detail="Subscription not found")
    status = data.status.strip().upper()
    if status not in ["ACTIVE", "SUSPENDED", "PENDING"]:
        raise HTTPException(status_code=400, detail="Invalid subscription status")
    sub.status = status
    db.commit()
    return {"message": "Subscription updated", "id": sub.id, "status": sub.status}


@app.get("/admin/projects")
def admin_projects(db: Session = Depends(get_db)):
    projects = db.query(models.Project).order_by(models.Project.id.desc()).all()
    return {"projects": [{"id": p.id, "client_id": p.client_id, "title": p.title, "budget_usd": p.budget_usd, "status": p.status, "freelancer_email": p.freelancer_email} for p in projects]}


@app.get("/admin/payments")
def admin_payments(db: Session = Depends(get_db)):
    payments = db.query(models.Payment).order_by(models.Payment.id.desc()).all()
    return {"payments": [payment_to_dict(p) for p in payments]}


class AccountStatusRequest(BaseModel):
    status: str


@app.put("/admin/users/{user_id}/status")
def admin_update_user_status(user_id: int, data: AccountStatusRequest, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    status = data.status.strip().upper()
    if status not in ["ACTIVE", "SUSPENDED"]:
        raise HTTPException(status_code=400, detail="Invalid account status")
    control = db.query(models.AccountControl).filter(models.AccountControl.user_id == user_id).first()
    if not control:
        control = models.AccountControl(user_id=user_id, status=status)
        db.add(control)
    else:
        control.status = status
    db.commit()
    return {"message": "Account status updated", "user_id": user_id, "status": status}


# ============================================================
# CLIENT / FREELANCER MARKETPLACE
# ============================================================

class ProjectCreateRequest(BaseModel):
    client_id: int
    title: str
    description: str
    skills: str = ""
    budget_usd: float
    deadline: str = ""


@app.post("/projects")
def create_project(data: ProjectCreateRequest, db: Session = Depends(get_db)):
    if data.budget_usd <= 0:
        raise HTTPException(status_code=400, detail="Budget must be greater than 0")
    client = db.query(models.User).filter(models.User.id == data.client_id, models.User.role == "client").first()
    if not client:
        raise HTTPException(status_code=404, detail="Client not found")
    sub = db.query(models.Subscription).filter(models.Subscription.client_id == data.client_id).first()
    if not sub:
        sub = models.Subscription(client_id=data.client_id, status="ACTIVE")
        db.add(sub)
        db.commit()
    if sub.status != "ACTIVE":
        raise HTTPException(status_code=403, detail="Active FreezeX subscription is required to post a project")
    project = models.Project(client_id=data.client_id, title=data.title.strip(), description=data.description.strip(), skills=data.skills.strip(), budget_usd=data.budget_usd, deadline=data.deadline.strip(), status="POSTED")
    db.add(project)
    db.commit()
    db.refresh(project)
    return {"message": "Project posted successfully", "project": {"id": project.id, "title": project.title, "status": project.status}}


def _project_dict(p, db):
    client = db.query(models.User).filter(models.User.id == p.client_id).first()
    return {"id": p.id, "client_id": p.client_id, "client_name": client.name if client else "Client", "title": p.title, "description": p.description, "skills": p.skills, "budget_usd": p.budget_usd, "deadline": p.deadline, "status": p.status, "freelancer_id": p.freelancer_id, "freelancer_email": p.freelancer_email}


@app.get("/projects")
def list_projects(status: str = "POSTED", db: Session = Depends(get_db)):
    q = db.query(models.Project)
    if status:
        q = q.filter(models.Project.status == status.upper())
    projects = q.order_by(models.Project.id.desc()).all()
    return {"projects": [_project_dict(p, db) for p in projects]}


@app.get("/projects/client/{client_id}")
def client_projects(client_id: int, db: Session = Depends(get_db)):
    projects = db.query(models.Project).filter(models.Project.client_id == client_id).order_by(models.Project.id.desc()).all()
    return {"projects": [_project_dict(p, db) for p in projects]}


@app.get("/projects/freelancer/{email}")
def freelancer_projects(email: str, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email, models.User.role == "freelancer").first()
    if not user:
        return {"projects": []}
    projects = db.query(models.Project).filter(models.Project.freelancer_id == user.id).order_by(models.Project.id.desc()).all()
    return {"projects": [_project_dict(p, db) for p in projects]}


class JobAcceptRequest(BaseModel):
    freelancer_email: str


@app.post("/projects/{project_id}/accept")
def accept_project(project_id: int, data: JobAcceptRequest, db: Session = Depends(get_db)):
    project = db.query(models.Project).filter(models.Project.id == project_id).first()
    freelancer = db.query(models.User).filter(models.User.email == data.freelancer_email.strip(), models.User.role == "freelancer").first()
    if not project or not freelancer:
        raise HTTPException(status_code=404, detail="Project or freelancer not found")
    if project.status != "POSTED":
        raise HTTPException(status_code=400, detail="Project is no longer available")
    project.freelancer_id = freelancer.id
    project.freelancer_email = freelancer.email
    project.status = "IN_PROGRESS"
    app_record = models.JobApplication(project_id=project.id, freelancer_id=freelancer.id, freelancer_email=freelancer.email, status="ACCEPTED", accepted_at=datetime.now(timezone.utc))
    db.add(app_record)
    db.commit()
    return {"message": "Job accepted", "project": _project_dict(project, db)}


@app.post("/projects/{project_id}/apply")
def apply_project(project_id: int, data: JobAcceptRequest, db: Session = Depends(get_db)):
    project = db.query(models.Project).filter(models.Project.id == project_id).first()
    freelancer = db.query(models.User).filter(models.User.email == data.freelancer_email.strip(), models.User.role == "freelancer").first()
    if not project or not freelancer:
        raise HTTPException(status_code=404, detail="Project or freelancer not found")
    if project.status != "POSTED":
        raise HTTPException(status_code=400, detail="Project is no longer accepting applications")
    existing = db.query(models.JobApplication).filter(models.JobApplication.project_id == project.id, models.JobApplication.freelancer_id == freelancer.id).first()
    if existing:
        return {"message": "Application already submitted", "status": existing.status}
    app_record = models.JobApplication(project_id=project.id, freelancer_id=freelancer.id, freelancer_email=freelancer.email, status="APPLIED")
    db.add(app_record)
    db.commit()
    return {"message": "Application submitted", "status": "APPLIED"}


@app.post("/projects/{project_id}/complete")
async def complete_project(project_id: int, data: JobAcceptRequest, db: Session = Depends(get_db)):
    project = db.query(models.Project).filter(models.Project.id == project_id).first()
    freelancer = db.query(models.User).filter(models.User.email == data.freelancer_email.strip(), models.User.role == "freelancer").first()
    if not project or not freelancer:
        raise HTTPException(status_code=404, detail="Project or freelancer not found")
    if project.freelancer_id != freelancer.id:
        raise HTTPException(status_code=400, detail="Project is not assigned to this freelancer")

    # Idempotency protection: a completed project must never create a second payment.
    if project.status == "COMPLETED":
        existing_payment = (
            db.query(models.Payment)
            .filter(
                models.Payment.client_id == project.client_id,
                models.Payment.freelancer_email == freelancer.email,
                models.Payment.project == project.title,
                models.Payment.status == "COMPLETED",
            )
            .order_by(models.Payment.id.desc())
            .first()
        )

        if existing_payment:
            return {
                "message": "Project already completed; existing automatic payment returned",
                "project": _project_dict(project, db),
                "payment": payment_to_dict(existing_payment),
                "already_completed": True,
            }

        raise HTTPException(
            status_code=409,
            detail="Project is already completed but no completed payment record was found",
        )

    if project.status != "IN_PROGRESS":
        raise HTTPException(status_code=400, detail="Project is not assigned to this freelancer")

    project.status = "COMPLETED"
    project.completed_at = datetime.now(timezone.utc)

    # Automatic payment orchestration for the hackathon prototype.
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            fx_response = await client.get("https://open.er-api.com/v6/latest/USD")
            fx_response.raise_for_status()
            fx_data = fx_response.json()
            fx_rate = float(fx_data.get("rates", {}).get("INR", 83.50))
    except Exception:
        fx_rate = 83.50

    amount_inr = project.budget_usd * fx_rate
    payment_id = f"PAY-{datetime.now(timezone.utc).strftime('%Y%m%d')}-{uuid.uuid4().hex[:8].upper()}"
    payment = models.Payment(
        payment_id=payment_id, client_id=project.client_id, freelancer_name=freelancer.name, freelancer_email=freelancer.email, freelancer_country="India", freelancer_wallet="", project=project.title, amount_usd=project.budget_usd, amount_inr=amount_inr, fx_rate=fx_rate, locked_fx_rate=fx_rate, fx_source="ExchangeRate-API", rate_status="LOCKED", status="COMPLETED",
        compliance_data={"status": "APPROVED", "simulation": True}, fraud_data={"decision": "APPROVE", "score": 0, "simulation": True}, fees_data={"client_fee": 0, "freelancer_fee": 0, "fx_markup": 0, "hidden_charges": 0}, route_data={"selected": "USA → USDC → INDIA", "status": "OPTIMIZED", "simulation": True}, lock_data={"status": "LOCKED", "locked_at": datetime.now(timezone.utc).isoformat()}, contract_data={"contract_id": f"SC-{uuid.uuid4().hex[:12].upper()}", "simulation": True}, blockchain_data={"transaction_hash": f"0x{uuid.uuid4().hex}", "simulation": True}, settlement_data={"status": "COMPLETED", "simulation": True},
    )
    db.add(payment)
    db.commit()
    db.refresh(payment)
    return {"message": "Work completed and automatic payment triggered", "project": _project_dict(project, db), "payment": payment_to_dict(payment)}
