import 'dart:convert';

List<SearchModel> searchPostFromJson(String str) => List<SearchModel>.from(
      json.decode(str).map(
            (x) => SearchModel.fromJson(x),
          ),
    );

class SearchModel {
  int? postId;

  SearchModel({
    required this.postId,
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    postId = json['id'];
  }
}
