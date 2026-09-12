import 'package:get_it/get_it.dart';
import '../../../core/storage/hive_client.dart';

Future<void> initLocalModule(GetIt sl) async {
  final hiveClient = HiveClient();
  await hiveClient.init();

  sl.registerSingleton<HiveClient>(hiveClient);
}
