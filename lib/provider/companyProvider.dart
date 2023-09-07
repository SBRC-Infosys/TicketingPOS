import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyProvider with ChangeNotifier {
  static const String baseUrl =  'http://[2400:1a00:b030:bf51::2]:5000/api/company';


  List<dynamic> companies = [];

  // Constructor
  CompanyProvider();

  // Fetch companies from the API
  Future<void> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        companies = data['companies'];
        notifyListeners();
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Create a new company
  Future<void> createCompany({
    required String companyName,
    required String companyAddress,
    required String companyPanVatNo,
    required String companyTelPhone,
    required String status,
  }) async {
    final Map<String, dynamic> companyData = {
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyPanVatNo': companyPanVatNo,
      'companyTelPhone': companyTelPhone,
      'status': status,
    };

    final response = await _postRequest('$baseUrl', body: companyData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newCompany = responseData['company'];
      companies.add(newCompany);
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Edit an existing company
  Future<void> editCompany({
    required int companyId,
    required String companyName,
    required String companyAddress,
    required String companyPanVatNo,
    required String companyTelPhone,
    required String status,
  }) async {
    final Map<String, dynamic> companyData = {
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyPanVatNo': companyPanVatNo,
      'companyTelPhone': companyTelPhone,
      'status': status,
    };

    final response = await _putRequest('$baseUrl/edit/$companyId', body: companyData);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Delete a company by its ID
  Future<void> deleteCompany(int companyId) async {
    final response = await _deleteRequest('$baseUrl/delete/$companyId');

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
