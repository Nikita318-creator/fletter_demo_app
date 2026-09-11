import 'package:get_it/get_it.dart';
import 'modules/network_module.dart';
import 'modules/local_module.dart';
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await initLocalModule(sl);
  initNetworkModule(sl);
  initRepositoryModule(sl);
  initBlocModule(sl);
}
