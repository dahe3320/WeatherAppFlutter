import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'about_page.dart';
import 'weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _route = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WeatherApp()),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _route,
    );
  }
}
