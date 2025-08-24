import 'dart:io';
import 'package:get/get.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:influnew/providers/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/available_slots_management_screen.dart';
import 'package:influnew/widgets/pages/channel_benefits_screen.dart';
import 'package:influnew/widgets/pages/channel_creation_screen.dart';
import 'package:influnew/widgets/pages/influencer_profile_display_screen.dart';
import 'package:influnew/widgets/pages/invite_followers_screen.dart';
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

class _ProfileManagementScreenState extends State<ProfileManagementScreen>
    with TickerProviderStateMixin {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final StoreProvider _storeProvider = Get.find<StoreProvider>();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<Map<String, dynamic>> _channels = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Subtle color palette
  static const Color _primaryColor = Color(0xFF6B73FF);
  static const Color _backgroundColor = Color(0xFFF8F9FA);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF2D3748);
  static const Color _textSecondary = Color(0xFF718096);
  static const Color _accentColor = Color(0xFF667EEA);
  static const Color _successColor = Color(0xFF48BB78);
  static const Color _warningColor = Color(0xFFED8936);
  static const Color _errorColor = Color(0xFFE53E3E);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _loadUserProfile();
    _loadChannels();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              backgroundColor: _successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update profile picture: ${result['message']}',
              ),
              backgroundColor: _errorColor,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile picture: $e'),
          backgroundColor: _errorColor,
        ),
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
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildCleanHeader(),
                _buildCleanProfileSection(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildCleanSection('Influencer Hub', [
                        _buildCleanMenuItem(
                          'Manage Influencer Profile',
                          Icons.person_outline_rounded,
                          _primaryColor,
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
                        _buildCleanMenuItem(
                          'Your Rate Cards',
                          Icons.credit_card_rounded,
                          _accentColor,
                          () {
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
                              _showCleanSnackBar(
                                'Please complete your influencer profile first to access rate cards.',
                                _warningColor,
                              );
                            }
                          },
                        ),
                        _buildCleanMenuItem(
                          'Manage Time-Slots',
                          Icons.schedule_rounded,
                          const Color(0xFF805AD5),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const AvailableSlotsManagementScreen(),
                              ),
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'Invite Followers',
                          Icons.group_add_rounded,
                          const Color(0xFF38B2AC),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const InviteFollowersScreen(),
                              ),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Store Management', [
                        _buildCleanMenuItem(
                          'View All Stores',
                          Icons.store_rounded,
                          const Color(0xFF3182CE),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoresScreen(),
                              ),
                            ).then((_) => _loadUserProfile());
                          },
                        ),
                        _buildCleanMenuItem(
                          'Frequently Asked Questions',
                          Icons.help_outline_rounded,
                          _textSecondary,
                          () {
                            _showCleanSnackBar(
                              'FAQ section coming soon!',
                              _primaryColor,
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Channel Hub', [
                        _buildCleanMenuItem(
                          'View All Channels',
                          Icons.tv_rounded,
                          const Color(0xFF9F7AEA),
                          () {
                            _showCleanSnackBar(
                              'Channels list coming soon!',
                              _primaryColor,
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'Channel Benefits',
                          Icons.star_rounded,
                          const Color(0xFFD69E2E),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ChannelBenefitsScreen(),
                              ),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Account & Settings', [
                        _buildCleanMenuItem(
                          'Manage Social Accounts',
                          Icons.share_rounded,
                          const Color(0xFF4299E1),
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
                        _buildCleanMenuItem(
                          'Manage Payment Methods',
                          Icons.payment_rounded,
                          const Color(0xFF38B2AC),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WalletScreen(),
                              ),
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'About',
                          Icons.info_outline_rounded,
                          _textSecondary,
                          () {
                            _showCleanSnackBar(
                              'About page coming soon!',
                              _primaryColor,
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'Help',
                          Icons.help_rounded,
                          _textSecondary,
                          () {
                            _showCleanSnackBar(
                              'Help page coming soon!',
                              _primaryColor,
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'Logout',
                          Icons.logout_rounded,
                          _errorColor,
                          () {
                            _showLogoutConfirmationDialog();
                          },
                        ),
                      ]),
                      const SizedBox(height: 30),
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

  Widget _buildCleanHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Profile',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySecurityScreen(),
                  ),
                );
              },
              icon: Icon(Icons.settings_rounded, color: _textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:
                          profileUrl != null
                              ? Image.network(
                                profileUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/images/bksaraf.png',
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                'assets/images/bksaraf.png',
                                fit: BoxFit.cover,
                              ),
                    ),
                  );
                }),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _updateProfilePicture,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: _cardColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 12,
                        color: Colors.white,
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
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
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
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        letterSpacing: 0.2,
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

                    bool isFullyVerified = false;
                    if (userType == 'Individual') {
                      final isAadhaarVerified =
                          kycData?['aadhaar']?['isVerified'] == true;
                      final isPanVerified =
                          kycData?['pan']?['isVerified'] == true;
                      isFullyVerified = isAadhaarVerified && isPanVerified;
                    } else if (userType == 'Organization') {
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
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isFullyVerified
                                  ? _successColor.withOpacity(0.1)
                                  : _warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isFullyVerified
                                    ? _successColor.withOpacity(0.3)
                                    : _warningColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFullyVerified
                                  ? Icons.verified_rounded
                                  : Icons.warning_rounded,
                              color:
                                  isFullyVerified
                                      ? _successColor
                                      : _warningColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isFullyVerified
                                  ? 'KYC Verified'
                                  : 'Get KYC Verified',
                              style: TextStyle(
                                color:
                                    isFullyVerified
                                        ? _successColor
                                        : _warningColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (!isFullyVerified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: _warningColor,
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

  Widget _buildCleanSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              title,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          ...items,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCleanMenuItem(
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: _textSecondary,
          size: 14,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.grey.shade50,
        splashColor: accentColor.withOpacity(0.1),
      ),
    );
  }

  void _showCleanSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 4,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.logout_rounded, color: _errorColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: _textSecondary, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: _errorColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performLogout();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
