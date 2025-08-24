import 'package:flutter/material.dart';
import 'app_theme.dart';

class WalletTermsPage extends StatelessWidget {
  const WalletTermsPage({Key? key}) : super(key: key);

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
                    'Wallet Terms & Conditions',
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
                '1. Wallet Services',
                'The Influ Wallet is a digital wallet service that allows you to receive, hold, and withdraw payments for your influencer services. By using our Wallet services, you agree to these terms and conditions.'
              ),
              _buildSection(
                '2. Account Eligibility',
                'To use the Wallet services, you must have a verified Influ account and comply with all applicable laws and regulations.'
              ),
              _buildSection(
                '3. Transactions',
                'All transactions through the Wallet are subject to review and may be delayed or stopped if we suspect fraudulent activity. We are not responsible for any losses resulting from such delays.'
              ),
              _buildSection(
                '4. Fees',
                'We may charge fees for certain Wallet transactions. These fees will be clearly disclosed before you complete the transaction.'
              ),
              _buildSection(
                '5. Withdrawals',
                'You may withdraw funds from your Wallet to your linked bank account. Withdrawals may take 3-5 business days to process, depending on your bank.'
              ),
              _buildSection(
                '6. Account Security',
                'You are responsible for maintaining the security of your Wallet account. You should never share your login credentials with anyone.'
              ),
              _buildSection(
                '7. Prohibited Activities',
                'You may not use the Wallet for any illegal activities, including money laundering, terrorist financing, or fraud.'
              ),
              _buildSection(
                '8. Termination',
                'We reserve the right to suspend or terminate your access to the Wallet services at any time for any reason.'
              ),
              _buildSection(
                '9. Changes to Terms',
                'We may update these Wallet Terms & Conditions from time to time. We will notify you of any material changes.'
              ),
              _buildSection(
                '10. Contact Information',
                'If you have any questions about these Wallet Terms & Conditions, please contact us at wallet@influ.com.'
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