import 'dart:convert';

List<CategoryModel> categoryFromJson(String str) => List<CategoryModel>.from(
      json.decode(str).map(
            (x) => CategoryModel.fromJson(x),
          ),
    );

class CategoryModel {
  int? categoryId;
  String? categoryName;
  int? count;
  String? tag;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.count,
    required this.tag,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['name'];
    count = json['count'];
    tag = json['name'][0];
  }
}
