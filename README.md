# BConnect (GBCONNET) • P2P Social Commerce Escrow Platform

[![Deploy BConnect to GitHub Pages](https://github.com/odufu/bconnect/actions/workflows/deploy.yml/badge.svg)](https://github.com/odufu/bconnect/actions/workflows/deploy.yml)

> **Live Interactive Client Prototype**: [https://odufu.github.io/bconnect/](https://odufu.github.io/bconnect/)

BConnect is a peer-to-peer social commerce escrow application engineered for the Nigerian market, eliminating buyer-seller fraud across Instagram, TikTok, WhatsApp, and Facebook. Powered by **Grand Brain Connect Nigeria Ltd (GBCONNET)**.

---

## 🌟 Key Features Implemented

1. **Brand Identity & Centralized Loading**:
   - Official BConnect monogram logo integration across web icons, PWA manifest, and app headers.
   - Centralized animated initialization screen with pulse glow, radial gradient, and smooth handoff.
   - Strict adherence to brand theme: Primary Emerald Green (`#0FA86A`), Deep Green (`#0B7A4D`), Dispute Red (`#FF3B30`), and neutral backgrounds (`#F8FAFC`).

2. **Core 4-Step Escrow Stepper**:
   - `Deal Created` &rarr; `Funds Deposited & Locked` &rarr; `Goods Waybilled / Shipped` &rarr; `Delivered & Verified` &rarr; `Funds Auto-Released`.
   - 2-Hour Auto-Release Safety Clock with real-time countdown timer.
   - Dual-side delivery verification code (e.g. `BC-849201`) to eliminate courier fraud.

3. **Fraud Prevention & Dispute Arbitration**:
   - Immediate freeze on locked escrow funds upon dispute initiation.
   - Secure evidence uploader (waybill slips, defect photos, chat logs).
   - Real-time arbitration panel with dedicated fintech mediation status.

4. **Public Social Commerce Marketplace**:
   - Browse vetted verified seller listings across Lagos, Abuja, Port Harcourt, and Ibadan.
   - "Wanted Board" allowing buyers to post specific items and receive escrow-guaranteed offers.
   - Instant deal-generation links for external sharing (`bconnect.ng/pay/BC-XXXXX`).

5. **Seller Storefront & Dual-Persona Switcher**:
   - 90% positive / 10% negative transparent trust metrics with verifiable deal history.
   - Badge tier system: *Top Rated Seller*, *Zero Dispute Record*, *Fast Dispatcher*.
   - Instant toggle between **Buyer Mode** and **Seller Mode** without logging out.

6. **Referral Engine**:
   - Shareable referral code (`BC-CHIDI-904`) with ₦500 bonus per verified deal.

---

## 🚀 Automated GitHub Pages Deployment

Every commit and push to `main` triggers `.github/workflows/deploy.yml`, which:
1. Runs automated unit and widget test suites.
2. Builds the optimized Flutter Web release targeting `--base-href /bconnect/`.
3. Deploys to GitHub Pages (`https://odufu.github.io/bconnect/`).

### Enabling GitHub Pages in Repository Settings:
1. Go to your GitHub repository: [https://github.com/odufu/bconnect](https://github.com/odufu/bconnect)
2. Click **Settings** &rarr; **Pages** (under *Code and automation*).
3. Under **Build and deployment**:
   - **Source**: Select **GitHub Actions** (or select **Deploy from a branch** &rarr; branch `gh-pages` / `root`).
4. Once deployed, the live prototype is accessible at:
   👉 **`https://odufu.github.io/bconnect/`**

---

## 💻 Local Development

```bash
# Clone the repository
git clone https://github.com/odufu/bconnect.git

# Navigate into project directory
cd bconnect

# Install dependencies
flutter pub get

# Run test suite
flutter test

# Run locally on Chrome
flutter run -d chrome

# Build for Web production
flutter build web --release --base-href /bconnect/
```
