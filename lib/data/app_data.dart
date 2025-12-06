import '../models/language.dart';

const List<Language> indianLanguages = [
  Language(code: "hi", name: "Hindi", nativeName: "हिन्दी", script: "Devanagari"),
  Language(code: "kn", name: "Kannada", nativeName: "ಕನ್ನಡ", script: "Kannada"),
  Language(code: "ta", name: "Tamil", nativeName: "தமிழ்", script: "Tamil"),
  Language(code: "te", name: "Telugu", nativeName: "తెలుగు", script: "Telugu"),
  Language(code: "ml", name: "Malayalam", nativeName: "മലയാളം", script: "Malayalam"),
  Language(code: "mr", name: "Marathi", nativeName: "मराठी", script: "Devanagari"),
  Language(code: "bn", name: "Bengali", nativeName: "বাংলা", script: "Bengali"),
  Language(code: "gu", name: "Gujarati", nativeName: "ગુજરાતી", script: "Gujarati"),
  Language(code: "pa", name: "Punjabi", nativeName: "ਪੰਜਾਬੀ", script: "Gurmukhi"),
];

class OnboardingContent {
  final String headline;
  final String subheadline;
  final String description;
  final String cta;

  const OnboardingContent({
    required this.headline,
    required this.subheadline,
    required this.description,
    required this.cta,
  });
}

const Map<String, OnboardingContent> onboardingCopy = {
  'welcome': OnboardingContent(
    headline: "Namaste! 🙏",
    subheadline: "Welcome to Bhasha Setu",
    description: "Finally, use any app in your own language. No more struggling with English — we translate everything on your screen, instantly.",
    cta: "Let's Begin",
  ),
  'ready': OnboardingContent(
    headline: "All Set! 🎉",
    subheadline: "Ab aap tayaar hain!",
    description: "Bhasha Setu is ready to help you. Open any app and tap the floating button to translate.",
    cta: "Start Using Bhasha Setu",
  ),
};