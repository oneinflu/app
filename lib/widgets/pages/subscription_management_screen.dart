import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubscriptionCard(
              title: 'Store Subscription',
              icon: Icons.store,
              color: const Color(0xFF4299E1),
              status: 'Active',
              startDate: '01 Jan 2024',
              currentPhase: 'Initial Phase (Free)',
              nextPhase: 'From 6th month: ₹1,000/month',
              benefits: [
                'Commission-free sales',
                'Unlimited product listings',
                'Analytics dashboard',
              ],
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(
              title: 'Academy Subscription',
              icon: Icons.school,
              color: const Color(0xFF9F7AEA),
              status: 'Active',
              startDate: '01 Jan 2024',
              currentPhase: 'Initial Phase (Free)',
              nextPhase: 'From 6th month: ₹1,000/month',
              benefits: [
                'Unlimited course creation',
                'Student analytics',
                'Live session tools',
              ],
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(
              title: 'Content Creator Subscription',
              icon: Icons.create,
              color: const Color(0xFFED64A6),
              status: 'Active',
              startDate: '01 Jan 2024',
              currentPhase: 'Initial Phase (Free)',
              nextPhase: 'From 6th month: ₹5,000/month',
              benefits: [
                'Premium creator tools',
                'Advanced analytics',
                'Priority support',
              ],
              taskInfo: TaskInfo(
                title: 'Get Lifetime Discount',
                description: 'Post about joining INFLU on your handle, mentioning your plans to share business and food vlogs, and tag @oneinflu',
                reward: 'Reduces subscription to ₹1,000/month from 6th month onwards',
                buttonText: 'Complete Task',
                onPressed: () {
                  // Handle task completion verification
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String status,
    required String startDate,
    required String currentPhase,
    required String nextPhase,
    required List<String> benefits,
    String? footnote,
    TaskInfo? taskInfo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Date: $startDate',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  currentPhase,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  nextPhase,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: color, size: 16),
                          const SizedBox(width: 8),
                          Text(benefit),
                        ],
                      ),
                    )),
                if (footnote != null) ...[                  
                  const SizedBox(height: 12),
                  Text(
                    footnote,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (taskInfo != null) ...[                  
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskInfo.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          taskInfo.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          taskInfo.reward,
                          style: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: taskInfo.onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              taskInfo.buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskInfo {
  final String title;
  final String description;
  final String reward;
  final String buttonText;
  final VoidCallback onPressed;

  const TaskInfo({
    required this.title,
    required this.description,
    required this.reward,
    required this.buttonText,
    required this.onPressed,
  });
}