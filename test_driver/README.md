# Testing Strategy for CoffeeExp App

## Overview
This directory contains integration tests for the CoffeeExp app. We're using Flutter Driver for basic integration testing and Flutter Gherkin for BDD-style tests.

## Setup Instructions

### For Testing on Mobile
1. Connect a mobile device or start an emulator
2. Run the tests using:
```
flutter drive --target=test_driver/app.dart --driver=test_driver/test_driver.dart
```

### For Testing on Web
1. Install ChromeDriver:
```
brew install chromedriver
```
2. Start ChromeDriver on port 4444:
```
chromedriver --port=4444
```
3. Run the tests using:
```
flutter drive -d chrome --target=test_driver/app.dart --driver=test_driver/test_driver.dart
```

## Test Organization
- `app.dart`: The instrumented app for testing
- `test_driver.dart`: Basic Flutter Driver tests
- `test_config.dart`: Configuration for Gherkin BDD tests
- `features/`: BDD feature files
- `steps/`: Step implementations for BDD tests

## Mock Services
The app uses mock implementations of Firebase services during testing to avoid real API calls. The following components are mocked:
- Firebase Authentication
- Firebase Storage
- Firebase Firestore
- Cloud Functions
- Photo Analysis Service (Gemini Vision API)

## Known Issues
1. Web testing requires special handling for web-specific imports like `dart:html` and web-specific packages.
2. Some features like camera access may not work in the test environment without additional setup.

## Test Data
For testing the photo analysis feature, mock responses are provided that simulate Gemini Vision API results.