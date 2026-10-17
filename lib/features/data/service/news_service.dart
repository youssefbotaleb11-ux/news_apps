import 'package:dio/dio.dart';
import 'package:news_apps/features/data/models/article_model.dart';

class NewsService {
  final Dio dio = Dio();

  // ضع مفتاح NewsAPI الخاص بك هنا
  final String apiKey = 'A0845629a70045ef91dad8d3e1b63a1f';

  Future<List<ArticleModel>> getNews({
    required String category,
  }) async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'apiKey': apiKey,
          'category': category.toLowerCase(),
          'country': 'us',
        },
      );

      return _parseArticles(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }

    throw Exception('Failed to load news');
  }

  Future<List<ArticleModel>> searchNews({
    required String query,
  }) async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'apiKey': apiKey,
          'q': query,
          'language': 'en',
          'sortBy': 'publishedAt',
        },
      );

      return _parseArticles(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }

    throw Exception('Failed to search news');
  }

  List<ArticleModel> _parseArticles(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response from NewsAPI');
    }

    if (responseData['status'] != 'ok') {
      throw Exception(
        responseData['message'] ?? 'Failed to load articles',
      );
    }

    final articles = responseData['articles'];

    if (articles is! List) {
      throw Exception('Invalid articles data');
    }

    return articles
        .whereType<Map<String, dynamic>>()
        .map((article) => ArticleModel.fromJson(article))
        .toList();
  }

  Never _handleDioError(DioException e) {
    final data = e.response?.data;
    String message = 'Failed to connect to NewsAPI';

    if (data is Map<String, dynamic>) {
      final code = data['code'];
      final apiMessage = data['message'];

      if (code == 'apiKeyInvalid') {
        message =
            'Invalid API key. Check your NewsAPI account and key.';
      } else if (code == 'apiKeyExhausted') {
        message = 'NewsAPI request limit has been reached.';
      } else if (code == 'apiKeyDisabled') {
        message = 'Your NewsAPI key is disabled.';
      } else if (apiMessage != null) {
        message = apiMessage.toString();
      }
    } else if (e.message != null) {
      message = e.message!;
    }

    print('NewsAPI Error: $message');
    throw Exception(message);
  }
}