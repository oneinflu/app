import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:influnew/verification_screen.dart';
import 'package:influnew/widgets/pages/create_influencer_profile_screen.dart';
import 'package:influnew/widgets/pages/discover_influencers_screen.dart';
import 'package:influnew/widgets/pages/earnings_screen.dart';
import 'package:influnew/widgets/pages/feed_screen.dart';
import 'package:influnew/widgets/pages/orders_page.dart';
import 'package:influnew/widgets/pages/partner_benefits_screen.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import 'app_theme.dart';
import 'widgets/pages/for_you_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ForYouPage();
      case 2: // Add this case for the middle index
        return const FeedScreen();
      case 3:
        return const OrdersPage();
      case 4:
        return const EarningsScreen(fromBottomNav: true); // Pass the flag
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildPlaceholderContent(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.primaryPurple,
      ),
      body: Center(child: Text('$title Page Coming Soon')),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.purpleGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLogoAndHeading(), // New method to replace quick actions
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfluencerProfileCard(),
                      const SizedBox(height: 20),
                      _buildStoreCard(),
                      const SizedBox(height: 20),
                      _buildEarningsCard(),
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

  // New method to display logo and heading
  Widget _buildLogoAndHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'influ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        // Heading with gradient text
        Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color.fromARGB(255, 83, 212, 244), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const Text(
              'Welcome to New \n World of Influencing',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    Colors
                        .white, // This color is used as the base for the gradient
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Keep all the existing methods below
  // _buildHeader(), _buildQuickActions(), etc.
  // Update the _buildHeader method in home_screen.dart

  Widget _buildHeader() {
    return GetBuilder<AuthProvider>(
      builder: (authProvider) {
        final userType = authProvider.userType;
        final kycData = authProvider.userData?['kyc'];

        // Add debug prints
        print('=== DEBUG VERIFICATION STATUS ===');
        print('UserType: $userType');
        print('UserData: ${authProvider.userData}');
        print('KYC Data: $kycData');

        // Check verification status based on user type
        bool isFullyVerified = false;
        if (userType == 'Individual') {
          // For individuals: Aadhaar + PAN
          final isAadhaarVerified = kycData?['aadhaar']?['isVerified'] == true;
          final isPanVerified = kycData?['pan']?['isVerified'] == true;
          print('Aadhaar Verified: $isAadhaarVerified');
          print('PAN Verified: $isPanVerified');
          isFullyVerified = isAadhaarVerified && isPanVerified;
        } else if (userType == 'Organization') {
          // For organizations: GST + PAN
          final isGstVerified = kycData?['gst']?['isVerified'] == true;
          final isPanVerified = kycData?['pan']?['isVerified'] == true;
          print('GST Verified: $isGstVerified');
          print('PAN Verified: $isPanVerified');
          isFullyVerified = isGstVerified && isPanVerified;
        }

        print('Is Fully Verified: $isFullyVerified');
        print('================================');

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
              GestureDetector(
                onTap:
                    isFullyVerified
                        ? null
                        : () {
                          // Only navigate if not fully verified
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationScreen(),
                            ),
                          );
                        },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isFullyVerified
                            ? Colors.green.withOpacity(0.8)
                            : Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isFullyVerified ? 'Verified' : 'Get Verified Badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isFullyVerified ? Colors.white : Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: isFullyVerified ? Colors.green : Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quick actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.bolt, color: Colors.yellow, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionItem('Discover\nInfluencers', 'discover.png'),
              _buildQuickActionItem('Find Offers\nNearby', 'compass 2.png'),
              _buildQuickActionItem('Find\nCourses', 'compass 3.png'),
              _buildQuickActionItem('Find Best\nCollabs', 'compass 4.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(String title, String iconName) {
    return GestureDetector(
      onTap: () {
        if (title.contains('Discover\nInfluencers')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscoverInfluencersScreen(),
            ),
          );
        }
      },
      child: Container(
        width: 80,
        // Remove the right margin to allow proper centering
        // margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.quickActionsCard,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/$iconName',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfluencerProfileCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PartnerBenefitsScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/icons/compass 5.png',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                );
              },
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set up your Influencer profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start, Connect & done!',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStoreActionItem('Manage\nStore', 'compass 6.png'),
              _buildStoreActionItem('Discover\nInfluencers', 'compass 7.png'),
              _buildStoreActionItem('Upsell\nCourses', 'compass 8.png'),
              _buildStoreActionItem('Teach\nOnline', 'compass 1.png'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set up your Free Store or Channel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage products, services or even courses',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreActionItem(String title, String iconName) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.quickActionsCard.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icons/$iconName',
              width: 24,
              height: 24,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 24,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to use INFLU for earnings?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Watch how INFLU can make your rich',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.play_arrow, color: Colors.red, size: 30),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bharath ka Engine text
        Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Text(
            'Bharath Ka Engine',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Original navigation bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(0, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.grid_view, 'For You'),
                  _buildCenterNavItem(),
                  _buildNavItem(3, Icons.shopping_bag_outlined, 'Orders'),
                  _buildNavItem(4, Icons.bar_chart, 'Earnings'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryPurple : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryPurple : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = 2; // Set index to 2 for the middle item
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/favicon.png',
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              );
            },
          ),
        ),
      ),
    );
  }
}
