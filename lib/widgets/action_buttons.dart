import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDislike;
  final VoidCallback onLike;

  const ActionButtons({
    super.key,
    required this.onDislike,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: onDislike,
          ),
          const SizedBox(width: 20),
          _ActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            onPressed: onLike,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: icon.toString(),
        onPressed: onPressed,
        backgroundColor: Colors.white,
        elevation: 0,
        child: Icon(icon, size: 36, color: color),
      ),
    );
  }
}
