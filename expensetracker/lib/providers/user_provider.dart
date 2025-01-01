import 'dart:convert';

import 'package:expensetracker/main.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

class UserProvider {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('${bUrl}/users/login');
    final body = jsonEncode({"email": email, "password": password});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == 'success') {
        await prefs!.setBool('login', true);
        await prefs!.setString('email', resp['user']['email']);
        await prefs!.setString('name', resp['user']['name']);
        await prefs!.setString('id', resp['user']['id']);
        await prefs!
            .setString('amount', resp['user']['totalAmount'].toString());
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> signupUser(
      String name, String email, String password) async {
    final url = Uri.parse(
        '${bUrl}/users/signup');
    final body =
        jsonEncode({"email": email, "password": password, "name": name});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'].toString() == "success") {
        await prefs!.setBool('login', true);
        await prefs!.setString('email', email);
        await prefs!.setString('name', name);
        await prefs!.setString('id', resp['id']);
        await prefs!.setString('amount', '0');
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String name, String email, String user_id) async {
    final url = Uri.parse(
        '${bUrl}/users/edit_profile');
    final body = jsonEncode({"email": email, "name": name, 'user_id': user_id});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        await prefs!.setString('email', email);
        await prefs!.setString('name', name);
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }
}
