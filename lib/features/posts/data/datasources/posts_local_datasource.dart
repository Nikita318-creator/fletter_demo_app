import 'dart:convert';
import '../../../../core/storage/hive_client.dart';
import '../models/post_dto.dart';

abstract interface class PostsLocalDataSource {
  Future<void> cachePosts(List<PostDto> posts);
  Future<List<PostDto>> getCachedPosts();
  Future<Set<int>> getFavoriteIds();
  Future<List<PostDto>> getFavorites();
  Future<void> toggleFavorite(PostDto post);
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  final HiveClient _hiveClient;

  static const String _cachedPostsKey = 'CACHED_POSTS';
  static const String _favoritesKey = 'FAVORITE_POSTS';

  PostsLocalDataSourceImpl(this._hiveClient);

  @override
  Future<void> cachePosts(List<PostDto> posts) async {
    final jsonList = posts.map((p) => p.toJson()).toList();
    await _hiveClient.cachedPostsBox.put(_cachedPostsKey, jsonEncode(jsonList));
  }

  @override
  Future<List<PostDto>> getCachedPosts() async {
    final jsonString = _hiveClient.cachedPostsBox.get(_cachedPostsKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString) as List;
    return decoded
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    final favorites = await getFavorites();
    return favorites.map((e) => e.id).toSet();
  }

  @override
  Future<List<PostDto>> getFavorites() async {
    final jsonString = _hiveClient.favoritesBox.get(_favoritesKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString) as List;
    return decoded
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> toggleFavorite(PostDto post) async {
    final currentFavorites = await getFavorites();
    final index = currentFavorites.indexWhere((e) => e.id == post.id);

    if (index >= 0) {
      currentFavorites.removeAt(index);
    } else {
      currentFavorites.add(post);
    }

    final rawList = currentFavorites.map((e) => e.toJson()).toList();
    await _hiveClient.favoritesBox.put(_favoritesKey, jsonEncode(rawList));
  }
}
