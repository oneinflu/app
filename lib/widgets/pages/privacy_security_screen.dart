import 'package:flutter/material.dart';
import 'package:influnew/policy_page.dart';
import 'package:influnew/terms_page.dart';
import '../../app_theme.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final Color _cardColor = Colors.white;
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _textPrimary = Colors.grey.shade900;
  final Color _textSecondary = Colors.grey.shade600;
  final Color _primaryColor = AppTheme.primaryPurple;
  final Color _accentColor = AppTheme.gradientEnd;
  final Color _warningColor = Colors.orange;
  final Color _errorColor = Colors.red.shade600;

  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _locationEnabled = true;
  bool _notificationsEnabled = true;
  bool _dataSharing = false;
  bool _activityStatus = true;
  bool _profileVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildCleanHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCleanSection('Security', [
                        _buildCleanToggleItem(
                          'Biometric Login',
                          Icons.fingerprint_rounded,
                          const Color(0xFF805AD5),
                          _biometricEnabled,
                          (value) => setState(() => _biometricEnabled = value),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Privacy', [
                        _buildCleanToggleItem(
                          'Location Services',
                          Icons.location_on_rounded,
                          const Color(0xFF38B2AC),
                          _locationEnabled,
                          (value) => setState(() => _locationEnabled = value),
                        ),
                        _buildCleanToggleItem(
                          'Push Notifications',
                          Icons.notifications_rounded,
                          const Color(0xFFD69E2E),
                          _notificationsEnabled,
                          (value) =>
                              setState(() => _notificationsEnabled = value),
                        ),
                        _buildCleanToggleItem(
                          'Data Sharing',
                          Icons.data_usage_rounded,
                          const Color(0xFF3182CE),
                          _dataSharing,
                          (value) => setState(() => _dataSharing = value),
                        ),
                        _buildCleanToggleItem(
                          'Activity Status',
                          Icons.visibility_rounded,
                          const Color(0xFF4299E1),
                          _activityStatus,
                          (value) => setState(() => _activityStatus = value),
                        ),
                        _buildCleanToggleItem(
                          'Profile Visibility',
                          Icons.person_rounded,
                          const Color(0xFF9F7AEA),
                          _profileVisibility,
                          (value) => setState(() => _profileVisibility = value),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Account', [
                        _buildCleanMenuItem(
                          'Download My Data',
                          Icons.download_rounded,
                          _textSecondary,
                          () => _showDownloadDataDialog(),
                        ),
                        _buildCleanMenuItem(
                          'Delete Account',
                          Icons.delete_forever_rounded,
                          _errorColor,
                          () => _showDeleteAccountDialog(),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildCleanSection('Legal', [
                        _buildCleanMenuItem(
                          'Privacy Policy',
                          Icons.privacy_tip_rounded,
                          _textSecondary,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PolicyPage(),
                              ),
                            );
                          },
                        ),
                        _buildCleanMenuItem(
                          'Terms of Service',
                          Icons.description_rounded,
                          _textSecondary,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsPage(),
                              ),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Privacy & Security',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildCleanSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
        const SizedBox(height: 12),
        Container(
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
          child: Column(children: items),
        ),
      ],
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

  Widget _buildCleanToggleItem(
    String title,
    IconData icon,
    Color accentColor,
    bool value,
    Function(bool) onChanged,
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
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: _primaryColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.grey.shade50,
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download My Data'),
            content: const Text(
              'We will prepare your data and send a download link to your registered email address. This process may take up to 24 hours.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Data request submitted. Check your email within 24 hours.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                ),
                child: const Text('Request Data'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: _errorColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This action cannot be undone. All your data will be permanently deleted.',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password to confirm',
                        hintStyle: TextStyle(
                          color: _textSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement account deletion logic
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _errorColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
