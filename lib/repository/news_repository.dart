import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_with_apis/model/categories_news_model.dart';

import 'package:news_app_with_apis/model/new_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadliensApi(String source) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=c62e6bbda4b24be68e036e0242da80dc";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body.toString());
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }
    Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=c62e6bbda4b24be68e036e0242da80dc";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body.toString());
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Error");
  }
}
