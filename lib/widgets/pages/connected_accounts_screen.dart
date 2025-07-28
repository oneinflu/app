import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ConnectedAccountsScreen extends StatefulWidget {
  const ConnectedAccountsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectedAccountsScreen> createState() => _ConnectedAccountsScreenState();
}

class _ConnectedAccountsScreenState extends State<ConnectedAccountsScreen> {
  final List<Map<String, dynamic>> _socialAccounts = [
    {
      'platform': 'Instagram',
      'username': '@johndoe',
      'isConnected': true,
      'icon': Icons.camera_alt,
      'color': const Color(0xFFE1306C),
    },
    {
      'platform': 'Facebook',
      'username': 'John Doe',
      'isConnected': true,
      'icon': Icons.facebook,
      'color': const Color(0xFF1877F2),
    },
    {
      'platform': 'YouTube',
      'username': 'John Doe Channel',
      'isConnected': true,
      'icon': Icons.play_arrow,
      'color': const Color(0xFFFF0000),
    },
    {
      'platform': 'Twitter',
      'username': '@johndoe',
      'isConnected': false,
      'icon': Icons.flutter_dash,
      'color': const Color(0xFF1DA1F2),
    },
    {
      'platform': 'LinkedIn',
      'username': 'John Doe',
      'isConnected': false,
      'icon': Icons.work,
      'color': const Color(0xFF0A66C2),
    },
  ];

  final List<Map<String, dynamic>> _paymentAccounts = [
    {
      'type': 'Bank Account',
      'details': 'HDFC Bank ****1234',
      'isConnected': true,
      'icon': Icons.account_balance,
    },
    {
      'type': 'UPI',
      'details': 'johndoe@upi',
      'isConnected': true,
      'icon': Icons.payment,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        title: const Text(
          'Connected Accounts',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Text(
                'Manage your connected social media and payment accounts',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Social Media Accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._socialAccounts.map((account) => _buildSocialAccountItem(account)),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._paymentAccounts.map((account) => _buildPaymentAccountItem(account)),
                  const SizedBox(height: 16),
                  _buildAddPaymentMethodButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialAccountItem(Map<String, dynamic> account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: account['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(account['icon'], color: account['color']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['platform'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  account['username'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Switch(
            value: account['isConnected'],
            onChanged: (value) {
              setState(() {
                account['isConnected'] = value;
              });
            },
            activeColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAccountItem(Map<String, dynamic> account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(account['icon'], color: AppTheme.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['type'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  account['details'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.grey,
                onPressed: () {},
              ),
              Switch(
                value: account['isConnected'],
                onChanged: (value) {
                  setState(() {
                    account['isConnected'] = value;
                  });
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentMethodButton() {
    return GestureDetector(
      onTap: () {
        // Show dialog to add new payment method
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryPurple, width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: AppTheme.primaryPurple),
            SizedBox(width: 8),
            Text(
              'Add Payment Method',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}