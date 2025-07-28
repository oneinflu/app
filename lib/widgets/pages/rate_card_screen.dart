import 'package:flutter/material.dart';
import '../../app_theme.dart';

class RateCardScreen extends StatefulWidget {
  const RateCardScreen({Key? key}) : super(key: key);

  @override
  State<RateCardScreen> createState() => _RateCardScreenState();
}

class _RateCardScreenState extends State<RateCardScreen> {
  final List<Map<String, dynamic>> _rateCards = [
    {
      'title': 'Instagram Post',
      'price': '₹5,000',
      'description': 'Single post with product placement',
      'isActive': true,
    },
    {
      'title': 'Instagram Story',
      'price': '₹3,000',
      'description': 'Story with swipe-up link',
      'isActive': true,
    },
    {
      'title': 'YouTube Video',
      'price': '₹15,000',
      'description': '60-second product mention in video',
      'isActive': false,
    },
    {
      'title': 'Full YouTube Review',
      'price': '₹25,000',
      'description': 'Dedicated product review video',
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        title: const Text(
          'Rate Cards',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Set your pricing for different services and collaborations',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._rateCards.map((card) => _buildRateCard(card)),
                const SizedBox(height: 20),
                _buildAddRateCardButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCard(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppTheme.primaryPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                Switch(
                  value: card['isActive'],
                  onChanged: (value) {
                    setState(() {
                      card['isActive'] = value;
                    });
                  },
                  activeColor: AppTheme.primaryPurple,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              card['price'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card['description'],
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.primaryPurple),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRateCardButton() {
    return GestureDetector(
      onTap: () {
        // Show dialog to add new rate card
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryPurple, width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: AppTheme.primaryPurple),
            SizedBox(width: 8),
            Text(
              'Add New Rate Card',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}