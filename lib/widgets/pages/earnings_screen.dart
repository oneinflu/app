import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import '../../app_theme.dart';

class EarningsScreen extends StatefulWidget {
  final bool fromBottomNav;

  const EarningsScreen({Key? key, this.fromBottomNav = false})
    : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool fromBottomNav =
        ModalRoute.of(context)?.settings.arguments == 'fromBottomNav';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        title: const Text('Earnings', style: TextStyle(color: Colors.white)),
        leading:
            fromBottomNav
                ? GestureDetector(
                  onTap: () {
                    // Navigate to profile management screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileManagementScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                )
                : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Influencer'),
            Tab(text: 'Store'),
            Tab(text: 'Channel'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfluencerEarnings(),
          _buildStoreEarnings(),
          _buildChannelEarnings(),
        ],
      ),
    );
  }

  Widget _buildInfluencerEarnings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningsSummary('₹25,000', 'This Month'),
          const SizedBox(height: 24),
          const Text(
            'Recent Campaigns',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          _buildCampaignItem(
            'Fashion Brand X',
            'Instagram Post',
            '₹5,000',
            'Completed',
            Colors.green,
          ),
          _buildCampaignItem(
            'Tech Company Y',
            'YouTube Review',
            '₹15,000',
            'Completed',
            Colors.green,
          ),
          _buildCampaignItem(
            'Food Brand Z',
            'Instagram Story',
            '₹3,000',
            'In Progress',
            Colors.orange,
          ),
          _buildCampaignItem(
            'Travel App',
            'Full Campaign',
            '₹20,000',
            'Pending',
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreEarnings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningsSummary('₹42,500', 'This Month'),
          const SizedBox(height: 24),
          const Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          _buildOrderItem(
            'Order #1234',
            '3 items',
            '₹2,500',
            'Delivered',
            Colors.green,
          ),
          _buildOrderItem(
            'Order #1235',
            '1 item',
            '₹1,200',
            'Delivered',
            Colors.green,
          ),
          _buildOrderItem(
            'Order #1236',
            '5 items',
            '₹4,800',
            'Shipped',
            Colors.blue,
          ),
          _buildOrderItem(
            'Order #1237',
            '2 items',
            '₹1,800',
            'Processing',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelEarnings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningsSummary('₹18,200', 'This Month'),
          const SizedBox(height: 24),
          const Text(
            'Course Enrollments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          _buildCourseItem(
            'Digital Marketing Masterclass',
            '12 enrollments',
            '₹12,000',
          ),
          _buildCourseItem('Photography Basics', '5 enrollments', '₹4,500'),
          _buildCourseItem(
            'Advanced Cooking Techniques',
            '2 enrollments',
            '₹1,700',
          ),
        ],
      ),
    );
  }

  // Update the _buildEarningsSummary method
  Widget _buildEarningsSummary(String amount, String period) {
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
            'Total Earnings',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            period,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildCampaignItem, _buildOrderItem, and _buildCourseItem methods similarly
  Widget _buildCampaignItem(
    String brand,
    String type,
    String amount,
    String status,
    Color statusColor,
  ) {
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
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.campaign, color: AppTheme.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(status, style: TextStyle(color: statusColor, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    String orderId,
    String items,
    String amount,
    String status,
    Color statusColor,
  ) {
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
            child: const Icon(
              Icons.shopping_bag,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  items,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(status, style: TextStyle(color: statusColor, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(
    String courseName,
    String enrollments,
    String amount,
  ) {
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
            child: const Icon(Icons.school, color: AppTheme.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  enrollments,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
