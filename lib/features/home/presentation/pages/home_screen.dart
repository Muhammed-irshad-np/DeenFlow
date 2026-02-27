import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../widgets/daily_reflection_section.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_progress_section.dart';
import '../widgets/quran_progress_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<PrayerProvider>(
          builder: (context, provider, child) {
            String locationText =
                provider.settings.locationName ?? 'Fetching location...';
            if (provider.isLoading) {
              locationText = 'Updating...';
            }
            return GestureDetector(
              onTap: () {
                provider.refreshLocation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Refreshing location...')),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DeenFlow'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        locationText,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NextPrayerCard(),
              SizedBox(height: 32.h),
              const PrayerProgressSection(),
              SizedBox(height: 32.h),
              const QuranProgressSection(),
              SizedBox(height: 32.h),
              const DailyReflectionSection(),
              SizedBox(height: 32.h), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
