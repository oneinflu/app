import 'package:flutter/material.dart';
import 'app_theme.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: AppTheme.backgroundLight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppTheme.backgroundLight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Last Updated: June 2023',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                '1. Information We Collect',
                'We collect information you provide directly to us, such as when you create an account, update your profile, or communicate with us. This may include your name, email address, phone number, profile picture, and social media handles.'
              ),
              _buildSection(
                '2. How We Use Your Information',
                'We use the information we collect to provide, maintain, and improve our services, communicate with you, and personalize your experience.'
              ),
              _buildSection(
                '3. Information Sharing',
                'We may share your information with third parties in the following circumstances: with your consent, with service providers, for legal reasons, or in connection with a business transfer.'
              ),
              _buildSection(
                '4. Your Choices',
                'You can access, update, or delete your account information at any time through your account settings. You can also opt out of receiving promotional communications from us.'
              ),
              _buildSection(
                '5. Data Security',
                'We take reasonable measures to help protect your personal information from loss, theft, misuse, and unauthorized access.'
              ),
              _buildSection(
                '6. Children\'s Privacy',
                'Our services are not directed to children under 13, and we do not knowingly collect personal information from children under 13.'
              ),
              _buildSection(
                '7. Changes to This Policy',
                'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.'
              ),
              _buildSection(
                '8. Contact Us',
                'If you have any questions about this privacy policy, please contact us at privacy@influ.com.'
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}