import 'package:flutter/material.dart';
import 'core/DI/injection.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clean Architecture Posts',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
