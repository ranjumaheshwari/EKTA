import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:bhasha_setu/compat/lucide_icons.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/colors.dart';

// This function must be top-level for the overlay window
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  bool isExpanded = false;
  bool isLoading = false;
  String detectedText = "नमस्ते! यह एक उदाहरण अनुवाद है।";

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) async {
      if (event is String && event.trim().isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        final prefs = await SharedPreferences.getInstance();
        final targetNative = prefs.getString('target_language_native') ?? 'Hindi';
        const apiKey = String.fromEnvironment('GEMINI_API_KEY');

        if (apiKey.isEmpty) {
          setState(() {
            detectedText = event;
            isLoading = false;
          });
          return;
        }

        final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
        final prompt = "Translate the following text into $targetNative: '$event'. Return only the translated text.";
        try {
          final response = await model.generateContent([Content.text(prompt)]);
          final translated = response.text?.trim();
          setState(() {
            detectedText = translated?.isNotEmpty == true ? translated! : event;
            isLoading = false;
          });
        } catch (_) {
          setState(() {
            detectedText = event;
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: isExpanded
            ? Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.languages,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Bhasha Setu",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                            onPressed: () async {
                              await FlutterOverlayWindow.resizeOverlay(
                                  60, 60, true);
                              setState(() => isExpanded = false);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Detected Text:",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: SingleChildScrollView(
                                  child: isLoading
                                      ? const Center(child: CircularProgressIndicator())
                                      : Text(
                                          detectedText,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Copy to clipboard
                                    },
                                    icon: const Icon(Icons.copy, size: 16),
                                    label: const Text("Copy"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // Speak text
                                    },
                                    icon: const Icon(Icons.volume_up, size: 16),
                                    label: const Text("Speak"),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: const BorderSide(
                                          color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () async {
                  await FlutterOverlayWindow.resizeOverlay(300, 250, true);
                  setState(() => isExpanded = true);
                },
                onLongPress: () async {
                  // Close overlay completely
                  await FlutterOverlayWindow.closeOverlay();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.languages,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
      ),
    );
  }
}
