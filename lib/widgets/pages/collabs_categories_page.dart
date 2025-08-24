import 'package:flutter/material.dart';
import 'package:influnew/home_screen.dart';
import 'package:influnew/widgets/pages/influencer_profile_screen.dart';
import '../../app_theme.dart';

class CollabsCategoriesPage extends StatefulWidget {
  const CollabsCategoriesPage({Key? key}) : super(key: key);

  @override
  State<CollabsCategoriesPage> createState() => _CollabsCategoriesPageState();
}

class _CollabsCategoriesPageState extends State<CollabsCategoriesPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _slideAnimations;

  // Categories data

  // Categories data
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Restaurants',
      'count': '2325 Businesses',
      'color': const Color(0xFFFFE0B2), // Light orange/peach
      'icon': Icons.restaurant,
    },
    {
      'name': 'Retail Stores',
      'count': '1845 Businesses',
      'color': const Color(0xFFE0F2F1), // Light mint
      'icon': Icons.store,
    },
    {
      'name': 'Hotels',
      'count': '925 Businesses',
      'color': const Color(0xFFE3F2FD), // Light blue
      'icon': Icons.hotel,
    },
    {
      'name': 'Real Estate',
      'count': '725 Businesses',
      'color': const Color(0xFFFFEBEE), // Light pink
      'icon': Icons.apartment,
    },
    {
      'name': 'Automotive',
      'count': '625 Businesses',
      'color': const Color(0xFFF3E5F5), // Light purple
      'icon': Icons.directions_car,
    },
    {
      'name': 'Healthcare',
      'count': '825 Businesses',
      'color': const Color(0xFFE8F5E9), // Light green
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Education',
      'count': '1225 Businesses',
      'color': const Color(0xFFFFF3E0), // Light amber
      'icon': Icons.school,
    },
    {
      'name': 'Entertainment',
      'count': '925 Businesses',
      'color': const Color(0xFFEDE7F6), // Light deep purple
      'icon': Icons.movie,
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
    // Navigate to filtered list of businesses for the selected category
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryBusinessScreen(category: category),
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

// Category Business Screen
class CategoryBusinessScreen extends StatefulWidget {
  final String category;

  const CategoryBusinessScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<CategoryBusinessScreen> createState() => _CategoryBusinessScreenState();
}

class _CategoryBusinessScreenState extends State<CategoryBusinessScreen> {
  // Add state for selected businesses
  final Set<String> _selectedBusinesses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Add FloatingActionButton
      floatingActionButton:
          _selectedBusinesses.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () => _showCollabRequestDialog(),
                backgroundColor: AppTheme.primaryColor,
                icon: const Icon(Icons.send),
                label: const Text(
                  'Send Collab Request',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${widget.category} Businesses',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterOptions(),
          Expanded(child: _buildBusinessList()),
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
            hintText: 'Search businesses',
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
            _buildFilterButton(null, 'Rating', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Location', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Size', showDropdown: true),
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

  Widget _buildBusinessList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBusinessItem(
          'The Grand Restaurant',
          '123 Main Street',
          4.5,
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
        ),
        _buildBusinessItem(
          'City View Hotel',
          '456 Park Avenue',
          4.8,
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
        ),
        _buildBusinessItem(
          'Tech Store Pro',
          '789 Digital Lane',
          4.2,
          'https://images.unsplash.com/photo-1531297484001-80022131f5a1',
        ),
        _buildBusinessItem(
          'Wellness Center',
          '321 Health Road',
          4.6,
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        ),
      ],
    );
  }

  Widget _buildBusinessItem(
    String name,
    String address,
    double rating,
    String imageUrl,
  ) {
    final bool isSelected = _selectedBusinesses.contains(name);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedBusinesses.remove(name);
            } else {
              _selectedBusinesses.add(name);
            }
          });
        },
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCollabRequestDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 160,
                              width: 160,
                              child: CircularProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey[100],
                                color: AppTheme.primaryColor,
                                strokeWidth: 12,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: value < 1
                                  ? const Icon(
                                      Icons.send,
                                      size: 60,
                                      color: AppTheme.primaryColor,
                                      key: ValueKey('send'),
                                    )
                                  : const Icon(
                                      Icons.check_circle,
                                      size: 80,
                                      color: AppTheme.primaryColor,
                                      key: ValueKey('check'),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            value < 1
                                ? 'Sending Collab Requests...'
                                : 'Requests Sent Successfully!',
                            key: ValueKey(value < 1 ? 'sending' : 'sent'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: value < 1 ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Text(
                                'Sending requests to ${_selectedBusinesses.length} businesses',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _selectedBusinesses.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.business,
                                          color: AppTheme.primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _selectedBusinesses.elementAt(index),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (value == 1) ...[  
                          const SizedBox(height: 24),
                          Text(
                            'We\'ll notify you when businesses respond',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Go to Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
