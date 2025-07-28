import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/channel_benefits_screen.dart';
import 'package:influnew/widgets/pages/discover_business_screen.dart';
import 'package:influnew/widgets/pages/discover_influencers_screen.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import 'package:influnew/widgets/pages/shop_products_screen.dart';
import 'package:influnew/widgets/pages/store_benefits_screen.dart';
import '../../app_theme.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  int _currentSlide = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildEarningsSection()],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // This removes the back arrow button
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black, // Changed to dark background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text(
                  'Get Verified Badge',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ), // Changed text color to white for better contrast
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
    );
  }

  Widget _buildSlider() {
    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentSlide = index;
          });
        },
        children: [
          _buildSlideItem(),
          // Add more slides as needed
        ],
      ),
    );
  }

  Widget _buildSlideItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Influ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Become a\nInfluencer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Start Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        1, // Change this to the number of slides
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentSlide == index
                    ? AppTheme.primaryPurple
                    : Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildLifestyleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Your Lifestyle Better',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard('Shop Products', Icons.shopping_bag),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard('Book Services', Icons.people)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard('Find Courses', Icons.school)),
            const SizedBox(width: 16),
            Expanded(child: Container()), // Empty container to maintain balance
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Your Earnings Better',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard('Hire Influencers', Icons.star)),
            const SizedBox(width: 16),
            Expanded(child: _buildActionCard('Collaborate', Icons.handshake)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard('Create Store', Icons.store)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard('Create Channel', Icons.video_library),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle navigation based on the card title
        if (title == 'Shop Products') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopProductsScreen()),
          );
        } else if (title == 'Create Store') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StoreBenefitsScreen(),
            ),
          );
        } else if (title == 'Create Channel') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChannelBenefitsScreen(),
            ),
          );
        } else if (title == 'Hire Influencers') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscoverInfluencersScreen(),
            ),
          );
        } else if (title == 'Collaborate') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscoverBusinessScreen(),
            ),
          );
        }
        // Add other navigation options for other cards as needed
      },
      child: Container(
        height: 90, // Fixed height for all action cards
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
