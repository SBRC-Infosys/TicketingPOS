import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  static const String baseUrl = 'http://[2400:1a00:b030:bf51::2]:5000/api/user';

  // Constructor
  UserProvider();

  // Login function
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> userData = {
      'email': email,
      'password': password,
    };

    try {
      final response =
          await _postRequest('$baseUrl/login', body: userData, authToken: '');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Handle the response as needed (e.g., store user data or tokens).
        // Notify listeners if necessary.
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }



// Helper method for handling HTTP POST requests with authentication token
  Future<http.Response> _postRequest(
    String url, {
    required Map<String, dynamic> body,
    required String authToken, // Include the authentication token
  }) async {
    return await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $authToken', // Include the token in the request headers
      },
    );
  }

  // Helper method for handling error responses
  void handleErrorResponse(http.Response response) {
    print('Error: ${response.statusCode} - ${response.reasonPhrase}');
  }
}
