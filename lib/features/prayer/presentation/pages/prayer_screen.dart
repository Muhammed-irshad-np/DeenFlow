import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/prayer_time_card.dart';
import '../providers/prayer_provider.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Prayer Tracker'),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: provider.selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    provider.changeDate(picked);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  // TODO: Settings screen
                },
              ),
            ],
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateHeader(context, provider),
                        SizedBox(height: 32.h),
                        _buildPrayerList(context, provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrayerList(BuildContext context, PrayerProvider provider) {
    if (provider.isLoading) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => provider.retry(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.todayPrayers.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: Text('No prayer times available.')),
      );
    }

    final now = DateTime.now();

    // Find next prayer (first prayer that is in the future)
    int nextPrayerIndex = provider.todayPrayers.indexWhere(
      (p) => p.time.isAfter(now),
    );

    // If all prayers are in the past today, next prayer might be tomorrow's Fajr
    // but for highlighting today's list, we leave it as -1

    return Column(
      children: provider.todayPrayers.asMap().entries.map((entry) {
        final index = entry.key;
        final prayer = entry.value;
        final isPast = prayer.time.isBefore(now);
        final isNext = index == nextPrayerIndex;

        return PrayerTimeCard(
          name: prayer.name,
          time: DateFormat.jm().format(prayer.time),
          isPrayed: prayer.isPrayed,
          isPast: isPast,
          isNext: isNext,
          onTap: () {
            // Can toggle if it's past or if it's the next prayer (in case it's early or right on time)
            if (isPast || isNext) {
              provider.togglePrayerStatus(prayer);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildDateHeader(BuildContext context, PrayerProvider provider) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday =
        provider.selectedDate.year == now.year &&
        provider.selectedDate.month == now.month &&
        provider.selectedDate.day == now.day;

    final dateText = isToday
        ? 'Today'
        : DateFormat('MMM d, yyyy').format(provider.selectedDate);

    final prayedCount = provider.todayPrayers.where((p) => p.isPrayed).length;
    final totalCount = provider.todayPrayers.isNotEmpty
        ? provider.todayPrayers.length
        : 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateText,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Islamic Date Format', // Hijri date formatting can be added later
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha((255 * 0.1).toInt()),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '$prayedCount/$totalCount Prayed',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
