import 'package:get_it/get_it.dart';
import '../../../core/storage/hive_client.dart';
import '../../../../features/posts/data/datasources/posts_local_datasource.dart';

Future<void> initLocalModule(GetIt sl) async {
  final hiveClient = HiveClient();
  await hiveClient.init();

  sl.registerLazySingleton<HiveClient>(() => hiveClient);

  // Регистрируем обновленный DataSource
  sl.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImpl(sl<HiveClient>()),
  );
}
