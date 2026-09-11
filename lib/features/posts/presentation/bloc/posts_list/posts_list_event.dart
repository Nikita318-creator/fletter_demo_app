import 'package:meta/meta.dart';

@immutable
sealed class PostsListEvent {
  const PostsListEvent();
}

final class FetchPostsEvent extends PostsListEvent {
  const FetchPostsEvent();
}

final class RefreshPostsEvent extends PostsListEvent {
  const RefreshPostsEvent();
}
