import 'dart:convert';

import 'package:intl/intl.dart';

List<PostModel> postsFromJson(String str) => List<PostModel>.from(
      json.decode(str).map(
            (x) => PostModel.fromJson(x),
          ),
    );

List<PostModel> searchFromJson(
        {required String str, required String mediaStr}) =>
    List<PostModel>.from(
      json.decode(str).map(
            (x) => PostModel.fromJson(x),
          ),
    );

PostModel postDetailsFromJson(String str) =>
    PostModel.fromJson(json.decode(str));

class PostModel {
  int? id;
  String? title;
  dynamic imageUrl;
  String? postedDate;
  String? author;
  String? postContent;

  PostModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.postedDate,
    required this.author,
    required this.postContent,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']['rendered'];
    imageUrl = json["_embedded"]["wp:featuredmedia"] == null
        ? 'https://pergjigje.net/wp-content/uploads/2021/09/Logo-e-544.png'
        : json["_embedded"]["wp:featuredmedia"][0]["source_url"];
    postedDate = DateFormat('MMMM d, yyyy').format(
      DateTime.parse(
        json['date'],
      ),
    );
    author = json["_embedded"]["author"][0]["name"];
    if (json['content']['rendered'] != null) {
      postContent = json['content']['rendered'];
    }
  }

  PostModel.searchFromJson(
      Map<String, dynamic> json, Map<String, dynamic> searchMediaJson) {
    id = json['id'];
    title = json['title']['rendered'];
    imageUrl = searchMediaJson['source_url'] == null
        ? 'https://via.placeholder.com/300x150.png'
        : json['source_url'];
    postedDate = DateFormat('MMMM d, yyyy').format(
      DateTime.parse(
        json['date'],
      ),
    );
    author = json["_embedded"]["author"][0]["name"];
    if (json['content']['rendered'] != null) {
      postContent = json['content']['rendered'];
    }
  }
}
