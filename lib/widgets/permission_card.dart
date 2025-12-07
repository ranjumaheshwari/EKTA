import 'package:flutter/material.dart';
import 'package:bhasha_setu/compat/lucide_icons.dart';
import '../theme/colors.dart';

class PermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isGranted;
  final VoidCallback onGrant;
  final Color color;

  const PermissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isGranted,
    required this.onGrant,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isGranted ? AppColors.success : AppColors.border,
          width: 2,
        ),
      ),
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGranted
                    ? AppColors.success.withOpacity(0.1)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isGranted ? LucideIcons.check : icon,
                color: isGranted ? AppColors.success : color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: 12),
                  if (!isGranted)
                    ElevatedButton(
                      onPressed: onGrant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Enable"),
                    )
                  else
                    Row(
                      children: [
                        const Icon(LucideIcons.check,
                            size: 16, color: AppColors.success),
                        SizedBox(width: 4),
                        const Text(
                          "Enabled",
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
