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
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  late TabController _tabController;

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
    _loadInfluencerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Help?',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 16),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.primaryPurple,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppTheme.primaryPurple,
                      tabs: const [
                        Tab(icon: Icon(Icons.person)),
                        Tab(icon: Icon(Icons.video_library)),
                      ],
                    ),
                  ),
                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // First Tab - Profile Content
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAboutSection(),
                              const SizedBox(height: 24),
                              _buildConnectedSocialMedia(),
                              const SizedBox(height: 24),
                              _buildRateCards(),
                              const SizedBox(height: 24),
                              _buildManagedBySection(),
                            ],
                          ),
                        ),
                        // Second Tab - Reels Interface
                        _buildReelsInterface(),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  // New method to build the reels interface
  Widget _buildReelsInterface() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
              borderRadius: BorderRadius.circular(12),
              child: Image.network(_unsplashImages[index], fit: BoxFit.cover),
            ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Shopping bag icon with order count
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
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
          const Icon(Icons.error_outline, size: 80, color: Color(0xFF9E9E9E)),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Color(0xFF9E9E9E)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInfluencerData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
    final username =
        userData?['username'] ??
        'username'; // Changed from 'name' to 'username'
    final profileUrl = userData?['profileURL'];

    // Add the missing variable declarations with safe type conversion
    final followersCount =
        _influencerProfile?['followersCount']?.toString() ?? '980';
    final followingCount =
        _influencerProfile?['followingCount']?.toString() ?? '81';
    final dealsCount = _influencerProfile?['dealsCount']?.toString() ?? '10';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
                      username, // Changed from 'name' to 'username'
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
          const SizedBox(height: 16),
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
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
      ),
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
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(
              0xFF757575,
            ), // Direct color instead of Colors.grey[600]
          ),
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
            color: Colors.grey.withOpacity(0.1),
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
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(bio, style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.business, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Collaborated with: ${brands.take(3).join(', ')}${brands.length > 3 ? ' many more...' : ''}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
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
            color: Colors.grey.withOpacity(0.1),
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
            'Connected Social Media',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
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
            activeColor: AppTheme.primaryPurple,
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
            color: Colors.grey.withOpacity(0.1),
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
              const Text(
                'Rate Cards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Updated to horizontal scrollable list
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryPurple : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : const Color(0xFF757575),
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
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 20),
                color: const Color(0xFF757575),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF616161)),
          ),
          const SizedBox(height: 4),
          Text(
            delivery,
            style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
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
                          color: const Color(0xFF757575),
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
            color: Colors.grey.withOpacity(0.1),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE0E0E0),
                child: const Icon(Icons.person, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Self Managed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
