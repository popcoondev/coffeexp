// Mock implementation of dart:html for non-web platforms
class File {
  final String name;
  
  File(this.name);
}

class FileReader {
  dynamic result;
  
  void readAsDataUrl(File file) {
    // Mock implementation that does nothing
    result = 'mock_data_url';
  }
  
  Stream<Event> get onLoadEnd => Stream.fromIterable([Event('loadend')]);
}

class Event {
  final String type;
  
  Event(this.type);
}

// Mocked window object
final window = Window();

class Window {
  void addEventListener(String type, Function listener) {
    // Mock implementation that does nothing
  }
  
  void removeEventListener(String type, Function listener) {
    // Mock implementation that does nothing
  }
}

// Mocked document object
final document = Document();

class Document {
  final Body? body = Body();
}

class Body {
  void append(dynamic element) {
    // Mock implementation that does nothing
  }
}