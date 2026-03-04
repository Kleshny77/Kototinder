import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/env.dart';
import '../../models/breed.dart';
import '../../models/cat_image.dart';

abstract class CatRemoteDataSource {
  Future<CatImage> fetchRandomCatImage();
  Future<List<Breed>> fetchAllBreeds();
  Future<List<CatImage>> fetchBreedImages(String breedId, {int limit = 5});
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  CatRemoteDataSourceImpl({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.thecatapi.com/v1';

  final String _baseUrl;

  Map<String, String> get _headers {
    final key = Env.catApiKey;
    if (key.isEmpty) return {};
    return {'x-api-key': key};
  }

  @override
  Future<CatImage> fetchRandomCatImage() async {
    const limit = 10;
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=1&limit=$limit'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw CatApiException('Ошибка загрузки: ${response.statusCode}');
    }
    final list = json.decode(response.body) as List<dynamic>;
    if (list.isEmpty) {
      throw CatApiException('Нет данных');
    }
    for (final item in list) {
      final map = item as Map<String, dynamic>;
      final breeds = map['breeds'] as List<dynamic>?;
      if (breeds != null && breeds.isNotEmpty) {
        return CatImage.fromJson(map);
      }
    }
    return CatImage.fromJson(list[0] as Map<String, dynamic>);
  }

  @override
  Future<List<Breed>> fetchAllBreeds() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/breeds'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw CatApiException('Ошибка загрузки пород: ${response.statusCode}');
    }
    final list = json.decode(response.body) as List<dynamic>;
    return list
        .map((e) => Breed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CatImage>> fetchBreedImages(String breedId,
      {int limit = 5}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?breed_ids=$breedId&limit=$limit'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw CatApiException('Ошибка загрузки изображений: ${response.statusCode}');
    }
    final list = json.decode(response.body) as List<dynamic>;
    return list
        .map((e) => CatImage.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class CatApiException implements Exception {
  CatApiException(this.message);
  final String message;
}
