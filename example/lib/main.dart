import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'view_models.dart';
import 'views.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _routerConfig;

  @override
  void initState() {
    super.initState();
    _routerConfig = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ViewModelBinding(
            viewBuilder: () => HomeView(),
            viewModelBuilder: () => HomeViewModel(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _routerConfig,
      theme: ThemeData(
        dataTableTheme: DataTableThemeData(
          horizontalMargin: 8.0,
          columnSpacing: 8.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _routerConfig.dispose();
    super.dispose();
  }
}
