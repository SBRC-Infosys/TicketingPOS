import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// A provider class for managing user data, including fetching and editing user profiles
class UserProvider with ChangeNotifier {
  /// The base URL of the remote API for user-related operations
  static const String baseUrl = 'https://demo.sbrcinfosys.com.np/api/user';

  /// Initialize a new instance of the UserProvider class
  UserProvider();

  /// A list to store user data fetched from the API
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

  /// Edit user information on the remote API
  ///
  /// Takes a [userId] and [userData] as parameters to update a user's information.
  /// Throws an exception if the API request fails.
Future<void> editUser(String userId, Map<String, dynamic> userData) async {
  try {
    final Uri url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.put(
      url,
      body: json.encode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
   
      final userIndex = users.indexWhere((user) => user['id'] == userId);
      if (userIndex != -1) {
        users[userIndex] = userData;
      }
      notifyListeners(); // Notify listeners of the change
    } else {
      throw Exception('Failed to edit user');
    }
  } catch (error) {
    throw error;
  }
}

}
