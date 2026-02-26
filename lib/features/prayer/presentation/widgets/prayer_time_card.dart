import 'package:flutter/material.dart';

class PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;
  final bool isPrayed;
  final bool isNext;
  final bool isPast;

  const PrayerTimeCard({
    super.key,
    required this.name,
    required this.time,
    this.isPrayed = false,
    this.isNext = false,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMissed = isPast && !isPrayed;

    Color bgColor = theme.cardColor;
    Color borderColor = Colors.transparent;

    if (isNext) {
      bgColor = theme.primaryColor.withAlpha((255 * 0.05).toInt());
      borderColor = theme.primaryColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(
          _getIconForPrayer(name),
          color: isNext ? theme.primaryColor : Colors.grey.shade500,
          size: 28,
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        subtitle: isMissed
            ? Text(
                'You can still make it up 🤍',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                color: isNext ? theme.primaryColor : null,
              ),
            ),
            const SizedBox(width: 16),
            _buildStatusIndicator(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    if (isPrayed) {
      return Icon(Icons.check_circle, color: theme.primaryColor);
    } else if (isPast) {
      return Icon(Icons.circle_outlined, color: Colors.grey.shade400);
    } else {
      return Icon(Icons.circle_outlined, color: Colors.grey.shade300);
    }
  }

  IconData _getIconForPrayer(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return Icons.nights_stay_outlined;
      case 'dhuhr':
        return Icons.wb_sunny_outlined;
      case 'asr':
        return Icons.wb_sunny;
      case 'maghrib':
        return Icons.wb_twilight_outlined;
      case 'isha':
        return Icons.mode_night_outlined;
      default:
        return Icons.access_time;
    }
  }
}
