import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  static const String baseUrl = 'http://[2400:1a00:b030:bf51::2]:5000/api/user';

  UserProvider();
  List<dynamic> users = [];

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final Uri url = Uri.parse('$baseUrl/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> usersData = json.decode(response.body);

        if (usersData is List) {
          final List<Map<String, dynamic>> usersList =
              usersData.cast<Map<String, dynamic>>();
          return usersList;
        }
      }
      throw Exception('Failed to fetch users');
    } catch (error) {
      throw error;
    }
  }

  Future<void> editUser(String userId, Map<String, dynamic> userData) async {
    try {
      final Uri url =
          Uri.parse('$baseUrl/users/$userId'); // Assuming userId is provided
      final response = await http.put(
        url,
        body: json.encode(userData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // User information updated successfully
      } else {
        throw Exception('Failed to edit user');
      }
    } catch (error) {
      throw error;
    }
  }
}
