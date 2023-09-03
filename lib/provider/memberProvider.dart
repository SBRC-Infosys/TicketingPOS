import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberProvider with ChangeNotifier {
  static const String baseUrl = 'http://[2400:1a00:b030:3592::2]:5000/api/member';

  List<dynamic> members = [];

  // Constructor
  MemberProvider();

  // Fetch members from the API
  Future<void> fetchMembers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        members = data['members'];
        notifyListeners();
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Create a new member
  Future<void> createMember({
    required int membershipTypeId,
    required String memberName,
    required String memberAddress,
    required String memberEmail,
    required String memberPhone,
    required String startDate,
    required String endDate,
    required String status,
    required String discountPercentage,
  }) async {
    final Map<String, dynamic> memberData = {
      'membershipTypeId': membershipTypeId,
      'memberName': memberName,
      'memberAddress': memberAddress,
      'memberEmail': memberEmail,
      'memberPhone': memberPhone,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'discountPercentage': discountPercentage,
    };

    final response = await _postRequest('$baseUrl', body: memberData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newMember = responseData['member'];
      members.add(newMember);
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Edit an existing member
  Future<void> editMember({
    required int memberId,
    required int membershipTypeId,
    required String memberName,
    required String memberAddress,
    required String memberEmail,
    required String memberPhone,
    required String startDate,
    required String endDate,
    required String status,
    required String discountPercentage,
  }) async {
    final Map<String, dynamic> memberData = {
      'membershipTypeId': membershipTypeId,
      'memberName': memberName,
      'memberAddress': memberAddress,
      'memberEmail': memberEmail,
      'memberPhone': memberPhone,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'discountPercentage': discountPercentage,
    };

    final response = await _putRequest('$baseUrl/edit/$memberId', body: memberData);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Delete a member by its ID
  Future<void> deleteMember(int memberId) async {
    final response = await _deleteRequest('$baseUrl/delete/$memberId');

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
