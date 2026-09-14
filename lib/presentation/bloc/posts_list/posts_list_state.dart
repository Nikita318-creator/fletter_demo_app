import 'package:flutter/foundation.dart';
import '../../../domain/entities/post_entity.dart';

@immutable
sealed class PostsListState {
  const PostsListState();
}

final class PostsListInitial extends PostsListState {
  const PostsListInitial();
}

final class PostsListLoading extends PostsListState {
  const PostsListLoading();
}

final class PostsListData extends PostsListState {
  final List<PostEntity> posts;
  const PostsListData(this.posts);
}

final class PostsListEmpty extends PostsListState {
  const PostsListEmpty();
}

final class PostsListError extends PostsListState {
  final String message;
  const PostsListError(this.message);
}
