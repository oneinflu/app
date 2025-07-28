import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/create_store_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_theme.dart';
import '../../services/instagram_service.dart';
import 'instagram_auth_screen.dart';
import 'profile_management_screen.dart';
import '../pages/influencer_profile_setup_screen.dart';

class SocialMediaConnectionScreen extends StatefulWidget {
  final String? sourceFlow; // Add this parameter

  const SocialMediaConnectionScreen({Key? key, this.sourceFlow})
    : super(key: key);

  @override
  State<SocialMediaConnectionScreen> createState() =>
      _SocialMediaConnectionScreenState();
}

class _SocialMediaConnectionScreenState
    extends State<SocialMediaConnectionScreen> {
  final InstagramService _instagramService = InstagramService();

  final Map<String, bool> _connectedAccounts = {
    'instagram': false,
    'youtube': false,
    'facebook': false,
    'twitter': false,
    'tiktok': false,
    'linkedin': false,
  };

  final Map<String, String> _accountHandles = {
    'instagram': '',
    'youtube': '',
    'facebook': '',
    'twitter': '',
    'tiktok': '',
    'linkedin': '',
  };

  final Map<String, Map<String, dynamic>> _accountData = {
    'instagram': {},
    'youtube': {},
    'facebook': {},
    'twitter': {},
    'tiktok': {},
    'linkedin': {},
  };

  @override
  void initState() {
    super.initState();
    _checkInstagramConnection();
  }

  void _checkInstagramConnection() async {
    final isConnected = await _instagramService.isConnected();
    if (isConnected) {
      final profile = await _instagramService.getUserProfile();
      if (profile['success']) {
        setState(() {
          _connectedAccounts['instagram'] = true;
          _accountHandles['instagram'] = profile['data']['username'];
          _accountData['instagram'] = profile['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Connect Social Media',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect Your Social Media Accounts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Link your social media profiles to showcase your reach and engagement to potential brand partners.',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 30),

            // Instagram
            _buildSocialMediaCard(
              platform: 'instagram',
              title: 'Instagram',
              subtitle: 'Connect your Instagram account',
              icon: 'assets/images/instagram.png',
              color: const Color(0xFFE4405F),
              followerCount: '1.2M followers',
            ),
            const SizedBox(height: 16),

            // YouTube
            _buildSocialMediaCard(
              platform: 'youtube',
              title: 'YouTube',
              subtitle: 'Connect your YouTube channel',
              icon: 'assets/images/youtube.png',
              color: const Color(0xFFFF0000),
              followerCount: '850K subscribers',
            ),
            const SizedBox(height: 16),

            // Facebook
            _buildSocialMediaCard(
              platform: 'facebook',
              title: 'Facebook',
              subtitle: 'Connect your Facebook page',
              icon: 'assets/images/facebook.png',
              color: const Color(0xFF1877F2),
              followerCount: '500K followers',
            ),
            const SizedBox(height: 16),

            // Twitter
            _buildSocialMediaCard(
              platform: 'twitter',
              title: 'Twitter',
              subtitle: 'Connect your Twitter account',
              icon: Icons.alternate_email,
              color: const Color(0xFF1DA1F2),
              followerCount: '300K followers',
            ),
            const SizedBox(height: 16),

            // TikTok
            _buildSocialMediaCard(
              platform: 'tiktok',
              title: 'TikTok',
              subtitle: 'Connect your TikTok account',
              icon: Icons.music_note,
              color: const Color(0xFF000000),
              followerCount: '2.1M followers',
            ),
            const SizedBox(height: 16),

            // LinkedIn
            _buildSocialMediaCard(
              platform: 'linkedin',
              title: 'LinkedIn',
              subtitle: 'Connect your LinkedIn profile',
              icon: Icons.business,
              color: const Color(0xFF0A66C2),
              followerCount: '50K connections',
            ),
            const SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _hasConnectedAccounts() ? _continueToNextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Continue (${_getConnectedCount()}/6 connected)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        _hasConnectedAccounts()
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Skip Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  if (widget.sourceFlow == 'store_creation') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateStoreScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => const InfluencerProfileSetupScreen(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Skip for now',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaCard({
    required String platform,
    required String title,
    required String subtitle,
    dynamic icon,
    required Color color,
    required String followerCount,
  }) {
    final bool isConnected = _connectedAccounts[platform] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? color : Colors.grey[300]!,
          width: isConnected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Platform Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child:
                  icon is String
                      ? Image.asset(
                        icon,
                        width: 28,
                        height: 28,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image, color: color, size: 28);
                        },
                      )
                      : Icon(icon as IconData, color: color, size: 28),
            ),
          ),
          const SizedBox(width: 16),

          // Platform Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected ? followerCount : subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isConnected ? color : Colors.grey[600],
                  ),
                ),
                if (isConnected && _accountHandles[platform]!.isNotEmpty)
                  Text(
                    '@${_accountHandles[platform]}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),

          // Connect/Connected Button
          GestureDetector(
            onTap: () => _toggleConnection(platform),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isConnected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isConnected)
                    const Icon(Icons.check, color: Colors.white, size: 16),
                  if (isConnected) const SizedBox(width: 4),
                  Text(
                    isConnected ? 'Connected' : 'Connect',
                    style: TextStyle(
                      color: isConnected ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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

  void _toggleConnection(String platform) {
    if (_connectedAccounts[platform] == true) {
      // Disconnect
      if (platform == 'instagram') {
        _disconnectInstagram();
      } else {
        setState(() {
          _connectedAccounts[platform] = false;
          _accountHandles[platform] = '';
          _accountData[platform] = {};
        });
      }
    } else {
      // Connect
      if (platform == 'instagram') {
        _connectInstagram();
      } else {
        _showConnectDialog(platform);
      }
    }
  }

  void _connectInstagram() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => InstagramAuthScreen(
              onAuthComplete: (result) {
                if (result['success']) {
                  _handleInstagramAuthSuccess();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ?? 'Failed to connect Instagram',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
      ),
    );
  }

  void _handleInstagramAuthSuccess() async {
    final profile = await _instagramService.getUserProfile();
    final insights = await _instagramService.getUserInsights();

    if (profile['success']) {
      setState(() {
        _connectedAccounts['instagram'] = true;
        _accountHandles['instagram'] = profile['data']['username'];
        _accountData['instagram'] = {
          ...profile['data'],
          'media_count': insights['success'] ? insights['media_count'] : 0,
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Instagram connected successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _disconnectInstagram() async {
    await _instagramService.disconnect();
    setState(() {
      _connectedAccounts['instagram'] = false;
      _accountHandles['instagram'] = '';
      _accountData['instagram'] = {};
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Instagram disconnected'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showConnectDialog(String platform) {
    final TextEditingController handleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connect ${platform.toUpperCase()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your ${platform} username/handle:'),
              const SizedBox(height: 16),
              TextField(
                controller: handleController,
                decoration: InputDecoration(
                  hintText: '@username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (handleController.text.isNotEmpty) {
                  setState(() {
                    _connectedAccounts[platform] = true;
                    _accountHandles[platform] = handleController.text
                        .replaceAll('@', '');
                  });
                  Navigator.of(context).pop();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${platform.toUpperCase()} connected successfully!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
              ),
              child: const Text(
                'Connect',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasConnectedAccounts() {
    return _connectedAccounts.values.any((connected) => connected);
  }

  int _getConnectedCount() {
    return _connectedAccounts.values.where((connected) => connected).length;
  }

  void _continueToNextStep() {
    // Save connected accounts data
    final connectedData = {
      'connectedAccounts': _connectedAccounts,
      'accountHandles': _accountHandles,
    };

    // Navigate back with data or to next screen
    Navigator.of(context).pop(connectedData);
  }
}
