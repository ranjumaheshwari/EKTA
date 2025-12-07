import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// import 'data/app_data.dart'; // unused - removed to silence analyzer
import 'models/language.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/permissions_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/colors.dart';
import 'widgets/custom_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize overlay window
  if (!kIsWeb && Platform.isAndroid) {
    await FlutterOverlayWindow.requestPermission();
  }

  const String geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  if (geminiKey.isNotEmpty) {
    genai.GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiKey);
  }

  runApp(const BhashaSetuApp());
}

class BhashaSetuApp extends StatelessWidget {
  const BhashaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhasha Setu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      home: const OnboardingOrchestrator(),
    );
  }
}

class OnboardingOrchestrator extends StatefulWidget {
  const OnboardingOrchestrator({super.key});

  @override
  State<OnboardingOrchestrator> createState() => _OnboardingOrchestratorState();
}

class _OnboardingOrchestratorState extends State<OnboardingOrchestrator> {
  int step = 0;
  Language? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return OnboardingView(
          stepKey: 'welcome',
          onNext: () => setState(() => step = 1),
        );
      case 1:
        return LanguageScreen(
          onLanguageSelected: (lang) {
            setState(() {
              selectedLanguage = lang;
              step = 2;
            });
          },
        );
      case 2:
        return PermissionsScreen(
          onContinue: () => setState(() => step = 3),
        );
      case 3:
        return OnboardingView(
          stepKey: 'ready',
          onNext: () => setState(() => step = 4),
        );
      case 4:
        return Scaffold(
          body: HomeScreen(language: selectedLanguage!),
        );
      default:
        return const Scaffold(
          body: Center(child: Text('Something went wrong')),
        );
    }
  }
}

// Simple onboarding view as a fallback
class SimpleOnboardingView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onNext;

  const SimpleOnboardingView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.language,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            FadeInUp(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: CustomButton(
                text: buttonText,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
