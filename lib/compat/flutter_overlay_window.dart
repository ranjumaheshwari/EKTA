import 'dart:async';
enum PositionGravity { auto, topLeft, topRight, bottomLeft, bottomRight }

enum NotificationVisibility { visibilityPublic, visibilityPrivate, visibilitySecret }

enum OverlayFlag { defaultFlag }

enum OverlayAlignment { centerRight, centerLeft, topRight, topLeft, bottomRight, bottomLeft }

class FlutterOverlayWindow {
  static bool _active = false;
  static final _overlayController = StreamController<dynamic>.broadcast();

  static Stream<dynamic> get overlayListener => _overlayController.stream;

  static Future<bool> isActive() async {
    return _active;
  }

  static Future<void> closeOverlay() async {
    _active = false;
  }

  static Future<bool> isPermissionGranted() async {
    return true;
  }

  static Future<bool?> requestPermission() async {
    return true;
  }

  static Future<void> showOverlay({
    bool enableDrag = true,
    String? overlayTitle,
    String? overlayContent,
    OverlayFlag flag = OverlayFlag.defaultFlag,
    OverlayAlignment alignment = OverlayAlignment.centerRight,
    NotificationVisibility visibility = NotificationVisibility.visibilityPublic,
    PositionGravity positionGravity = PositionGravity.auto,
    int height = 150,
    int width = 150,
  }) async {
    _active = true;
  }

  static Future<void> shareData(dynamic data) async {
    _overlayController.add(data);
  }

  static Future<void> resizeOverlay(int height, int width, bool animated) async {}
  static Future<void> updateFlag(OverlayFlag flag) async {}
}
