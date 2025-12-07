import 'package:flutter/material.dart';
import 'package:bhasha_setu/compat/lucide_icons.dart';
import 'package:bhasha_setu/compat/flutter_overlay_window.dart';
import 'package:bhasha_setu/compat/flutter_accessibility_service.dart';
import '../theme/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/permission_card.dart';

class PermissionsScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const PermissionsScreen({super.key, required this.onContinue});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  bool isOverlayGranted = false;
  bool isAccessibilityGranted = false;

  @override
  void initState() {
    super.initState();
    // Register this observer to detect when user returns to the app
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app resumes (user comes back from Settings), re-check permissions
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    // Check Overlay Permission
    final overlay = await FlutterOverlayWindow.isPermissionGranted();

    // Check Accessibility Permission
    final accessibility =
        await FlutterAccessibilityService.isAccessibilityPermissionEnabled();

    if (mounted) {
      setState(() {
        isOverlayGranted = overlay;
        isAccessibilityGranted = accessibility;
      });
    }
  }

  Future<void> _requestOverlay() async {
    // This plugin returns a boolean status directly
    final bool? status = await FlutterOverlayWindow.requestPermission();
    if (mounted) {
      setState(() => isOverlayGranted = status ?? false);
    }
  }

  Future<void> _requestAccessibility() async {
    // This opens the system settings screen
    await FlutterAccessibilityService.requestAccessibilityPermission();
    // We rely on didChangeAppLifecycleState to check the result when they return
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we can proceed
    final bool allGranted = isOverlayGranted && isAccessibilityGranted;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.trust.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.shield,
                    size: 48, color: AppColors.trust),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                "Permissions Needed",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground),
              ),
              const SizedBox(height: 8),
              const Text(
                "To translate text from other apps, we need these permissions. Your data stays on your device.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 32),

              // Permission Cards List
              Expanded(
                child: ListView(
                  children: [
                    PermissionCard(
                      title: "Screen Reading",
                      description:
                          "Required to read text from other apps so we can translate it for you.",
                      icon: LucideIcons.eye,
                      isGranted: isAccessibilityGranted,
                      onGrant: _requestAccessibility,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    PermissionCard(
                      title: "Translation Bubble",
                      description:
                          "Required to show the floating translation button over other apps.",
                      icon: LucideIcons.layers,
                      isGranted: isOverlayGranted,
                      onGrant: _requestOverlay,
                      color: AppColors.trust,
                    ),
                  ],
                ),
              ),

              // Continue Button
              CustomButton(
                text: allGranted ? "Continue" : "Enable Permissions",
                onPressed: allGranted
                    ? widget.onContinue
                    : () {
                        // Optional: Show a toast if they click without permissions
                        if (!isAccessibilityGranted)
                          _requestAccessibility();
                        else if (!isOverlayGranted) _requestOverlay();
                      },
                color: allGranted ? AppColors.primary : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
