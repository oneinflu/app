import 'dart:io';
import 'package:get/get.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:influnew/providers/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/channel_benefits_screen.dart';
import 'package:influnew/widgets/pages/channel_creation_screen.dart';
import 'package:influnew/widgets/pages/influencer_profile_display_screen.dart';
import 'package:influnew/widgets/pages/partner_benefits_screen.dart';
import 'package:influnew/widgets/pages/rate_cards_management_screen.dart';
import 'package:influnew/widgets/pages/store_benefits_screen.dart';
import 'package:influnew/widgets/pages/store_creation_screen.dart';
import 'package:influnew/widgets/pages/products_services_management_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influnew/widgets/pages/stores_screen.dart';
import '../../app_theme.dart';
import '../../home_screen.dart';
import 'connected_accounts_screen.dart';
import 'create_influencer_profile_screen.dart';
import 'earnings_screen.dart';
import 'privacy_security_screen.dart';
import 'rate_card_screen.dart';
import 'wallet_screen.dart';
import '../../verification_screen.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({Key? key}) : super(key: key);

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final StoreProvider _storeProvider = Get.find<StoreProvider>();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<Map<String, dynamic>> _channels = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadChannels();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authProvider.getUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadChannels() async {
    // TODO: Implement channel loading when channel provider is available
    // For now, assume no channels exist
    setState(() {
      _channels = [];
    });
  }

  Future<void> _updateProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        final result = await _authProvider.updateProfilePicture(image.path);

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update profile picture: ${result['message']}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile picture: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF341969), // Updated background start color
              Color(0xFF372065), // Updated background end color
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildProfileSection(),
                const SizedBox(height: 20),
                // Remove the nested container and integrate sections directly
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSection('Influencer Related', [
                        _buildMenuItem(
                          'Manage Influencer Profile',
                          Icons.person_outline,
                          () {
                            if (_authProvider.hasCompletedInfluencerProfile) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const InfluencerProfileDisplayScreen(),
                                ),
                              ).then((_) => _loadUserProfile());
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const PartnerBenefitsScreen(),
                                ),
                              ).then((_) => _loadUserProfile());
                            }
                          },
                        ),
                        _buildMenuItem('Your Rate Cards', Icons.credit_card, () {
                          if (_authProvider.hasCompletedInfluencerProfile) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const RateCardsManagementScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please complete your influencer profile first to access rate cards.',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        }),
                        _buildMenuItem('Manage Time-Slots', Icons.schedule, () {
                          // TODO: Navigate to time slots management
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Time slots management coming soon!',
                              ),
                            ),
                          );
                        }),
                        _buildMenuItem('Invite Followers', Icons.group_add, () {
                          // TODO: Navigate to invite followers
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invite followers feature coming soon!',
                              ),
                            ),
                          );
                        }),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Store Related', [
                        _buildMenuItem('View All Stores', Icons.store, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoresScreen(),
                            ),
                          ).then((_) => _loadUserProfile());
                        }),
                        _buildMenuItem(
                          'Frequently Asked Questions',
                          Icons.help_outline,
                          () {
                            // TODO: Navigate to FAQ
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('FAQ section coming soon!'),
                              ),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Channel Related', [
                        _buildMenuItem('View All Channels', Icons.tv, () {
                          // TODO: Navigate to channels list
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Channels list coming soon!'),
                            ),
                          );
                        }),
                        _buildMenuItem('Channel Benefits', Icons.star, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ChannelBenefitsScreen(),
                            ),
                          );
                        }),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('More', [
                        _buildMenuItem(
                          'Manage Social Accounts',
                          Icons.share,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ConnectedAccountsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          'Manage Payment Methods',
                          Icons.payment,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WalletScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem('About', Icons.info_outline, () {
                          // TODO: Navigate to about page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('About page coming soon!'),
                            ),
                          );
                        }),
                        _buildMenuItem('Help', Icons.help, () {
                          // TODO: Navigate to help page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help page coming soon!'),
                            ),
                          );
                        }),
                        _buildMenuItem('Logout', Icons.logout, () {
                          _showLogoutConfirmationDialog();
                        }),
                      ]),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySecurityScreen(),
                ),
              );
            },
            child: const Icon(Icons.edit, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF210E47), // Updated to match other cards
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Obx(() {
                  final userData = _authProvider.user.value;
                  final profileUrl =
                      userData != null ? userData['profileURL'] : null;

                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image:
                          profileUrl != null
                              ? DecorationImage(
                                image: NetworkImage(profileUrl),
                                fit: BoxFit.cover,
                              )
                              : const DecorationImage(
                                image: AssetImage('assets/images/bksaraf.png'),
                                fit: BoxFit.cover,
                              ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : null,
                  );
                }),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _updateProfilePicture,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: Color(0xFF2D1B69),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final userData = _authProvider.user.value;
                    final name =
                        userData != null
                            ? (userData['name'] ?? 'User')
                            : 'User';
                    return Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                  const SizedBox(height: 4),
                  Obx(() {
                    final userData = _authProvider.user.value;
                    final email =
                        userData != null
                            ? (userData['email'] ?? 'user@example.com')
                            : 'user@example.com';
                    return Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                  const SizedBox(height: 8),
                  Obx(() {
                    final userData = _authProvider.user.value;
                    final userType = userData?['userType'];
                    final kycData = userData?['kyc'];

                    // Check verification status based on user type (same logic as homepage)
                    bool isFullyVerified = false;
                    if (userType == 'Individual') {
                      // For individuals: Aadhaar + PAN
                      final isAadhaarVerified =
                          kycData?['aadhaar']?['isVerified'] == true;
                      final isPanVerified =
                          kycData?['pan']?['isVerified'] == true;
                      isFullyVerified = isAadhaarVerified && isPanVerified;
                    } else if (userType == 'Organization') {
                      // For organizations: GST + PAN
                      final isGstVerified =
                          kycData?['gst']?['isVerified'] == true;
                      final isPanVerified =
                          kycData?['pan']?['isVerified'] == true;
                      isFullyVerified = isGstVerified && isPanVerified;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (!isFullyVerified) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isFullyVerified ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFullyVerified ? Icons.verified : Icons.warning,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isFullyVerified
                                  ? 'KYC Verified'
                                  : 'Get KYC Verified',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            if (!isFullyVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    Color getBarColor(String title) {
      switch (title) {
        case 'Influencer Related':
          return const Color.fromARGB(255, 142, 45, 246); // Green
        case 'Store Related':
          return const Color.fromARGB(255, 142, 45, 246); // Blue
        case 'Channel Related':
          return const Color.fromARGB(255, 142, 45, 246); // Orange
        case 'More':
          return const Color.fromARGB(255, 142, 45, 246); // Red
        default:
          return const Color.fromARGB(255, 142, 45, 246); // Purple
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF210E47), // Updated card background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section with highlighting bar
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Highlighting bar
                Container(
                  width: 4,
                  height: 32, // Reduced height from 56 to 32
                  decoration: BoxDecoration(
                    color: getBarColor(title),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                  ),
                ),
                // Title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Menu items with dividers
          ...List.generate(items.length, (index) {
            return Column(
              children: [
                items[index],
                if (index <
                    items.length - 1) // Add divider except for last item
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ), // Reduced horizontal margin
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ), // Reduced horizontal padding
        leading: Icon(icon, color: Colors.white70, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.white.withOpacity(0.1),
        splashColor: Colors.white.withOpacity(0.2),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D1B69),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    final authProvider = Get.find<AuthProvider>();
    await authProvider.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }
}
