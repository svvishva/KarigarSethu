<div align="center">
  <img src="assets/logo_padded.jpeg" alt="KarigarSethu Logo" width="120" />
  <h1>KarigarSethu</h1>
  <p><strong>AI Virtual Business Manager for Artisans</strong></p>
  <p><em>Smart India Hackathon 2026 Submission</em></p>
</div>

---

## 🎯 The Problem

Millions of highly skilled local artisans (Karigars) in India struggle to enter the digital marketplace. They face a massive digital divide consisting of language barriers, lack of digital cataloging skills, and difficulty in competitive pricing. As a result, they remain reliant on middlemen, heavily reducing their profit margins.

## 💡 Our Solution: KarigarSethu

KarigarSethu is a mobile-first, AI-powered **Virtual Business Manager** tailored specifically for Indian artisans. It acts as a bridge ("Sethu") between traditional craftsmanship and modern e-commerce. By simply using their smartphone and speaking in their native language, a Karigar can instantly create professional-grade, SEO-optimized product listings ready for global marketplaces or direct-to-consumer sales.

---

## ✨ Key Innovation & Features

*   **🗣️ Voice-to-Catalog (Hyper-Localized):** Artisans simply describe their product verbally in their local language (e.g., Telugu, Hindi, Marathi). We utilize **Groq's Whisper API** for ultra-fast, dialect-aware native speech recognition.
*   **📸 AI Image Studio (Zero-Cost Professional Photos):** No need for expensive photoshoots. Using **Google ML Kit** and on-device processing, KarigarSethu automatically removes messy backgrounds and formats images perfectly for e-commerce.
*   **🧠 Generative AI Auto-Cataloger:** We leverage **Google Gemini & Groq LLMs** to instantly translate local voice inputs into rich, SEO-friendly English product descriptions and automatically extract key attributes (material, dimensions, care instructions).
*   **💰 Dynamic AI Pricing Assistant:** Helps artisans price their goods fairly and competitively. By analyzing input costs (raw material, labor) against real-time market contexts, our LLM engine suggests an optimal selling price.
*   **🌐 GeM-Ready Architecture:** Designed with B2B marketplace integrations in mind, enabling artisans to easily tap into government procurement and bulk buyer channels.

---

## 📸 Prototype Gallery

*(Over 40% of the prototype is completed and fully functional as demonstrated below)*

<p align="center">
  <img src="assets/login.jpeg" width="22%" />
  <img src="assets/select_language.jpeg" width="22%" />
  <img src="assets/dashboard.jpeg" width="22%" />
  <img src="assets/add_product.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/audio_to_description.jpeg" width="22%" />
  <img src="assets/add_features.jpeg" width="22%" />
  <img src="assets/base_price.jpeg" width="22%" />
</p>

---

## 🏗️ Technical Architecture & Process Flow

<p align="center">
  <img src="assets/architecture-diagram-updated.png" alt="Architecture Diagram" width="90%" />
</p>

### 🛠 Tech Stack
*   **Frontend Mobile App:** Flutter (Cross-platform)
*   **Backend & APIs:** Python + FastAPI *(Planned)*
*   **Database & Auth:** PostgreSQL / Supabase
*   **AI Integration:** Groq API (LLM & Whisper), Google Generative AI (Gemini)
*   **Image Processing:** OpenCV, `rembg`, `pro_image_editor`, Google ML Kit Subject Segmentation

---

## 🚀 Judge's Evaluation / Local Setup Guide

If you'd like to build and run the application locally to evaluate the prototype:

### Prerequisites
*   Flutter SDK (^3.13.3)
*   An Android or iOS Emulator / Physical Device

### Setup Steps
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/svvishva/KarigarSethu.git
    cd KarigarSethu
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Environment Variables:**
    Create a `.env` file in the root of the project to test the AI integration.
    *(Note: To test the app, you will need to supply your own API keys for the LLMs)*
    ```env
    GEMINI_API_KEY=your_gemini_key_here
    GROQ_API_KEY=your_groq_key_here
    ```
4.  **Run the application:**
    ```bash
    flutter run
    ```

---
<div align="center">
  <strong>Built with ❤️ for the artisans of India.</strong>
</div>
