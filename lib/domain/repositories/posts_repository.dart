import '../../../../core/result/result.dart';
import '../entities/post_entity.dart';

abstract interface class PostsRepository {
  Future<Result<List<PostEntity>>> getPosts();
  Future<Result<PostEntity>> getPostDetails(int id);
  Future<Result<List<PostEntity>>> getFavoritePosts();
  Future<Result<void>> toggleFavorite(PostEntity post);
}
