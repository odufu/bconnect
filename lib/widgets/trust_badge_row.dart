import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TrustBadgeRow extends StatelessWidget {
  final int dealsCompleted;
  final double positivePercent;
  final double negativePercent;
  final List<String> badges;
  final bool compact;

  const TrustBadgeRow({
    super.key,
    this.dealsCompleted = 248,
    this.positivePercent = 90.0,
    this.negativePercent = 10.0,
    this.badges = const ['Verified ✓', 'Top Seller', 'Fast Shipper'],
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 11, color: AppColors.primary),
                const SizedBox(width: 3),
                Text(
                  '${positivePercent.toInt()}% Positive',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$dealsCompleted Deals',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Row: 248 Deals | 90% Positive (green) | 10% Negative (red)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$dealsCompleted',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Deals Completed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 26, color: AppColors.border),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_rounded, size: 14, color: AppColors.positiveGreen),
                      const SizedBox(width: 4),
                      Text(
                        '${positivePercent.toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.positiveGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Positive Rating',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 26, color: AppColors.border),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_down_rounded, size: 14, color: AppColors.negativeRed),
                      const SizedBox(width: 4),
                      Text(
                        '${negativePercent.toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.negativeRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Negative Rating',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Badges: Verified ✓ | Top Seller | Fast Shipper
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: badges.map((badge) {
            Color badgeBg;
            Color badgeText;
            IconData iconData;

            if (badge.contains('Verified')) {
              badgeBg = AppColors.primaryLight;
              badgeText = AppColors.primaryDark;
              iconData = Icons.verified_user_rounded;
            } else if (badge.contains('Top')) {
              badgeBg = const Color(0xFFFEF3C7);
              badgeText = const Color(0xFF92400E);
              iconData = Icons.military_tech_rounded;
            } else {
              badgeBg = const Color(0xFFEFF6FF);
              badgeText = const Color(0xFF1D4ED8);
              iconData = Icons.bolt_rounded;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: badgeText.withAlpha(50)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, size: 13, color: badgeText),
                  const SizedBox(width: 4),
                  Text(
                    badge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
