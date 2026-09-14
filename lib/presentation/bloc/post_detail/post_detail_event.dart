import 'package:flutter/foundation.dart';
import '../../../domain/entities/post_entity.dart';

@immutable
sealed class PostDetailEvent {
  const PostDetailEvent();
}

final class FetchPostDetailEvent extends PostDetailEvent {
  final int postId;
  const FetchPostDetailEvent(this.postId);
}

final class ToggleFavoriteEvent extends PostDetailEvent {
  final PostEntity post;
  const ToggleFavoriteEvent(this.post);
}
