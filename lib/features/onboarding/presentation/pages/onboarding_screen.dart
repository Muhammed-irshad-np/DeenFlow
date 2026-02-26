import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<OnboardingProvider>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: provider.pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent manual swipe to control flow
                onPageChanged: provider.onPageChanged,
                children: const [
                  _WelcomeStep(),
                  _LocationStep(),
                  _CalculationMethodStep(),
                  _GoalsStep(),
                  _NotificationStep(),
                ],
              ),
            ),
            _buildBottomControls(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    OnboardingProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (provider.currentPage > 0)
            TextButton(
              onPressed: provider.previousPage,
              child: const Text('Back'),
            )
          else
            const SizedBox(width: 64), // Placeholder for alignment

          Row(
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: provider.currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: provider.currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              if (provider.currentPage == 4) {
                provider.completeOnboarding(() => context.go('/home'));
              } else {
                provider.nextPage();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(provider.currentPage == 4 ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}

// --- Steps ---

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mosque_outlined,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            'Peace be upon you',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to DeenFlow. A calm spiritual companion for your daily journey.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Language',
              border: OutlineInputBorder(),
            ),
            initialValue: context.watch<OnboardingProvider>().selectedLanguage,
            items: ['English', 'Arabic', 'Urdu', 'French'].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (val) => provider.updateLanguage(val ?? 'English'),
          ),
        ],
      ),
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 32),
          Text(
            'Location Permission',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'We use your location solely to calculate accurate prayer times for your area. We do not track you.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              // Trigger permission logic here
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Allow Location'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Manual selection
            },
            child: const Text('Or select city manually'),
          ),
        ],
      ),
    );
  }
}

class _CalculationMethodStep extends StatelessWidget {
  const _CalculationMethodStep();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Prayer Calculation Method',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _MethodCard(
            title: 'Shafi, Maliki, Hanbali',
            description: 'Standard Asr calculation',
            isSelected: provider.calculationMethod == 'Shafi',
            onTap: () => context
                .read<OnboardingProvider>()
                .updateCalculationMethod('Shafi'),
          ),
          const SizedBox(height: 16),
          _MethodCard(
            title: 'Hanafi',
            description: 'Later Asr calculation',
            isSelected: provider.calculationMethod == 'Hanafi',
            onTap: () => context
                .read<OnboardingProvider>()
                .updateCalculationMethod('Hanafi'),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).primaryColor
        : Colors.grey.shade300;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(
                  (255 * 0.05).toInt(),
                ) // Replaced withOpacity with withAlpha
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set Daily Goals',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 48),
          Text(
            'Daily Quran Goal',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (provider.quranGoalPages > 1) {
                    context.read<OnboardingProvider>().updateQuranGoal(
                      provider.quranGoalPages - 1,
                    );
                  }
                },
              ),
              Text(
                '${provider.quranGoalPages} Pages',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  context.read<OnboardingProvider>().updateQuranGoal(
                    provider.quranGoalPages + 1,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 48),
          SwitchListTile(
            title: const Text('Enable Dhikr Reminders'),
            subtitle: const Text(
              'Gentle nudges for morning and evening Adhkar',
            ),
            value: provider.enableDhikrReminders,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: (val) =>
                context.read<OnboardingProvider>().toggleDhikrReminders(val),
          ),
        ],
      ),
    );
  }
}

class _NotificationStep extends StatelessWidget {
  const _NotificationStep();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 32),
          Text(
            'Stay Connected',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'We will gently notify you when it is time to pray, never with a sense of urgency or guilt.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SwitchListTile(
            title: const Text('Prayer Alerts'),
            subtitle: const Text('Receive notifications for Adhan / Iqamah'),
            value: provider.enablePrayerAlerts,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: (val) =>
                context.read<OnboardingProvider>().togglePrayerAlerts(val),
          ),
        ],
      ),
    );
  }
}
