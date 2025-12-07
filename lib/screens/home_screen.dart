import 'package:flutter/material.dart';
import 'package:bhasha_setu/compat/flutter_overlay_window.dart'
    show
        FlutterOverlayWindow,
        PositionGravity,
        NotificationVisibility,
        OverlayFlag,
        OverlayAlignment;
import 'package:bhasha_setu/compat/lucide_icons.dart';
import 'dart:async';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart'
    as fas;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/language.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  final Language language;
  const HomeScreen({super.key, required this.language});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isActive = false;
  StreamSubscription? _accSub;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  /// Checks if the overlay is currently active (persists state across app restarts)
  Future<void> _checkServiceStatus() async {
    final bool active = await FlutterOverlayWindow.isActive();
    if (mounted) {
      setState(() => isActive = active);
    }
  }

  /// Toggles the floating bubble on/off
  Future<void> toggleService() async {
    if (isActive) {
      // STOP Service
      await FlutterOverlayWindow.closeOverlay();
      if (mounted) {
        setState(() => isActive = false);
      }
      Fluttertoast.showToast(
        msg: "Translation Stopped",
        backgroundColor: AppColors.foreground,
        textColor: Colors.white,
      );
    } else {
      // START Service
      // Double check permission just in case
      final bool hasPermission =
          await FlutterOverlayWindow.isPermissionGranted();

      if (!hasPermission) {
        Fluttertoast.showToast(
          msg: "Overlay permission is missing",
          backgroundColor: Colors.red,
        );
        final bool? granted = await FlutterOverlayWindow.requestPermission();
        if (granted != true) return;
      }

      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: "Bhasha Setu",
        overlayContent: "Tap to translate",
        flag: OverlayFlag.defaultFlag,
        alignment: OverlayAlignment.centerRight,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        height: 150, // Initial small size
        width: 150,
      );

      if (mounted) {
        setState(() => isActive = true);
      }

      _startListening();

      Fluttertoast.showToast(
        msg: "Translation Active",
        backgroundColor: AppColors.success,
        textColor: Colors.white,
      );
    }
  }

  void _startListening() {
    _accSub?.cancel();
    _accSub = fas.FlutterAccessibilityService.accessStream.listen((event) async {
      try {
        final e = event as dynamic;
        final String text = ((e.capturedText as String?) ?? '') +
            '\n' +
            (((e.nodesText as List<String>?)?.join('\n')) ?? '');
        final normalized = text.trim();
        if (normalized.isEmpty) return;
        await FlutterOverlayWindow.shareData(normalized);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _accSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Hides back button
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(LucideIcons.globe, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bhasha Setu",
                    style: TextStyle(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text("Your language, every app",
                    style: TextStyle(
                        color: AppColors.mutedForeground, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: AppColors.foreground),
            onPressed: () {
              Fluttertoast.showToast(msg: "Settings coming soon");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Status Card
                Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isActive
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.border,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Animated Status Icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.muted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive ? LucideIcons.languages : LucideIcons.square,
                          size: 40,
                          color: isActive
                              ? AppColors.success
                              : AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Status Text
                      Text(
                        isActive ? "Translation Active" : "Translation Off",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isActive
                            ? "Bhasha Setu is helping you"
                            : "Turn on to start reading apps",
                        style: const TextStyle(
                            fontSize: 16, color: AppColors.mutedForeground),
                      ),
                      const SizedBox(height: 32),

                      // Toggle Button
                      ElevatedButton.icon(
                        onPressed: toggleService,
                        icon: Icon(
                            isActive ? LucideIcons.square : LucideIcons.play),
                        label: Text(
                          isActive ? "Stop" : "Start Translating",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isActive ? Colors.white : AppColors.primary,
                          foregroundColor:
                              isActive ? AppColors.foreground : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          elevation: isActive ? 1 : 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: isActive
                                ? const BorderSide(color: AppColors.border)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Current Language Card
                GestureDetector(
                  onTap: () {
                    // Navigate back to language selection if needed
                    // For now just showing a toast
                    Fluttertoast.showToast(
                        msg: "Language: ${widget.language.name}");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.language.nativeName.isNotEmpty
                                ? widget.language.nativeName[0]
                                : "?",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Translating to",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.mutedForeground)),
                            Text(
                              "${widget.language.nativeName} (${widget.language.name})",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(LucideIcons.chevronRight,
                            color: AppColors.mutedForeground),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
