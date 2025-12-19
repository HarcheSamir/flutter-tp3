
**Instructions:**
1.  Create a file named `README.md` at the root of your `tp3` folder.
2.  Paste the content below.

***

# 📱 TP3: Flutter & Firebase Quiz App

A fully dynamic Quiz application built with **Flutter** and **Firebase**. This project demonstrates advanced state management, cloud database integration (Firestore), user authentication, and clean architecture principles.

---

## 🚀 Features

### 🔐 Authentication & User Management
*   **Sign Up / Sign In:** Secure email/password authentication using **Firebase Auth**.
*   **Real-time Auth Gate:** Auto-redirects users based on login status.
*   **User Profile:** View profile details and generate random avatars via the **RoboHash API**.
*   **Real-time Updates:** Avatar changes update instantly across the app via Firestore streams.

### 🧠 Dynamic Quiz Engine
*   **Cloud-Hosted Content:** Themes and questions are fetched dynamically from **Cloud Firestore**.
*   **Interactive Gameplay:** Progress bars, immediate visual feedback (Green/Red), and score tracking.
*   **Audio Integration:** Sound effects for correct (`win.mp3`) and incorrect (`loss.mp3`) answers.

### 🛠️ Admin & Contribution (Bonus)
*   **Add Questions:** A dedicated Admin interface allows users to contribute new questions to existing themes directly from the app.
*   **Atomic Updates:** Uses `FieldValue.arrayUnion` to safely update database arrays.

---

## 🏗️ Architecture

The project follows the **Package by Layer** (Clean Architecture) principle to ensure separation of concerns:

```text
lib/
├── business_logic/       # State management logic (BLoC/Cubits)
├── data/                 # Data layer
│   ├── models/           # Data models (Question, QuizTheme)
│   ├── services/         # Firebase interactions (AuthService, QuizService)
│   └── repositories/     # Repositories (optional abstraction)
├── presentation/         # UI layer
│   ├── screens/          # Application screens (Login, Home, Quiz, Profile)
│   └── widgets/          # Reusable UI components
└── main.dart             # Entry point & App Configuration
```

---

## 🛠️ Tech Stack & Packages

*   **Framework:** Flutter (Dart)
*   **Backend:** Firebase (Core, Auth, Firestore)
*   **State Management:** `StreamBuilder` & `StatefulWidget` (plus `provider`/`flutter_bloc` foundations)
*   **Key Dependencies:**
    *   `firebase_auth`: User management.
    *   `cloud_firestore`: NoSQL Database.
    *   `audioplayers`: Sound effects.
    *   `http`: Network requests (for RoboHash).
    *   `font_awesome_flutter`: Icons.
    *   `intl`: Formatting.

---

## ⚙️ Setup & Installation

### 1. Prerequisites
*   Flutter SDK installed.
*   A Firebase project created on the [Firebase Console](https://console.firebase.google.com/).

### 2. Installation
Clone the repository and install dependencies:
```bash
git clone <your-repo-url>
cd tp3
flutter pub get
```

### 3. Firebase Configuration
**Important:** This project requires a `firebase_options.dart` file which contains API keys.
1.  Install the FlutterFire CLI:
    ```bash
    dart pub global activate flutterfire_cli
    ```
2.  Configure your project (select your Firebase project):
    ```bash
    flutterfire configure
    ```
3.  **Firestore Rules:** Ensure your Firestore database is in **Test Mode** or has rules allowing read/write.

### 4. Run the App
```bash
flutter run
```

---



## 👤 Author

**Samir HARCHE**
*Mobile Development / IoT Unit*
*Date: December 2025*