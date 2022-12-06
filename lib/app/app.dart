import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/app/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return MaterialApp.router(
        title: 'Flutter Multi Factor Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        routerConfig: ref.watch(routerProvider),
      );
    });
  }
}
