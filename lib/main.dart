import 'package:flutter/material.dart';
import 'package:news_apps/core/routes/app_routes.dart';
import 'package:news_apps/features/view/screens/details_screen.dart';
import 'package:news_apps/features/view/screens/home_screen.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.details: (context) => const DetailsScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}