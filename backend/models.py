from datetime import datetime, timezone

from sqlalchemy import Column, DateTime, Float, Integer, JSON, String

from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    role = Column(String, nullable=False)


class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)
    payment_id = Column(String, unique=True, nullable=False, index=True)

    client_id = Column(Integer, nullable=False, index=True)
    freelancer_name = Column(String, nullable=False)
    freelancer_email = Column(String, nullable=False, index=True)
    freelancer_country = Column(String, nullable=False)
    freelancer_wallet = Column(String, nullable=False, default="")
    project = Column(String, nullable=False)

    amount_usd = Column(Float, nullable=False)
    amount_inr = Column(Float, nullable=False, default=0.0)
    fx_rate = Column(Float, nullable=False, default=0.0)
    locked_fx_rate = Column(Float, nullable=True)
    fx_source = Column(String, nullable=False, default="ExchangeRate-API")
    rate_status = Column(String, nullable=False, default="AVAILABLE")

    status = Column(String, nullable=False, index=True)

    compliance_data = Column(JSON, nullable=False, default=dict)
    fraud_data = Column(JSON, nullable=False, default=dict)
    fees_data = Column(JSON, nullable=False, default=dict)
    route_data = Column(JSON, nullable=False, default=dict)
    lock_data = Column(JSON, nullable=False, default=dict)
    contract_data = Column(JSON, nullable=False, default=dict)
    blockchain_data = Column(JSON, nullable=False, default=dict)
    settlement_data = Column(JSON, nullable=False, default=dict)

    created_at = Column(
        DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )
    updated_at = Column(
        DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )


class Profile(Base):
    __tablename__ = "profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, unique=True, nullable=False, index=True)
    country = Column(String, nullable=False, default="")
    phone = Column(String, nullable=False, default="")
    company_name = Column(String, nullable=False, default="")
    company_type = Column(String, nullable=False, default="")
    business_description = Column(String, nullable=False, default="")
    skills = Column(String, nullable=False, default="")
    experience = Column(String, nullable=False, default="")
    about = Column(String, nullable=False, default="")
    looking_for = Column(String, nullable=False, default="")


class Subscription(Base):
    __tablename__ = "subscriptions"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, nullable=False, unique=True, index=True)
    plan = Column(String, nullable=False, default="FreezeX Business")
    amount = Column(Float, nullable=False, default=99.0)
    status = Column(String, nullable=False, default="ACTIVE", index=True)
    created_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))


class Project(Base):
    __tablename__ = "projects"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, nullable=False, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    skills = Column(String, nullable=False, default="")
    budget_usd = Column(Float, nullable=False)
    deadline = Column(String, nullable=False, default="")
    status = Column(String, nullable=False, default="POSTED", index=True)
    freelancer_id = Column(Integer, nullable=True, index=True)
    freelancer_email = Column(String, nullable=False, default="")
    created_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    completed_at = Column(DateTime(timezone=True), nullable=True)


class JobApplication(Base):
    __tablename__ = "job_applications"

    id = Column(Integer, primary_key=True, index=True)
    project_id = Column(Integer, nullable=False, index=True)
    freelancer_id = Column(Integer, nullable=False, index=True)
    freelancer_email = Column(String, nullable=False, index=True)
    status = Column(String, nullable=False, default="APPLIED")
    created_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    accepted_at = Column(DateTime(timezone=True), nullable=True)


class AccountControl(Base):
    __tablename__ = "account_controls"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False, unique=True, index=True)
    status = Column(String, nullable=False, default="ACTIVE", index=True)
    updated_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
