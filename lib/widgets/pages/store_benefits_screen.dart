import 'package:flutter/material.dart';
import 'package:influnew/verification_screen.dart';
import '../../app_theme.dart';

class StoreBenefitsScreen extends StatelessWidget {
  const StoreBenefitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.purpleGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildTitle(),
              _buildBenefitsSection(),
              _buildBecomeVendorButton(context),
              _buildFootnote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'influ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          // Store text in gold
          const Center(
            child: Text(
              'Store',
              style: TextStyle(
                color: Color(0xFFFFD700), // Gold color
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Our Benefits with stars
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Color(0xFFFFD700), size: 24),
              SizedBox(width: 10),
              Text(
                'OUR BENEFITS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.star, color: Color(0xFFFFD700), size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF341969).withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBenefitItem(
                  icon: Icons.monetization_on,
                  title: '0% Commission on Orders',
                  description:
                      'Keep full profit — we don\'t take a cut from your sales.',
                  assetPath: 'assets/images/icons/compass 5.png',
                ),
                const Divider(
                  color: Colors.white24,
                  height: 30,
                  thickness: 0.5,
                ),
                _buildBenefitItem(
                  icon: Icons.campaign,
                  title: 'Direct Promotions via Influencers',
                  description:
                      'Get discovered and promoted by INFLU creators instantly.',
                  assetPath: 'assets/images/icons/compass 7.png',
                ),
                const Divider(
                  color: Colors.white24,
                  height: 30,
                  thickness: 0.5,
                ),
                _buildBenefitItem(
                  icon: Icons.block,
                  title: 'No Middlemen, No Delays',
                  description:
                      'No agency cuts, no pending payments, just clean transactions.',
                  assetPath: 'assets/images/icons/compass 8.png',
                ),
                const Divider(
                  color: Colors.white24,
                  height: 30,
                  thickness: 0.5,
                ),
                _buildBenefitItem(
                  icon: Icons.local_shipping,
                  title: 'Delivery Support Without Extra Charges',
                  description:
                      'Tap into INFLU\'s delivery network with no additional commission.',
                  assetPath: 'assets/images/icons/compass 6.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
    required String assetPath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: 28,
                height: 28,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(icon, color: Colors.white, size: 28);
                },
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeVendorButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to verification screen instead of KYC
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerificationScreen(sourceScreen: 'store'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Become Our Vendor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFootnote() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
      child: Center(
        child: Text(
          '*After 6 months ₹1000/m subscription. Lifetime 0% commission on any order',
          style: TextStyle(color: Colors.white70, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
