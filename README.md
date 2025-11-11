# TaskFlow - Professional To Do App

A beautifully designed, feature-rich To Do application built with Flutter and Hive database.

## Features

### ✨ Modern UI/UX
- Professional design with smooth animations
- Material 3 design system
- Custom color scheme and typography
- Animated splash screen
- Staggered list animations

### 📋 Task Management
- Create, edit, and delete tasks
- Set task priorities (Low, Medium, High)
- Add due dates with overdue indicators
- Organize tasks by categories
- Add detailed descriptions
- Mark tasks as complete/incomplete

### 🔍 Advanced Features
- Real-time search functionality
- Filter tasks by status (All, Pending, Completed, Overdue)
- Filter by categories
- Smart sorting by priority and due date
- Task statistics and analytics
- Category breakdown with visual progress

### 📊 Statistics Dashboard
- Overview of completed, pending, and overdue tasks
- High priority task counter
- Category-wise task distribution
- Visual progress indicators
- Quick action buttons for common tasks

### 💾 Data Persistence
- Local storage using Hive database
- Fast and efficient data operations
- Offline-first approach
- Data persistence across app restarts

## Technical Stack

- **Framework**: Flutter
- **Database**: Hive (NoSQL local database)
- **State Management**: ValueListenableBuilder
- **Animations**: flutter_staggered_animations
- **Typography**: Google Fonts (Inter)
- **Date Handling**: intl package

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Project Structure

```
lib/
├── boxes/          # Hive box management
├── models/         # Data models (Task)
├── screens/        # App screens
├── theme/          # App theme and styling
├── widgets/        # Reusable UI components
└── main.dart       # App entry point
```

## Dependencies

- `hive` & `hive_flutter`: Local database
- `google_fonts`: Typography
- `intl`: Date formatting
- `flutter_staggered_animations`: List animations
- `build_runner` & `hive_generator`: Code generation
