import 'package:hive_flutter/hive_flutter.dart';

class HiveClient {
  static const String cachedPostsBoxName = 'cached_posts_box';
  static const String favoritesBoxName = 'favorites_box';

  late final Box<String> _cachedPostsBox;
  late final Box<String> _favoritesBox;

  Box<String> get cachedPostsBox => _cachedPostsBox;
  Box<String> get favoritesBox => _favoritesBox;

  Future<void> init() async {
    await Hive.initFlutter();

    _cachedPostsBox = await Hive.openBox<String>(cachedPostsBoxName);
    _favoritesBox = await Hive.openBox<String>(favoritesBoxName);
  }
}
