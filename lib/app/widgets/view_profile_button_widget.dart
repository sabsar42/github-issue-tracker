import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProfileButton extends StatelessWidget {
  final String url;
  const ViewProfileButton({Key? key, required this.url}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: () => _launchURL(url),
      child: const Text('View Profile', style: TextStyle(color: Colors.black)),
    );
  }
}
