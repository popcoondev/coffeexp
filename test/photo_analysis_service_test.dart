import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:coffeexp/services/photo_analysis_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mock.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}
class MockUser extends Mock implements User {
  @override
  String get uid => 'test-uid';
}

class MockReference extends Mock implements Reference {
  @override
  String get fullPath => 'test-path';
}

class MockStorageBucket extends Mock implements FirebaseStorage {
  @override
  String get bucket => 'test-bucket';
}

class MockHttpsCallable extends Mock implements HttpsCallable {}

class MockPhotoAnalysisService implements PhotoAnalysisService {
  @override
  FirebaseAuth get auth => MockFirebaseAuth();
  
  @override
  FirebaseStorage get storage => MockFirebaseStorage();
  
  @override
  FirebaseFunctions get functions => MockFirebaseFunctions();
  
  @override
  Future<Map<String, dynamic>> analyzeCoffeePhoto(String imageUrl) async {
    return {
      "name": "テスト エチオピア",
      "roaster": "Test Roasters",
      "country": "エチオピア",
      "region": "Test Region",
      "process": "ウォッシュド",
      "variety": "テスト品種",
      "elevation": "1800-2000m",
      "roastLevel": "Medium"
    };
  }
  
  @override
  Future<String> uploadImage(dynamic imageData) async {
    return 'gs://test-bucket/test-image.jpg';
  }
}

void main() {
  late PhotoAnalysisService photoAnalysisService;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseStorage mockStorage;
  late MockFirebaseFunctions mockFunctions;
  late MockReference mockReference;
  late MockUser mockUser;
  late MockHttpsCallable mockCallable;

  // Initialize Firebase mocks
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockStorage = MockFirebaseStorage();
    mockFunctions = MockFirebaseFunctions();
    mockReference = MockReference();
    mockUser = MockUser();
    mockCallable = MockHttpsCallable();

    // Use a mock instance for all tests
    final mockInstance = MockPhotoAnalysisService();
    PhotoAnalysisService.setMockInstance(mockInstance);
    photoAnalysisService = PhotoAnalysisService.getInstance();
  });

  group('PhotoAnalysisService', () {
    test('getInstance returns a singleton instance', () {
      final instance1 = PhotoAnalysisService.getInstance();
      final instance2 = PhotoAnalysisService.getInstance();
      
      // Same instance should be returned
      expect(identical(instance1, instance2), true);
    });

    test('setMockInstance replaces the singleton instance', () {
      // Create a custom mock implementation
      final mockInstance = MockPhotoAnalysisService();
      
      PhotoAnalysisService.setMockInstance(mockInstance);
      final instance = PhotoAnalysisService.getInstance();
      
      // The mock instance should be returned
      expect(identical(instance, mockInstance), true);
    });
    
    test('analyzeCoffeePhoto returns mock data', () async {
      // The service should return mock data
      final result = await photoAnalysisService.analyzeCoffeePhoto('gs://test-bucket/test-image.jpg');
      
      // Verify the expected mock data from our MockPhotoAnalysisService
      expect(result['name'], 'テスト エチオピア');
      expect(result['roaster'], 'Test Roasters');
      expect(result['country'], 'エチオピア');
    });
  });
}