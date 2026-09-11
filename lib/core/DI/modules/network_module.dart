import 'package:get_it/get_it.dart';
import '../../network/dio_client.dart';

void initNetworkModule(GetIt sl) {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}
