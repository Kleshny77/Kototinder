import 'package:flutter/material.dart';
import '../models/breed.dart';
import '../screens/breed_detail_screen.dart';

class BreedCard extends StatelessWidget {
  final Breed breed;

  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(
            breed.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: _BreedSubtitle(breed: breed),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _navigateToDetail(context),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BreedDetailScreen(breed: breed)),
    );
  }
}

class _BreedSubtitle extends StatelessWidget {
  final Breed breed;

  const _BreedSubtitle({required this.breed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breed.origin != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.public, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(breed.origin as String),
            ],
          ),
        ],
        if (breed.temperament != null) ...[
          const SizedBox(height: 4),
            Text(
            breed.temperament as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }
}
