// Mock implementation of image_picker_web for non-web platforms
import 'dart:typed_data';

class ImagePickerWeb {
  static final ImagePickerWeb _instance = ImagePickerWeb._();
  
  factory ImagePickerWeb() => _instance;
  
  ImagePickerWeb._();
  
  static Future<Uint8List?> getImageAsBytes() async {
    // Return mock image data for testing
    return Uint8List.fromList([0, 1, 2, 3, 4, 5]);
  }
}