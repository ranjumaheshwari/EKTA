import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import '../theme/colors.dart';
import '../widgets/custom_button.dart';

class LanguageScreen extends StatefulWidget {
  final Function(Language) onLanguageSelected;
  const LanguageScreen({super.key, required this.onLanguageSelected});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Language? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                "Choose Your Language",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.foreground),
              ),
              const SizedBox(height: 8),
              const Text(
                "Apni pasand ki bhasha chuniye",
                style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: indianLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = indianLanguages[index];
                    final isSelected = selected == lang;
                    return GestureDetector(
                      onTap: () => setState(() => selected = lang),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha:0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lang.nativeName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              lang.name,
                              style: const TextStyle(color: AppColors.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Continue",
                onPressed: selected != null
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('target_language_code', selected!.code);
                        await prefs.setString('target_language_name', selected!.name);
                        await prefs.setString('target_language_native', selected!.nativeName);
                        widget.onLanguageSelected(selected!);
                      }
                    : () {},
                color: selected != null ? AppColors.primary : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
