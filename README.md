# 6am Chat

A real-time chat application built with Flutter and Firebase.

## Features

- 🔐 **User Authentication** - Sign up, login, and logout with Firebase Auth
- 💬 **Real-time Messaging** - Send and receive messages instantly using Firebase Realtime Database
- 👥 **User List** - Browse and select users to start conversations
- 📜 **Pagination** - Load older messages as you scroll up
- 🎨 **Clean UI** - Modern and intuitive user interface

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **GetX** - State management and dependency injection
- **Firebase Auth** - User authentication
- **Firebase Realtime Database** - Real-time data synchronization
- **Clean Architecture** - Organized with data, domain, and presentation layers

## Project Structure

```
lib/
├── config/           # App configuration (routes, firebase options)
├── core/             # Constants, utilities, and helpers
├── data/             # Data layer (models, repository implementations)
├── domain/           # Business logic (entities, repositories, usecases)
└── presentation/     # UI layer (views, controllers, widgets)
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase project with Auth and Realtime Database enabled

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/sabbirahmed6amtech/6amChat.git
   cd sixamchat
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure Firebase
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

4. Run the app
   ```bash
   flutter run
   ```

## License

This project is for educational purposes.
