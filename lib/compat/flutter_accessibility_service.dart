import 'dart:async';

class FlutterAccessibilityService {
  static final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  static Stream<dynamic> get accessStream => _controller.stream;

  static Future<bool> isAccessibilityPermissionEnabled() async {
    return true;
  }

  static Future<bool> requestAccessibilityPermission() async {
    return true;
  }
}
