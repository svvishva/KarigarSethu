<div align="center">
  <img src="assets/logo_padded.jpeg" alt="KarigarSethu Logo" width="120" />

  <h1>KarigarSethu</h1>

  <p><strong>AI Virtual Business Manager for Artisans</strong></p>
  <p><em>Smart India Hackathon 2026 Submission — SIH26090</em></p>
</div>

---

## 🎯 The Problem

Marginalized artisans and micro-entrepreneurs often face barriers when entering digital marketplaces.

The major challenges include:

- Language barriers
- Limited digital cataloging skills
- Difficulty creating professional product photographs
- Difficulty writing e-commerce product descriptions
- Uncertainty about competitive pricing
- Limited access to B2B and larger digital markets

As a result, many skilled artisans remain dependent on physical exhibitions, local markets and intermediaries.

---

## 💡 Our Solution — KarigarSethu

**KarigarSethu** is an AI-powered, mobile-first **Virtual Business Manager for Artisans**.

It helps artisans transform a simple **product photo + voice description** into a professional, market-ready product listing.

### Core Pipeline

```text
Product Photo + Voice Description
              ↓
        AI Processing
              ↓
   ┌──────────┼───────────┐
   ↓          ↓           ↓
Image       Speech      Language
AI          AI          AI
   ↓          ↓           ↓
ML Kit     Whisper      Groq LLM
              ↓
      Product Understanding
              ↓
   English + Hindi Catalog
              ↓
       AI Price Assistance
              ↓
       Artisan Review/Edit
              ↓
      Publish to Marketplace
📸 2. AI Image Studio

Artisans do not need professional photography equipment.

The application uses Google ML Kit Subject Segmentation and on-device image processing to help prepare product photographs for digital marketplaces.

Capabilities include:

Background removal
Product isolation
Clean product presentation
Image editing
E-commerce-ready formatting

On-device processing helps reduce unnecessary server-side image processing and can provide a responsive user experience.

🧠 3. AI-Powered Product Intelligence

The Groq-powered LLM processes the artisan's product description and extracts useful product information such as:

Product name
Category
Material
Colour
Size
Product characteristics
Care information
SEO keywords
Professional product description

The system is designed to turn informal artisan descriptions into structured marketplace-ready information.

💰 4. Dynamic AI Pricing Assistant

KarigarSethu assists artisans in determining a suitable selling price using product and market-related information.

The pricing workflow can consider:

Raw material cost
Labour cost
Packaging cost
Product category
Market price information
Demand-related inputs

The AI produces a price recommendation that the artisan can review, edit or approve before publishing.

The final selling price always remains under the artisan's control.

👤 5. Human-in-the-Loop

KarigarSethu does not blindly publish AI-generated content.

The artisan can review and modify:

Product image
Product name
Description
Product attributes
Suggested price

Only after approval is the product ready to be published.

🌐 6. GeM-Ready Architecture

The backend follows a REST API-based architecture designed to support future integrations with:

B2B marketplaces
Government procurement platforms
Government e-Marketplace (GeM)

Note: Live GeM integration is part of the future scope and requires the appropriate official APIs, access and authorization.

🏗️ Technical Architecture
                    ┌──────────────────────┐
                    │   Flutter Mobile App │
                    └──────────┬───────────┘
                               │
                         HTTPS / REST
                               │
                               ▼
                    ┌──────────────────────┐
                    │   Python + FastAPI   │
                    │    Backend Layer     │
                    └──────────┬───────────┘
                               │
          ┌────────────────────┼─────────────────────┐
          │                    │                     │
          ▼                    ▼                     ▼
 ┌────────────────┐   ┌─────────────────┐   ┌────────────────┐
 │ Google ML Kit  │   │    Groq API     │   │ Pricing Engine │
 │ Subject        │   │                 │   │                │
 │ Segmentation   │   │ ┌─────────────┐ │   │ AI-based       │
 │                │   │ │   Whisper   │ │   │ price          │
 │ Image          │   │ │ Speech→Text │ │   │ recommendation │
 │ Processing     │   │ └─────────────┘ │   │                │
 └────────────────┘   │ ┌─────────────┐ │   └────────────────┘
                      │ │  Groq LLM   │ │
                      │ │ Catalog/NLP  │ │
                      │ └─────────────┘ │
                      └─────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ PostgreSQL /         │
                    │ Supabase             │
                    │                      │
                    │ • Database           │
                    │ • Authentication     │
                    │ • Storage            │
                    │ • Realtime           │
                    └──────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Firebase Cloud       │
                    │ Messaging            │
                    └──────────────────────┘
🛠️ Tech Stack
Frontend
Flutter & Dart — Cross-platform mobile application
Stateful UI & ValueNotifier — Application state management
flutter_localizations / ARB files — Multilingual application interface
Backend
Python
FastAPI — REST API and backend business logic
Docker — Containerization and deployment
Artificial Intelligence
Groq Whisper API — Regional-language speech-to-text
Groq API / LLM — Language understanding, translation, catalog generation and product attribute extraction
Google ML Kit Subject Segmentation — On-device product/background segmentation
AI Pricing Engine — Product and market information based price recommendation
Database & Cloud Services
PostgreSQL / Supabase — Database
Supabase Authentication — User authentication
Supabase Storage — Product image/file storage
Firebase Cloud Messaging — Push notifications
Architecture
REST APIs
HTTPS
GeM-ready architecture
Cloud-deployable Docker containers
📁 Project Structure
KarigarSethu/
│
├── assets/
│   ├── logo_padded.jpeg
│   ├── architecture-diagram-updated.png
│   ├── login.jpeg
│   ├── select_language.jpeg
│   ├── dashboard.jpeg
│   ├── add_product.jpeg
│   ├── audio_to_description.jpeg
│   ├── add_features.jpeg
│   └── base_price.jpeg
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   └── locale/
│   │
│   ├── l10n/
│   │   └── *.arb
│   │
│   ├── models/
│   │
│   ├── screens/
│   │   ├── dashboard/
│   │   ├── add_product/
│   │   └── language_selection/
│   │
│   ├── services/
│   │   ├── groq/
│   │   ├── speech/
│   │   └── ...
│   │
│   └── widgets/
│
├── android/
├── ios/
├── web/
├── pubspec.yaml
└── README.md
📸 Prototype

More than 40% of the prototype has been completed, covering the core application workflow.

Prototype Screens
<p align="center"> <img src="assets/login.jpeg" width="22%" /> <img src="assets/select_language.jpeg" width="22%" /> <img src="assets/dashboard.jpeg" width="22%" /> <img src="assets/add_product.jpeg" width="22%" /> </p> <p align="center"> <img src="assets/audio_to_description.jpeg" width="22%" /> <img src="assets/add_features.jpeg" width="22%" /> <img src="assets/base_price.jpeg" width="22%" /> </p>
🔄 End-to-End Workflow
1. Artisan Login
        ↓
2. Select Language
        ↓
3. Add Product
        ↓
4. Capture / Upload Product Photo
        ↓
5. AI Image Processing
        ↓
6. Record Product Description
        ↓
7. Groq Whisper Speech-to-Text
        ↓
8. Groq LLM Understanding & Translation
        ↓
9. English + Hindi Catalog Generation
        ↓
10. Product Attribute Extraction
        ↓
11. AI Price Recommendation
        ↓
12. Artisan Reviews / Edits
        ↓
13. Approves Product
        ↓
14. Publish to Marketplace
🚀 Local Setup
Prerequisites
Flutter SDK
Android Studio / Xcode
Android Emulator or physical Android device
iOS device/simulator for iOS development
Git
1. Clone the Repository
git clone https://github.com/svvishva/KarigarSethu.git
cd KarigarSethu
2. Install Dependencies
flutter pub get
3. Configure Environment Variables

Create the required environment configuration according to the project's implementation.

For Groq integration:

GROQ_API_KEY=your_groq_api_key
Security

Never commit real API keys to GitHub.

Use:

.env

and keep it excluded through .gitignore.

4. Run the Application
flutter run

For a connected Android device:

flutter devices
flutter run
🔐 Security Considerations

For prototype deployment:

API keys should be stored in environment variables.
Do not commit secrets to GitHub.
Use HTTPS for API communication.
Authenticate backend requests.
Apply access controls to stored artisan data.
Minimize personal information sent to external AI APIs.
Keep AI providers behind the backend layer for future provider replacement.

For production government deployment, the infrastructure and AI services can be migrated to deployment environments approved by the concerned government organization and its security/data-residency requirements.

☁️ Planned Production Architecture

The prototype is designed to evolve into a scalable cloud architecture:

Flutter
   ↓
HTTPS
   ↓
API Gateway / Reverse Proxy
   ↓
FastAPI Backend
   ↓
┌────────────────────────────────┐
│ AI Services                    │
│                                │
│ Groq Whisper / LLM             │
│ Image Processing               │
│ Pricing Engine                 │
└────────────────────────────────┘
   ↓
PostgreSQL / Supabase
   ↓
B2B / Marketplace Integrations
   ↓
Future GeM Integration

The AI provider layer can be replaced or migrated according to future deployment, security and data-residency requirements.

🏛️ Smart India Hackathon

Problem Statement: SIH26090

Problem Statement:
AI-Driven Market Linkage and Smart Cataloging Mobile Application for Marginalized Artisans

Theme: Heritage & Culture

Category: Software

Team: INNO CREW

Team ID: 25T

📚 Research & References
Groq API

Used for speech-to-text and LLM-powered multilingual catalog generation.

https://console.groq.com/docs/overview

Google ML Kit

Used for on-device machine-learning capabilities including subject segmentation.

https://developers.google.com/ml-kit

Supabase

https://supabase.com/

FastAPI

https://fastapi.tiangolo.com/

Flutter

https://flutter.dev/

PM Vishwakarma

https://www.pmvishwakarma.gov.in/

IndiaHandmade

https://www.indiahandmade.com/

🔗 Project Links
GitHub

https://github.com/svvishva/KarigarSethu

Demo / Video

Add your deployment or demonstration link here.

<div align="center">
🪡 From Craft to Commerce

<strong>Built with ❤️ for the artisans of India.</strong>

KarigarSethu — AI Virtual Business Manager for Artisans

</div> ```
