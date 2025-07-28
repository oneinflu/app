import 'package:flutter/material.dart';
import '../../app_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'credit',
      'amount': '₹5,000',
      'description': 'Payment from Fashion Brand X',
      'date': '15 May 2023',
      'category': 'Influencer',
    },
    {
      'type': 'credit',
      'amount': '₹2,500',
      'description': 'Order #1234 payment',
      'date': '12 May 2023',
      'category': 'Store',
    },
    {
      'type': 'debit',
      'amount': '₹1,200',
      'description': 'Platform fee',
      'date': '10 May 2023',
      'category': 'Fee',
    },
    {
      'type': 'credit',
      'amount': '₹3,600',
      'description': 'Course enrollment payments',
      'date': '05 May 2023',
      'category': 'Channel',
    },
    {
      'type': 'debit',
      'amount': '₹5,000',
      'description': 'Withdrawal to bank account',
      'date': '01 May 2023',
      'category': 'Withdrawal',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        title: const Text(
          'Wallet',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Balance'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBalanceTab(),
          _buildTransactionsTab(),
        ],
      ),
    );
  }

  Widget _buildBalanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletBalance(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          ..._transactions.take(3).map((tx) => _buildTransactionItem(tx)),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                _tabController.animateTo(1);
              },
              child: const Text(
                'View All Transactions',
                style: TextStyle(color: AppTheme.primaryPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._transactions.map((tx) => _buildTransactionItem(tx)),
      ],
    );
  }

  // Update the _buildWalletBalance method
  Widget _buildWalletBalance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryPurple, AppTheme.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            '₹24,900',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Withdraw',
                      style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.history,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem(Icons.account_balance, 'Add Bank'),
            _buildQuickActionItem(Icons.credit_card, 'Add Card'),
            _buildQuickActionItem(Icons.receipt_long, 'Invoices'),
            _buildQuickActionItem(Icons.support_agent, 'Support'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Update the _buildTransactionItem method
  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final bool isCredit = transaction['type'] == 'credit';
    final IconData icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final Color iconColor = isCredit ? Colors.green : Colors.red;
    
    return Container(
      width: double.infinity,
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
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      transaction['date'],
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        transaction['category'],
                        style: const TextStyle(
                          color: AppTheme.primaryPurple,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            transaction['amount'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}