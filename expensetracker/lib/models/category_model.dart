// To parse this JSON data, do
//
//     final CategoryModel = CategoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel CategoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String CategoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<Category> categories;

  CategoryModel({
    required this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  String id;
  bool active;
  String categoryName;
  String emoji;
  String userId;
  double budget;
  String type;

  Category(
      {required this.id,
      required this.active,
      required this.categoryName,
      required this.emoji,
      required this.userId,
      required this.type,
      required this.budget});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        active: json["active"],
        categoryName: json["category_name"],
        emoji: json["emoji"],
        userId: json["user_id"],
        budget: json["budget"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "active": active,
        "category_name": categoryName,
        "emoji": emoji,
        "user_id": userId,
        "budget": budget,
        "type": type,
      };
}
