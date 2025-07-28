import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'influencer_profile_setup_screen.dart';
import 'rate_cards_management_screen.dart';

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
  bool _isLoading = true;
  String? _error;
  String _selectedPlatform = 'All';
  List<String> _availablePlatforms = ['All'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInfluencerProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInfluencerProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getInfluencerProfile();

      if (response.success && response.data != null) {
        setState(() {
          _influencerProfile = response.data!['influencerProfile'];
          _rateCards = _influencerProfile?['rateCards'] ?? [];
          _updateAvailablePlatforms();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load profile';
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

  void _updateAvailablePlatforms() {
    final platforms =
        _rateCards
            .map((card) => card['platform'] as String? ?? 'Other')
            .toSet()
            .toList();
    platforms.sort();
    _availablePlatforms = ['All', ...platforms];

    if (!_availablePlatforms.contains(_selectedPlatform)) {
      _selectedPlatform = 'All';
    }
  }

  List<dynamic> get _filteredRateCards {
    if (_selectedPlatform == 'All') {
      return _rateCards;
    }
    return _rateCards
        .where((card) => card['platform'] == _selectedPlatform)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Influencer Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.primaryPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfluencerProfileSetupScreen(),
                ),
              ).then((_) => _loadInfluencerProfile());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryPurple,
          labelColor: AppTheme.primaryPurple,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Profile Info'), Tab(text: 'Rate Cards')],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _buildErrorState()
              : TabBarView(
                controller: _tabController,
                children: [_buildProfileInfoTab(), _buildRateCardsTab()],
              ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Error Loading Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInfluencerProfile,
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

  Widget _buildProfileInfoTab() {
    if (_influencerProfile == null) {
      return const Center(child: Text('No profile data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.primaryPurple.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    _authProvider.user.value?['name']
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _authProvider.user.value?['name'] ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _influencerProfile!['isActive'] ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Followers',
                  _formatNumber(_influencerProfile!['totalFollowers'] ?? 0),
                  Icons.people,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg Engagement',
                  '${_influencerProfile!['avgEngagementRate'] ?? 0}%',
                  Icons.trending_up,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bio Section
          _buildInfoCard(
            'Bio',
            _influencerProfile!['bio'] ?? 'No bio available',
            Icons.person,
          ),

          const SizedBox(height: 16),

          // Categories Section
          _buildInfoCard(
            'Categories',
            (_influencerProfile!['categories'] as List?)?.join(', ') ??
                'No categories',
            Icons.category,
          ),

          const SizedBox(height: 16),

          // Platforms Section
          _buildInfoCard(
            'Platforms',
            (_influencerProfile!['platforms'] as List?)?.join(', ') ??
                'No platforms',
            Icons.social_distance,
          ),

          const SizedBox(height: 16),

          // Brands Worked With
          if (_influencerProfile!['brandsWorkedWith'] != null &&
              (_influencerProfile!['brandsWorkedWith'] as List).isNotEmpty)
            _buildInfoCard(
              'Brands Worked With',
              (_influencerProfile!['brandsWorkedWith'] as List).join(', '),
              Icons.business,
            ),

          const SizedBox(height: 16),

          // Media Kit URL
          if (_influencerProfile!['mediaKitUrl'] != null &&
              _influencerProfile!['mediaKitUrl'].toString().isNotEmpty)
            _buildInfoCard(
              'Media Kit',
              _influencerProfile!['mediaKitUrl'],
              Icons.link,
              isLink: true,
            ),
        ],
      ),
    );
  }

  Widget _buildRateCardsTab() {
    return Column(
      children: [
        // Platform Navigation Pills
        if (_availablePlatforms.length > 1) _buildPlatformTabs(),
        // Content
        Expanded(
          child:
              _filteredRateCards.isEmpty
                  ? _buildEmptyRateCardsState()
                  : _buildRateCardsList(),
        ),
      ],
    );
  }

  Widget _buildPlatformTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availablePlatforms.length,
        itemBuilder: (context, index) {
          final platform = _availablePlatforms[index];
          final isSelected = platform == _selectedPlatform;
          final count =
              platform == 'All'
                  ? _rateCards.length
                  : _rateCards
                      .where((card) => card['platform'] == platform)
                      .length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlatform = platform;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryPurple : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    platform,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.white.withOpacity(0.2)
                                : AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppTheme.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyRateCardsState() {
    final isFilteredEmpty =
        _selectedPlatform != 'All' && _filteredRateCards.isEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFilteredEmpty
                ? Icons.filter_list_off
                : Icons.credit_card_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isFilteredEmpty
                ? 'No Rate Cards for $_selectedPlatform'
                : 'No Rate Cards Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFilteredEmpty
                ? 'Create a rate card for $_selectedPlatform\nto start receiving collaboration requests'
                : 'Create your first rate card to start\nreceiving collaboration requests',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RateCardsManagementScreen(),
                ),
              ).then((_) => _loadInfluencerProfile());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isFilteredEmpty
                  ? 'Create Rate Card for $_selectedPlatform'
                  : 'Create Rate Card',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCardsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRateCards.length,
      itemBuilder: (context, index) {
        final rateCard = _filteredRateCards[index];
        return _buildRateCardItem(rateCard);
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    String content,
    IconData icon, {
    bool isLink = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isLink ? Colors.blue : Colors.grey[800],
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppTheme.primaryPurple),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRateCardItem(Map<String, dynamic> rateCard) {
    final price = rateCard['price'] ?? {};
    final amount = price['amount'] ?? 0;
    final currency = price['currency'] ?? 'INR';
    final negotiable = price['negotiable'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              rateCard['platform'] ?? '',
                              style: const TextStyle(
                                color: AppTheme.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              rateCard['contentType'] ?? '',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (rateCard['description'] != null &&
                          rateCard['description'].toString().isNotEmpty)
                        Text(
                          rateCard['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppTheme.primaryPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RateCardsManagementScreen(),
                      ),
                    ).then((_) => _loadInfluencerProfile());
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '$currency $amount',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    if (negotiable)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Negotiable',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  'Created: ${_formatDate(rateCard['createdAt'])}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
