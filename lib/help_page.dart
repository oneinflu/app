import 'package:flutter/material.dart';
import 'app_theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

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
                    'Help & Support',
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
                'How can we help you?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                'Account & Login',
                'Having trouble logging in? Make sure you\'re using the correct phone number. If you\'re still having issues, try requesting a new OTP.'
              ),
              _buildSection(
                'Profile Setup',
                'Complete your profile to get the most out of Influ. Add your social media accounts, create rate cards, and showcase your best work.'
              ),
              _buildSection(
                'Payments & Wallet',
                'All transactions are secure and processed within 3-5 business days. If you have any issues with payments, please contact our support team.'
              ),
              _buildSection(
                'Content Guidelines',
                'Ensure your content follows our community guidelines. We prohibit explicit, harmful, or copyrighted content without proper attribution.'
              ),
              _buildSection(
                'Technical Issues',
                'If you\'re experiencing technical difficulties, try updating the app to the latest version or clearing the app cache.'
              ),
              _buildSection(
                'Contact Support',
                'Need more help? Contact our support team at support@influ.com or call us at +91 9876543210 during business hours.'
              ),
              const SizedBox(height: 20),
              _buildFAQSection(),
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

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 15),
        _buildFAQItem('How do I reset my password?', 
          'You can reset your password by requesting an OTP to your registered mobile number.'),
        _buildFAQItem('How do I connect my social media accounts?', 
          'Go to your profile page and tap on "Connected Social Media" to link your accounts.'),
        _buildFAQItem('How do I create a rate card?', 
          'Navigate to your profile, tap on "Rate Cards" and then "Create New" to set up your services.'),
        _buildFAQItem('When will I receive payment for completed deals?', 
          'Payments are processed within 3-5 business days after a deal is marked as completed.'),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}