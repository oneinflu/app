import 'package:flutter/material.dart';
import '../../app_theme.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),

            // Title
            Text(
              'My Orders',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderTypeCard(
              title: 'Product Orders',
              icon: Icons.shopping_bag_outlined,
              color: AppTheme.primaryColor,
              onTap: () => _navigateToOrdersPage(context, isService: false),
            ),
            const SizedBox(height: 16),
            _buildOrderTypeCard(
              title: 'Service Orders',
              icon: Icons.design_services_outlined,
              color: AppTheme.secondaryColor,
              onTap: () => _navigateToOrdersPage(context, isService: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View all orders',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOrderStat('Pending', '05', color),
                  _buildOrderStat('Processing', '12', color),
                  _buildOrderStat('Completed', '28', color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStat(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  void _navigateToOrdersPage(BuildContext context, {required bool isService}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => OrdersListPage(
              isService: isService,
              title: isService ? 'Service Orders' : 'Product Orders',
            ),
      ),
    );
  }

  void _showNotificationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder:
                        (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'New Order Received',
                                      style: TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Order #123456 has been placed',
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '2m ago',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class OrdersListPage extends StatefulWidget {
  final bool isService;
  final String title;

  const OrdersListPage({Key? key, required this.isService, required this.title})
    : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Latest';

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),

            // Title
            Text(
              widget.title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Notification Bell Icon
            GestureDetector(
              onTap: () {
                // Show notification modal
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder:
                      (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.dividerColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Mark all as read',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 10,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemBuilder:
                                    (context, index) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.backgroundLight,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.notifications_outlined,
                                              color: AppTheme.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'New Order Received',
                                                  style: TextStyle(
                                                    color: AppTheme.textPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Order #123456 has been placed',
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.textSecondary,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '2m ago',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
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
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search orders...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter and Sort Options
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items:
                              ['All', 'Pending', 'Processing', 'Completed']
                                  .map(
                                    (status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => _selectedFilter = value!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedSort,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items:
                              [
                                    'Latest',
                                    'Oldest',
                                    'Price: High to Low',
                                    'Price: Low to High',
                                  ]
                                  .map(
                                    (sort) => DropdownMenuItem(
                                      value: sort,
                                      child: Text(sort),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => _selectedSort = value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _mainTabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            tabs: [
              Tab(
                text:
                    widget.isService ? 'Bookings Received' : 'Orders Received',
              ),
              Tab(text: widget.isService ? 'Bookings Made' : 'Orders Placed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                _buildOrdersList(isReceived: true),
                _buildOrdersList(isReceived: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList({required bool isReceived}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual data length
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (widget.isService
                              ? AppTheme.secondaryColor
                              : AppTheme.primaryColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.isService
                          ? Icons.calendar_today_outlined
                          : Icons.shopping_bag_outlined,
                      color:
                          widget.isService
                              ? AppTheme.secondaryColor
                              : AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isService
                              ? 'Service Booking #${1000 + index}'
                              : 'Product Order #${1000 + index}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹2,999',
                          style: TextStyle(
                            color:
                                widget.isService
                                    ? AppTheme.secondaryColor
                                    : AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentMint.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.accentMint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: AppTheme.accentMint,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textSecondary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2 hours ago',
                        style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle view details
                    },
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color:
                            widget.isService
                                ? AppTheme.secondaryColor
                                : AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
