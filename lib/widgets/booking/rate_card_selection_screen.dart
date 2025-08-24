import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'platform_item.dart';
import 'rate_card_item.dart';
import 'availability_screen.dart';

class RateCardSelectionScreen extends StatefulWidget {
  final String influencerName;
  final Function(List<RateCardItem>, List<PlatformItem>, double) onNext;

  const RateCardSelectionScreen({
    Key? key,
    required this.influencerName,
    required this.onNext,
  }) : super(key: key);

  @override
  State<RateCardSelectionScreen> createState() =>
      _RateCardSelectionScreenState();
}

class _RateCardSelectionScreenState extends State<RateCardSelectionScreen> {
  // Platform-based services
  final Map<String, List<RateCardItem>> _platformServices = {
    'Instagram': [
      RateCardItem(
        title: 'Story Post',
        price: 5000,
        description: '24h duration',
        rating: 4.76,
        ratingCount: '978k',
        isBestSeller: true,
      ),
      RateCardItem(
        title: 'Feed Post',
        price: 8000,
        description: 'Permanent post',
        rating: 4.82,
        ratingCount: '756k',
      ),
    ],
    'YouTube': [
      RateCardItem(
        title: 'Video Integration',
        price: 15000,
        description: '60s mention',
        rating: 4.85,
        ratingCount: '450k',
        isBestSeller: true,
      ),
      RateCardItem(
        title: 'Dedicated Review',
        price: 25000,
        description: 'Full video',
        rating: 4.90,
        ratingCount: '320k',
      ),
    ],
  };

  // Add this line to declare the _expandedCategories map
  final Map<String, bool> _expandedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _buildNextButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._platformServices.entries.map((entry) =>
              _buildServiceCategory(entry.key, entry.value)
            ),
            _buildCustomPlanButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final selectedServices = _platformServices.values
        .expand((services) => services)
        .where((service) => service.isSelected)
        .toList();

    final hasSelectedServices = selectedServices.isNotEmpty;
    final totalPrice = selectedServices.fold(0.0, (sum, service) => sum + service.price);

    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(16),
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
      child: ElevatedButton(
        onPressed: hasSelectedServices
            ? () => widget.onNext(selectedServices, [], totalPrice)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: Text(
          hasSelectedServices
              ? 'Next - ₹${totalPrice.toStringAsFixed(0)}'
              : 'Select at least one service',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildServiceCategory(String category, List<RateCardItem> services) {
    return Column(
      children: [
        ListTile(
          title: Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            _expandedCategories[category] ?? true ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              _expandedCategories[category] = !(_expandedCategories[category] ?? true);
            });
          },
        ),
        if (_expandedCategories[category] ?? true)
          ...services.map((service) => _buildServiceCard(service)),
      ],
    );
  }

  Widget _buildServiceCard(RateCardItem service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://source.unsplash.com/60x60/?${service.title.toLowerCase().replaceAll(' ', '-')}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              // Add error handling and loading placeholder
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.isBestSeller)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Best Seller',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    Text(
                      ' ${service.rating} (${service.ratingCount}) | ${service.description}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${service.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                service.isSelected = !service.isSelected;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: service.isSelected ? AppTheme.primaryColor : Colors.white,
              foregroundColor: service.isSelected ? Colors.white : AppTheme.primaryColor,
              elevation: 0,
              side: BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(service.isSelected ? 'Added' : 'Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPlanButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton(
        onPressed: () {
          // Handle custom plan creation
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: BorderSide(color: AppTheme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Create Custom Plan'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to platforms selection
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text('Select Platforms'),
      ),
    );
  }
}

// Remove the RateCardItem class definition (lines 271-291)