import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MembershipTypeProvider with ChangeNotifier {
  static const String baseUrl = 'http://[2400:1a00:b030:9869::2]:5000/api/membershipType';

  List<dynamic> membershipTypes = [];

  // Constructor
  MembershipTypeProvider();

  // Fetch membership types from the API
  Future<void> fetchMembershipTypes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        membershipTypes = data['membershipTypes'];
        notifyListeners();
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Create a new membership type
  Future<void> createMembershipType({
    required String membershipType,
    required String description,
    required String status,
    required String discountPercentage,
  }) async {
    final Map<String, dynamic> membershipTypeData = {
      'membershipType': membershipType,
      'description': description,
      'status': status,
      'discountPercentage': discountPercentage,
    };

    final response = await _postRequest('$baseUrl', body: membershipTypeData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newMembershipType = responseData['membershipType'];
      membershipTypes.add(newMembershipType);
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Edit an existing membership type
  Future<void> editMembershipType({
    required int membershipTypeId,
    required String membershipType,
    required String description,
    required String status,
    required String discountPercentage,
  }) async {
    final Map<String, dynamic> membershipTypeData = {
      'membershipType': membershipType,
      'description': description,
      'status': status,
      'discountPercentage': discountPercentage,
    };

    final response = await _putRequest('$baseUrl/edit/$membershipTypeId', body: membershipTypeData);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Delete a membership type by its ID
  Future<void> deleteMembershipType(int membershipTypeId) async {
    final response = await _deleteRequest('$baseUrl/delete/$membershipTypeId');

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Helper method for handling HTTP POST requests
  Future<http.Response> _postRequest(String url, {required Map<String, dynamic> body}) async {
    return await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Helper method for handling HTTP PUT requests
  Future<http.Response> _putRequest(String url, {required Map<String, dynamic> body}) async {
    return await http.put(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Helper method for handling HTTP DELETE requests
  Future<http.Response> _deleteRequest(String url) async {
    return await http.delete(Uri.parse(url));
  }

  // Helper method for handling error responses
  void handleErrorResponse(http.Response response) {
    print('Error: ${response.statusCode} - ${response.reasonPhrase}');
  }
}
