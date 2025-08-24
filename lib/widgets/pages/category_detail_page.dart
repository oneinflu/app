import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:influnew/widgets/pages/discovery_filters_widget.dart';

class CategoryContent {
  final String tagline;
  final List<String> images;
  final List<ActionButton> actions;

  CategoryContent({
    required this.tagline,
    required this.images,
    required this.actions,
  });
}

class ActionButton {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  ActionButton({required this.label, required this.icon, required this.onTap});
}

class CategoryDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;

  const CategoryDetailPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
  }) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  int _currentImageIndex = 0;
  late CategoryContent _categoryContent;

  @override
  void initState() {
    super.initState();
    _categoryContent = _getCategoryContent();
  }

  CategoryContent _getCategoryContent() {
    final category = '${widget.title} ${widget.subtitle}'.toLowerCase();

    switch (category) {
      case 'luxury stays':
        return CategoryContent(
          tagline: 'Experience Premium Villas and Celebrity-Style Homes',
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
              label: 'Explore Property',
              icon: Icons.villa,
              onTap: () => _handleAction('explore_property'),
            ),
            ActionButton(
              label: 'Co-Invest',
              icon: Icons.attach_money,
              onTap: () => _handleAction('co_invest'),
            ),
          ],
        );

      case 'smart living':
        return CategoryContent(
          tagline: 'Experience Next-Gen Smart Homes and Tech-Enabled Living',
          images: [
            'https://images.unsplash.com/photo-1558211583-d26f610c1eb1',
            'https://images.unsplash.com/photo-1593784991095-a205069470b6',
            'https://images.unsplash.com/photo-1556761175-b413da4baf72',
          ],
          actions: [
            ActionButton(
              label: 'Own Smart Home',
              icon: Icons.home_work,
              onTap: () => _handleAction('own_smart_home'),
            ),
            ActionButton(
              label: 'Book Smart Stay',
              icon: Icons.home,
              onTap: () => _handleAction('book_smart_stay'),
            ),
            ActionButton(
              label: 'Invest in Smart',
              icon: Icons.trending_up,
              onTap: () => _handleAction('invest_smart_projects'),
            ),
          ],
        );

      case 'work & create':
        return CategoryContent(
          tagline:
              'Professional Spaces Designed for Innovation and Productivity',
          images: [
            'https://images.unsplash.com/photo-1497366216548-37526070297c',
            'https://images.unsplash.com/photo-1497366811353-6870744d04b2',
            'https://images.unsplash.com/photo-1497215842964-222b430dc094',
          ],
          actions: [
            ActionButton(
              label: 'Book Workspace',
              icon: Icons.business_center,
              onTap: () => _handleAction('book_workspace'),
            ),
            ActionButton(
              label: 'Host & Earn',
              icon: Icons.store,
              onTap: () => _handleAction('host_earn'),
            ),
            ActionButton(
              label: 'Collaborate Now',
              icon: Icons.handshake,
              onTap: () => _handleAction('collaborate_now'),
            ),
          ],
        );

      case 'weekend escapes':
        return CategoryContent(
          tagline: 'Your Perfect Weekend Getaway Destinations',
          images: [
            'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2',
            'https://images.unsplash.com/photo-1470010762743-1fa2363f65ca',
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
          ],
          actions: [
            ActionButton(
              label: 'Book Escape',
              icon: Icons.weekend,
              onTap: () => _handleAction('book_escape'),
            ),
            ActionButton(
              label: 'Group Split-Pay',
              icon: Icons.group_add,
              onTap: () => _handleAction('group_split_pay'),
            ),
            ActionButton(
              label: 'Rent-to-Own',
              icon: Icons.real_estate_agent,
              onTap: () => _handleAction('rent_to_own_getaway'),
            ),
          ],
        );

      case 'urban lifestyle':
        return CategoryContent(
          tagline: 'Live the Trendy Urban Life in Prime Locations',
          images: [
            'https://images.unsplash.com/photo-1493246507139-91e8fad9978e',
            'https://images.unsplash.com/photo-1494203484021-3c454daf695d',
            'https://images.unsplash.com/photo-1460317442991-0ec209397118',
          ],
          actions: [
            ActionButton(
              label: 'Live Here Now',
              icon: Icons.apartment,
              onTap: () => _handleAction('live_here_now'),
            ),
            ActionButton(
              label: 'Buy in Hotspot',
              icon: Icons.location_city,
              onTap: () => _handleAction('buy_in_hotspot'),
            ),
            ActionButton(
              label: 'Join Urban Club',
              icon: Icons.people,
              onTap: () => _handleAction('join_urban_club'),
            ),
          ],
        );

      case 'collab spaces':
        return CategoryContent(
          tagline: 'Create, Collaborate, and Connect in Inspiring Spaces',
          images: [
            'https://images.unsplash.com/photo-1497366412874-3415097a27e7',
            'https://images.unsplash.com/photo-1497366754035-f200968a6e72',
            'https://images.unsplash.com/photo-1497215728101-856f4ea42174',
          ],
          actions: [
            ActionButton(
              label: 'Book for Shoot',
              icon: Icons.videocam,
              onTap: () => _handleAction('book_for_shoot'),
            ),
            ActionButton(
              label: 'Host with INFLU',
              icon: Icons.store_mall_directory,
              onTap: () => _handleAction('host_with_influ'),
            ),
            ActionButton(
              label: 'Find Partners',
              icon: Icons.people_outline,
              onTap: () => _handleAction('find_collab_partners'),
            ),
          ],
        );

      case 'budget goals':
        return CategoryContent(
          tagline: 'Affordable Luxury Living Within Your Reach',
          images: [
            'https://images.unsplash.com/photo-1484154218962-a197022b5858',
            'https://images.unsplash.com/photo-1560520653-9e0e4c89eb11',
            'https://images.unsplash.com/photo-1554995207-c18c203602cb',
          ],
          actions: [
            ActionButton(
              label: 'Book Affordable',
              icon: Icons.home,
              onTap: () => _handleAction('book_affordable_stay'),
            ),
            ActionButton(
              label: 'Rent-to-Own',
              icon: Icons.real_estate_agent,
              onTap: () => _handleAction('rent_to_own_plan'),
            ),
            ActionButton(
              label: 'Invest Small',
              icon: Icons.savings,
              onTap: () => _handleAction('invest_small_earn_big'),
            ),
          ],
        );

      case 'green living':
        return CategoryContent(
          tagline: 'Sustainable Living in Harmony with Nature',
          images: [
            'https://images.unsplash.com/photo-1518780664697-55e3ad937233',
            'https://images.unsplash.com/photo-1518780664697-55e3ad937233',
            'https://images.unsplash.com/photo-1518780664697-55e3ad937233',
          ],
          actions: [
            ActionButton(
              label: 'Book Eco Stay',
              icon: Icons.eco,
              onTap: () => _handleAction('book_eco_stay'),
            ),
            ActionButton(
              label: 'Own Eco Home',
              icon: Icons.home,
              onTap: () => _handleAction('own_sustainable_home'),
            ),
            ActionButton(
              label: 'Invest Green',
              icon: Icons.nature,
              onTap: () => _handleAction('invest_green_projects'),
            ),
          ],
        );

      case 'community living':
        return CategoryContent(
          tagline: 'Join a Vibrant Community of Like-minded Individuals',
          images: [
            'https://images.unsplash.com/photo-1543269865-cbf427effbad',
            'https://images.unsplash.com/photo-1543269865-cbf427effbad',
            'https://images.unsplash.com/photo-1543269865-cbf427effbad',
          ],
          actions: [
            ActionButton(
              label: 'Join Community',
              icon: Icons.groups,
              onTap: () => _handleAction('join_community_stay'),
            ),
            ActionButton(
              label: 'Own in Community',
              icon: Icons.home,
              onTap: () => _handleAction('own_in_community'),
            ),
            ActionButton(
              label: 'Earn via Referrals',
              icon: Icons.share,
              onTap: () => _handleAction('community_referrals'),
            ),
          ],
        );

      case 'investment picks':
        return CategoryContent(
          tagline: 'High-Return Investment Opportunities in Prime Locations',
          images: [
            'https://images.unsplash.com/photo-1551135049-8a33b5883817',
            'https://images.unsplash.com/photo-1551135049-8a33b5883817',
            'https://images.unsplash.com/photo-1551135049-8a33b5883817',
          ],
          actions: [
            ActionButton(
              label: 'Invest Now',
              icon: Icons.trending_up,
              onTap: () => _handleAction('invest_now'),
            ),
            ActionButton(
              label: 'Co-Invest',
              icon: Icons.group,
              onTap: () => _handleAction('co_invest_influencers'),
            ),
            ActionButton(
              label: 'Track ROI',
              icon: Icons.analytics,
              onTap: () => _handleAction('track_roi_growth'),
            ),
          ],
        );

      default:
        return CategoryContent(
          tagline: widget.description,
          images: [
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
          ],
          actions: [
            ActionButton(
              label: 'Explore',
              icon: Icons.search,
              onTap: () => _handleAction('explore'),
            ),
            ActionButton(
              label: 'Contact',
              icon: Icons.contact_support,
              onTap: () => _handleAction('contact'),
            ),
            ActionButton(
              label: 'Details',
              icon: Icons.info_outline,
              onTap: () => _handleAction('details'),
            ),
          ],
        );
    }
  }

  void _handleAction(String action) {
    // Implement action handling based on the action type
    print('Handling action: $action');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero Section with fixed height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                // Image Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.5,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                  ),
                  items:
                      _categoryContent.images.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),

                // Gradient Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 32,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Replace line 463 with:
                        '${widget.title} ${widget.subtitle}'.trim(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _categoryContent.tagline,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            _categoryContent.actions
                                .map(
                                  (action) => _buildActionButton(
                                    action.label,
                                    action.icon,
                                    action.onTap,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
                // Carousel Indicator
                Positioned(
                  bottom: 180,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        _categoryContent.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Discovery Filters Screen
          Expanded(child: LuxuryStaysScreen()),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
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
}
