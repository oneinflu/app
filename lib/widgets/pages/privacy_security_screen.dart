import 'package:flutter/material.dart';
import '../../app_theme.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        title: const Text(
          'Privacy & Security',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                'Manage your account security and privacy settings',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionTitle('Security'),
                  const SizedBox(height: 16),
                  _buildSecurityItem(
                    'Change Password',
                    'Last changed 30 days ago',
                    Icons.lock,
                    onTap: () {
                      _showChangePasswordDialog();
                    },
                  ),
                  _buildToggleItem(
                    'Two-Factor Authentication',
                    'Add an extra layer of security',
                    Icons.security,
                    _twoFactorEnabled,
                    (value) {
                      setState(() {
                        _twoFactorEnabled = value;
                      });
                      if (value) {
                        _showTwoFactorDialog();
                      }
                    },
                  ),
                  _buildToggleItem(
                    'Biometric Login',
                    'Use fingerprint or face recognition',
                    Icons.fingerprint,
                    _biometricEnabled,
                    (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Privacy'),
                  const SizedBox(height: 16),
                  _buildToggleItem(
                    'Location Services',
                    'Allow app to access your location',
                    Icons.location_on,
                    _locationEnabled,
                    (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                    },
                  ),
                  _buildToggleItem(
                    'Push Notifications',
                    'Receive updates and alerts',
                    Icons.notifications,
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _buildToggleItem(
                    'Data Sharing',
                    'Share usage data to improve services',
                    Icons.data_usage,
                    _dataSharing,
                    (value) {
                      setState(() {
                        _dataSharing = value;
                      });
                    },
                  ),
                  _buildToggleItem(
                    'Activity Status',
                    'Show when you are active on the platform',
                    Icons.visibility,
                    _activityStatus,
                    (value) {
                      setState(() {
                        _activityStatus = value;
                      });
                    },
                  ),
                  _buildToggleItem(
                    'Profile Visibility',
                    'Allow others to discover your profile',
                    Icons.person,
                    _profileVisibility,
                    (value) {
                      setState(() {
                        _profileVisibility = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Account'),
                  const SizedBox(height: 16),
                  _buildSecurityItem(
                    'Download My Data',
                    'Get a copy of your personal data',
                    Icons.download,
                    onTap: () {
                      _showDownloadDataDialog();
                    },
                  ),
                  _buildSecurityItem(
                    'Delete Account',
                    'Permanently delete your account and data',
                    Icons.delete_forever,
                    textColor: Colors.red,
                    onTap: () {
                      _showDeleteAccountDialog();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildPrivacyPolicyLink(),
                  const SizedBox(height: 16),
                  _buildTermsOfServiceLink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryPurple,
      ),
    );
  }

  Widget _buildSecurityItem(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            color: AppTheme.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            color: AppTheme.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicyLink() {
    return GestureDetector(
      onTap: () {
        // Navigate to privacy policy
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.privacy_tip_outlined,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Privacy Policy',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsOfServiceLink() {
    return GestureDetector(
      onTap: () {
        // Navigate to terms of service
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Terms of Service',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement password change logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                ),
                child: const Text('Change'),
              ),
            ],
          ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Two-Factor Authentication'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We will send a verification code to your registered mobile number each time you log in.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Verify Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _twoFactorEnabled = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement 2FA setup logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Two-factor authentication enabled'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                ),
                child: const Text('Enable'),
              ),
            ],
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
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This action cannot be undone. All your data will be permanently deleted.',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your password to confirm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement account deletion logic
                  Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Permanently'),
              ),
            ],
          ),
    );
  }
}
