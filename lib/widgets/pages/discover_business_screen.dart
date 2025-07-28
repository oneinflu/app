import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/business_profile_screen.dart';
import '../../app_theme.dart';

class DiscoverBusinessScreen extends StatefulWidget {
  const DiscoverBusinessScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverBusinessScreen> createState() => _DiscoverBusinessScreenState();
}

class _DiscoverBusinessScreenState extends State<DiscoverBusinessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text(
                  'Get Verified Badge',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
        ],
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
            hintText: 'Search by business name',
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
            _buildFilterButton(null, 'Industry', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Location', showDropdown: true),
            const SizedBox(width: 8),
            _buildFilterButton(null, 'Size', showDropdown: true),
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

  Widget _buildBusinessList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBusinessItem(
          'TechCorp',
          'TechCorp Solutions Inc.',
          'assets/images/bksaraf.png',
          isVerified: true,
        ),
        _buildBusinessItem(
          'EcoFriendly',
          'EcoFriendly Products',
          'assets/images/bksaraf.png',
        ),
        _buildBusinessItem(
          'HealthPlus',
          'HealthPlus Medical Services',
          'assets/images/bksaraf.png',
        ),
        _buildBusinessItem(
          'FoodDelight',
          'Food Delight Catering',
          'assets/images/bksaraf.png',
          isVerified: true,
        ),
        _buildBusinessItem(
          'CreativeDesign',
          'Creative Design Studios',
          'assets/images/bksaraf.png',
        ),
      ],
    );
  }

  Widget _buildBusinessItem(
    String name,
    String fullName,
    String imagePath, {
    bool isVerified = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to business profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BusinessProfileScreen(
                    businessName: name,
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
}
