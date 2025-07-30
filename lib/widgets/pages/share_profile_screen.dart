import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import 'package:get/get.dart';

class ShareProfileScreen extends StatefulWidget {
  const ShareProfileScreen({Key? key}) : super(key: key);

  @override
  State<ShareProfileScreen> createState() => _ShareProfileScreenState();
}

class _ShareProfileScreenState extends State<ShareProfileScreen> {
  final GlobalKey qrKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    final userData = authProvider.user.value;
    final username = userData?['username'] ?? 'username';
    final profileUrl = 'https://influnew.app/profile/$username';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.purpleGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'COLOUR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/favicon.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer to center the QR code
              const Spacer(),

              // QR Code Container
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // QR Code with app logo in center
                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: profileUrl,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryPurple,
                          embeddedImage: const AssetImage(
                            'assets/images/favicon.png',
                          ),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(40, 40),
                          ),
                          gapless: false,
                          errorStateBuilder: (cxt, err) {
                            return Container(
                              child: const Center(
                                child: Text(
                                  'QR Code Error',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Username
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/favicon.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.share,
                        label: 'Share profile',
                        onTap: () => _shareProfile(profileUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.link,
                        label: 'Copy link',
                        onTap: () => _copyProfileLink(profileUrl, context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.download,
                        label: 'Download',
                        onTap: () => _downloadQRCode(context),
                        isLoading: _isSaving,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            isLoading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryPurple,
                    ),
                  ),
                )
                : Icon(icon, color: AppTheme.primaryPurple, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Copy profile link to clipboard
  void _copyProfileLink(String url, BuildContext context) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Share profile link
  void _shareProfile(String url) async {
    try {
      // Using url_launcher to share via system share sheet
      final uri = Uri.parse('mailto:?subject=Check out my profile&body=$url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Fallback to clipboard if sharing fails
        await Clipboard.setData(ClipboardData(text: url));
      }
    } catch (e) {
      debugPrint('Error sharing profile: $e');
    }
  }

  // Download QR code as image
  Future<void> _downloadQRCode(BuildContext context) async {
    try {
      setState(() {
        _isSaving = true;
      });

      // Get the RenderRepaintBoundary object
      final RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Convert to image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ImageByteFormat.png,
      );

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/influnew_qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
        final File file = File(imagePath);

        // Write file
        await file.writeAsBytes(pngBytes);

        setState(() {
          _isSaving = false;
        });

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR Code saved to: $imagePath'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save QR Code: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      debugPrint('Error saving QR code: $e');
    }
  }
}
