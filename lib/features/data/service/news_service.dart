import 'package:dio/dio.dart';
import 'package:news_apps/features/data/models/article_model.dart';

class NewsService {
  final Dio dio = Dio();
  final String apiKey = '5661802499cb481f8948f8f812a7a420';

  Future<List<ArticleModel>> getNews({required String category}) async {
    try {
      // تم إزالة country=us عشان الـ category تشتغل بشكل صحيح ودقيق
      var response = await dio.get(
        'https://newsapi.org/v2/top-headlines?apiKey=$apiKey&category=$category',
      );

      Map<String, dynamic> jsonData = response.data;
      List<dynamic> articles = jsonData['articles'];

      return articles.map((article) => ArticleModel.fromJson(article)).toList();
    } catch (e) {
      print('================ ERROR (getNews): $e ================');
      return [];
    }
  }

  Future<List<ArticleModel>> searchNews({required String query}) async {
    try {
      var response = await dio.get(
        'https://newsapi.org/v2/everything?apiKey=$apiKey&q=$query',
      );

      Map<String, dynamic> jsonData = response.data;
      List<dynamic> articles = jsonData['articles'];

      return articles.map((article) => ArticleModel.fromJson(article)).toList();
    } catch (e) {
      print('================ ERROR (searchNews): $e ================');
      return [];
    }
  }
}