import 'package:flutter/material.dart';

import '../widgets/daily_reflection_section.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_progress_section.dart';
import '../widgets/quran_progress_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeenFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              NextPrayerCard(),
              SizedBox(height: 32),
              PrayerProgressSection(),
              SizedBox(height: 32),
              QuranProgressSection(),
              SizedBox(height: 32),
              DailyReflectionSection(),
              SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
