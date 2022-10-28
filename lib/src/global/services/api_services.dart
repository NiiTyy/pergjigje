import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pergjigje/src/global/models/category_model.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/constants/config.dart';
import 'package:pergjigje/src/global/models/search_model.dart';

class ApiServices {
  static var client = http.Client();

  static Future<List<CategoryModel>> fetchCategories(
      {required int pageNum}) async {
    var url = Config.apiUrl + Config.categoryUrl + pageNum.toString();
    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return categoryFromJson(jsonString);
    } else {
      List<CategoryModel> emptyList = [];
      return emptyList;
    }
  }

  static Future<List<PostModel>> fetchPosts({
    required int pageNum,
  }) async {
    var url = Config.apiUrl + Config.postsUrl + pageNum.toString();
    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;

      return postsFromJson(jsonString);
    } else {
      List<PostModel> emptyList = [];
      return emptyList;
    }
  }

  static Future<List<PostModel>> fetchCategoryPosts(
      {required int pageNum, required int categoryId}) async {
    var url = Config.apiUrl +
        Config.postFromCategory +
        categoryId.toString() +
        '&per_page=' +
        pageNum.toString();
    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return postsFromJson(jsonString);
    } else {
      List<PostModel> emptyList = [];
      return emptyList;
    }
  }

  static Future<List<PostModel>> fetchPostsFromSearch(
      {required String searchText, required int pageNum}) async {
    var url =
        Config.apiUrl + Config.searchUrl + searchText + '&per_page=$pageNum';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      List<PostModel> searchList = [];
      List<SearchModel> result = searchPostFromJson(jsonString);
      for (final item in result) {
        var response = await http.get(Uri.parse(
            'https://pergjigje.net/wp-json/wp/v2/posts/${item.postId}?_embed'));
        var str = response.body;
        var extractedData = json.decode(str);
        searchList.add(
          PostModel.fromJson(extractedData),
        );
      }
      return searchList;
    } else {
      List<PostModel> emptyList = [];
      return emptyList;
    }
  }
}
