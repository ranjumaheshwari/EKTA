// Local stub for FlutterAccessibilityService used by the app.
// This provides minimal implementations to satisfy analyzer and allow
// the app to build without the external package present.

class FlutterAccessibilityService {
  // Returns whether accessibility permission appears to be enabled.
  static Future<bool> isAccessibilityPermissionEnabled() async {
    // Conservative default: report not granted.
    return false;
  }

  // Request accessibility permission (opens settings on real plugin).
  static Future<void> requestAccessibilityPermission() async {
    // No-op in stub.
    return;
  }
}
