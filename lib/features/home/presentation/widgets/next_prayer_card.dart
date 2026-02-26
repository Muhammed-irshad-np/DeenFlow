import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).primaryColor.withAlpha((255 * 0.2).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Asr',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.warmOffWhite,
                  fontSize: 32,
                ),
              ),
              Icon(
                Icons.wb_sunny_outlined,
                color: AppTheme.goldAccent,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '3:45 PM',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.warmOffWhite.withAlpha((255 * 0.8).toInt()),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '-01:15:30',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.warmOffWhite,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Time remaining',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.warmOffWhite.withAlpha(
                        (255 * 0.6).toInt(),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.deepEmerald,
                ),
                label: const Text(
                  'Prayed',
                  style: TextStyle(
                    color: AppTheme.deepEmerald,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
