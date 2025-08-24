import 'package:flutter/material.dart';
import 'package:influnew/login_screen.dart';
import 'package:influnew/terms_page.dart';
import 'package:influnew/policy_page.dart';
import 'package:influnew/wallet_terms_page.dart';
import 'app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.purpleGradient),
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Using the logo.png from assets
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),

            // White card at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // Background circle positioned to be half above the card
                  Positioned(
                    top:
                        -100, // Half the circle height to position it halfway above the card
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                          width: 25,
                        ),
                        // Removed the color property to make it hollow
                      ),
                    ),
                  ),
                  // White card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Continue to Influ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Login or sign up to your account',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 30),

                        // Continue with mobile button
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.phone_android,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Continue with mobile',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // Navigate to login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                        // Continue with Google button - using local asset

                        // Terms text
                        const Text(
                          'By continuing, I agree to Influ',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Terms',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Text(
                              ', ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PolicyPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Policies',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Text(
                              ' and ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WalletTermsPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Wallet Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Bottom indicator
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
