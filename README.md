# Notes Assignment App

A Flutter application for taking notes with Firebase authentication and Firestore backend.

## Features

- **Authentication**: Email/password signup and login using Firebase Auth
- **Notes Management**: Full CRUD operations (Create, Read, Update, Delete)
- **State Management**: BLoC pattern for clean architecture
- **Real-time Updates**: Synchronized with Firestore
- **Clean UI**: Material Design with custom styling

## Architecture

The app follows a clean architecture pattern with:

- **Models**: Data structures for Note objects
- **Repositories**: Data access layer for Firebase services
- **BLoC**: Business logic and state management
- **UI**: Screens and widgets for user interface

## Setup Instructions

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure Firebase:
   - The app is already configured with Firebase project: `notes-assignment-app`
   - Authentication and Firestore are enabled

3. Run the app:
   ```bash
   flutter run
   ```

## Firebase Services Used

- **Firebase Authentication**: For user registration and login
- **Cloud Firestore**: For storing and syncing notes data
- **Firebase Core**: For app initialization

## App Flow

1. **Authentication Screen**: Users can sign up or log in
2. **Notes Screen**: Main interface showing all notes
3. **Add/Edit Notes**: Dialog for creating and editing notes
4. **Real-time Sync**: Changes are immediately reflected in Firestore

## File Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── note.dart            # Note data model
├── repositories/
│   ├── auth_repository.dart  # Firebase Auth operations
│   └── notes_repository.dart # Firestore operations
├── bloc/
│   ├── auth_bloc.dart       # Authentication state management
│   ├── auth_event.dart      # Authentication events
│   ├── auth_state.dart      # Authentication states
│   ├── notes_bloc.dart      # Notes state management
│   ├── notes_event.dart     # Notes events
│   └── notes_state.dart     # Notes states
├── screens/
│   ├── auth_screen.dart     # Login/Signup UI
│   └── notes_screen.dart    # Main notes interface
└── widgets/
    ├── add_note_dialog.dart # Add/Edit note dialog
    └── note_item.dart       # Individual note display
```

## Dependencies

- `firebase_core`: Firebase SDK initialization
- `firebase_auth`: Authentication services
- `cloud_firestore`: Database services
- `flutter_bloc`: State management
- `equatable`: Value equality for objects
- `intl`: Date formatting utilities

## Demo Video Instructions

For the assignment submission, create a demo video showing:

1. **User Registration**: Create a new user account
2. **User Login**: Sign in with the created credentials
3. **Empty State**: Show the "Nothing here yet—tap ➕ to add a note" message
4. **Create Notes**: Add multiple notes and show them appearing in Firestore
5. **Read Notes**: Display existing notes in the UI
6. **Update Notes**: Edit a note and show the change in Firestore
7. **Delete Notes**: Remove a note and confirm deletion in Firestore
8. **Firebase Console**: Show the data in Firebase Auth and Firestore

## Assignment Requirements Checklist

- ✅ Clean architecture (separation of UI and logic)
- ✅ BLoC state management (no setState used)
- ✅ SnackBar feedback for all operations
- ✅ Loading indicator during initial fetch
- ✅ Firebase Authentication (email/password)
- ✅ Firestore CRUD operations
- ✅ Proper data structure for user notes
- ✅ Empty state message when no notes exist
