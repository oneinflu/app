import 'package:flutter/material.dart';
import 'app_theme.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

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
                    'Terms of Service',
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
                '1. Acceptance of Terms',
                'By accessing or using Influ, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.'
              ),
              _buildSection(
                '2. Description of Service',
                'Influ provides a platform for influencers and brands to connect, collaborate, and manage their partnerships. Our services include profile management, rate card creation, and partnership facilitation.'
              ),
              _buildSection(
                '3. User Accounts',
                'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.'
              ),
              _buildSection(
                '4. User Content',
                'You retain ownership of any content you submit to Influ. By submitting content, you grant us a worldwide, non-exclusive license to use, reproduce, modify, and display your content for the purpose of operating and improving our services.'
              ),
              _buildSection(
                '5. Prohibited Activities',
                'You agree not to engage in any activity that interferes with or disrupts the services or servers and networks connected to the services.'
              ),
              _buildSection(
                '6. Termination',
                'We reserve the right to terminate or suspend your account at any time for any reason without notice.'
              ),
              _buildSection(
                '7. Changes to Terms',
                'We may modify these terms at any time. Your continued use of Influ after any changes indicates your acceptance of the modified terms.'
              ),
              _buildSection(
                '8. Contact Information',
                'If you have any questions about these Terms, please contact us at support@influ.com.'
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