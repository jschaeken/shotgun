# Shotgun Mobile App

The Shotgun mobile app is designed to make carpooling easy, fun, and engaging, allowing friends and family to book seats in cars for shared rides. The app integrates features like seat booking, origin and destination mapping, group music queuing with Spotify, and in-ride games, providing a comprehensive carpooling experience.

## Project Structure

This project adopts Clean Architecture and uses the BLoC pattern for state management, ensuring a scalable, maintainable, and testable codebase. The app is divided into three main feature modules: Common/Core, Driver, and Passenger, each encapsulating its domain-specific logic, data, and presentation layers.

### Common/Core Module

Contains shared utilities, widgets, models, and BLoCs that are used across the entire app.

- **/lib**
  - **/features**
    - **/common**
      - **/core**
        - **/network** - Networking setup and utilities.
        - **/theme** - Shared UI themes and style definitions.
        - **/widgets** - Commonly used widgets across the app.
      - **/models** - Shared data models across features.
      - **/bloc** - Shared BLoCs for common functionality, e.g., authentication.

### Driver Module

Focused on functionality exclusive to drivers, including creating rides, managing ride requests, and music queue management.

- **/driver**
  - **/domain** - Business logic and use cases for driver-specific functionalities.
  - **/data** - Data models, repositories implementations, and data sources for driver-related data.
  - **/presentation** - UI screens, widgets, and BLoCs dedicated to driver interactions.

### Passenger Module

Centers on the passenger experience, such as finding rides, booking seats, and in-ride features.

- **/passenger**
  - **/domain** - Business logic and use cases for passenger-specific functionalities.
  - **/data** - Data models, repositories implementations, and data sources for passenger-related data.
  - **/presentation** - UI screens, widgets, and BLoCs tailored to passenger needs.

## Setup and Configuration

- **Flutter Version**: Ensure you are using Flutter 2.x.x or higher.
- **Firebase**: This app uses Firebase for backend services. Follow the Firebase project setup guide for Flutter to configure your Firebase instance.
- **Spotify API**: For the music queuing feature, you'll need to set up a Spotify Developer account and configure your app with Spotify.

## Running the App

1. Clone the repository to your local machine.
2. Navigate to the project directory and run `flutter pub get` to install dependencies.
3. Create your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in the respective directories.
4. Run `flutter run` to build and run the app on your connected device or emulator.

## Contributing

Contributions to the Shotgun app are welcome. Please follow these steps to contribute:

1. Fork the project repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes with clear, descriptive commit messages.
4. Push your branch and submit a pull request against the main branch.
