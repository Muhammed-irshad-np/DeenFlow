import 'package:flutter/material.dart';

import '../widgets/prayer_time_card.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateHeader(context),
                    const SizedBox(height: 32),
                    const PrayerTimeCard(
                      name: 'Fajr',
                      time: '5:30 AM',
                      isPast: true,
                      isPrayed: true,
                    ),
                    const PrayerTimeCard(
                      name: 'Dhuhr',
                      time: '12:45 PM',
                      isPast: true,
                      isPrayed: true,
                    ),
                    const PrayerTimeCard(
                      name: 'Asr',
                      time: '3:45 PM',
                      isPast: true,
                      isPrayed: false, // Missed indicator should show
                    ),
                    const PrayerTimeCard(
                      name: 'Maghrib',
                      time: '6:15 PM',
                      isNext: true,
                    ),
                    const PrayerTimeCard(name: 'Isha', time: '7:30 PM'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '12 Ramadan 1445', // Dummy Hijri date
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).primaryColor.withAlpha((255 * 0.1).toInt()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '3/5 Prayed',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
