# KarigarSethu

KarigarSethu is a modern, feature-rich Flutter application designed to bridge the gap between artisans (Karigars) and the digital marketplace. It empowers creators by providing advanced AI-driven tools to showcase their products beautifully.

## ✨ Features

*   **AI-Powered Image Enhancement:** Seamlessly remove backgrounds and edit product photos using on-device ML (Google ML Kit) and `background_remover`.
*   **Generative AI Integration:** Uses Google Generative AI & Groq to help generate product descriptions, improving the product's market appeal.
*   **Advanced Image Editing:** Crop, adjust, and refine images using `pro_image_editor` and `image_cropper`.
*   **Localization (i18n):** Fully localized supporting multiple languages (including Telugu) out of the box using Flutter's official localization system.
*   **Beautiful UI:** Styled with `google_fonts`, custom typography, and responsive modern layouts.

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.13.3 or higher)
*   Dart SDK
*   An Android / iOS device or emulator for testing

### Installation

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
    Create a `.env` file in the root of the project to store your API keys:
    ```env
    # Example .env file
    GEMINI_API_KEY=your_gemini_key_here
    GROQ_API_KEY=your_groq_key_here
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## 🛠 Tech Stack & Packages

*   **Framework:** [Flutter](https://flutter.dev/)
*   **AI & ML:** `google_generative_ai`, `google_mlkit_subject_segmentation`
*   **Image Processing:** `pro_image_editor`, `image_cropper`, `background_remover`
*   **State & Storage:** `shared_preferences`
*   **Media & Permissions:** `image_picker`, `record`, `permission_handler`

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/svvishva/KarigarSethu/issues).

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
