import '../../models/breed.dart';
import '../../models/cat_image.dart';

abstract class CatRepository {
  Future<CatImage> getRandomCatImage();
  Future<List<Breed>> getAllBreeds();
  Future<List<CatImage>> getBreedImages(String breedId, {int limit = 5});
}
