import 'breed.dart';

class CatImage {
  final String id;
  final String url;
  final List<Breed> breeds;

  CatImage({required this.id, required this.url, required this.breeds});

  factory CatImage.fromJson(Map<String, dynamic> json) {
    final breedsList = json['breeds'] as List<dynamic>? ?? [];

    return CatImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      breeds: breedsList.map((breed) => Breed.fromJson(breed)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'breeds': breeds.map((breed) => breed.toJson()).toList(),
    };
  }

  String get breedName =>
      breeds.isNotEmpty ? breeds.first.name : 'Неизвестная порода';

  Breed? get breed => breeds.isNotEmpty ? breeds.first : null;
}
