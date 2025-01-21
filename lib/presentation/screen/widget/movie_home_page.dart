import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key, required this.homepageUrl});

  final String? homepageUrl;

  Future<void> getLaunchUrl() async {
    if (!await launchUrl(Uri.parse(homepageUrl!))) {
      throw Exception('Could not launch $homepageUrl');
    }
  }

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.getLaunchUrl,
      child: const Icon(
        Icons.language,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
