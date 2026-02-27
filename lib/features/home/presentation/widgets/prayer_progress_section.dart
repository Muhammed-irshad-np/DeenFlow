import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../prayer/presentation/providers/prayer_provider.dart';

class PrayerProgressSection extends StatelessWidget {
  const PrayerProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Prayers',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16.h),
        Consumer<PrayerProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading || provider.todayPrayers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final now = DateTime.now();
            int activePrayerIndex = provider.todayPrayers.indexWhere((p) {
              return (now.isAfter(p.time) || now.isAtSameMomentAs(p.time)) &&
                  now.isBefore(p.endTime);
            });

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: provider.todayPrayers.asMap().entries.map((entry) {
                final index = entry.key;
                final prayer = entry.value;
                final isActive = index == activePrayerIndex;

                return _PrayerCircle(
                  name: prayer.name,
                  isPrayed: prayer.isPrayed,
                  isActive: isActive,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _PrayerCircle extends StatelessWidget {
  final String name;
  final bool isPrayed;
  final bool isActive;

  const _PrayerCircle({
    required this.name,
    required this.isPrayed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    Color borderColor = Colors.grey.shade300;
    Color iconColor = Colors.grey.shade400;
    Color bgColor = Colors.transparent;
    IconData icon = Icons.circle_outlined;

    if (isPrayed) {
      borderColor = primary;
      iconColor = primary;
      bgColor = primary.withAlpha((255 * 0.1).toInt());
      icon = Icons.check_circle;
    } else if (isActive) {
      borderColor = primary;
      iconColor = primary;
      icon = Icons.access_time;
    }

    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: iconColor, size: 24.r),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isActive
                ? primary
                : (isPrayed ? primary : Colors.grey.shade600),
            fontWeight: isActive || isPrayed
                ? FontWeight.w600
                : FontWeight.normal,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
