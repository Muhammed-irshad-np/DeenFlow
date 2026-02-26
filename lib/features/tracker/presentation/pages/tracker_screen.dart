import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tracker')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressRings(context),
              const SizedBox(height: 32),
              _buildDhikrSection(context),
              const SizedBox(height: 24),
              _buildHabitsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
          width: 72,
          height: 72,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation(
                  color.withAlpha((255 * 0.2).toInt()),
                ),
              ),
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
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
        const SizedBox(height: 12),
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'SubhanAllah',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                '33',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 64,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: AppTheme.goldAccent,
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: const Icon(Icons.add, size: 32),
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
        const SizedBox(height: 16),
        _HabitTile(
          title: 'Fasting (Sunnah)',
          icon: Icons.wb_twilight,
          isCompleted: false,
        ),
        const SizedBox(height: 12),
        _HabitTile(
          title: 'Charity / Sadaqah',
          icon: Icons.favorite_border,
          isCompleted: true,
        ),
        const SizedBox(height: 12),
        _HabitTile(
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
        borderRadius: BorderRadius.circular(12),
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
