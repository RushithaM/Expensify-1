import 'dart:convert';
import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:http/http.dart' as http;
import 'package:expensetracker/main.dart';

class CategoryProvider {
  List<Category> categories = [];
  Future<Map<String, dynamic>> getcategories(String user_id) async {
    final url = Uri.parse('${bUrl}/category/get_categories');
    final body = jsonEncode({"user_id": user_id});
    try {
      catPro.categories = [];
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 503) {
        return {'message': 'Service Unavailable'};
      }
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        catPro.categories = CategoryModel.fromJson(resp).categories;
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {
        'error': 'Something went wrong: $e',
        'message': 'something went wrong'
      };
    }
  }

  Future<Map<String, dynamic>> addcategory(
      String user_id, String category_name, String emoji) async {
    final url = Uri.parse('${bUrl}/category/add_category');
    final body = jsonEncode(
        {"user_id": user_id, "category_name": category_name, 'emoji': emoji});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        catPro.categories.add(Category(
            id: resp['category_id'],
            active: true,
            categoryName: category_name,
            emoji: emoji,
            userId: user_id));
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> deletecategory(String category_id) async {
    final url = Uri.parse('${bUrl}/category/delete_category');
    final body = jsonEncode({"category_id": category_id});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        catPro.categories.firstWhere((element) => element.id == category_id).active=false;
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'message': 'something went wrong'};
    }
  }

  Future<Map<String, dynamic>> editcategory(String category_id,
      String category_name, String emoji, String user_id) async {
    final url = Uri.parse('${bUrl}/category/edit_category');
    final body = jsonEncode({
      "category_id": category_id,
      "category_name": category_name,
      'emoji': emoji,
      'user_id': user_id
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        catPro.categories
            .firstWhere((element) => element.id == category_id)
            .categoryName = category_name;
        catPro.categories
            .firstWhere((element) => element.id == category_id)
            .emoji = emoji;
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'message': 'something went wrong'};
    }
  }
}
