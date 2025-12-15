import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black26),
        ],
      ),
    );
  }
}
