import 'dart:convert';
import '../../../../core/result/result.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_datasource.dart';
import '../datasources/posts_remote_datasource.dart';
import '../mappers/post_mapper.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<PostEntity>>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      final favorites = await localDataSource.getFavoriteIds();

      final entities = remotePosts
          .map((dto) => dto.toEntity(isFavorite: favorites.contains(dto.id)))
          .toList();

      await localDataSource.cachePosts(remotePosts);
      return Success(entities);
    } catch (_) {
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        if (cachedPosts.isNotEmpty) {
          final favorites = await localDataSource.getFavoriteIds();
          final entities = cachedPosts
              .map(
                (dto) => dto.toEntity(isFavorite: favorites.contains(dto.id)),
              )
              .toList();
          return Success(entities);
        }
        return const Failure(NetworkFailure());
      } catch (e) {
        return const Failure(CacheFailure());
      }
    }
  }

  @override
  Future<Result<PostEntity>> getPostDetails(int id) async {
    try {
      final postDto = await remoteDataSource.getPost(id);
      final userDto = await remoteDataSource.getUser(postDto.userId);
      final favorites = await localDataSource.getFavoriteIds();

      return Success(
        postDto.toEntity(
          authorName: userDto.name,
          isFavorite: favorites.contains(postDto.id),
        ),
      );
    } catch (_) {
      return const Failure(ServerFailure());
    }
  }

  @override
  Future<Result<List<PostEntity>>> getFavoritePosts() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Success(favorites);
    } catch (e) {
      return const Failure(CacheFailure());
    }
  }

  @override
  Future<Result<void>> toggleFavorite(PostEntity post) async {
    try {
      await localDataSource.toggleFavorite(post);
      return const Success(null);
    } catch (e) {
      return const Failure(CacheFailure());
    }
  }
}
