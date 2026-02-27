import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../../../prayer/domain/entities/prayer_time_record.dart';

class NextPrayerCard extends StatefulWidget {
  const NextPrayerCard({super.key});

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading || provider.todayPrayers.isEmpty) {
          return _buildLoadingOrEmptyCard(context);
        }

        final prayers = provider.todayPrayers;
        PrayerTimeRecord? currentPrayer;
        PrayerTimeRecord? nextPrayer;

        for (int i = 0; i < prayers.length; i++) {
          if (prayers[i].time.isAfter(_now)) {
            nextPrayer = prayers[i];
            if (i > 0) {
              currentPrayer = prayers[i - 1];
            }
            break;
          }
        }

        if (nextPrayer == null && prayers.isNotEmpty) {
          // After Isha today
          currentPrayer = prayers.last;
          nextPrayer = PrayerTimeRecord(
            name: prayers.first.name,
            time: prayers.first.time.add(const Duration(days: 1)),
            endTime: prayers.first.endTime.add(const Duration(days: 1)),
            isPrayed: false,
          );
        }

        if (currentPrayer != null && _now.isAfter(currentPrayer.endTime)) {
          // Current prayer has expired
          currentPrayer = null;
        }

        bool isUpcomingOnly = currentPrayer == null;
        final displayPrayer = currentPrayer ?? nextPrayer;
        if (displayPrayer == null) return const SizedBox();

        final targetTime = isUpcomingOnly
            ? nextPrayer!.time
            : currentPrayer.endTime;
        final difference = targetTime.difference(_now);

        String remainingTimeStr = "00:00:00";
        if (!difference.isNegative) {
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          String hours = twoDigits(difference.inHours);
          String minutes = twoDigits(difference.inMinutes.remainder(60));
          String seconds = twoDigits(difference.inSeconds.remainder(60));
          remainingTimeStr = "$hours:$minutes:$seconds";
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).primaryColor.withAlpha((255 * 0.2).toInt()),
                blurRadius: 16.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isUpcomingOnly ? 'Upcoming : ' : 'Now : ',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.warmOffWhite),
                        ),
                        Text(
                          displayPrayer.name,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppTheme.warmOffWhite,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(width: 8.w),
                        if (!isUpcomingOnly)
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            DateFormat.jm().format(displayPrayer.time),
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  color: AppTheme.warmOffWhite,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '(Start time)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.warmOffWhite.withAlpha(
                                    (255 * 0.7).toInt(),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (!isUpcomingOnly)
                      ElevatedButton.icon(
                        onPressed: () {
                          provider.togglePrayerStatus(currentPrayer!);
                        },
                        icon: Icon(
                          currentPrayer.isPrayed
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: AppTheme.deepEmerald,
                          size: 20.r,
                        ),
                        label: Text(
                          currentPrayer.isPrayed ? 'Prayed' : 'Mark Prayed',
                          style: const TextStyle(
                            color: AppTheme.deepEmerald,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldAccent,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (nextPrayer != null && !difference.isNegative)
                SizedBox(
                  width: 110.r,
                  height: 110.r,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: isUpcomingOnly
                            ? 1.0
                            : _calculateProgress(
                                currentPrayer.time,
                                currentPrayer.endTime,
                                _now,
                              ),
                        strokeWidth: 4.r,
                        backgroundColor: AppTheme.warmOffWhite.withAlpha(
                          (255 * 0.2).toInt(),
                        ),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.goldAccent,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Time Left',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.warmOffWhite.withAlpha(
                                      (255 * 0.7).toInt(),
                                    ),
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              remainingTimeStr,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.warmOffWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  double _calculateProgress(DateTime start, DateTime end, DateTime now) {
    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0.0;
    final remaining = end.difference(now).inSeconds;
    return (remaining / total).clamp(0.0, 1.0);
  }

  Widget _buildLoadingOrEmptyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: CircularProgressIndicator(color: AppTheme.warmOffWhite),
      ),
    );
  }
}
