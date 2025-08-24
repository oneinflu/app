import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/category_detail_page.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import '../../app_theme.dart';
import 'package:video_player/video_player.dart';

class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({Key? key}) : super(key: key);

  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late VideoPlayerController _videoPlayerController;
  bool _isMuted = true;
  bool _isVideoInitialized = false;

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

    _videoPlayerController = VideoPlayerController.network(
        'https://videos.pexels.com/video-files/4673653/4673653-uhd_2560_1440_30fps.mp4',
      )
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _videoPlayerController.setLooping(true);
          _videoPlayerController.setVolume(0.0);
          _videoPlayerController.play();
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _restartVideo() {
    _videoPlayerController.seekTo(Duration.zero);
    _videoPlayerController.play();
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Discover Your Next Investment Opportunity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Search properties',
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(CategoryData category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CategoryDetailPage(
                  title: category.title,
                  subtitle: category.subtitle,
                  description: category.description,
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  '${category.imageUrl}?auto=format&fit=crop&w=800&q=80',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.backgroundLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.3),
                        AppTheme.primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(category.icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      category.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      category.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const ProfileManagementScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showNotificationDialog();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover Premium\nReal Estate Investments',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Find exclusive properties and investment opportunities',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                bottom: 200,
              ), // Increased bottom padding
              child: SizedBox(
                // Changed from Container to SizedBox for clarity
                height:
                    MediaQuery.of(context).size.height *
                    0.55, // Increased height proportion
                child: _buildCategoriesGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,

            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),

          const Text(
            'Welcome to New World\nof Influencing',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your journey as an influencer and connect with brands',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showNotificationDialog();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
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
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog() {
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

class CategoryData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final String description;

  CategoryData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.description,
  });
}

final List<CategoryData> categories = [
  CategoryData(
    title: 'Luxury',
    subtitle: 'Stays',
    imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
    icon: Icons.villa_outlined,
    description: 'Premium villas, penthouses, celebrity-style homes',
  ),
  CategoryData(
    title: 'Smart',
    subtitle: 'Living',
    imageUrl: 'https://images.unsplash.com/photo-1558211583-d26f610c1eb1',
    icon: Icons.smart_toy_outlined,
    description: 'Tech-enabled apartments, co-living spaces, smart homes',
  ),
  CategoryData(
    title: 'Work &',
    subtitle: 'Create',
    imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c',
    icon: Icons.work_outline,
    description: 'Office spaces, co-working hubs, studios',
  ),
  CategoryData(
    title: 'Weekend',
    subtitle: 'Escapes',
    imageUrl: 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2',
    icon: Icons.weekend_outlined,
    description: 'Farmhouses, short-term rentals, holiday homes',
  ),
  CategoryData(
    title: 'Urban',
    subtitle: 'Lifestyle',
    imageUrl: 'https://images.unsplash.com/photo-1493246507139-91e8fad9978e',
    icon: Icons.location_city_outlined,
    description: 'Trendy apartments in influencer hotspots',
  ),
  CategoryData(
    title: 'Collab',
    subtitle: 'Spaces',
    imageUrl: 'https://images.unsplash.com/photo-1497366412874-3415097a27e7',
    icon: Icons.groups_outlined,
    description: 'Spaces designed for content creation & events',
  ),
  CategoryData(
    title: 'Budget',
    subtitle: 'Goals',
    imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858',
    icon: Icons.savings_outlined,
    description: 'Affordable housing with lifestyle vibes',
  ),
  CategoryData(
    title: 'Green',
    subtitle: 'Living',
    imageUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233',
    icon: Icons.eco_outlined,
    description: 'Eco-homes, sustainable architecture',
  ),
  CategoryData(
    title: 'Community',
    subtitle: 'Living',
    imageUrl: 'https://images.unsplash.com/photo-1543269865-cbf427effbad',
    icon: Icons.people_outline,
    description: 'Gated societies with modern amenities',
  ),
  CategoryData(
    title: 'Investment',
    subtitle: 'Picks',
    imageUrl: 'https://images.unsplash.com/photo-1551135049-8a33b5883817',
    icon: Icons.trending_up_outlined,
    description: 'High ROI potential properties',
  ),
];
