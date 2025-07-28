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
import '../../app_theme.dart';
import '../../home_screen.dart';
import 'connected_accounts_screen.dart';
import 'create_influencer_profile_screen.dart';
import 'earnings_screen.dart';
import 'privacy_security_screen.dart';
import 'rate_card_screen.dart';
import 'wallet_screen.dart';

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
  List<Map<String, dynamic>> _stores = [];
  List<Map<String, dynamic>> _channels =
      []; // You'll need to implement channel provider

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadStores();
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

  Future<void> _loadStores() async {
    try {
      await _storeProvider.getStores();
      setState(() {
        _stores = _storeProvider.stores;
      });
    } catch (e) {
      print('Error loading stores: $e');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Profile Management',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Purple background for the header
          Container(height: 220, color: AppTheme.primaryPurple),
          // Profile header with image and name
          _buildProfileHeader(),
          // White container with rounded corners for content
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildSectionTitle('Manage Profiles'),
                  // Influencer Profile - Navigate to benefits screen if not completed
                  _buildProfileCard(
                    title:
                        _authProvider.hasCompletedInfluencerProfile
                            ? 'Manage Influencer Profile'
                            : 'Create Influencer Profile',
                    subtitle:
                        _authProvider.hasCompletedInfluencerProfile
                            ? 'Update your influencer details and settings'
                            : 'Set up your influencer profile to get started',
                    icon: Icons.person_outline,
                    onTap: () {
                      if (_authProvider.hasCompletedInfluencerProfile) {
                        // Navigate to display/manage screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const InfluencerProfileDisplayScreen(),
                          ),
                        ).then((_) => _loadUserProfile()); // Refresh on return
                      } else {
                        // Navigate to benefits screen first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PartnerBenefitsScreen(),
                          ),
                        ).then((_) => _loadUserProfile()); // Refresh on return
                      }
                    },
                  ),
                  // Store Profile - Navigate to benefits screen if no stores exist
                  _buildProfileCard(
                    title: _stores.isNotEmpty ? 'Manage Store' : 'Create Store',
                    subtitle:
                        _stores.isNotEmpty
                            ? 'Manage your store details and products'
                            : 'Set up your store to start selling',
                    icon: Icons.store_outlined,
                    onTap: () {
                      if (_stores.isNotEmpty) {
                        // Navigate to store management (ProductsServicesManagementScreen)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductsServicesManagementScreen(
                                  storeId:
                                      _stores
                                          .first['_id'], // Use first store ID
                                ),
                          ),
                        ).then((_) => _loadStores()); // Refresh on return
                      } else {
                        // Navigate to store benefits screen first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreBenefitsScreen(),
                          ),
                        ).then((_) => _loadStores()); // Refresh on return
                      }
                    },
                  ),
                  // Channel Profile - Navigate to benefits screen if no channels exist
                  _buildProfileCard(
                    title:
                        _channels.isNotEmpty
                            ? 'Manage Channel'
                            : 'Create Channel',
                    subtitle:
                        _channels.isNotEmpty
                            ? 'Manage your channel details and courses'
                            : 'Set up your channel to start teaching',
                    icon: Icons.video_library_outlined,
                    onTap: () {
                      if (_channels.isNotEmpty) {
                        // TODO: Navigate to channel management screen when available
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Channel management coming soon!'),
                          ),
                        );
                      } else {
                        // Navigate to channel benefits screen first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChannelBenefitsScreen(),
                          ),
                        ).then((_) => _loadChannels()); // Refresh on return
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Monetization'),
                  // Rate Cards - Disabled until influencer profile is created
                  _buildProfileCard(
                    title: 'Rate Cards',
                    subtitle:
                        _authProvider.hasCompletedInfluencerProfile
                            ? 'Set your pricing for different services'
                            : 'Complete your influencer profile first',
                    icon: Icons.attach_money_outlined,
                    isDisabled: !_authProvider.hasCompletedInfluencerProfile,
                    onTap: () {
                      if (_authProvider.hasCompletedInfluencerProfile) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const RateCardsManagementScreen(),
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
                    },
                  ),
                  _buildProfileCard(
                    title: 'Earnings',
                    subtitle: 'Track your earnings and payment history',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EarningsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileCard(
                    title: 'Wallet',
                    subtitle: 'Manage your wallet and transaction history',
                    icon: Icons.wallet,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Account'),
                  _buildProfileCard(
                    title: 'KYC Details',
                    subtitle: 'View and update your verification details',
                    icon: Icons.verified_user_outlined,
                    onTap: () {},
                  ),
                  _buildProfileCard(
                    title: 'Connected Accounts',
                    subtitle: 'Manage your connected social media accounts',
                    icon: Icons.link_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectedAccountsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileCard(
                    title: 'Privacy & Security',
                    subtitle: 'Manage your account security settings',
                    icon: Icons.security_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacySecurityScreen(),
                        ),
                      );
                    },
                  ),

                  // Add this new logout card
                  _buildProfileCard(
                    title: 'Logout',
                    subtitle: 'Sign out from your account',
                    icon: Icons.logout,
                    onTap: () {
                      _showLogoutConfirmationDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      decoration: const BoxDecoration(color: AppTheme.primaryPurple),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Profile image with edit button
          Stack(
            children: [
              Obx(() {
                final userData = _authProvider.user.value;
                final profileUrl =
                    userData != null ? userData['profileURL'] : null;

                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : null,
                );
              }),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _updateProfilePicture,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppTheme.primaryPurple,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User name with verified badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Obx(() {
                  final userData = _authProvider.user.value;
                  final name = userData != null ? userData['name'] : 'User';
              
                  return Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // User email
          Obx(() {
            final userData = _authProvider.user.value;
            final email =
                userData != null ? userData['email'] : 'user@example.com';

            return Text(
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isDisabled
                ? Colors.grey.withOpacity(0.1)
                : AppTheme.primaryPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                isDisabled
                    ? Colors.grey.withOpacity(0.2)
                    : AppTheme.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDisabled ? Colors.grey : AppTheme.primaryPurple,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDisabled ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDisabled ? Colors.grey : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDisabled ? Colors.grey : Colors.black54,
        ),
        onTap: isDisabled ? null : onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
    // Get the AuthProvider instance
    final authProvider = Get.find<AuthProvider>();

    // Call the logout method
    await authProvider.logout();

    // Navigate to welcome or login screen
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }
}
