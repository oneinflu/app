import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/business_collab_detail_screen.dart';
import '../../app_theme.dart';
import 'influencer_detail_screen.dart';

class InfluencerBookingsPage extends StatefulWidget {
  const InfluencerBookingsPage({Key? key}) : super(key: key);

  @override
  State<InfluencerBookingsPage> createState() => _InfluencerBookingsPageState();
}

class _InfluencerBookingsPageState extends State<InfluencerBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showNotificationDot = true;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _showNotificationDot = false);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 3,
                  itemBuilder:
                      (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        title: Text('Notification ${index + 1}'),
                        subtitle: Text(
                          '2 hours ago',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                ),
              ],
            ),
          ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.textSecondary,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      title: Text(
        'Influencer Bookings',
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: _showNotificationModal,
                  padding: EdgeInsets.zero,
                ),
                if (_showNotificationDot)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
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
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Bookings Made'),
              Tab(text: 'Bookings Received'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    final statuses = ['Upcoming', 'In Progress', 'Completed', 'Cancelled'];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(statuses[index]),
              selected: index == 0,
              onSelected: (selected) {},
              backgroundColor: Colors.grey[200],
              selectedColor: AppTheme.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color:
                    index == 0 ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color:
                      index == 0 ? AppTheme.primaryColor : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingsList({required bool isReceived}) {
    return Column(
      children: [
        _buildStatusTabs(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildBookingItem(
                name:
                    isReceived
                        ? 'Client ${index + 1}'
                        : 'Influencer ${index + 1}',
                date: 'Jun ${index + 1}th, 2025',
                status: _getRandomStatus(),
                isReceived: isReceived,
              );
            },
          ),
        ),
      ],
    );
  }

  String _getRandomStatus() {
    final statuses = ['Upcoming', 'In Progress', 'Completed', 'Cancelled'];
    return statuses[DateTime.now().millisecond % statuses.length];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppTheme.primaryColor;
      case 'in progress':
        return AppTheme.accentYellow;
      case 'completed':
        return AppTheme.accentMint;
      case 'cancelled':
        return AppTheme.accentCoral;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildBookingItem({
    required String name,
    required String date,
    required String status,
    required bool isReceived, // Added this parameter
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    isReceived
                        ? BusinessCollabDetailScreen(
                          name: name,
                          location: 'Hyderabad, India', // Default location
                        )
                        : InfluencerDetailScreen(name: name, date: date),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // Reduced margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Smaller radius
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ), // Lighter border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // Lighter shadow
              blurRadius: 4, // Reduced blur
              offset: const Offset(0, 1), // Smaller offset
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ), // Reduced padding
          leading: CircleAvatar(
            radius: 20, // Smaller avatar
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              name[0],
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14, // Smaller font
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500, // Lighter weight
              fontSize: 14, // Smaller font
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 12,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ), // Smaller padding
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 11, // Smaller font
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textSecondary,
            size: 14, // Smaller icon
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookingsList(isReceived: false),
        _buildBookingsList(isReceived: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [_buildTabs(), Expanded(child: _buildTabContent())],
      ),
    );
  }
}
