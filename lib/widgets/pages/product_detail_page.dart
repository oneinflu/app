import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/profile_management_screen.dart';
import '../../app_theme.dart';
import 'package:video_player/video_player.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
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

    // Initialize video player with a sample video URL
    // Replace this URL with your actual video URL
    _videoPlayerController = VideoPlayerController.network(
        'https://res.cloudinary.com/dxe7ouw1m/video/upload/v1755889570/boat_thzsq6.mp4',
      )
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          // Set video to loop
          _videoPlayerController.setLooping(true);
          // Start playing with muted audio
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

  void _showOrderBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Order Items',
                  style: AppTheme.headlineStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Product details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://example.com/placeholder.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Boat Headphones',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Electronics',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '₹1,999',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.dividerColor),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () {},
                            ),
                            const Text('1'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Order button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: FadeTransition(opacity: _fadeAnimation, child: _buildBody()),
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
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
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

  Widget _buildBody() {
    return Column(
      children: [
        _buildCategoryPills(),
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              // You would typically load different videos based on the index
              // For now, we're just showing the same video card
              return _buildVideoCard();
            },
            // Set this to a large number for "infinite" scrolling
            itemCount: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPills() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildPill('All', true),
          _buildPill('Restaurants', false),
          _buildPill('Furniture', false),
          _buildPill('Places to Visit', false),
        ],
      ),
    );
  }

  Widget _buildPill(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? AppTheme.primaryColor : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildVideoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Video player
            _isVideoInitialized
                ? GestureDetector(
                  onTap: _toggleMute,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoPlayerController.value.size.width,
                        height: _videoPlayerController.value.size.height,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),

            // Mute/Unmute indicator
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // Background gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section with brand name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Boat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Electronics',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'India',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Bottom action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        Icons.replay,
                        Colors.amber,
                        _restartVideo,
                      ),
                      _buildActionButton(Icons.close, Colors.red, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This video showed to next time'),
                          ),
                        );
                      }),
                      _buildActionButton(
                        Icons.shopping_cart,
                        AppTheme.primaryPurple,
                        _showOrderBottomSheet,
                      ),
                      _buildActionButton(Icons.favorite, Colors.green, () {
                        // Add favorite functionality
                        setState(() {
                          // Toggle favorite status
                          // You can add a boolean variable to track this
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to favorites')),
                          );
                        });
                      }),
                      _buildActionButton(
                        Icons.bookmark_border,
                        Colors.amber,
                        () {
                          // Add bookmark functionality
                          setState(() {
                            // Toggle bookmark status
                            // You can add a boolean variable to track this
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saved to bookmarks'),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.explore, 'For You', 1),
          _buildCenterNavItem(),
          _buildNavItem(Icons.shopping_bag, 'Orders', 2),
          _buildNavItem(Icons.account_balance_wallet, 'Wallet', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset('assets/images/favicon.png', fit: BoxFit.contain),
      ),
    );
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
