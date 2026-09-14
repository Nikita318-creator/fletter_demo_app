import '../../../../core/result/result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetFavoritesUseCase {
  final PostsRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Result<List<PostEntity>>> call() {
    return _repository.getFavoritePosts();
  }
}
