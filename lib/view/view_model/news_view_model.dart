import 'package:news_app_with_apis/model/categories_news_model.dart';
import 'package:news_app_with_apis/model/new_channel_headlines_model.dart';
import 'package:news_app_with_apis/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadliensApi(String source) async {
    final response = await _rep.fetchNewsChannelHeadliensApi(source);
    return response;
  }
   Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
