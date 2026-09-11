import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import 'posts_list_event.dart';
import 'posts_list_state.dart';

class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  final GetPostsUseCase _getPostsUseCase;

  PostsListBloc(this._getPostsUseCase) : super(const PostsListInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostsListState> emit,
  ) async {
    emit(const PostsListLoading());
    await _loadPosts(emit);
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostsListState> emit,
  ) async {
    await _loadPosts(emit);
  }

  Future<void> _loadPosts(Emitter<PostsListState> emit) async {
    final result = await _getPostsUseCase();

    switch (result) {
      case Success(data: final posts):
        if (posts.isEmpty) {
          emit(const PostsListEmpty());
        } else {
          emit(PostsListData(posts));
        }
      case Failure(failure: final failure):
        emit(PostsListError(failure.message));
    }
  }
}
