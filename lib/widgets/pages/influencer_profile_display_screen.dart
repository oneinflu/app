import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/widgets/pages/share_profile_screen.dart';
import '../../app_theme.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'influencer_profile_setup_screen.dart';
import 'rate_cards_management_screen.dart';
import 'connected_accounts_screen.dart';
import 'package:reels_viewer/reels_viewer.dart';
import '../../models/custom_reel_model.dart';
import 'dart:math' as math;

class InfluencerProfileDisplayScreen extends StatefulWidget {
  const InfluencerProfileDisplayScreen({Key? key}) : super(key: key);

  @override
  State<InfluencerProfileDisplayScreen> createState() =>
      _InfluencerProfileDisplayScreenState();
}

class _InfluencerProfileDisplayScreenState
    extends State<InfluencerProfileDisplayScreen>
    with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic>? _influencerProfile;
  List<dynamic> _rateCards = [];
  Map<String, dynamic>? _socialMediaConnections;
  bool _isLoading = true;
  String? _error;

  // Sample data for reels
  final List<String> _unsplashImages = [
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000',
    'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=1000',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=1000',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1000',
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?q=80&w=1000',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadInfluencerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInfluencerData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load influencer profile
      final profileResponse = await _apiService.getInfluencerProfile();

      // Load social media connections
      final socialResponse = await _apiService.getSocialMediaConnections();

      // Load rate cards
      final rateCardsResponse = await _apiService.getRateCards();

      if (profileResponse.success && profileResponse.data != null) {
        setState(() {
          _influencerProfile = profileResponse.data!['influencerProfile'];
          _rateCards = _influencerProfile?['rateCards'] ?? [];

          if (socialResponse.success && socialResponse.data != null) {
            _socialMediaConnections = socialResponse.data;
          }

          if (rateCardsResponse.success && rateCardsResponse.data != null) {
            _rateCards = rateCardsResponse.data!['rateCards'] ?? _rateCards;
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _error = profileResponse.message ?? 'Failed to load profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
             
        
              : FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildTabBar(),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // First Tab - Profile Content
                                  _buildProfileContent(),
                                  // Second Tab - Reels Interface
                                  _buildReelsInterface(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Help?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProfileHeader(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppTheme.primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Profile'), Tab(text: 'Content')],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection(),
          const SizedBox(height: 16),
          _buildConnectedSocialMedia(),
          const SizedBox(height: 16),
          _buildRateCards(),
          const SizedBox(height: 16),
          _buildManagedBySection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // New method to build the reels interface
  Widget _buildReelsInterface() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _unsplashImages.length,
      itemBuilder: (context, index) {
        // Generate random order count between 5-50
        final random = math.Random();
        final orderCount = random.nextInt(46) + 5; // 5 to 50

        return Stack(
          fit: StackFit.expand,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(_unsplashImages[index], fit: BoxFit.cover),
            ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Shopping bag icon with order count
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$orderCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppTheme.accentCoral,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: AppTheme.secondaryTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInfluencerData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userData = _authProvider.user.value;
    final username = userData?['username'] ?? 'username';
    final profileUrl = userData?['profileURL'];

    // Add the missing variable declarations with safe type conversion
    final followersCount =
        _influencerProfile?['followersCount']?.toString() ?? '980';
    final followingCount =
        _influencerProfile?['followingCount']?.toString() ?? '81';
    final dealsCount = _influencerProfile?['dealsCount']?.toString() ?? '10';

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  profileUrl != null
                      ? NetworkImage(profileUrl)
                      : const AssetImage('assets/images/bksaraf.png')
                          as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatItem(followersCount, 'Followers'),
                      const SizedBox(width: 24),
                      _buildStatItem(followingCount, 'Following'),
                      const SizedBox(width: 24),
                      _buildStatItem(dealsCount, 'Deals'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShareProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Share Profile',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const InfluencerProfileSetupScreen(),
                    ),
                  ).then((_) => _loadInfluencerData());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Manage Profile',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    final bio =
        _influencerProfile?['bio'] ??
        'Content Creator | Brand Collaborator | Lifestyle';
    final location =
        _influencerProfile?['location'] ?? 'Based in Hyderabad, India';
    final description =
        _influencerProfile?['description'] ??
        'Sharing daily inspiration in fashion, wellness, tech';

    // Fix: Handle both List and String types for brandsWorkedWith
    final brandsData = _influencerProfile?['brandsWorkedWith'];
    List<String> brands;

    if (brandsData is List) {
      brands = brandsData.cast<String>();
    } else if (brandsData is String) {
      brands = [brandsData];
    } else {
      brands = ['Nike', 'Adidas', 'Nykaa'];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: AppTheme.headlineStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(bio, style: AppTheme.bodyTextStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTheme.secondaryTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTheme.bodyTextStyle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.business,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Collaborated with: ${brands.take(3).join(', ')}${brands.length > 3 ? ' many more...' : ''}',
                  style: AppTheme.secondaryTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedSocialMedia() {
    final socialAccounts = [
      {
        'platform': 'Instagram',
        'username': 'shannu.jashwanthi',
        'icon': Icons.camera_alt,
        'color': Colors.pink,
        'connected': true,
      },
      {
        'platform': 'Facebook',
        'username': 'Shannu',
        'icon': Icons.facebook,
        'color': Colors.blue,
        'connected': true,
      },
      {
        'platform': 'YouTube',
        'username': 'Shannnu.channel',
        'icon': Icons.play_circle_fill,
        'color': Colors.red,
        'connected': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Connected Social Media',
                style: AppTheme.headlineStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...socialAccounts.map((account) => _buildSocialMediaItem(account)),
        ],
      ),
    );
  }

  Widget _buildSocialMediaItem(Map<String, dynamic> account) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: account['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(account['icon'], color: account['color'], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              account['username'],
              style: AppTheme.bodyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: account['connected'],
            onChanged: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectedAccountsScreen(),
                ),
              );
            },
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRateCards() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rate Cards',
                    style: AppTheme.headlineStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RateCardsManagementScreen(),
                    ),
                  ).then((_) => _loadInfluencerData());
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Updated to horizontal scrollable list
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildPlatformChip('All Platforms', true),
                const SizedBox(width: 8),
                _buildPlatformChip('Youtube', false),
                const SizedBox(width: 8),
                _buildPlatformChip('Facebook', false),
                const SizedBox(width: 8),
                _buildPlatformChip('Instagram', false),
                const SizedBox(width: 8),
                _buildPlatformChip('Twitter', false),
                const SizedBox(width: 8),
                _buildPlatformChip('LinkedIn', false),
                const SizedBox(width: 8),
                _buildPlatformChip('TikTok', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRateCardItem(
            'Story (1-3 Frames)',
            '₹5,000',
            '24-hour story with swipe-up/mention',
            'Delivery: 3-5 working days after brief/product received',
            [Icons.camera_alt, Icons.facebook, Icons.play_circle_fill],
          ),
          const SizedBox(height: 12),
          _buildRateCardItem(
            'Giveaway Collaboration',
            '₹18,000',
            '1 post + story + coordination',
            'Delivery: 4-5 working days after brief/product received',
            [Icons.camera_alt, Icons.facebook, Icons.play_circle_fill],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: AppTheme.dividerColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.white : AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildRateCardItem(
    String title,
    String price,
    String description,
    String delivery,
    List<IconData> platforms,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.bodyTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 20),
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentMint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTheme.bodyTextStyle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            delivery,
            style: AppTheme.secondaryTextStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children:
                platforms
                    .map(
                      (icon) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          icon,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildManagedBySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Managed By',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.backgroundLight,
                child: const Icon(
                  Icons.person,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Self Managed',
                style: AppTheme.bodyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
