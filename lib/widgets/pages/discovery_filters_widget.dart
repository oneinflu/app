import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/property_detail_page.dart';
import 'package:video_player/video_player.dart';

class LuxuryStaysScreen extends StatefulWidget {
  const LuxuryStaysScreen({super.key});

  @override
  State<LuxuryStaysScreen> createState() => _LuxuryStaysScreenState();
}

class _LuxuryStaysScreenState extends State<LuxuryStaysScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<String> _filters = [
    '🌊 Beachfront',
    '⏱️ Short Stay',
    '🌟 Celebrity Homes',
    '🏊‍♂️ Poolside',
    '⛰️ Hilltop',
    '🐾 Pet Friendly',
    '🌴 Tropical',
    '🏔️ Mountain View',
    '🌅 Sunset View',
    '🎨 Designer Homes',
  ];
  final Set<String> _selectedFilters = {};

  final List<Map<String, dynamic>> _reels = [
    {
      'videoUrl':
          'https://assets.mixkit.co/videos/preview/mixkit-luxury-house-with-a-pool-seen-from-above-42770-large.mp4',
      'influencer': 'Sarah Luxury Living',
      'title': 'Beachfront Villa Maldives',
      'tags': ['Beachfront', 'Luxury'],
      'thumbnail':
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
    },
    {
      'videoUrl':
          'https://assets.mixkit.co/videos/preview/mixkit-interior-of-a-luxury-house-42771-large.mp4',
      'influencer': 'Mike Modern Homes',
      'title': 'Hilltop Mansion Beverly Hills',
      'tags': ['Hilltop', 'Celebrity'],
      'thumbnail':
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
    },
    {
      'videoUrl':
          'https://assets.mixkit.co/videos/preview/mixkit-modern-living-room-interior-3505-large.mp4',
      'influencer': 'Luxury Lifestyle',
      'title': 'Modern Penthouse NYC',
      'tags': ['Luxury', 'City View'],
      'thumbnail':
          'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
    },
    {
      'videoUrl':
          'https://assets.mixkit.co/videos/preview/mixkit-luxury-house-interior-2288-large.mp4',
      'influencer': 'Elite Properties',
      'title': 'Ocean View Villa Miami',
      'tags': ['Beachfront', 'Luxury'],
      'thumbnail':
          'https://images.unsplash.com/photo-1523217582562-09d0def993a6',
    },
    {
      'videoUrl':
          'https://assets.mixkit.co/videos/preview/mixkit-living-room-with-a-modern-tv-setup-4268-large.mp4',
      'influencer': 'Design Masters',
      'title': 'Smart Home LA',
      'tags': ['Smart Home', 'Modern'],
      'thumbnail':
          'https://images.unsplash.com/photo-1484154218962-a197022b5858',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Add more items by duplicating existing ones with modified titles
      _reels.addAll(
        _reels
            .take(5)
            .map(
              (reel) => {
                ...reel,
                'title': '${reel['title']} ${(_reels.length ~/ 5 + 1)}',
              },
            ),
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Filter Section
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilters.contains(filter);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFilters.add(filter);
                        } else {
                          _selectedFilters.remove(filter);
                        }
                      });
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: Colors.amber[300],
                    checkmarkColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.amber : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    elevation: 2,
                    pressElevation: 4,
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),

          // Reels Section
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _reels.length + 1, // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index == _reels.length) {
                  return _isLoading
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : const SizedBox.shrink();
                }
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.only(right: 16),
                  child: ReelCard(data: _reels[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReelCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const ReelCard({super.key, required this.data});

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.data['videoUrl']);
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video or Thumbnail
            if (_isInitialized)
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: VideoPlayer(_controller),
              )
            else
              Image.network(
                widget.data['thumbnail'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                },
              ),

            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.data['influencer'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.data['title'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DefaultTabController(
                              length: 3,
                              child: PropertyDetailPage(
                                title: widget.data['title'],
                                subtitle: widget.data['influencer'],
                                description: 'Experience luxury living at its finest',
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Explore Property',
                        style: TextStyle(fontSize: 16),
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
}

// Remove the _ActionButton class as it's no longer needed
