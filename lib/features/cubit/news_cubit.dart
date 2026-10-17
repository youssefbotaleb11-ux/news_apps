import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_apps/features/data/models/article_model.dart';
import 'package:news_apps/features/data/service/news_service.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsService newsService;

  NewsCubit(this.newsService) : super(NewsInitialState()) {
    getNews(category: 'general');
  }

  Future<void> getNews({required String category}) async {
    emit(NewsLoadingState());

    try {
      final List<ArticleModel> articles =
          await newsService.getNews(category: category);

      emit(NewsSuccessState(articles));
    } catch (e) {
      emit(NewsErrorState(e.toString()));
    }
  }
}