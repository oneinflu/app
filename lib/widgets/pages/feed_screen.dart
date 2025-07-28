import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:reels_viewer/reels_viewer.dart';
import '../../app_theme.dart';
import '../../models/custom_reel_model.dart';
import '../pages/profile_management_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<CustomReelModel> _reelsList;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeReels();
  }

  void _initializeReels() {
    // Convert your existing reels data to CustomReelModel format
    _reelsList = [
      CustomReelModel(
        'https://barcodeent.com/wp-content/uploads/2024/08/jockey-woman.mp4',
        'Jockey Fashion',
        likeCount: 13500,
        isLiked: false,
        musicName: 'Jockey Women Collection',
        reelDescription: 'Get ready to light up the dance',
        profileUrl: 'assets/images/favicon.png',
        productName: 'Jockey Women Collection 2024',
        productPrice: '₹1,999',
        location: 'Sri Prasad, Haripriya, Kav',
      ),
      CustomReelModel(
        'https://barcodeent.com/wp-content/uploads/2024/01/yt-shorts.mp4',
        'YouTube Creator',
        likeCount: 850,
        isLiked: false,
        musicName: 'YouTube Shorts Promotion',
        reelDescription: 'Create amazing shorts with YouTube',
        profileUrl: 'assets/images/favicon.png',
        productName: 'YouTube Premium Subscription',
        productPrice: '₹129/month',
        location: 'Mumbai, India',
      ),
      CustomReelModel(
        'https://barcodeent.com/wp-content/uploads/2024/01/triller.mp4',
        'Triller Official',
        likeCount: 2300,
        isLiked: false,
        musicName: 'Triller App Showcase',
        reelDescription: 'Create amazing videos with Triller',
        profileUrl: 'assets/images/favicon.png',
        productName: 'Triller Pro Subscription',
        productPrice: '₹399/month',
        location: 'Los Angeles, CA',
      ),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  void _handleOrderNow() {
    final currentReel = _reelsList[_currentIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ordering ${currentReel.productName}'),
        backgroundColor: AppTheme.primaryPurple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Influ Feed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Order Now Button in AppBar
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _handleOrderNow,
              icon: const Icon(Icons.shopping_cart, size: 16),
              label: const Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryPurple),
              )
              : ReelsViewer(
                reelsList: _reelsList,
                appbarTitle: 'Reels',
                onShare: (url) {
                  log('Shared reel url ==> $url');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Share options opened'),
                      backgroundColor: AppTheme.primaryPurple,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onLike: (url) {
                  log('Liked reel url ==> $url');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Liked!'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onFollow: () {
                  log('Clicked on follow');
                },
                onComment: (comment) {
                  log('Comment on reel ==> $comment');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Comments opened'),
                      backgroundColor: AppTheme.primaryPurple,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onClickMoreBtn: () {
                  log('Clicked on more option');
                },
                onClickBackArrow: () {
                  Navigator.of(context).pop();
                },
                onIndexChanged: (index) {
                  log('Current Index ======> $index');
                  setState(() {
                    _currentIndex = index;
                  });
                },
                showProgressIndicator: true,
                showVerifiedTick: false,
                showAppbar: false,
              ),
    );
  }
}
