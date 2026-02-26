import 'package:flutter/material.dart';

class PrayerProgressSection extends StatelessWidget {
  const PrayerProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy state for UI
    final prayers = [
      {'name': 'Fajr', 'isPrayed': true},
      {'name': 'Dhuhr', 'isPrayed': true},
      {'name': 'Asr', 'isPrayed': false, 'isNext': true},
      {'name': 'Maghrib', 'isPrayed': false},
      {'name': 'Isha', 'isPrayed': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Prayers',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: prayers
              .map(
                (p) => _PrayerCircle(
                  name: p['name'] as String,
                  isPrayed: p['isPrayed'] as bool,
                  isNext: p['isNext'] as bool? ?? false,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PrayerCircle extends StatelessWidget {
  final String name;
  final bool isPrayed;
  final bool isNext;

  const _PrayerCircle({
    required this.name,
    required this.isPrayed,
    this.isNext = false,
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
    } else if (isNext) {
      borderColor = primary;
      iconColor = primary;
      icon = Icons.access_time;
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isNext
                ? primary
                : (isPrayed ? primary : Colors.grey.shade600),
            fontWeight: isNext || isPrayed
                ? FontWeight.w600
                : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
