import 'package:flutter/material.dart';
import 'package:influnew/app_theme.dart';
import 'chat_screen.dart';

class InfluencerDetailScreen extends StatelessWidget {
  final String name;
  final String date;

  const InfluencerDetailScreen({
    Key? key,
    required this.name,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Inside the build method, update the Chat button:
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChatScreen(
                          partnerName: name,
                          partnerImagePath: 'assets/images/shannu.png',
                          userType: ChatUserType.business,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2D82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Chat',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildInfluencerProfile(),
            const SizedBox(height: 12),
            _buildBookingDetails(),
            const SizedBox(height: 12),
            _buildInfluPromise(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfluencerProfile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image using shannu.png
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/shannu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Social media stats with image assets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSocialStat(
                        '16.5M',
                        'Followers',
                        'assets/images/facebook.png',
                      ),
                      _buildSocialStat(
                        '16.8M',
                        'Followers',
                        'assets/images/instagram.png',
                      ),
                      _buildSocialStat(
                        '18.8M',
                        'Subscribers',
                        'assets/images/youtube.png',
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

  Widget _buildSocialStat(String count, String label, String iconPath) {
    return Column(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildBookingDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailItem(Icons.access_time, 'Mon, Jul 17 at 11:30PM'),
            Divider(color: Colors.grey[200], height: 32),
            _buildDetailItem(
              Icons.location_on,
              'Home B-101, OYSTER, Pragathi Nagar Road, Nizampet, Hyderabad',
            ),
            Divider(color: Colors.grey[200], height: 32),
            _buildDetailItem(Icons.phone, 'Suurya Prabhat +91 7673925350'),
            Divider(color: Colors.grey[200], height: 32),
            _buildAmountItem('10,000 total amount'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildAmountItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.receipt, color: Colors.black54, size: 20),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 14)),
          ],
        ),
        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      ],
    );
  }

  Widget _buildInfluPromise() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      color: Colors.white, // Explicitly set to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Influ',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' promise',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPromiseItem(
              'Fixed rate card',
              'Transparent & upfront pricing',
            ),
            const SizedBox(height: 16),
            _buildPromiseItem(
              'Verified Profiles by Influ',
              'All Profiles are verified & authenticated',
            ),
            const SizedBox(height: 16),
            _buildPromiseItem(
              'Approve & Post',
              'Approve the draft then only it gets posted',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromiseItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Icon(Icons.receipt, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
