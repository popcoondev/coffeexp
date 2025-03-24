# Coffee Package Photo Analysis Implementation

## Overview
This document outlines the implementation of the coffee package photo analysis feature using Gemini Vision API via Firebase Functions.

## Components

### 1. Firebase Cloud Function: `analyzeCoffeePhoto`
- Implemented in `/functions/src/index.ts`
- Takes an image URL from Firebase Storage
- Calls Gemini Vision API with a specific prompt to extract coffee details
- Returns structured data in JSON format

### 2. Photo Analysis Service
- Implemented in `/lib/services/photo_analysis_service.dart`
- Singleton pattern with mockable interface for testing
- Handles image upload to Firebase Storage
- Calls the Cloud Function to analyze the image
- Returns structured coffee data to the UI

### 3. UI Integration
- Updated `/lib/screens/add_coffee_screen.dart` to:
  - Add a camera button to capture/select coffee package photos
  - Show loading indicators during analysis
  - Auto-fill form fields with extracted data
  - Allow user to edit data before saving

### 4. Testing Framework
- Integration tests using Flutter Driver in `/test_driver/`
- Mock implementations for Firebase services
- BDD-style tests with Gherkin for feature verification

## Development vs Production
- Development mode uses dummy data (`useDummyData = true`) to allow testing without a Firebase Blaze plan
- Production will use actual Firebase Function calls (`useDummyData = false`)

## API Key Configuration
- Gemini API key needs to be configured using Firebase CLI:
```
firebase functions:config:set gemini.api_key=YOUR_API_KEY
```

## Testing
To run the tests:
1. For mobile testing:
```
flutter drive --target=test_driver/app.dart --driver=test_driver/test_driver.dart
```

2. For web testing:
```
chromedriver --port=4444 &
flutter drive -d chrome --target=test_driver/app.dart --driver=test_driver/test_driver.dart
```

## Deployment
1. Deploy the Firebase Function:
```
cd functions
npm run deploy
```

2. Build the app with production settings:
- Set `useDummyData = false` in photo_analysis_service.dart
- Build for desired platforms

## Limitations and Future Improvements
1. Current implementation is limited to Japanese coffee packaging
2. Future enhancements:
   - Multi-language support
   - QR code/barcode detection
   - Improved error handling for poor image quality
   - Caching of analysis results