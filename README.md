# DonAid

Modern Flutter app with Firebase (Auth + Firestore) to manage prestations. Web-ready and mobile-friendly.

## Features
- Email/password authentication (login & registration)
- Profile editing (display name, photo URL)
- Add/Edit/Delete prestations filtered by current user
- Attractive UI: custom app bar, hero header, cards, chips, polished forms
- Flutter Web Firebase initialization fixed

## Requirements
- Flutter 3.x+
- Dart 3.x
- Firebase project (Auth + Firestore enabled)

## Getting Started

1. Clone the project
```
git clone <your-repo-url>
cd DanAid/danaid
```

2. Install dependencies
```
flutter pub get
```

3. Configure Firebase
- Create a Firebase project.
- Enable Authentication (Email/Password) and Firestore.
- Use FlutterFire to generate `lib/firebase_options.dart`:
```
flutterfire configure
```
- For web, ensure `web/index.html` has Firebase SDK tags or rely on `firebase_options.dart` with `DefaultFirebaseOptions.currentPlatform` in `lib/main.dart`.

4. Firestore Security Rules (development)
Use permissive rules for authenticated users while developing:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /prestations/{id} {
      allow read, write: if request.auth != null && request.auth.uid != null;
    }
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```
Remember to harden rules before production.

5. Run the app
```
flutter run -d chrome
# or
flutter run
```

## Project Structure
- `lib/main.dart` – App entry and Firebase initialization
- `lib/screens/` – UI screens (home, auth, profile, add/edit prestation, details)
- `lib/widgets/` – Reusable widgets (e.g., CustomAppBar, CustomTextField)
- `lib/services/` – Abstractions for Firebase (AuthService, DatabaseService)
- `lib/models/` – Data models (e.g., Prestation)

## Notable UI
- `lib/widgets/custom_app_bar.dart` – Larger logo, back button, unified app bars
- `lib/screens/home_screen.dart` – Hero image on Accueil, empty state when no prestations
- `lib/screens/prestation_detail_screen.dart` – Gradient header with chips and action buttons
- `lib/screens/add_edit_prestation_screen.dart` – Form in card with validation and full-width submit
- `lib/screens/auth_screen.dart` – Login/Registration with repeated password on sign-up

## Environment & Assets
- Ensure assets are declared in `pubspec.yaml`:
```
assets:
  - assets/logo/logo.png
  - assets/image/hero1.png
```

## Common Issues
- FirebaseOptions null on web: ensure `DefaultFirebaseOptions.currentPlatform` is used in `main.dart` and `firebase_options.dart` exists.
- Firestore permission-denied: verify rules and that the user is authenticated.
- CORS on web: serve via `flutter run -d chrome` or a proper host.

## Scripts
- Analyze: `flutter analyze`
- Format: `flutter format .`

## License

