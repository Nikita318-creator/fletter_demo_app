import '../../../../core/result/result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository _repository;

  GetPostsUseCase(this._repository);

  Future<Result<List<PostEntity>>> call() {
    return _repository.getPosts();
  }
}
