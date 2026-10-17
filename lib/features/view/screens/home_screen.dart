import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:news_apps/core/routes/app_routes.dart';
import 'package:news_apps/features/cubit/news_cubit.dart';
import 'package:news_apps/features/cubit/news_state.dart';
import 'package:news_apps/features/data/models/article_model.dart';
import 'package:news_apps/features/data/service/news_service.dart';
import 'package:news_apps/features/view/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'general';

  final List<String> categories = [
    'general',
    'business',
    'sports',
    'technology',
    'health',
    'science',
  ];

  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box<ArticleModel>('favorites_box');

    return BlocProvider(
      create: (_) => NewsCubit(NewsService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                widget.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: widget.onToggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected =
                      category == selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: ChoiceChip(
                      label: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        if (!selected) return;

                        setState(() {
                          selectedCategory = category;
                        });

                        this.context
                            .read<NewsCubit>()
                            .getNews(category: category);
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsInitialState ||
                      state is NewsLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is NewsErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'حدث خطأ أثناء تحميل الأخبار:\n'
                              '${state.errorMessage}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<NewsCubit>()
                                    .getNews(
                                      category: selectedCategory,
                                    );
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is NewsSuccessState) {
                    final articles = state.articles;

                    if (articles.isEmpty) {
                      return const Center(
                        child: Text('لا توجد أخبار حالياً'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];

                        return ValueListenableBuilder(
                          valueListenable:
                              favoritesBox.listenable(),
                          builder: (
                            context,
                            Box<ArticleModel> box,
                            _,
                          ) {
                            final isFavorite = box.values.any(
                              (item) =>
                                  item.title == article.title,
                            );

                            return Card(
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.details,
                                    arguments: article,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        if (article.image != null &&
                                            article.image!
                                                .isNotEmpty)
                                          Image.network(
                                            article.image!,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                height: 180,
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                                alignment:
                                                    Alignment.center,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                          )
                                        else
                                          Container(
                                            height: 180,
                                            width: double.infinity,
                                            color: Colors.grey[300],
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.newspaper,
                                              size: 48,
                                            ),
                                          ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.black54,
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                if (isFavorite) {
                                                  dynamic keyToDelete;

                                                  for (final key
                                                      in box.keys) {
                                                    final saved =
                                                        box.get(key);

                                                    if (saved?.title ==
                                                        article.title) {
                                                      keyToDelete = key;
                                                      break;
                                                    }
                                                  }

                                                  if (keyToDelete !=
                                                      null) {
                                                    await box.delete(
                                                      keyToDelete,
                                                    );
                                                  }
                                                } else {
                                                  await box.add(
                                                    article,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title.isNotEmpty
                                                ? article.title
                                                : 'بدون عنوان',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            article.subTitle ?? '',
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return const Center(
                    child: Text('في انتظار الأخبار...'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}