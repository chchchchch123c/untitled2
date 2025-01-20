import 'package:flutter/material.dart';

class MovieRuntime extends StatelessWidget {

  final int durationInMinutes;

  const MovieRuntime({super.key, required this.durationInMinutes});

  @override
  Widget build(BuildContext context) {
    final int hours = durationInMinutes ~/ 60;
    final int minutes = durationInMinutes % 60;
    return Text(' ${hours}h ${minutes}m', style: TextStyle(color: Colors.white, fontSize: 14),);
  }
}
