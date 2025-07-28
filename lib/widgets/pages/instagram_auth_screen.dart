import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/instagram_service.dart';
import '../../app_theme.dart';

class InstagramAuthScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAuthComplete;

  const InstagramAuthScreen({Key? key, required this.onAuthComplete})
    : super(key: key);

  @override
  State<InstagramAuthScreen> createState() => _InstagramAuthScreenState();
}

class _InstagramAuthScreenState extends State<InstagramAuthScreen> {
  late final WebViewController _controller;
  final InstagramService _instagramService = InstagramService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith(
                  'https://influ.in/auth/instagram/callback',
                )) {
                  _handleCallback(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(_instagramService.getInstagramAuthUrl()));
  }

  void _handleCallback(String url) async {
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];
    final error = uri.queryParameters['error'];

    if (error != null) {
      widget.onAuthComplete({
        'success': false,
        'message': 'Authorization failed: $error',
      });
      Navigator.of(context).pop();
      return;
    }

    if (code != null && state != null) {
      setState(() {
        _isLoading = true;
      });

      final result = await _instagramService.exchangeCodeForToken(code, state);
      widget.onAuthComplete(result);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Instagram'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onAuthComplete({
              'success': false,
              'message': 'Cancelled by user',
            });
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
