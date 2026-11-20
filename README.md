# Fitora

Fitora is a Flutter fitness application for viewing workouts, services, products, and saved workout progress.

## Features

- Email/password Firebase Authentication registration and login
- Google and Facebook Firebase social sign-in
- Password reset through Firebase Authentication
- Firebase logout
- Firestore workout progress CRUD
- Workout session tracking
- Workout and service catalogs
- REST API product catalog with create, read, update, and delete operations
- Responsive Flutter navigation

## Technologies

- Flutter and Dart
- Firebase Authentication
- Cloud Firestore
- REST API integration with DummyJSON
- Material 3

## Firebase setup

The project uses the Firebase options in `lib/firebase_options.dart`.

For Firestore, create a database and allow authenticated users to access:

```text
users/{uid}/progress/{recordId}
```

Recommended development security rules:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

## Run

```powershell
flutter pub get
flutter run
```

## Tests

```powershell
flutter test
flutter analyze
```

## Submission evidence checklist

Capture emulator screenshots for:

- Login screen
- Registration screen
- Firebase password validation
- Main dashboard and navigation
- Workout session workflow
- Firestore progress create operation
- Firestore progress read operation
- Firestore progress update operation
- Firestore progress delete operation
- API product create/read/update/delete operations
- Logout returning to the login screen

Capture Firebase Console screenshots for:

- Authentication users
- Firestore `users/{uid}/progress` records
