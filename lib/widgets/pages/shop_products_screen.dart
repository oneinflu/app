import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ShopProductsScreen extends StatefulWidget {
  const ShopProductsScreen({Key? key}) : super(key: key);

  @override
  State<ShopProductsScreen> createState() => _ShopProductsScreenState();
}

class _ShopProductsScreenState extends State<ShopProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text(
                  '0 items in cart',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildSliderSection(), // Changed from _buildBannerAd() to _buildSliderSection()
            _buildCategorySection(),
            _buildRecommendedSection(),
          ],
        ),
      ),
    );
  }

  // New slider section method with border radius
  Widget _buildSliderSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/slider.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search any product',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAd() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/app_icon.png'),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'vivo',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'vivo T4 5G',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'From ₹19,999*',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Slimmest 7300 mAh battery phone**',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Flat ₹2,000',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Instant Discount*',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      height: 160, // Fixed height for the entire section including text
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryItem(
            'Fashion & Apparel',
            'assets/images/categories/Rectangle 22.png',
          ),
          const SizedBox(width: 16),
          _buildCategoryItem(
            'Electronics & Gadgets',
            'assets/images/categories/Rectangle 30.png',
          ),
          const SizedBox(width: 16),
          _buildCategoryItem(
            'Beauty & Personal Care',
            'assets/images/categories/Rectangle 31.png',
          ),
          const SizedBox(width: 16),
          _buildCategoryItem(
            'Home & Living',
            'assets/images/categories/Rectangle 32.png',
          ),
          const SizedBox(width: 16),
          _buildCategoryItem(
            'Fashion & Apparel',
            'assets/images/categories/Rectangle 22.png',
          ),
          const SizedBox(width: 16),
          _buildCategoryItem(
            'Electronics & Gadgets',
            'assets/images/categories/Rectangle 30.png',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Color(
        0xFFF3EEFF,
      ), // Light purple background color as shown in the image
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Creator Recommended',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 230, // Fixed height for the product cards section
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildProductCard(
                  'Sony PlayStation5 Gaming Console (Slim)',
                  'assets/images/products/Rectangle 47.png',
                  'Sony',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Babily Big Size Fibre Filled Stuffed Animal Baby Plush',
                  'assets/images/products/Rectangle 47-1.png',
                  'Babily',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Babily Big Size Fibre Filled Stuffed Animal Baby',
                  'assets/images/products/Rectangle 47-2.png',
                  'Babily',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Sony PlayStation5 Gaming Console (Slim)',
                  'assets/images/products/Rectangle 47.png',
                  'Sony',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Babily Big Size Fibre Filled Stuffed Animal Baby Plush',
                  'assets/images/products/Rectangle 47-1.png',
                  'Babily',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String imagePath, String brand) {
    return Container(
      width: 180, // Fixed width for each product card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Brand: $brand',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
