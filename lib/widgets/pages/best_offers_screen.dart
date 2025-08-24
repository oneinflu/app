import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app_theme.dart';

class BestOffersScreen extends StatefulWidget {
  const BestOffersScreen({Key? key}) : super(key: key);

  @override
  State<BestOffersScreen> createState() => _BestOffersScreenState();
}

class _BestOffersScreenState extends State<BestOffersScreen> {
  bool isProductOffers = true;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final Map<MarkerId, Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadMoreOffers();
    _scrollController.addListener(_onScroll);
    _initializeMarkers();
  }

  void _initializeMarkers() {
    // Example markers for offers
    for (var i = 0; i < _offers.length; i++) {
      final markerId = MarkerId('offer_$i');
      final marker = Marker(
        markerId: markerId,
        position: LatLng(
          37.42796133580664 + (i * 0.01),
          -122.085749655962,
        ), // Example coordinates
        infoWindow: InfoWindow(title: _offers[i]['title']),
        onTap: () => _showOfferDetails(_offers[i]),
      );
      _markers[markerId] = marker;
    }
  }

  void _showMapView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Offers Near You',
                              style: AppTheme.headlineStyle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(
                              37.42796133580664,
                              -122.085749655962,
                            ),
                            zoom: 12,
                          ),
                          markers: Set<Marker>.of(_markers.values),
                          onMapCreated:
                              (controller) => _mapController = controller,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showOfferDetails(Map<String, dynamic> offer) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    offer['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  offer['title'],
                  style: AppTheme.headlineStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(offer['subtitle'], style: AppTheme.secondaryTextStyle),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${offer['price']}',
                      style: AppTheme.headlineStyle.copyWith(
                        color: AppTheme.accentCoral,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle offer action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(offer['actionText']),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreOffers();
    }
  }

  Future<void> _loadMoreOffers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 1));

    final newOffers = [
      {
        'image': 'assets/images/products/offer1.png',
        'title': 'AWESOME PRODUCTS',
        'subtitle': 'Before our finance chief ends this deal',
        'price': '5',
        'actionText': 'Start Building Your Cart',
      },
      {
        'image': 'assets/images/products/offer2.png',
        'title': 'AWESOME PRODUCTS',
        'subtitle': 'Before our finance chief ends this deal',
        'price': '5',
        'actionText': 'Start Building Your Cart',
      },
      {
        'image': 'assets/images/products/offer3.png',
        'title': 'AWESOME PRODUCTS',
        'subtitle': 'Before our finance chief ends this deal',
        'price': '5',
        'actionText': 'Start Building Your Cart',
      },
      {
        'image': 'assets/images/products/offer4.png',
        'title': 'AWESOME PRODUCTS',
        'subtitle': 'Before our finance chief ends this deal',
        'price': '5',
        'actionText': 'Start Building Your Cart',
      },
      {
        'image': 'assets/images/products/offer5.png',
        'title': 'AWESOME PRODUCTS',
        'subtitle': 'Before our finance chief ends this deal',
        'price': '5',
        'actionText': 'Start Building Your Cart',
      },
      // Add more offers as needed
    ];

    setState(() {
      _offers.addAll(newOffers);
      _isLoading = false;
      _hasMore = _offers.length < 20; // Example limit
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                _showNotificationModal(context);
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
      ),
      body: Column(
        children: [
          _buildToggleBar(),
          _buildCategories(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _offers.length + 1,
              itemBuilder: (context, index) {
                if (index == _offers.length) {
                  return _hasMore
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : const SizedBox.shrink();
                }

                final offer = _offers[index];
                return _buildOfferCard(
                  offer['image'],
                  offer['title'],
                  offer['subtitle'],
                  offer['price'],
                  offer['actionText'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMapView,
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.map_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildToggleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the toggle buttons
        children: [
          _buildToggleButton('Product Offers', isProductOffers),
          const SizedBox(width: 10),
          _buildToggleButton('Service Offers', !isProductOffers),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 110, // Increased height to prevent overflow
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCategoryItem('Fashion', Icons.checkroom, true),
          _buildCategoryItem('Electronics', Icons.devices),
          _buildCategoryItem('Cosmetics', Icons.face),
          _buildCategoryItem('Stationary', Icons.edit),
          _buildCategoryItem('Decor', Icons.home),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isProductOffers = text == 'Product Offers';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String name,
    IconData icon, [
    bool isSelected = false,
  ]) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppTheme.secondaryColor.withOpacity(0.1)
                      : Colors.white,
              border: Border.all(
                color:
                    isSelected
                        ? AppTheme.secondaryColor
                        : AppTheme.dividerColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  isSelected ? AppTheme.secondaryColor : AppTheme.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color:
                  isSelected ? AppTheme.secondaryColor : AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
    String image,
    String title,
    String subtitle,
    String? price,
    String actionText,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }

  void _showNotificationModal(BuildContext context) {
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
