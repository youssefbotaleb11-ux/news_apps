import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:news_apps/core/routes/app_routes.dart';
import 'package:news_apps/features/data/models/article_model.dart';
import 'package:news_apps/features/cubit/news_cubit.dart';
import 'package:news_apps/features/data/service/news_service.dart';
import 'package:news_apps/features/view/screens/home_screen.dart';
import 'package:news_apps/features/view/screens/details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<ArticleModel>('favorites_box');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      initialRoute: AppRoutes.home,

      // استخدام الـ routes المباشرة لتجنب مشاكل onGenerateRoute
      routes: {
        AppRoutes.home: (context) => BlocProvider(
              create: (_) => NewsCubit(NewsService()),
              child: HomeScreen(
                isDarkMode: isDarkMode,
                onToggleTheme: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
              ),
            ),
        AppRoutes.details: (context) => const DetailsScreen(),
      },
    );
  }
}