import '../../models/breed.dart';
import '../../models/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_datasource.dart';

class CatRepositoryImpl implements CatRepository {
  CatRepositoryImpl(this._remote);

  final CatRemoteDataSource _remote;

  @override
  Future<CatImage> getRandomCatImage() => _remote.fetchRandomCatImage();

  @override
  Future<List<Breed>> getAllBreeds() => _remote.fetchAllBreeds();

  @override
  Future<List<CatImage>> getBreedImages(String breedId, {int limit = 5}) =>
      _remote.fetchBreedImages(breedId, limit: limit);
}
