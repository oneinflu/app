import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:influnew/app_theme.dart';
import 'package:influnew/aadhaar_verification_screen.dart';
import 'package:influnew/pan_verification_screen.dart';
import 'package:influnew/gst_verification_screen.dart';
import 'package:influnew/widgets/pages/channel_creation_screen.dart';
import 'package:influnew/widgets/pages/social_media_connection_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String? sourceScreen; // To track which benefit screen user came from

  const VerificationScreen({super.key, this.sourceScreen});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  String? userType;
  Map<String, dynamic>? kycData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Add this method to refresh data when returning from verification screens
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when screen becomes active again
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserData();
    });
  }

  void _getUserData() {
    final userData = _authProvider.user.value;
    if (userData != null) {
      userType = userData['userType'] ?? 'Individual';
      kycData = userData['kyc'];
    } else {
      userType = 'Individual'; // Default fallback
    }
    if (mounted) {
      setState(() {});
    }
  }

  // Add this method to handle navigation with refresh callback
  Future<void> _navigateToVerification(Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // Refresh data when returning from verification screen
    if (mounted) {
      await _authProvider.getUserProfile(); // Refresh user profile from server
      _getUserData(); // Update local state
    }
  }

  bool _isAadhaarVerified() {
    return kycData?['aadhaar']?['isVerified'] == true;
  }

  bool _isPanVerified() {
    return kycData?['pan']?['isVerified'] == true;
  }

  bool _isGstVerified() {
    return kycData?['gst']?['isVerified'] == true;
  }

  bool _isFullyVerified() {
    if (userType == 'Individual') {
      return _isAadhaarVerified() && _isPanVerified();
    } else {
      return _isGstVerified() && _isPanVerified();
    }
  }

  bool _isFromBenefitScreen() {
    return widget.sourceScreen == 'influencer' ||
        widget.sourceScreen == 'partner' ||
        widget.sourceScreen == 'channel' ||
        widget.sourceScreen == 'store';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            // Notification Bell Icon
            GestureDetector(
              onTap: () {
                _showNotificationModal();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.accentCoral,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Verify your ${userType?.toLowerCase() ?? 'individual'} account',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Complete your verification to unlock all features and build trust with your audience.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  if (userType == 'Individual') ..._buildIndividualOptions(),
                  if (userType == 'Organization')
                    ..._buildOrganizationOptions(),

                  // Show social media connection button when fully verified and coming from benefit screens
                  if (_isFullyVerified() && _isFromBenefitScreen())
                    ..._buildSocialMediaSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSocialMediaSection() {
    return [
      const SizedBox(height: 30),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple.withOpacity(0.1),
              AppTheme.primaryPurple.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Verification Complete!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.sourceScreen == 'channel'
                  ? 'Now create your tutor profile to start teaching and earning.'
                  : 'Now connect your social media accounts to showcase your reach to potential partners.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.sourceScreen == 'channel') {
                    // Navigate directly to channel creation screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChannelCreationScreen(),
                      ),
                    );
                  } else {
                    // Determine sourceFlow based on sourceScreen
                    String? sourceFlow;
                    if (widget.sourceScreen == 'store') {
                      sourceFlow = 'store_creation';
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SocialMediaConnectionScreen(
                              sourceFlow: sourceFlow,
                            ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.sourceScreen == 'channel'
                          ? Icons.school
                          : Icons.link,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.sourceScreen == 'channel'
                          ? 'Create Tutor Profile'
                          : 'Connect Social Accounts',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildIndividualOptions() {
    return [
      _buildVerificationCard(
        title: 'Aadhaar Verification',
        subtitle:
            _isAadhaarVerified()
                ? 'Verified on ${_getVerificationDate('aadhaar')}'
                : 'Verify your identity with Aadhaar card',
        icon: Icons.credit_card,
        isVerified: _isAadhaarVerified(),
        onTap:
            _isAadhaarVerified()
                ? null
                : () =>
                    _navigateToVerification(const AadhaarVerificationScreen()),
      ),
      const SizedBox(height: 16),
      _buildVerificationCard(
        title: 'PAN Verification',
        subtitle:
            _isPanVerified()
                ? 'Verified on ${_getVerificationDate('pan')}'
                : 'Verify your PAN card details',
        icon: Icons.account_balance_wallet,
        isVerified: _isPanVerified(),
        onTap:
            _isPanVerified()
                ? null
                : () => _navigateToVerification(const PanVerificationScreen()),
      ),
    ];
  }

  List<Widget> _buildOrganizationOptions() {
    return [
      _buildVerificationCard(
        title: 'GST Verification',
        subtitle:
            _isGstVerified()
                ? 'Verified on ${_getVerificationDate('gst')}'
                : 'Verify your GST registration details',
        icon: Icons.business,
        isVerified: _isGstVerified(),
        onTap:
            _isGstVerified()
                ? null
                : () => _navigateToVerification(const GstVerificationScreen()),
      ),
      const SizedBox(height: 16),
      _buildVerificationCard(
        title: 'PAN Verification',
        subtitle:
            _isPanVerified()
                ? 'Verified on ${_getVerificationDate('pan')}'
                : 'Verify your organization PAN details',
        icon: Icons.account_balance_wallet,
        isVerified: _isPanVerified(),
        onTap:
            _isPanVerified()
                ? null
                : () => _navigateToVerification(const PanVerificationScreen()),
      ),
    ];
  }

  String _getVerificationDate(String verificationType) {
    final verifiedAt = kycData?[verificationType]?['verifiedAt'];
    if (verifiedAt != null) {
      try {
        final date = DateTime.parse(verifiedAt);
        return '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        return 'Recently';
      }
    }
    return 'Recently';
  }

  Widget _buildVerificationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isVerified,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isVerified ? Colors.green.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isVerified ? Colors.green.withOpacity(0.3) : Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    isVerified
                        ? Colors.green.withOpacity(0.1)
                        : AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isVerified ? Colors.green : AppTheme.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isVerified ? Colors.green[700] : Colors.black,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.green, size: 20),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isVerified ? Colors.green[600] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!isVerified)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
            else
              Icon(Icons.check_circle, color: Colors.green, size: 24),
          ],
        ),
      ),
    );
  }

  void _showNotificationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Notifications',
                  style: AppTheme.headlineStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stay updated with the latest opportunities and updates',
                  style: AppTheme.secondaryTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Text(
                    'No new notifications',
                    style: AppTheme.secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }
}
