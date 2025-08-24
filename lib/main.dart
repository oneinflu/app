import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/providers/store_provider.dart';
import 'package:influnew/welcome_screen.dart';
import 'package:influnew/widgets/pages/product_detail_page.dart';
import 'login_screen.dart';
import 'package:influnew/home_screen.dart';
import 'animated_splash_screen.dart';
import 'onboarding_screen.dart';
import 'app_theme.dart';
import 'providers/auth_provider.dart';

void main() {
  // Initialize providers
  Get.put(AuthProvider());
  Get.put(StoreProvider());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Influu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthCheckScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/product_detail_page':
            (context) => const ProductDetailPage(), // Add this line
      },
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Obx(() {
      if (authProvider.isLoading.value) {
        // Show splash screen while checking auth status
        return AnimatedSplashScreen(
          onAnimationComplete: () {
            // This won't be called as we'll navigate based on auth status
          },
        );
      } else if (authProvider.isLoggedIn.value) {
        // User is logged in, go to home screen
        return const HomeScreen();
      } else {
        // User is not logged in, go to onboarding or login
        return const OnboardingScreen();
        // If you want to skip onboarding and go directly to login:
        // return const LoginScreen();
      }
    });
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      onAnimationComplete: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      },
    );
  }
}
