import 'package:flutter/material.dart';
import '../../app_theme.dart';

class InfluencerProfileScreen extends StatefulWidget {
  final String username;
  final String fullName;
  final String imagePath;
  final bool isVerified;

  const InfluencerProfileScreen({
    Key? key,
    required this.username,
    required this.fullName,
    required this.imagePath,
    this.isVerified = false,
  }) : super(key: key);

  @override
  State<InfluencerProfileScreen> createState() =>
      _InfluencerProfileScreenState();
}

class _InfluencerProfileScreenState extends State<InfluencerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryPurple,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative circles like in splash screen
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 25,
                  ),
                ),
              ),
            ),
            // Main content
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildProfileCard()),
                  SliverToBoxAdapter(child: _buildTabBar()),
                ];
              },
              body: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(
                widget.username,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              if (widget.isVerified)
                Container(
                  margin: const EdgeInsets.only(left: 4),
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
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: AppTheme.purpleGradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(children: [_buildProfileInfo(), _buildStats()]),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(widget.imagePath),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fashion | Travel | Minimalism',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Social icons and location in same row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Social icons pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Icon(Icons.facebook, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Icon(Icons.play_arrow, color: Colors.white, size: 20),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Location pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Hyderabad, India',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Follow button and followers count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFollowButton(),
              const SizedBox(width: 16),
              _buildFollowersButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.quickActionsCard,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: const Text('Follow'),
    );
  }

  Widget _buildFollowersButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.transparent),
      ),
      child: const Text(
        '9.5 M Followers',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('12.5 M', 'Followers'),
          _buildVerticalDivider(),
          _buildStatItem('8.9%', 'Engagement'),
          _buildVerticalDivider(),
          _buildStatItem('2.1M+', 'Total Reach'),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem('About', 0),
          _buildTabItem('Hire Me', 1),
          _buildTabItem('My Store', 2),
          _buildTabItem('Academy', 3),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAboutTab(),
        _buildPlaceholderTab('Hire Me'),
        _buildPlaceholderTab('My Store'),
        _buildPlaceholderTab('Academy'),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.format_quote, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Helping brands, businesses & communities grow through influence, knowledge, and storytelling. Building the future one post, one campaign, one vision at a time.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'I can speak in...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLanguageChip('English'),
              const SizedBox(width: 8),
              _buildLanguageChip('Hindi'),
              const SizedBox(width: 8),
              _buildLanguageChip('Telugu'),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Recent Posts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Icon(Icons.facebook, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecentPosts(),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        language,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildRecentPosts() {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/bksaraf.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/bksaraf.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/shannu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        '$title tab content coming soon',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
