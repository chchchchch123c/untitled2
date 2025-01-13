import 'package:flutter/material.dart';

class MovieIcon extends StatelessWidget {
  const MovieIcon({super.key, required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF414141)
      ),
      child: Center(
          child: Icon(icon.icon, color: Colors.white, size: 23,)
      ),
    );
  }
}
