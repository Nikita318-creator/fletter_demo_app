import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initLocalModule(GetIt sl) async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
}
