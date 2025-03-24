// This file contains platform-specific implementations
// Use conditional imports in Flutter

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

// Interface for our image picker abstraction
abstract class PlatformImagePicker {
  Future<Uint8List?> getImageAsBytes();
}

// Default implementation for non-web platforms
class DefaultImagePicker implements PlatformImagePicker {
  @override
  Future<Uint8List?> getImageAsBytes() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return null;
    return await image.readAsBytes();
  }
}

// Import the conditional implementation based on platform
// This will be replaced with the web version when compiled for web
PlatformImagePicker getImagePicker() {
  if (kIsWeb) {
    // When running on web, this will be replaced with WebImagePicker
    // The web-specific implementation is in web_image_picker_web.dart
    // which will be automatically used when compiling for web
    return webImagePicker();
  } else {
    // For mobile platforms
    return DefaultImagePicker();
  }
}

// This is a stub that will be replaced by the web implementation when on web platform
PlatformImagePicker webImagePicker() {
  // This should never be called on non-web platforms
  throw UnsupportedError('webImagePicker() is only supported on web platforms.');
}