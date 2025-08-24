import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/influencer_profile_screen.dart';
import '../../app_theme.dart';

class DiscoverInfluencersScreen extends StatefulWidget {
  const DiscoverInfluencersScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverInfluencersScreen> createState() =>
      _DiscoverInfluencersScreenState();
}

class _DiscoverInfluencersScreenState extends State<DiscoverInfluencersScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _slideAnimations;

  // Categories data
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Food Vlogers',
      'count': '1325 Creators',
      'color': const Color(0xFFFFE0B2), // Light orange/peach
      'icon': Icons.fastfood,
    },
    {
      'name': 'Fashion',
      'count': '1345 Creators',
      'color': const Color(0xFFE0F2F1), // Light mint
      'icon': Icons.shopping_bag,
    },
    {
      'name': 'Electronics',
      'count': '1725 Creators',
      'color': const Color(0xFFE3F2FD), // Light blue
      'icon': Icons.devices,
    },
    {
      'name': 'Finance',
      'count': '1725 Creators',
      'color': const Color(0xFFFFEBEE), // Light pink
      'icon': Icons.attach_money,
    },
    {
      'name': 'Travel',
      'count': '1125 Creators',
      'color': const Color(0xFFF3E5F5), // Light purple
      'icon': Icons.flight,
    },
    {
      'name': 'Fitness',
      'count': '1525 Creators',
      'color': const Color(0xFFE8F5E9), // Light green
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Beauty',
      'count': '1825 Creators',
      'color': const Color(0xFFFFF3E0), // Light amber
      'icon': Icons.face,
    },
    {
      'name': 'Gaming',
      'count': '1425 Creators',
      'color': const Color(0xFFEDE7F6), // Light deep purple
      'icon': Icons.sports_esports,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers and animations for each category
    _animationControllers = List.generate(
      _categories.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _slideAnimations = List.generate(
      _categories.length,
      (index) => Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationControllers[index],
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Start animations sequentially
    _startAnimations();
  }

  void _startAnimations() async {
    for (var controller in _animationControllers) {
      await Future.delayed(const Duration(milliseconds: 100));
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimations[index],
            child: _buildCategoryCard(
              name: _categories[index]['name'],
              count: _categories[index]['count'],
              color: _categories[index]['color'],
              icon: _categories[index]['icon'],
              onTap: () {
                // Navigate to influencer list filtered by this category
                _navigateToCategoryInfluencers(_categories[index]['name']);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required String count,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color.withAlpha(200), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          count,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCategoryInfluencers(String category) {
    // This would navigate to a filtered list of influencers for the selected category
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryInfluencersScreen(category: category),
      ),
    );
  }

  // Add notification modal
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

// Category Influencers Screen
class CategoryInfluencersScreen extends StatefulWidget {
  final String category;

  const CategoryInfluencersScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<CategoryInfluencersScreen> createState() =>
      _CategoryInfluencersScreenState();
}

class _CategoryInfluencersScreenState extends State<CategoryInfluencersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterOptions(),
          Expanded(child: _buildInfluencersList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search by name',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterButton(Icons.tune, 'Filter'),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Location', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Budget', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Type', showDropdown: true),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    IconData? icon,
    String text, {
    bool showDropdown = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: Colors.black),
          if (icon != null) const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14)),
          if (showDropdown) const SizedBox(width: 4),
          if (showDropdown) const Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
    );
  }

  Widget _buildInfluencersList() {
    // This would typically filter influencers by the selected category
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfluencerItem(
          'Shannu',
          'Shannu Jaswanth Kandregula',
          'assets/images/shannu.png',
          isVerified: true,
        ),
        _buildInfluencerItem(
          'Stella9',
          'Stella Joseph',
          'assets/images/bksaraf.png',
        ),
        _buildInfluencerItem(
          'Suurya',
          'Suurya Prabhat',
          'assets/images/bksaraf.png',
        ),
        _buildInfluencerItem(
          'Deepthi',
          'Deepthi Sunaina',
          'assets/images/bksaraf.png',
          isVerified: true,
        ),
        _buildInfluencerItem(
          'Raju_09',
          'Singa Raju',
          'assets/images/bksaraf.png',
        ),
      ],
    );
  }

  Widget _buildInfluencerItem(
    String name,
    String fullName,
    String imagePath, {
    bool isVerified = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to influencer profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => InfluencerProfileScreen(
                    username: name,
                    fullName: fullName,
                    imagePath: imagePath,
                    isVerified: isVerified,
                  ),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isVerified)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Add notification modal
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
