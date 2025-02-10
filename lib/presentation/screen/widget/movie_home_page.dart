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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
              color: Color(0xFF414141),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}
