import 'package:flutter/foundation.dart';

@immutable
sealed class FavoritesEvent {
  const FavoritesEvent();
}

final class FetchFavoritesEvent extends FavoritesEvent {
  const FetchFavoritesEvent();
}
