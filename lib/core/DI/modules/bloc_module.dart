import 'package:get_it/get_it.dart';

import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/get_post_details_usecase.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../../presentation/bloc/favorites/favorites_bloc.dart';
import '../../../presentation/bloc/post_detail/post_detail_bloc.dart';
import '../../../presentation/bloc/posts_list/posts_list_bloc.dart';

void initBlocModule(GetIt sl) {
  // Posts List BLoC
  sl.registerFactory<PostsListBloc>(() => PostsListBloc(sl<GetPostsUseCase>()));

  // Post Detail BLoC
  sl.registerFactory<PostDetailBloc>(
    () => PostDetailBloc(
      getPostDetailsUseCase: sl<GetPostDetailsUseCase>(),
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
    ),
  );

  // Favorites BLoC
  sl.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(sl<GetFavoritesUseCase>()),
  );
}
