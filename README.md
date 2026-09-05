# FreezeX

### Lock the rate. Move the money.

FreezeX is a cross-border payment prototype designed to make international freelancer payments more transparent, predictable, and efficient.

It focuses on a simple problem:

> A company in the US wants to pay a freelancer in India, but the freelancer should know exactly how much INR they will receive before the payment is settled.

FreezeX provides a transparent payment flow with an upfront FX rate, compliance checks, fraud screening, route optimization, and simulated smart-contract settlement.

---

## 🚀 Problem

Cross-border freelancer payments can involve:

* Unpredictable foreign-exchange rates
* Hidden FX markups
* Transaction fees
* Multiple intermediaries
* Slow settlement
* Compliance and identity verification complexity
* Limited visibility into the payment process

For example, a US company may agree to pay an Indian freelancer **$500**, but the freelancer may not know the exact INR amount they will receive until the transaction is completed.

FreezeX addresses this by locking and displaying the conversion rate before settlement.

---

## 💡 Solution

FreezeX creates a transparent payment experience:

```text
US COMPANY
     │
     │ $500
     ▼
FREEZEX PAYMENT PROTOCOL
     │
     ├── Identity Verification
     ├── KYC / AML Checks
     ├── Fraud Detection
     ├── FX Rate Lock
     ├── Route Optimization
     └── Smart Contract Orchestration
     │
     │ ₹41,750
     ▼
INDIAN FREELANCER
```

For the prototype:

**$500 × ₹83.50/USD = ₹41,750**

The user-facing payment breakdown is:

| Component              |     Amount |
| ---------------------- | ---------: |
| Payment                |       $500 |
| FX Rate                | ₹83.50/USD |
| Freelancer Receives    |    ₹41,750 |
| Client Transaction Fee |         $0 |
| Freelancer Fee         |         ₹0 |
| FX Markup              |         ₹0 |
| Hidden Charges         |         ₹0 |

> **Note:** The zero-fee figures represent the FreezeX prototype's user-facing pricing model. Real-world payment infrastructure still has costs such as banking rails, liquidity, compliance, taxes, blockchain gas, and payout infrastructure.

---

## ✨ Key Features

### 1. Role-Based Access

FreezeX supports two user roles:

**Client**

* Login / Sign Up
* Subscription
* Client Dashboard
* Create Payment
* Select Freelancer
* Payment processing

**Freelancer**

* Login / Sign Up
* Freelancer Dashboard
* Identity / KYC status
* Incoming payments
* Transaction details

Freelancers do not require a subscription in the prototype.

---

### 2. Client Subscription

FreezeX uses a subscription-based business model for clients.

The prototype demonstrates:

**Business Plan — $99/month**

The subscription is intended to cover platform/infrastructure costs separately from the freelancer's payout.

This allows the payment experience to maintain:

* ₹0 freelancer transaction fee
* ₹0 client transaction fee
* ₹0 FX markup

---

### 3. FX Rate Lock

The payment engine locks an illustrative FX rate before settlement.

Example:

```text
USD Amount     = $500
FX Rate        = ₹83.50/USD
INR Payout     = ₹41,750
```

The freelancer can therefore see the expected payout before the transaction is finalized.

---

### 4. Identity & Compliance

The prototype includes simulated:

* Identity verification
* KYC verification
* AML screening

A transaction is approved only when the required checks pass.

```text
Identity Verified ──┐
KYC Passed ─────────┼──> Compliance Decision
AML Passed ─────────┘
```

> Compliance functionality is simulated for the hackathon prototype and is not a production KYC/AML service.

---

### 5. Fraud Detection

FreezeX includes a prototype fraud-risk scoring system.

The system evaluates factors such as:

* Identity verification
* KYC status
* AML status
* Transaction amount

The prototype produces one of:

```text
APPROVE
REVIEW
BLOCK
```

This demonstrates how risk screening could be integrated into the payment orchestration layer.

---

### 6. Route Optimization

The payment engine evaluates multiple possible settlement routes.

Example routes:

```text
USA → USDC → INDIA
USA → UAE → INDIA
USA → INDIA
```

Routes are evaluated using:

* Infrastructure fee
* Estimated settlement time
* Risk score

The prototype selects the route with the lowest combined score.

---

### 7. Smart Contract Orchestration

FreezeX demonstrates a simulated smart-contract stage in the payment flow.

```text
Payment Created
      ↓
Compliance Approved
      ↓
Fraud Check
      ↓
FX Rate Locked
      ↓
Route Selected
      ↓
Smart Contract
      ↓
Settlement
      ↓
Transaction Success
```

The current implementation is a **simulation for the hackathon** and does not move real cryptocurrency or fiat currency.

---

### 8. Transaction Details

After settlement, users can view transaction information including:

* Transaction ID
* Sender
* Freelancer
* USD amount
* INR payout
* FX rate
* Fees
* Payment status
* Settlement information

Example:

```text
Transaction ID: TX-FX-2026-000501

Amount:       $500
FX Rate:      ₹83.50/USD
Payout:       ₹41,750
Client Fee:   $0
Freelancer Fee: ₹0

Status: Completed
```

---

## 🛠️ Technology Stack

### Frontend

* Flutter
* Dart
* Material 3
* Responsive UI

### Application Logic

* Dart
* Custom `PaymentEngine`
* Client/Freelancer role flow
* Simulated compliance engine
* Simulated fraud engine
* Route optimization logic
* Transaction orchestration

### Platform

The application can run on:

* Web
* Windows
* Chrome

---

## 📁 Project Structure

```text
FreezeX/
│
├── lib/
│   ├── main.dart
│   └── payment_engine.dart
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
│
├── test/
├── pubspec.yaml
└── README.md
```

### `main.dart`

Contains the main application UI and navigation flow:

* Role Selection
* Login
* Sign Up
* Subscription
* Client Dashboard
* Freelancer Dashboard
* Create Payment
* Conversion
* Compliance
* Route Optimization
* Smart Contract
* Settlement
* Success
* Transaction Details

### `payment_engine.dart`

Contains the core payment prototype logic:

* USD → INR conversion
* Compliance checks
* Fraud scoring
* Route selection
* Payment processing

---

## 🔄 Complete Payment Flow

### Client Flow

```text
Role Selection
      ↓
Client
      ↓
Login / Sign Up
      ↓
Subscription
      ↓
Client Dashboard
      ↓
Create Payment
      ↓
Enter Amount
      ↓
Select Freelancer
      ↓
Identity & Compliance
      ↓
FX Conversion
      ↓
Route Optimization
      ↓
Smart Contract
      ↓
Settlement
      ↓
Success
      ↓
Transaction Details
```

### Freelancer Flow

```text
Role Selection
      ↓
Freelancer
      ↓
Login / Sign Up
      ↓
Freelancer Dashboard
      ↓
Identity / KYC
      ↓
Incoming Payments
      ↓
Transaction Details
```

---

## 💰 Business Model

FreezeX separates **payment infrastructure costs** from the freelancer's payout.

Possible revenue models include:

### Client Subscription

Companies pay a monthly platform subscription.

Example:

```text
FreezeX Business Plan
$99 / month
```

### Gig Platform Integration

Freelance marketplaces can integrate FreezeX through an API/platform agreement and pay infrastructure costs separately.

### Enterprise/API Model

Companies can pay for:

* Payment orchestration
* Compliance infrastructure
* FX routing
* Transaction monitoring
* API access

This allows the user-facing transaction experience to remain transparent.

---

## 🔐 Security & Compliance

A production version of FreezeX would require appropriate:

* KYC/AML infrastructure
* Identity verification
* Fraud monitoring
* Transaction monitoring
* Secure authentication
* Encryption
* Payment-provider integrations
* Regulated banking/payment partners
* Regulatory compliance

The hackathon implementation uses **simulated compliance and settlement logic** to demonstrate the product architecture.

---

## ⚠️ Prototype Disclaimer

FreezeX is currently a hackathon prototype.

The following components are simulated:

* KYC verification
* AML screening
* Fraud detection
* FX rate
* Route optimization
* Smart contract
* Blockchain settlement
* Payment settlement

The application does **not** currently process real money.

A production implementation would require integration with regulated payment providers, banking partners, liquidity providers, identity/KYC providers, and appropriate regulatory frameworks.

---

## 🎯 Example Use Case

### Scenario

A US company hires an Indian freelancer for website development.

Agreed payment:

```text
$500
```

FreezeX displays:

```text
FX Rate
₹83.50/USD

Expected Freelancer Payout
₹41,750
```

The transaction then passes through:

```text
Identity
   ↓
KYC
   ↓
AML
   ↓
Fraud Check
   ↓
FX Lock
   ↓
Route Optimization
   ↓
Smart Contract
   ↓
Settlement
```

The transaction finishes with:

```text
Payment Successful

$500 → ₹41,750

Client Fee: $0
Freelancer Fee: ₹0
FX Markup: 0%
```

---

## 🧪 Running the Project

Make sure Flutter is installed and configured.

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd FreezeX
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run on Chrome

```bash
flutter run -d chrome
```

### 4. Build the web application

```bash
flutter build web
```

The production web files will be generated inside:

```text
build/web
```

---

## 🧑‍💻 Development

Check Flutter configuration:

```bash
flutter doctor
```

Clean the project if required:

```bash
flutter clean
flutter pub get
```

Run the application:

```bash
flutter run -d chrome
```

---

## 🏆 Hackathon Highlights

FreezeX demonstrates how cross-border freelancer payments can be redesigned around **transparency and predictable payouts**.

### Our key differentiators

* 🔒 FX rate locked upfront
* 💰 Zero user-facing transaction fees in the prototype
* 🚫 No hidden FX markup
* 🧾 Transparent payment breakdown
* 🪪 Identity and compliance checks
* 🛡️ Fraud-risk screening
* ⚡ Intelligent payment routing
* 🔗 Smart-contract orchestration concept
* 👤 Separate Client and Freelancer experiences
* 💳 Subscription-based infrastructure model

---

## 🌍 Future Roadmap

### Phase 1 — Hackathon Prototype

* Flutter UI
* Simulated payment engine
* Simulated KYC/AML
* Simulated fraud detection
* Simulated route optimization
* Simulated smart-contract settlement

### Phase 2 — Payment Infrastructure

* Real payment-provider integration
* Real FX rates
* Banking/payment rails
* Secure wallet/payment integrations
* Production KYC/AML providers

### Phase 3 — Intelligent Routing

* Real-time liquidity optimization
* Multi-rail routing
* Cost optimization
* Settlement-time optimization
* Risk-aware routing

### Phase 4 — Platform Integration

* Freelancer marketplaces
* Payroll platforms
* Enterprise APIs
* Accounting integrations
* Automated cross-border payouts

---

## 📊 Architecture

```text
                    ┌─────────────────────┐
                    │      FreezeX        │
                    │    Flutter App      │
                    └──────────┬──────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
        ┌───────▼────────┐           ┌────────▼────────┐
        │ Client Flow    │           │ Freelancer Flow │
        └───────┬────────┘           └────────┬────────┘
                │                             │
                └──────────────┬──────────────┘
                               │
                     ┌─────────▼─────────┐
                     │ Payment Engine    │
                     ├───────────────────┤
                     │ FX Conversion     │
                     │ Compliance        │
                     │ Fraud Detection   │
                     │ Route Optimization│
                     └─────────┬─────────┘
                               │
                     ┌─────────▼─────────┐
                     │ Settlement Layer  │
                     │ Smart Contract    │
                     │   Simulation      │
                     └─────────┬─────────┘
                               │
                     ┌─────────▼─────────┐
                     │ Transaction       │
                     │ Details / Success │
                     └───────────────────┘
```

---

## 💬 One-Line Pitch

> **FreezeX locks the FX rate and moves cross-border freelancer payments transparently, without hidden FX markups or user-facing transaction fees.**

---

## 🎤 Short Hackathon Pitch

> **“Today, cross-border freelancers don't always know exactly how much they'll receive after FX conversion and payment fees. FreezeX changes that. We lock the FX rate upfront, run identity, compliance and fraud checks, optimize the settlement route, and orchestrate the payment through a smart-contract-based architecture. Our business model separates infrastructure costs from the freelancer payout, allowing us to provide a transparent zero-user-fee experience in the prototype. FreezeX — lock the rate, move the money.”**

---

## 📌 Status

**Hackathon Prototype — Ready for Demonstration**

FreezeX currently demonstrates the complete client and freelancer payment experience using simulated payment infrastructure.

---

## 👨‍💻 Team

Built for a hackathon using Flutter and Dart.

**Project:** FreezeX
**Tagline:** *Lock the rate. Move the money.*
