import 'package:flutter/material.dart';
import 'package:news_apps/core/routes/app_routes.dart';
import 'package:news_apps/features/data/models/article_model.dart';
import 'package:news_apps/features/data/service/news_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final NewsService _newsService = NewsService();

  List<ArticleModel> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSearched = false;

  Future<void> _performSearch(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = null;
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      final results =
          await _newsService.searchNews(query: trimmedQuery);

      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء البحث، حاول مرة أخرى.';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'ابحث عن الأخبار...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                _performSearch(_searchController.text),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : !_hasSearched
                  ? const Center(
                      child: Text('اكتب كلمة للبحث عن الأخبار'),
                    )
                  : _searchResults.isEmpty
                      ? const Center(
                          child: Text('لا توجد نتائج للبحث'),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final article = _searchResults[index];

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
                                    if (article.image != null &&
                                        article.image!.isNotEmpty)
                                      Image.network(
                                        article.image!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 180,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? '',
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
                                              color: Colors.grey,
                                              fontSize: 12,
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
                        ),
    );
  }
}