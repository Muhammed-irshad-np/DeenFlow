import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tracker')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressRings(context),
              SizedBox(height: 32.h),
              _buildDhikrSection(context),
              SizedBox(height: 24.h),
              _buildHabitsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRings(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRing(context, 'Prayers', 0.6, AppTheme.deepEmerald),
          _buildRing(context, 'Quran', 0.4, AppTheme.darkTeal),
          _buildRing(context, 'Dhikr', 0.8, AppTheme.goldAccent),
        ],
      ),
    );
  }

  Widget _buildRing(
    BuildContext context,
    String label,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 72.w,
          height: 72.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 6.w,
                valueColor: AlwaysStoppedAnimation(
                  color.withAlpha((255 * 0.2).toInt()),
                ),
              ),
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6.w,
                valueColor: AlwaysStoppedAnimation(color),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildDhikrSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dhikr Counter',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text(
                'SubhanAllah',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 24.h),
              Text(
                '33',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 64.sp,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(24.w),
                  backgroundColor: AppTheme.goldAccent,
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Icon(Icons.add, size: 32.r),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Habits',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        const _HabitTile(
          title: 'Fasting (Sunnah)',
          icon: Icons.wb_twilight,
          isCompleted: false,
        ),
        SizedBox(height: 12.h),
        const _HabitTile(
          title: 'Charity / Sadaqah',
          icon: Icons.favorite_border,
          isCompleted: true,
        ),
        SizedBox(height: 12.h),
        const _HabitTile(
          title: 'Read Surah Al-Mulk',
          icon: Icons.menu_book,
          isCompleted: false,
        ),
      ],
    );
  }
}

class _HabitTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompleted;

  const _HabitTile({
    required this.title,
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? Theme.of(context).primaryColor.withAlpha((255 * 0.05).toInt())
            : Theme.of(context).cardColor,
        border: Border.all(
          color: isCompleted
              ? Theme.of(context).primaryColor.withAlpha((255 * 0.3).toInt())
              : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isCompleted
              ? Theme.of(context).primaryColor
              : Colors.grey.shade500,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isCompleted
            ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
            : Icon(Icons.circle_outlined, color: Colors.grey.shade300),
      ),
    );
  }
}
