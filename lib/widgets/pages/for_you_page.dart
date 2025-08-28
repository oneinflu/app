import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/channel_benefits_screen.dart';
import 'package:influnew/widgets/pages/collabs_categories_page.dart';
import 'package:influnew/widgets/pages/discover_business_screen.dart';
import 'package:influnew/widgets/pages/discover_influencers_screen.dart';
import 'package:influnew/widgets/pages/find_courses_screen.dart';
import 'package:influnew/widgets/pages/partner_benefits_screen.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import 'package:influnew/widgets/pages/shop_products_screen.dart';
import 'package:influnew/widgets/pages/store_benefits_screen.dart';
import '../../app_theme.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> with TickerProviderStateMixin {
  int _currentSlide = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeaturedSlider(),
                const SizedBox(height: 16),
                _buildSliderIndicator(),
                const SizedBox(height: 32),

                _buildEarningsSection(),
                const SizedBox(height: 32),
                _buildLifestyleSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
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

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'For You',
            style: AppTheme.headlineStyle.copyWith(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover personalized content and opportunities',
            style: AppTheme.bodyTextStyle.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSlider() {
    return Container(
      height: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentSlide = index;
          });
        },
        children: [
          _buildSlideItem(
            'Become an Influencer',
            'Start your journey to influence and earn',
            AppTheme.actionGradient,
            Icons.star,
          ),
          _buildSlideItem(
            'Create Your Store',
            'Build your business and reach more customers',
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.accentMint, AppTheme.secondaryColor],
            ),
            Icons.store,
          ),

          _buildSlideItem(
            'Create Online Course',
            'Start teaching and share your knowledge',
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.accentCoral, AppTheme.primaryColor],
            ),
            Icons.school,
          ),
        ],
      ),
    );
  }

  Widget _buildSlideItem(
    String title,
    String subtitle,
    LinearGradient gradient,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Reduced from 20 to 16
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Added to prevent overflow
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28, // Reduced from 32 to 28
          ),
          const SizedBox(height: 12), // Reduced from 16 to 12
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18, // Reduced from 20 to 18
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6), // Reduced from 8 to 6
          Expanded(
            // Wrap subtitle in Expanded to prevent overflow
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13, // Reduced from 14 to 13
              ),
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing before button
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            _currentSlide == 0
                                ? const PartnerBenefitsScreen()
                                : _currentSlide == 1
                                ? const StoreBenefitsScreen()
                                : const ChannelBenefitsScreen(),
                  ),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              _currentSlide == 0
                  ? 'Get Started'
                  : _currentSlide == 1
                  ? 'Get Started'
                  : 'Get Started',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3, // Number of slides
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentSlide == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color:
                _currentSlide == index
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Earnings',
          style: AppTheme.headlineStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Post Property',
                Icons.home,
                AppTheme.accentMint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Manage Store',
                Icons.store,
                AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Manage Services',
                Icons.miscellaneous_services,
                AppTheme.accentYellow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Collab',
                Icons.handshake,
                AppTheme.accentCoral,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLifestyleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lifestyle & Services',
          style: AppTheme.headlineStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Shop Products',
                Icons.shopping_bag,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Hire Influencers',
                Icons.star,
                AppTheme.accentYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Book Services',
                Icons.people,
                AppTheme.accentMint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Find Courses',
                Icons.school,
                AppTheme.accentYellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color accentColor) {
    return InkWell(
      onTap: () {
        _handleCardNavigation(title);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTheme.bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardNavigation(String title) {
    switch (title) {
      case 'Shop Products':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopProductsScreen()),
        );
        break;
      case 'Create Store':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StoreBenefitsScreen()),
        );
        break;
      case 'Create Channel':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChannelBenefitsScreen(),
          ),
        );
        break;
      case 'Hire Influencers':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscoverInfluencersScreen(),
          ),
        );
        break;
      case 'Collaborate':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CollabsCategoriesPage(),
          ),
        );
        break;
      case 'Find Courses':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FindCoursesScreen()),
        );
        break;
      case 'Discover Business':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscoverBusinessScreen(),
          ),
        );
        break;
      default:
        // Handle other cases or show a coming soon message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature coming soon!'),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
    }
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
