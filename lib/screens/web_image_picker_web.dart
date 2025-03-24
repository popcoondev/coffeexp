// This file is only imported on web platforms
import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'web_image_picker.dart';

// Web implementation for image picker
class WebImagePicker implements PlatformImagePicker {
  @override
  Future<Uint8List?> getImageAsBytes() async {
    final completer = Completer<Uint8List?>();
    
    // Create file input element
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    
    // Add to DOM temporarily
    html.document.body?.append(input);
    
    // Listen for file selection
    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        final reader = html.FileReader();
        
        reader.onLoad.listen((event) {
          final result = reader.result as Uint8List?;
          completer.complete(result);
          input.remove(); // Remove from DOM
        });
        
        reader.onError.listen((event) {
          completer.complete(null);
          input.remove(); // Remove from DOM
        });
        
        // Read the file
        reader.readAsArrayBuffer(file);
      } else {
        completer.complete(null);
        input.remove(); // Remove from DOM
      }
    });
    
    // Open file picker dialog
    input.click();
    
    return completer.future;
  }
}

// Export the factory function for web
PlatformImagePicker webImagePicker() {
  return WebImagePicker();
}