import 'package:meta/meta.dart';
import '../../../domain/entities/post_entity.dart';

@immutable
sealed class PostDetailState {
  const PostDetailState();
}

final class PostDetailInitial extends PostDetailState {
  const PostDetailInitial();
}

final class PostDetailLoading extends PostDetailState {
  const PostDetailLoading();
}

final class PostDetailData extends PostDetailState {
  final PostEntity post;
  const PostDetailData(this.post);
}

final class PostDetailError extends PostDetailState {
  final String message;
  const PostDetailError(this.message);
}
