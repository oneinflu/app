import 'package:flutter/material.dart';
import 'package:influnew/widgets/booking/booking_flow_widget.dart';
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
  bool isFavorite = false;

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
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppTheme.accentCoral : Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black54),
              onPressed: () {},
            ),
          ),
        ],
      ),
      // Add the floating action button at the bottom of the scaffold
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildBookButton(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // Add padding at the bottom to prevent content from being hidden behind the button
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16), // Added extra spacing here
                  _buildProfileHeader(),
                  _buildStatsRow(),
                  _buildTabBar(),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height *
                        0.4, // Adjustable height for tab content
                    child: _buildTabContent(),
                  ),
                  // Removed _buildBookButton() from here since it's now a floating action button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          Text(
            'Content Creator',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Name and verification
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.fullName,
                            style: const TextStyle(
                              color: Color(0xFF2D3142),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppTheme.accentMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 24,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Fashion | Travel | Minimalism',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Profile image
              Hero(
                tag: 'influencer-${widget.username}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // "Starts From" text
          Text(
            'Starts From',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),

          // Price per collaboration
          Row(
            children: [
              Text(
                '\$84',
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/collaboration',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard('12', 'years', 'Experience', Icons.access_time),
          const SizedBox(width: 12),
          _buildStatCard('4.8', '', 'Rating', Icons.star),
          const SizedBox(width: 12),
          _buildStatCard('2500+', '', 'Followers', Icons.people),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String unit,
    String label,
    IconData icon,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF2D3142),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                unit,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTabItem('About', 0),
          _buildTabItem('Availability', 1),
          _buildTabItem('Rate Cards', 2),
          _buildTabItem('Samples', 3),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppTheme.secondaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.secondaryColor : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAboutTab(),
        _buildPlaceholderTab('Availability'),
        _buildRateCardsTab(),
        _buildSamplesTab(),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lifestyle content creator with expertise in fashion, travel, and minimalist living. Specializes in authentic brand partnerships and creating engaging visual content for social media platforms.',
            style: TextStyle(
              color: Color(0xFF2D3142),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('More'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Collaboration Fee', '\$84'),
          const SizedBox(height: 12),
          _buildInfoRow('Additional Posts', '\$40 (Within 7 days)'),
          const SizedBox(height: 12),
          _buildInfoRow('Avg. Engagement', '3.2%'),
          const SizedBox(height: 12),
          _buildInfoRow('Total Followers', '2500+'),
        ],
      ),
    );
  }

  Widget _buildRateCardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRateCard(
            'Instagram Post',
            '\$84',
            'Single high-quality post with your product/service',
          ),
          const SizedBox(height: 16),
          _buildRateCard(
            'Instagram Story',
            '\$60',
            '3 story frames featuring your brand',
          ),
          const SizedBox(height: 16),
          _buildRateCard('Reel/TikTok', '\$120', '15-30 second video content'),
          const SizedBox(height: 16),
          _buildRateCard(
            'Full Package',
            '\$250',
            'Post + Stories + Reel (Save 5%)',
          ),
        ],
      ),
    );
  }

  Widget _buildRateCard(String title, String price, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2D3142),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSamplesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 6, // Sample count
      itemBuilder: (context, index) {
        return _buildSampleItem(index);
      },
    );
  }

  Widget _buildSampleItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(widget.imagePath), // Use placeholder image
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2D3142),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        '$title content coming soon',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }

  Widget _buildBookButton() {
    return BookingFlowWidget(
      influencerName: widget.fullName,
      fullName: widget.fullName,
      imagePath: widget.imagePath,
    );
  }
}
