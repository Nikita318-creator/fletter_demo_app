import '../../../../core/result/result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostDetailsUseCase {
  final PostsRepository _repository;

  GetPostDetailsUseCase(this._repository);

  Future<Result<PostEntity>> call(int id) {
    return _repository.getPostDetails(id);
  }
}
