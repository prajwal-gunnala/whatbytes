# WhatBytes - Task Management for Gig Workers

*"Your gigs, organized. Your time, optimized."*

A premium Flutter-based task management app designed specifically for gig workers to efficiently manage multiple projects and tasks. Features Firebase authentication, Firestore real-time sync, and a modern dark UI with Material Design 3.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🔐 Authentication
- Email/password registration and login
- Secure Firebase Authentication
- Session persistence
- User profile management
- Real-time auth state monitoring

### 📝 Task Management
- **Create** tasks with title, description, due date, and priority
- **View** all tasks in real-time with Firestore sync
- **Edit** existing task details
- **Delete** tasks with confirmation dialog
- **Toggle** task completion status with one tap

### 🎯 Smart Filtering & Sorting
- **Filter by status**: All Tasks, Pending, Completed
- **Sort by**: Due Date, Priority, Date Created
- Overdue task indicators
- Empty states for better UX

### 🎨 Premium Dark UI
- Material Design 3 dark theme
- Custom color palette (#0F172A background, #6366F1 primary, #22D3EE accent)
- Poppins font family via Google Fonts
- Glassmorphism effects and smooth animations
- Responsive layouts

## 🏗️ Architecture

Built with **Clean Architecture** principles and **Riverpod** state management:

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── theme/         # Theme, colors, text styles
│   └── utils/         # Validators, formatters, helpers
├── features/
│   ├── auth/
│   │   ├── data/      # Data sources, models, repositories
│   │   ├── domain/    # Entities, repository interfaces
│   │   └── presentation/  # Screens, widgets, providers
│   └── tasks/
│       ├── data/      # Task data layer
│       ├── domain/    # Task domain layer
│       └── presentation/  # Task UI layer
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10 or higher
- Android Studio / VS Code with Flutter extensions
- Firebase account
- Android device or emulator (Android 8.0+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/whatbytes.git
   cd whatbytes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   
   b. Enable Authentication (Email/Password)
   
   c. Create a Firestore database
   
   d. Configure Firebase for Android:
   ```bash
   flutterfire configure --project=your-project-id
   ```
   
   e. Deploy Firestore security rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Configuration

### Firestore Security Rules
The app uses secure Firestore rules (`firestore.rules`):
- Users can only access their own data
- Tasks are private to each user
- All operations require authentication

### Firestore Collections

**users**
```json
{
  "id": "user_uid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "createdAt": "2025-12-24T10:00:00Z"
}
```

**tasks**
```json
{
  "id": "task_id",
  "userId": "user_uid",
  "title": "Complete project",
  "description": "Finish the landing page",
  "dueDate": "2025-12-31T23:59:59Z",
  "priority": "high",
  "isCompleted": false,
  "createdAt": "2025-12-24T10:00:00Z",
  "updatedAt": "2025-12-24T10:00:00Z"
}
```

## 📦 Dependencies

### Core
- `flutter_riverpod` - State management
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database

### UI
- `google_fonts` - Poppins font family

### Utilities
- `intl` - Date formatting
- `equatable` - Value equality

## 🎨 Theme Customization

The app uses a premium dark theme. Customize colors in:
- `lib/core/theme/app_colors.dart` - Color palette
- `lib/core/theme/app_text_styles.dart` - Typography
- `lib/core/theme/app_theme.dart` - Theme configuration

**Current Color Palette:**
- Background: `#0F172A` (Slate 900)
- Primary: `#6366F1` (Indigo 500)
- Accent: `#22D3EE` (Cyan 400)
- Text: `#E5E7EB` (Gray 200)

## 📱 Screenshots

> Add your app screenshots here

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support, email your.email@example.com or open an issue on GitHub.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for design inspiration
- Google Fonts for typography

---

**Built with ❤️ using Flutter and Firebase**
