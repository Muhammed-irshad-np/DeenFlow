import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/themes/app_theme.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/main_navigation/presentation/pages/main_navigation_screen.dart';
import 'features/prayer/presentation/pages/prayer_screen.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/quran/presentation/pages/quran_screen.dart';
import 'features/quran/presentation/pages/quran_reading_screen.dart';
import 'features/tracker/presentation/pages/tracker_screen.dart';
import 'core/usecases/usecase.dart';
import 'features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'injection_container.dart' as di;
import 'package:provider/provider.dart';
import 'features/prayer/presentation/providers/prayer_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  final checkOnboarding = di.sl<CheckOnboardingStatusUseCase>();
  final isOnboarded = await checkOnboarding(const NoParams());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<PrayerProvider>()),
      ],
      child: DeenFlowApp(initialRoute: isOnboarded ? '/home' : '/onboarding'),
    ),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter _createRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/quran/read',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return QuranReadingScreen(
          surahName: extra['nameEnglish'] as String? ?? 'Al-Fatihah',
          surahArabicName: extra['nameArabic'] as String? ?? 'الفاتحة',
        );
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainNavigationScreen(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/quran',
          builder: (context, state) => const QuranScreen(),
        ),
        GoRoute(
          path: '/prayer',
          builder: (context, state) => const PrayerScreen(),
        ),
        GoRoute(
          path: '/tracker',
          builder: (context, state) => const TrackerScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class DeenFlowApp extends StatelessWidget {
  final String initialRoute;
  const DeenFlowApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // typical mobile device design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'DeenFlow',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system, // Defaults to dark mode per UX rules
          routerConfig: _createRouter(initialRoute),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
