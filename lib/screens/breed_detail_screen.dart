import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/breed.dart';
import '../widgets/characteristic_bar.dart';

class BreedDetailScreen extends StatelessWidget {
  final Breed breed;
  final String? imageUrl;

  const BreedDetailScreen({super.key, required this.breed, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl as String,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 400,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 50),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (breed.origin != null)
                    Row(
                      children: [
                        const Icon(Icons.public, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          breed.origin as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),

                  if (breed.lifeSpan != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${breed.lifeSpan as String} лет',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  if (breed.description != null) ...[
                    const Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.description as String,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (breed.temperament != null) ...[
                    const Text(
                      'Темперамент',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (breed.temperament as String)
                          .split(', ')
                          .map(
                            (trait) => Chip(
                              label: Text(trait),
                              backgroundColor: Colors.deepPurple.shade50,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Характеристики',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (breed.adaptability != null)
                    CharacteristicBar(
                      label: 'Адаптивность',
                      value: breed.adaptability as int,
                    ),

                  if (breed.affectionLevel != null)
                    CharacteristicBar(
                      label: 'Уровень привязанности',
                      value: breed.affectionLevel as int,
                    ),

                  if (breed.childFriendly != null)
                    CharacteristicBar(
                      label: 'Дружелюбие к детям',
                      value: breed.childFriendly as int,
                    ),

                  if (breed.energyLevel != null)
                    CharacteristicBar(
                      label: 'Уровень энергии',
                      value: breed.energyLevel as int,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
