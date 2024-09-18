import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProfileButton extends StatelessWidget {
  final String url;
  const ViewProfileButton({super.key, required this.url});

  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      print('Attempting to launch URL: $url');
      if (await canLaunchUrl(uri)) {
        print('canLaunchUrl returned true');
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        print('launchUrl returned: $launched');
        if (!launched) {
          throw 'URL launch returned false';
        }
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: () => _launchURL(context, url),
      child: const Text('View Profile', style: TextStyle(color: Colors.black)),
    );
  }
}