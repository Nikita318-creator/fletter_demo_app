import '../../../../core/result/result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class ToggleFavoriteUseCase {
  final PostsRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Result<void>> call(PostEntity post) {
    return _repository.toggleFavorite(post);
  }
}
