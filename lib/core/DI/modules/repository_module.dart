import 'package:get_it/get_it.dart';

import '../../../data/datasources/posts_local_datasource.dart';
import '../../../data/datasources/posts_remote_datasource.dart';
import '../../../data/repositories/posts_repository_impl.dart';
import '../../../domain/repositories/posts_repository.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/get_post_details_usecase.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../network/dio_client.dart';
import '../../storage/hive_client.dart';

void initRepositoryModule(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImpl(sl<HiveClient>()),
  );

  // Repositories
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: sl<PostsRemoteDataSource>(),
      localDataSource: sl<PostsLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(sl<PostsRepository>()),
  );

  sl.registerLazySingleton<GetPostDetailsUseCase>(
    () => GetPostDetailsUseCase(sl<PostsRepository>()),
  );

  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<PostsRepository>()),
  );

  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<PostsRepository>()),
  );
}
