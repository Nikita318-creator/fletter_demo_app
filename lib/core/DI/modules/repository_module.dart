import 'package:get_it/get_it.dart';

import 'package:fletter_demo_app/core/network/dio_client.dart';
import 'package:fletter_demo_app/core/storage/hive_client.dart';
import '../../../../features/posts/data/datasources/posts_local_datasource.dart';
import '../../../../features/posts/data/datasources/posts_remote_datasource.dart';
import '../../../../features/posts/data/repositories/posts_repository_impl.dart';
import '../../../../features/posts/domain/repositories/posts_repository.dart';
import '../../../../features/posts/domain/usecases/get_favorites_usecase.dart';
import '../../../../features/posts/domain/usecases/get_post_details_usecase.dart';
import '../../../../features/posts/domain/usecases/get_posts_usecase.dart';
import '../../../../features/posts/domain/usecases/toggle_favorite_usecase.dart';

void initRepositoryModule(GetIt sl) {
  // Data Sources (абстракция -> реализация)
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImpl(sl<HiveClient>()),
  );

  // Repository (абстракция -> реализация)
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
