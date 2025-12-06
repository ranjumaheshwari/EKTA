// Local shim for flutter_overlay_window API used in the app.
// Provides minimal implementations so analyzer and builds succeed
// without the external package.

class OverlayFlag {
  static const int defaultFlag = 0;
}

class OverlayAlignment {
  static const int centerRight = 0;
}

class NotificationVisibility {
  static const int visibilityPublic = 0;
}

class PositionGravity {
  static const int auto = 0;
}

class FlutterOverlayWindow {
  static Future<bool?> requestPermission() async {
    // Return granted by default in this shim
    return true;
  }

  static Future<bool> isPermissionGranted() async {
    return true;
  }

  static Future<bool> isActive() async {
    return false;
  }

  static Future<void> showOverlay({
    bool enableDrag = false,
    String? overlayTitle,
    String? overlayContent,
    int? flag,
    int? alignment,
    int? visibility,
    int? positionGravity,
    double? height,
    double? width,
  }) async {
    // No-op shim
    return;
  }

  static Future<void> closeOverlay() async {
    return;
  }

  static Future<void> resizeOverlay(int w, int h, bool center) async {
    return;
  }
}
