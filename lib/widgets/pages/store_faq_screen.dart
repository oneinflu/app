import 'package:flutter/material.dart';
import '../../app_theme.dart';

class StoreFAQScreen extends StatelessWidget {
  const StoreFAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildFAQList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search FAQs',
          hintStyle: TextStyle(
            color: AppTheme.textSecondary.withOpacity(0.5),
            fontSize: 16,
          ),
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFAQList() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I create a store?',
        'answer': 'To create a store, go to your profile and click on "Create Store". Fill in the required details like store name, description, and category. Upload store images and submit for review.',
      },
      {
        'question': 'What types of products can I sell?',
        'answer': 'You can sell various products including clothing, accessories, electronics, and more. Ensure your products comply with our platform guidelines and regulations.',
      },
      {
        'question': 'How do I manage my store inventory?',
        'answer': 'Use the inventory management section to add, update, or remove products. You can track stock levels, set prices, and manage product variations.',
      },
      {
        'question': 'How are payments processed?',
        'answer': 'Payments are processed securely through our platform. We support various payment methods including UPI, credit/debit cards, and net banking. Funds are transferred to your linked bank account.',
      },
      {
        'question': 'What are the fees and charges?',
        'answer': 'We charge a small commission on each sale. The exact percentage depends on your product category and sales volume. There are no monthly or setup fees.',
      },
      {
        'question': 'How do I handle returns and refunds?',
        'answer': 'You can set your return policy in store settings. When a return request is received, review it and process the refund through the platform. We handle the payment reversal process.',
      },
      {
        'question': 'How can I promote my store?',
        'answer': 'Use our built-in promotion tools to create offers and discounts. You can also share your store on social media and participate in platform-wide promotional events.',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildFAQItem(faqs[index]);
      },
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        faq['question']!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq['answer']!,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}