import 'package:flutter/material.dart';
import '../../domain/usecases/onboarding_usecases.dart';

class OnboardingProvider extends ChangeNotifier {
  final SaveOnboardingStatusUseCase saveOnboardingStatusUseCase;

  OnboardingProvider({required this.saveOnboardingStatusUseCase});

  int _currentPage = 0;
  final PageController pageController = PageController();

  // Onboarding Data
  String _selectedLanguage = 'English';
  String _location = '';
  String _calculationMethod = 'Shafi';
  int _quranGoalPages = 1;
  bool _enableDhikrReminders = false;
  bool _enablePrayerAlerts = true;

  int get currentPage => _currentPage;
  String get selectedLanguage => _selectedLanguage;
  String get location => _location;
  String get calculationMethod => _calculationMethod;
  int get quranGoalPages => _quranGoalPages;
  bool get enableDhikrReminders => _enableDhikrReminders;
  bool get enablePrayerAlerts => _enablePrayerAlerts;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void updateLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  void updateCalculationMethod(String method) {
    _calculationMethod = method;
    notifyListeners();
  }

  void updateQuranGoal(int pages) {
    _quranGoalPages = pages;
    notifyListeners();
  }

  void toggleDhikrReminders(bool value) {
    _enableDhikrReminders = value;
    notifyListeners();
  }

  void togglePrayerAlerts(bool value) {
    _enablePrayerAlerts = value;
    notifyListeners();
  }

  Future<void> completeOnboarding(VoidCallback onComplete) async {
    // Save onboarding completed status
    await saveOnboardingStatusUseCase(true);
    // Call completion callback
    onComplete();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
