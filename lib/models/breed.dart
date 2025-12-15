class Breed {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? lifeSpan;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? energyLevel;
  final String? wikipediaUrl;

  Breed({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.lifeSpan,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.energyLevel,
    this.wikipediaUrl,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'],
      adaptability: json['adaptability'],
      affectionLevel: json['affection_level'],
      childFriendly: json['child_friendly'],
      energyLevel: json['energy_level'],
      wikipediaUrl: json['wikipedia_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'temperament': temperament,
      'origin': origin,
      'life_span': lifeSpan,
      'adaptability': adaptability,
      'affection_level': affectionLevel,
      'child_friendly': childFriendly,
      'energy_level': energyLevel,
      'wikipedia_url': wikipediaUrl,
    };
  }
}
