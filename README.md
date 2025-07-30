# SwiftWallet

A cross-platform expense tracker app built with Flutter.

## Features

- Email + OTP authentication (simulated)
- Expense tracking with CRUD operations
- Monthly budget management
- Spending history with visual charts
- Offline support using SQLite database
- CSV and PDF export functionality
- Dark mode support
- Language switching (English/Swahili)
- Cross-platform support (Web, Android, iOS, Desktop)

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies

### Running the App

- For web: `flutter run -d chrome`
- For Android: `flutter run -d android`
- For iOS: `flutter run -d ios`
- For desktop: `flutter run -d linux` (or windows, macos)

### Building for Deployment

- For web: `flutter build web`
- For Android: `flutter build apk`
- For iOS: `flutter build ios`
- For desktop: `flutter build linux` (or windows, macos)

## Dependencies

- flutter_localizations: For internationalization support
- shared_preferences: For local data storage
- path_provider: For file system access
- share_plus: For sharing reports
- intl: For internationalization
- sqflite: For SQLite database support
- pdf: For PDF generation

## Architecture

The app follows a clean architecture pattern with:
- `lib/components`: Reusable UI components
- `lib/screens`: Screen-specific widgets
- `lib/navigation`: Navigation logic
- `lib/utils`: Utility functions and helpers
- `lib/services`: Business logic and services
- `lib/store`: State management (if using a state management solution)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is licensed under the MIT License.
