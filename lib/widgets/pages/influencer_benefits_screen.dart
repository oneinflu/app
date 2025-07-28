import 'package:flutter/material.dart';
import 'package:influnew/verification_screen.dart';
import 'package:influnew/widgets/pages/create_influencer_profile_screen.dart';
import '../../app_theme.dart';

class InfluencerBenefitsScreen extends StatelessWidget {
  const InfluencerBenefitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1A1A1A,
      ), // Dark background like Zomato Gold
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildGoldTitle(),
            _buildSavingsSection(),
            _buildCurrentBenefits(),
            _buildCouponSection(),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const Spacer(),
          const Text(
            'Influencer Gold',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 24), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildGoldTitle() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // App logo
        const Text(
          'influ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // GOLD text with crown
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'G',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const Icon(
                Icons.diamond,
                color: Color(0xFFFFD700),
                size: 32,
              ),
            ),
            const Text(
              'LD',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'MEMBER TILL 7TH SEP 2025',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
            SizedBox(width: 8),
            Text(
              'SAVINGS TILL NOW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.trending_up,
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brand Collaborations',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'Used 63 times',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Text(
            '₹2382',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBenefits() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You have earned more than 19 times',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Text(
              'of what you paid for Gold 👑',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
                SizedBox(width: 8),
                Text(
                  'CURRENT BENEFITS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBenefitItem(
                      icon: Icons.delivery_dining,
                      title: 'Zero Commission',
                      description:
                          'Zero commission and high demand surge fee waiver on all brand collaborations under 7 km, on orders above ₹199. May not be applicable at a few brands that manage their own delivery',
                      iconColor: const Color(0xFFFFD700),
                    ),
                    const SizedBox(height: 20),
                    _buildBenefitItem(
                      icon: Icons.local_offer,
                      title: 'Up to 30% extra earnings',
                      description:
                          'Above all existing offers at 20,000+ partner brands across India',
                      iconColor: const Color(0xFFFFD700),
                    ),
                    const SizedBox(height: 20),
                    _buildBenefitItem(
                      icon: Icons.verified,
                      title: 'Priority Verification',
                      description:
                          'Get your profile verified faster and access premium brand partnerships',
                      iconColor: const Color(0xFFFFD700),
                    ),
                    const SizedBox(height: 20),
                    _buildBenefitItem(
                      icon: Icons.analytics,
                      title: 'Advanced Analytics',
                      description:
                          'Detailed insights on your performance and earnings potential',
                      iconColor: const Color(0xFFFFD700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Have a coupon code?',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle coupon code application
            },
            child: const Text(
              'Apply',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.help_outline,
            title: 'Frequently asked questions',
            onTap: () {
              // Handle FAQ navigation
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.description_outlined,
            title: 'Terms and Conditions',
            onTap: () {
              // Handle T&C navigation
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.chat_outlined,
            title: 'Need help? Chat with us',
            onTap: () {
              // Handle chat support
            },
            showUnderline: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const VerificationScreen(
                          sourceScreen: 'influencer',
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Started with Verification',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showUnderline = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border:
              showUnderline
                  ? const Border(
                    bottom: BorderSide(color: Colors.white24, width: 1),
                  )
                  : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
