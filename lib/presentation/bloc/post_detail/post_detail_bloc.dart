import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletter_demo_app/core/result/result.dart';
import '../../../domain/usecases/get_post_details_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import 'post_detail_event.dart';
import 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostDetailsUseCase _getPostDetailsUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  PostDetailBloc({
    required GetPostDetailsUseCase getPostDetailsUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  }) : _getPostDetailsUseCase = getPostDetailsUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       super(const PostDetailInitial()) {
    on<FetchPostDetailEvent>(_onFetchPostDetail);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onFetchPostDetail(
    FetchPostDetailEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(const PostDetailLoading());

    final result = await _getPostDetailsUseCase(event.postId);

    switch (result) {
      case Success(data: final post):
        emit(PostDetailData(post));
      case Failure(failure: final failure):
        emit(PostDetailError(failure.message));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    final updatedPost = event.post.copyWith(isFavorite: !event.post.isFavorite);
    emit(PostDetailData(updatedPost));

    final result = await _toggleFavoriteUseCase(event.post);

    if (result is Failure) {
      // Откат состояния при ошибке сохранения
      emit(PostDetailData(event.post));
    }
  }
}
