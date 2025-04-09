import 'package:esg_post_office/core/providers/navigation_provider.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:esg_post_office/features/carbon_credits/presentation/pages/carbon_credits_page.dart';
import 'package:esg_post_office/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:esg_post_office/features/record/presentation/pages/record_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/core/theme/app_theme.dart';
import 'package:esg_post_office/features/auth/presentation/pages/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Provide a default API key or handle the error as needed
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: false,
    phoneNumber: null,
    smsCode: null,
    forceRecaptchaFlow: true,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBottomNav = ref.watch(bottomNavVisibilityProvider);
    final currentIndex = ref.watch(navigationProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'ESG Post Office',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const SplashScreen();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(bottomNavVisibilityProvider.notifier).show();
          });

          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: const [
                DashboardPage(),
                RecordPage(),
                Scaffold(body: Center(child: Text('Notifications Page'))),
                CarbonCreditsPage(),
              ],
            ),
            bottomNavigationBar: showBottomNav
                ? BottomNavigationBar(
                    currentIndex: currentIndex,
                    type: BottomNavigationBarType.fixed,
                    onTap: (index) =>
                        ref.read(navigationProvider.notifier).setIndex(index),
                    selectedItemColor: const Color(0xFF1B5E20),
                    unselectedItemColor: Colors.grey,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.scale),
                        label: 'Record',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.energy_savings_leaf),
                        label: 'Carbon Credits',
                      ),
                    ],
                  )
                : null,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SplashScreen(),
      ),
    );
  }
}
