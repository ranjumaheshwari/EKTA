import 'package:flutter/material.dart';

// Minimal OnboardingView stub to satisfy imports and provide a simple onboarding step.
class OnboardingView extends StatelessWidget {
  final String stepKey;
  final VoidCallback onNext;

  const OnboardingView(
      {super.key, required this.stepKey, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final title = stepKey == 'welcome' ? 'Welcome' : 'Ready';
    final subtitle = stepKey == 'welcome'
        ? 'Welcome to Bhasha Setu. Let\'s get started.'
        : 'You are ready to use the app.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.language,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onNext,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
