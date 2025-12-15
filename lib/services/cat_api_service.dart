import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_image.dart';
import '../models/breed.dart';

class CatApiService {
  static const String baseUrl = 'https://api.thecatapi.com/v1';

  static const String apiKey =
      'live_0FKDmwJ6e5pYTtMcPgSSFoygTDgQOGF0hTl6UV7cg57wllLf9Sq2q6IiIGob43du';

  Future<CatImage> getRandomCatImage() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/images/search?has_breeds=1'),
        headers: apiKey.startsWith('live_PASTE') ? {} : {'x-api-key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return CatImage.fromJson(data[0]);
        } else {
          throw Exception('Не удалось получить изображение котика');
        }
      } else {
        throw Exception('Ошибка при загрузке: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Получить список всех пород
  Future<List<Breed>> getAllBreeds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/breeds'),
        headers: apiKey.startsWith('live_PASTE') ? {} : {'x-api-key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((breed) => Breed.fromJson(breed)).toList();
      } else {
        throw Exception('Ошибка при загрузке пород: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Получить изображения для конкретной породы
  Future<List<CatImage>> getBreedImages(String breedId, {int limit = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/images/search?breed_ids=$breedId&limit=$limit'),
        headers: apiKey.startsWith('live_PASTE') ? {} : {'x-api-key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((image) => CatImage.fromJson(image)).toList();
      } else {
        throw Exception(
          'Ошибка при загрузке изображений: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }
}
