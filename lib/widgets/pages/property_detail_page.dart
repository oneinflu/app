import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:influnew/app_theme.dart';

class ShopItem {
  final String image;
  final String name;
  final String price;
  final String category;

  ShopItem({
    required this.image,
    required this.name,
    required this.price,
    required this.category,
  });
}

class PropertyContent {
  final String tagline;
  final List<String> images;
  final List<ActionButton> actions;
  final List<String> lifestyleTags;
  final String influencerQuote;
  final String influencerHandle;
  final List<AmenityIcon> amenities;
  final List<ShopItem> shopItems; // Add this field
  final List<ServiceOption> services;
  final List<InfluencerContent> influencers;
  final List<ReviewContent> reviews;
  final List<InvestmentOption> investmentOptions;
  final int coInvestorsCount;
  final double totalInvestment;
  final List<ExperienceOption> experiences;
  PropertyContent({
    required this.tagline,
    required this.images,
    required this.actions,
    required this.lifestyleTags,
    required this.influencerQuote,
    required this.influencerHandle,
    required this.amenities,
    required this.shopItems,
    required this.services,
    required this.influencers,
    required this.reviews,
    required this.investmentOptions,
    required this.coInvestorsCount,
    required this.totalInvestment,
    required this.experiences, // Add this parameter
  });
}

class AmenityIcon {
  final IconData icon;
  final String label;

  AmenityIcon({required this.icon, required this.label});
}

class ActionButton {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  ActionButton({required this.label, required this.icon, required this.onTap});
}

class PropertyDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;

  const PropertyDetailPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
  }) : super(key: key);

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  late PropertyContent _propertyContent;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _propertyContent = _getPropertyContent();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {}); // Trigger rebuild when tab changes
    }
  }

  PropertyContent _getPropertyContent() {
    return PropertyContent(
      tagline: widget.description,
      images: [
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
        'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
        'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf',
      ],
      actions: [
        ActionButton(
          label: 'Book Stay',
          icon: Icons.hotel,
          onTap: () => _handleAction('book_stay'),
        ),
        ActionButton(
          label: 'Co-Invest',
          icon: Icons.attach_money,
          onTap: () => _handleAction('co_invest'),
        ),
        ActionButton(
          label: 'Shop Décor',
          icon: Icons.shopping_bag,
          onTap: () => _handleAction('shop_decor'),
        ),
      ],
      lifestyleTags: ['🌊 Beachfront', '🏔 Hilltop', '👑 Celebrity Host'],
      influencerQuote: 'Stayed here for a music video shoot',
      influencerHandle: '@InfluencerHandle',
      amenities: [
        AmenityIcon(icon: Icons.pool, label: 'Pool'),
        AmenityIcon(icon: Icons.smart_toy, label: 'Smart Tech'),
        AmenityIcon(icon: Icons.restaurant, label: 'Chef on Call'),
      ],
      experiences: [
        ExperienceOption(
          icon: Icons.hiking,
          title: 'Sunset Trek Adventure',
          category: 'Trek Guide',
          description: 'Guided trek through scenic mountain trails',
          price: 1499.0,
        ),
        ExperienceOption(
          icon: Icons.nightlife,
          title: 'Exclusive Club Access',
          category: 'Nightlife',
          description: 'VIP entry to premium clubs nearby',
          price: 2999.0,
        ),
        ExperienceOption(
          icon: Icons.restaurant,
          title: 'Gourmet Food Tour',
          category: 'Restaurants',
          description: 'Curated dining experience at top restaurants',
          price: 3499.0,
        ),
        ExperienceOption(
          icon: Icons.event,
          title: 'Local Events Pass',
          category: 'Events',
          description: 'Access to exclusive local events',
          price: 1999.0,
        ),
      ],
      shopItems: [
        ShopItem(
          image: 'https://images.unsplash.com/photo-1592078615290-033ee584e267',
          name: 'Modern Accent Chair',
          price: '\$899',
          category: 'Furniture',
        ),
        ShopItem(
          image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
          name: 'Crystal Chandelier',
          price: '\$2,499',
          category: 'Lighting',
        ),
        ShopItem(
          image: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace',
          name: 'Decorative Vase',
          price: '\$299',
          category: 'Décor',
        ),
      ],
      services: [
        ServiceOption(
          icon: Icons.restaurant,
          label: 'Hire a Chef',
          description: 'Personal chef service at your villa',
          price: 299.99,
        ),
        ServiceOption(
          icon: Icons.directions_car,
          label: 'Book Chauffeur',
          description: 'Luxury car with professional driver',
          price: 199.99,
        ),
        ServiceOption(
          icon: Icons.spa,
          label: 'Spa At Home',
          description: 'Professional spa treatments',
          price: 149.99,
        ),
        ServiceOption(
          icon: Icons.camera_alt,
          label: 'Content Crew',
          description: 'Professional photo/video shoot',
          price: 399.99,
        ),
      ],
      influencers: [
        InfluencerContent(
          name: 'Sarah Style',
          avatar:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          reelPreview:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          reelUrl: 'https://example.com/reel1',
        ),
        InfluencerContent(
          name: 'Travel Mike',
          avatar:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
          reelPreview:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          reelUrl: 'https://example.com/reel2',
        ),
        InfluencerContent(
          name: 'Lisa Luxury',
          avatar:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
          reelPreview:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          reelUrl: 'https://example.com/reel3',
        ),
      ],
      reviews: [
        ReviewContent(
          reviewerName: 'Alex M.',
          reviewerAvatar:
              'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
          videoUrl: 'https://example.com/review1.mp4',
          videoThumbnail:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          emojiRating: '😍',
          shortComment: 'Perfect weekend getaway!',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ReviewContent(
          reviewerName: 'Sophie R.',
          reviewerAvatar:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          videoUrl: 'https://example.com/review2.mp4',
          videoThumbnail:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          emojiRating: '🌟',
          shortComment: 'Amazing views & service',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ReviewContent(
          reviewerName: 'James K.',
          reviewerAvatar:
              'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
          videoUrl: 'https://example.com/review3.mp4',
          videoThumbnail:
              'https://images.unsplash.com/photo-1615529328331-f8917597711f',
          emojiRating: '👌',
          shortComment: 'Worth every penny!',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
      investmentOptions: [
        InvestmentOption(
          type: 'stay',
          price: 999.99,
          duration: 'per night',
          additionalInfo: {
            'weekly_rate': 5999.99,
            'minimum_stay': '2 nights',
            'peak_season_rate': 1299.99,
          },
        ),
        InvestmentOption(
          type: 'own',
          price: 2500000.00,
          duration: 'outright',
          additionalInfo: {
            'emi_rate': 8.5,
            'tenure_years': 20,
            'monthly_emi': 21632.98,
            'down_payment': 500000.00,
          },
        ),
        InvestmentOption(
          type: 'co_invest',
          price: 250000.00,
          duration: 'minimum',
          additionalInfo: {
            'projected_roi': 12.5,
            'lock_in_period': '3 years',
            'expected_yield': '8-10% annually',
            'total_shares': 10,
          },
        ),
      ],
      coInvestorsCount: 125,
      totalInvestment: 12000000.00,
    );
  }

  // Add this method for the animated icon
  Widget _buildAnimatedAmenityIcon(AmenityIcon amenity) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  amenity.icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amenity.label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }

  // Update the content section in the build method
  void _handleAction(String action) {
    // Handle property-specific actions
    print('Handling action: $action');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Section with Carousel
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.7,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                  items:
                      _propertyContent.images.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Add dark overlay
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.black.withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }).toList(),
                ),
                Positioned(
                  bottom: 48,
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHeroActionButton(
                        'Book Stay',
                        Icons.hotel,
                        () => _handleAction('book_stay'),
                      ),
                      _buildHeroActionButton(
                        'Co-Invest',
                        Icons.attach_money,
                        () => _handleAction('co_invest'),
                      ),
                      _buildHeroActionButton(
                        'Buy',
                        Icons.shopping_bag,
                        () => _handleAction('buy'),
                      ),
                    ],
                  ),
                ),
                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Carousel Indicator
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        _propertyContent.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(
                                _currentImageIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            // 2. Influencer Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  // Lifestyle Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _propertyContent.lifestyleTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Influencer Quote
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.format_quote,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _propertyContent.influencerQuote,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _propertyContent.influencerHandle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Amenity Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        _propertyContent.amenities
                            .map(
                              (amenity) => _buildAnimatedAmenityIcon(amenity),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            // 3. Shop the Look Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop the Look',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seen in this Villa',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _propertyContent.shopItems.length,
                      itemBuilder: (context, index) {
                        final item = _propertyContent.shopItems[index];
                        return Container(
                          width: 200,
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 16,
                            right:
                                index == _propertyContent.shopItems.length - 1
                                    ? 0
                                    : 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.image,
                                  height: 180,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.category,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle navigation to INFLU Store
                        print('Navigate to INFLU Store');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Shop Now on INFLU Store',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ... existing code ...

            // 4. Services Add-On Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services Add-On',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Luxury Concierge Options',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _propertyContent.services.length,
                    itemBuilder: (context, index) {
                      final service = _propertyContent.services[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              service.icon,
                              size: 32,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              service.label,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${service.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle service booking
                        print('Book services');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add to Stay or Hire Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 5. Influencer & Creator Layer Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Who\'s Been Here?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _propertyContent.influencers.length,
                      itemBuilder: (context, index) {
                        final influencer = _propertyContent.influencers[index];
                        return Container(
                          width: 180,
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 16,
                            right:
                                index == _propertyContent.influencers.length - 1
                                    ? 0
                                    : 0,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      influencer.reelPreview,
                                      height: 180,
                                      width: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Handle reel playback
                                          print(
                                            'Play reel: ${influencer.reelUrl}',
                                          );
                                        },
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      influencer.avatar,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      influencer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle booking
                        print('Book property');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Stay Like Them',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Inside build method, after Who's Been Here section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Reviews',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _propertyContent.reviews.length,
                      itemBuilder: (context, index) {
                        final review = _propertyContent.reviews[index];
                        return Container(
                          width: 220,
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 16,
                            right:
                                index == _propertyContent.reviews.length - 1
                                    ? 0
                                    : 0,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      review.videoThumbnail,
                                      height: 160,
                                      width: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Handle video playback
                                          print(
                                            'Play review video: ${review.videoUrl}',
                                          );
                                        },
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      review.reviewerAvatar,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.reviewerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '${review.emojiRating} ${review.shortComment}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Inside build method, after Community Reviews section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.grey[50],
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Investment & Ownership',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              padding: EdgeInsets.zero,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey[600],
                              tabs: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    'Stay',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    'Own',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    'Co-Invest',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 250,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildStayTab(
                                  _propertyContent.investmentOptions[0],
                                ),
                                _buildOwnTab(
                                  _propertyContent.investmentOptions[1],
                                ),
                                _buildCoInvestTab(
                                  _propertyContent.investmentOptions[2],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Live Ticker
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child:
                                  _tabController.index == 2
                                      ? RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: AppTheme.primaryColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${_propertyContent.coInvestorsCount} users ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: 'co-invested ',
                                            ),
                                            TextSpan(
                                              text:
                                                  '₹${(_propertyContent.totalInvestment / 10000000).toStringAsFixed(1)}Cr ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: 'already.'),
                                          ],
                                        ),
                                      )
                                      : _tabController.index == 1
                                      ? const Text(
                                        'Own your dream property with flexible EMI options and expert guidance.',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                        ),
                                      )
                                      : const Text(
                                        'Book your luxury stay with exclusive member benefits and personalized service.',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle action based on current tab
                            switch (_tabController.index) {
                              case 0:
                                print('Book stay');
                                break;
                              case 1:
                                print('Schedule visit');
                                break;
                              case 2:
                                print('Start investing');
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _tabController.index == 2
                                ? 'Start Investing Now'
                                : _tabController.index == 1
                                ? 'Schedule Property Visit'
                                : 'Book Your Stay',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // After Investment & Ownership section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Things to Do Around Here',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: _propertyContent.experiences.length,
                    itemBuilder: (context, index) {
                      final experience = _propertyContent.experiences[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              experience.icon,
                              size: 32,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              experience.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              experience.category,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${experience.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to services module
                        print('Navigate to experiences booking');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Book Experience',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayTab(InvestmentOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₹${option.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(option.duration, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 24),
        _buildInfoRow(
          'Weekly Rate',
          '₹${option.additionalInfo['weekly_rate']}',
        ),
        _buildInfoRow('Minimum Stay', option.additionalInfo['minimum_stay']),
        _buildInfoRow(
          'Peak Season',
          '₹${option.additionalInfo['peak_season_rate']}/night',
        ),
      ],
    );
  }

  Widget _buildOwnTab(InvestmentOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₹${(option.price / 100000).toStringAsFixed(1)}Cr',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(option.duration, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 24),
        _buildInfoRow(
          'Down Payment',
          '₹${(option.additionalInfo['down_payment'] / 100000).toStringAsFixed(1)}L',
        ),
        _buildInfoRow('EMI Rate', '${option.additionalInfo['emi_rate']}%'),
        _buildInfoRow(
          'Tenure',
          '${option.additionalInfo['tenure_years']} years',
        ),
        _buildInfoRow(
          'Monthly EMI',
          '₹${option.additionalInfo['monthly_emi']}',
        ),
      ],
    );
  }

  Widget _buildCoInvestTab(InvestmentOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₹${(option.price / 100000).toStringAsFixed(1)}L',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text('minimum investment', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 24),
        _buildInfoRow(
          'Projected ROI',
          '${option.additionalInfo['projected_roi']}%',
        ),
        _buildInfoRow(
          'Lock-in Period',
          option.additionalInfo['lock_in_period'],
        ),
        _buildInfoRow(
          'Expected Yield',
          option.additionalInfo['expected_yield'],
        ),
        _buildInfoRow(
          'Total Shares',
          '${option.additionalInfo['total_shares']}',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildHeroActionButton(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ActionButton action) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(action.icon),
            onPressed: action.onTap,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(action.label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ServiceOption {
  final IconData icon;
  final String label;
  final String description;
  final double price;

  ServiceOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.price,
  });
}

class InfluencerContent {
  final String name;
  final String avatar;
  final String reelPreview;
  final String reelUrl;

  InfluencerContent({
    required this.name,
    required this.avatar,
    required this.reelPreview,
    required this.reelUrl,
  });
}

class ReviewContent {
  final String reviewerName;
  final String reviewerAvatar;
  final String videoUrl;
  final String videoThumbnail;
  final String emojiRating; // e.g. "😍", "🌟", "👌"
  final String shortComment;
  final DateTime date;

  ReviewContent({
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.videoUrl,
    required this.videoThumbnail,
    required this.emojiRating,
    required this.shortComment,
    required this.date,
  });
}

class InvestmentOption {
  final String type; // 'stay', 'own', or 'co_invest'
  final double price;
  final String duration; // 'per night', 'outright', or 'minimum'
  final Map<String, dynamic> additionalInfo; // EMI details or ROI projections

  InvestmentOption({
    required this.type,
    required this.price,
    required this.duration,
    required this.additionalInfo,
  });
}

class ExperienceOption {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final double price;

  ExperienceOption({
    required this.icon,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
  });
}
