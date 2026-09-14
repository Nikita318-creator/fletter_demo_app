import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fletter_demo_app/core/result/result.dart';

import '../../../domain/usecases/get_favorites_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;

  FavoritesBloc(this._getFavoritesUseCase) : super(const FavoritesInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    final result = await _getFavoritesUseCase();

    switch (result) {
      case Success(data: final posts):
        if (posts.isEmpty) {
          emit(const FavoritesEmpty());
        } else {
          emit(FavoritesData(posts));
        }
      case Failure(failure: final failure):
        emit(FavoritesError(failure.message));
    }
  }
}
