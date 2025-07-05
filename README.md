# Notes Assignment App

A Flutter application for taking notes with Firebase authentication and Firestore backend.

## Features

- **Authentication**: Email/password signup and login using Firebase Auth
- **Notes Management**: Full CRUD operations (Create, Read, Update, Delete)
- **State Management**: BLoC pattern for clean architecture
- **Real-time Updates**: Synchronized with Firestore
- **Clean UI**: Material Design with custom styling

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                          │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │   AuthScreen    │    │   NotesScreen   │                    │
│  │                 │    │                 │                    │
│  └─────────────────┘    └─────────────────┘                    │
│           │                        │                           │
│           ▼                        ▼                           │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │    AuthBloc     │    │   NotesBloc     │                    │
│  │                 │    │                 │                    │
│  └─────────────────┘    └─────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
           │                        │
           ▼                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Domain Layer                                │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │ AuthRepository  │    │ NotesRepository │                    │
│  │                 │    │                 │                    │
│  └─────────────────┘    └─────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
           │                        │
           ▼                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Data Layer                                 │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │ Firebase Auth   │    │ Cloud Firestore │                    │
│  │                 │    │                 │                    │
│  └─────────────────┘    └─────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

### BLoC State Management

This application uses the **BLoC (Business Logic Component) pattern** for state management. Here's how to implement it:

1. **Install Dependencies**:
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.6
     equatable: ^2.0.5
   ```

2. **Create Events** (what can happen):
   ```dart
   abstract class AuthEvent extends Equatable {
     const AuthEvent();
   }
   
   class AuthSignInRequested extends AuthEvent {
     final String email;
     final String password;
     // ...
   }
   ```

3. **Create States** (what the UI can be in):
   ```dart
   class AuthState extends Equatable {
     final AuthStatus status;
     final User? user;
     final String? errorMessage;
     // ...
   }
   ```

4. **Create BLoC** (handles events and emits states):
   ```dart
   class AuthBloc extends Bloc<AuthEvent, AuthState> {
     AuthBloc() : super(AuthState.unknown()) {
       on<AuthSignInRequested>(_onAuthSignInRequested);
     }
     
     Future<void> _onAuthSignInRequested(event, emit) async {
       emit(AuthState.loading());
       try {
         final user = await authRepository.signIn(event.email, event.password);
         emit(AuthState.authenticated(user));
       } catch (e) {
         emit(AuthState.error(e.toString()));
       }
     }
   }
   ```

5. **Use BLoC in UI**:
   ```dart
   BlocBuilder<AuthBloc, AuthState>(
     builder: (context, state) {
       if (state.status == AuthStatus.loading) {
         return CircularProgressIndicator();
       }
       // Handle other states...
     },
   )
   ```

**Key Benefits of BLoC:**
- Separates business logic from UI
- Makes testing easier
- Provides predictable state management
- Enables reactive programming
- Maintains single source of truth

**Repository Pattern Integration:**
The BLoC layer communicates with Repository classes that handle data operations:
- `AuthRepository`: Manages Firebase Authentication
- `NotesRepository`: Handles Firestore CRUD operations

This creates a clean separation where:
- UI only knows about BLoC
- BLoC only knows about Repository
- Repository handles external services (Firebase)

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

### Recording Setup (5-10 minutes, 720p+)
- Record in **landscape mode** on phone/emulator
- Show your **face** during narration
- Use **clear audio** without background noise
- Record in **one continuous take** (no edits)

### Demo Sequence
1. **Cold Start**: Launch app from fresh install
2. **Sign Up**: Create new account with email/password
3. **Sign In**: Log in with created credentials  
4. **Empty State**: Show "Nothing here yet—tap ➕ to add a note." message
5. **Add Notes**: Create 3-4 different notes
6. **Firestore Console**: Show notes appearing in real-time in Firebase console
7. **Read Notes**: Scroll through note list
8. **Update Note**: Edit an existing note and show changes in Firestore
9. **Delete Note**: Remove a note with confirmation dialog
10. **Rotation Test**: Rotate device to show responsive design
11. **Logout/Login**: Sign out and back in to show persistence

### Error Demonstration
Show these validation scenarios:
- Invalid email format
- Weak password (under 6 chars or missing requirements)
- Wrong password on login
- Empty fields

### Firebase Console Views
During recording, show:
- **Authentication** tab with user account
- **Firestore Database** with real-time note updates
- **Project Overview** confirming correct project

### Technical Checklist
- ✅ No setState usage (pure BLoC)
- ✅ Repository pattern implementation
- ✅ Clean architecture separation
- ✅ Proper error handling with SnackBars
- ✅ Loading states and transitions
- ✅ Input validation
- ✅ Responsive UI design

## Assignment Requirements Checklist

- ✅ Clean architecture (separation of UI and logic)
- ✅ BLoC state management (no setState used)
- ✅ SnackBar feedback for all operations
- ✅ Loading indicator during initial fetch
- ✅ Firebase Authentication (email/password)
- ✅ Firestore CRUD operations
- ✅ Proper data structure for user notes
- ✅ Empty state message when no notes exist
