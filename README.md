# SubTrack

A comprehensive Flutter application for managing and tracking your subscriptions, helping you stay on top of your recurring payments and free trials.

<p align="center">
  <img src="https://github.com/user-attachments/assets/78a7ef02-60a3-4b39-807f-c519004ec709" width="240" />
  <img src="https://github.com/user-attachments/assets/942b301c-8268-43fd-8949-6e215cd062c7" width="240" />
  <img src="https://github.com/user-attachments/assets/c45596eb-40e3-48ad-bcd9-b0f81f72e3d5" width="240" />
  <img src="https://github.com/user-attachments/assets/3584447c-e088-485a-bebb-2fcf030df7a5" width="240" />
</p>

## Features

### Dashboard
- **Overview Statistics**: Track total monthly/yearly spending
- **Visual Charts**: Interactive spending charts using FL Chart
- **Upcoming Payments**: Never miss a payment with clear upcoming payment views
- **Category Breakdown**: Organize subscriptions by categories

### Smart Notifications
- **Payment Reminders**: Get notified before payments are due
- **Trial Expiration Alerts**: Never forget about ending free trials
- **Customizable Timing**: Set reminder preferences (default: 3 days before)

### Trial Watchdog
- **Free Trial Tracking**: Monitor all your active free trials
- **Expiration Warnings**: Get alerts before trials convert to paid subscriptions
- **Trial Management**: Easy overview of trial end dates

### Modern UI/UX
- **Dark/Light Theme**: Automatic theme switching support
- **Material Design**: Clean, intuitive interface
- **Responsive Design**: Works across different screen sizes
- **Custom Color Scheme**: Carefully crafted color palette

### Cross-Platform Support
- **Android**: Full Android support with API 21+
- **iOS**: Complete iOS compatibility
- **Web**: Progressive Web App capabilities
- **Desktop**: Windows, macOS, and Linux support

## Tech Stack 

### Framework & Language
- **Flutter**: 3.7.2+
- **Dart**: Latest stable version

### Key Dependencies
- **Provider**: State management (^6.1.5)
- **FL Chart**: Beautiful charts and graphs (^1.0.0)
- **Flutter Local Notifications**: Push notifications (^17.2.3)
- **Shared Preferences**: Local data persistence (^2.3.2)

### Architecture
- **Provider Pattern**: For state management
- **Repository Pattern**: Clean data layer separation
- **Service Layer**: Notification and business logic services

## Getting Started 

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/kasramontakhabi/subtrack.git
   cd subtrack
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34
- Compile SDK: API 35
- Java Version: 11
- Core Library Desugaring: Enabled

#### iOS
- iOS 12.0+
- Xcode 14+

## Project Structure 

```
lib/
├── data/
│   └── dummy_data.dart          # Sample data for development
├── models/
│   └── subscription.dart        # Subscription data model
├── providers/
│   ├── auth_provider.dart       # Authentication state
│   ├── subscription_provider.dart # Subscription management
│   └── theme_provider.dart      # Theme management
├── screens/
│   ├── add_subscription_screen.dart
│   ├── dashboard_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── main_navigation.dart
│   └── trial_watchdog_screen.dart
├── services/
│   └── notification_service.dart # Push notification handling
├── theme/
│   ├── app_colors.dart          # Color definitions
│   └── app_theme.dart           # Theme configuration
├── widgets/
│   ├── dashboard_stat_card.dart
│   ├── filter_chips.dart
│   ├── subscription_card.dart
│   └── trial_card.dart
└── main.dart                    # App entry point
```

## Key Features Implementation 

### State Management
The app uses the Provider pattern for state management:
- **AuthProvider**: Handles user authentication state
- **SubscriptionProvider**: Manages subscription data and operations
- **ThemeProvider**: Controls app theme (light/dark mode)

### Notifications
Local notifications are implemented using `flutter_local_notifications`:
- Payment reminders
- Trial expiration alerts
- Customizable notification timing

## Building for Production 

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure proper error handling

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
