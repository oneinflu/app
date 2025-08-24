import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CollabRequestsPage extends StatefulWidget {
  const CollabRequestsPage({Key? key}) : super(key: key);

  @override
  State<CollabRequestsPage> createState() => _CollabRequestsPageState();
}

class _CollabRequestsPageState extends State<CollabRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        'Collab Requests',
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Requests Sent'),
          Tab(text: 'Requests Accepted'),
        ],
      ),
    );
  }

  Widget _buildRequestsList({required bool isAccepted}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRequestItem(
          name: 'Business ${index + 1}',
          date: 'Jun ${index + 1}th, 2025',
          status: isAccepted ? 'Accepted' : 'Pending',
        );
      },
    );
  }

  Widget _buildRequestItem({
    required String name,
    required String date,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            name[0],
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 14),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              date,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:
                    status == 'Accepted'
                        ? AppTheme.accentMint.withOpacity(0.1)
                        : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color:
                      status == 'Accepted'
                          ? AppTheme.accentMint
                          : AppTheme.primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.textSecondary,
          size: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList(isAccepted: false),
                _buildRequestsList(isAccepted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
