import 'package:meta/meta.dart';
import '../../../domain/entities/post_entity.dart';

@immutable
sealed class FavoritesState {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesData extends FavoritesState {
  final List<PostEntity> posts;
  const FavoritesData(this.posts);
}

final class FavoritesEmpty extends FavoritesState {
  const FavoritesEmpty();
}

final class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
