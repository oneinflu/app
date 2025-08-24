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
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedTabIndex = 0;

  // Sample data for 6-month earnings chart
  final List<Map<String, dynamic>> _monthlyEarnings = [
    {'month': 'Jan', 'amount': 18000},
    {'month': 'Feb', 'amount': 22000},
    {'month': 'Mar', 'amount': 15000},
    {'month': 'Apr', 'amount': 30000},
    {'month': 'May', 'amount': 25000},
    {'month': 'Jun', 'amount': 28000},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInfluencerEarnings(),
                  _buildStoreEarnings(),
                  _buildChannelEarnings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileManagementScreen(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.dividerColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_outline,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
          ),

          // Notification Bell Icon
          GestureDetector(
            onTap: () {
              _showNotificationModal();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.dividerColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.accentCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabItem('Influencer', 0),
          _buildTabItem('Store', 1),
          _buildTabItem('Channel', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfluencerEarnings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningsChart(),
          const SizedBox(height: 24),
          _buildEarningsSummaryRow(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'Pending Withdrawals',
            Icons.account_balance_wallet,
          ),
          const SizedBox(height: 16),
          _buildWithdrawalCard(
            '₹12,500',
            'Pending approval',
            'Requested on 15 May 2023',
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Deals', Icons.handshake),
          const SizedBox(height: 16),
          _buildDealCard(
            'Fashion Brand X',
            'Instagram Post',
            '₹5,000',
            'Completed',
            Colors.green,
            Icons.camera_alt,
          ),
          _buildDealCard(
            'Tech Company Y',
            'YouTube Review',
            '₹15,000',
            'Completed',
            Colors.green,
            Icons.play_circle_fill,
          ),
          _buildDealCard(
            'Food Brand Z',
            'Instagram Story',
            '₹3,000',
            'In Progress',
            Colors.orange,
            Icons.fastfood,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    // Find the maximum value for scaling
    final maxAmount =
        _monthlyEarnings
            .map((e) => e['amount'] as int)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings (Last 6 Months)',
            style: AppTheme.headlineStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  _monthlyEarnings.map((data) {
                    final double barHeight =
                        120 * ((data['amount'] as num).toDouble() / maxAmount);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['month'],
                          style: AppTheme.secondaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummaryRow() {
    return Row(
      children: [
        Expanded(child: _buildEarningsSummary('₹25,000', 'This Month')),
        const SizedBox(width: 12),
        Expanded(child: _buildEarningsSummary('₹125,000', 'Total Earnings')),
      ],
    );
  }

  Widget _buildEarningsSummary(String amount, String period) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            period,
            style: AppTheme.secondaryTextStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTheme.headlineStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalCard(String amount, String status, String date) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: AppTheme.headlineStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(date, style: AppTheme.secondaryTextStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Track Status'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(
    String brand,
    String type,
    String amount,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  brand,
                  style: AppTheme.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  type,
                  style: AppTheme.secondaryTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: AppTheme.bodyTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Delivered',
            '24',
            Icons.check_circle,
            AppTheme.accentMint,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Processing',
            '8',
            Icons.hourglass_top,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Cancelled',
            '3',
            Icons.cancel,
            AppTheme.accentCoral,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.secondaryTextStyle.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
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
          _buildEarningsChart(),
          const SizedBox(height: 24),
          _buildEarningsSummaryRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Order Statistics', Icons.analytics),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Orders', Icons.shopping_bag),
          const SizedBox(height: 16),
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
          _buildEarningsChart(),
          const SizedBox(height: 24),
          _buildEarningsSummaryRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Enrollment Statistics', Icons.school),
          const SizedBox(height: 16),
          _buildEnrollmentStatsRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Course Enrollments', Icons.book),
          const SizedBox(height: 16),
          _buildCourseCard(
            'Digital Marketing Masterclass',
            '12 enrollments',
            '₹12,000',
            AppTheme.primaryColor,
          ),
          _buildCourseCard(
            'Content Creation Basics',
            '8 enrollments',
            '₹8,000',
            AppTheme.secondaryColor,
          ),
          _buildCourseCard(
            'Social Media Growth',
            '5 enrollments',
            '₹5,000',
            AppTheme.accentCoral,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active',
            '19',
            Icons.people,
            AppTheme.accentMint,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            '32',
            Icons.school,
            AppTheme.secondaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Revenue',
            '₹25K',
            Icons.attach_money,
            AppTheme.accentYellow,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(
    String courseName,
    String enrollments,
    String amount,
    Color iconColor,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.school, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: AppTheme.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  enrollments,
                  style: AppTheme.secondaryTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Notifications',
                  style: AppTheme.headlineStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stay updated with the latest opportunities and updates',
                  style: AppTheme.secondaryTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Text(
                    'No new notifications',
                    style: AppTheme.secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }
}
