import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  static const String baseUrl =
      'http://[2400:1a00:b030:5aff::2]:5000/api/transaction';

  List<dynamic> transactions = [];

  // Constructor
  TransactionProvider();

  // Fetch transactions from the API
  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        transactions = data['transactions'];
        notifyListeners();
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Create a new transaction
  Future<void> createTransaction({
    required int serviceId,
    int? membershipId,
    required double discountAmount,
    required double discountPercent,
    required double totalAmount,
    String status = 'open',
  }) async {
    final Map<String, dynamic> transactionData = {
      'serviceId': serviceId,
      'membershipId': membershipId,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'totalAmount': totalAmount,
      'status': status,
    };

    final response = await _postRequest('$baseUrl', body: transactionData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newTransaction = responseData['transaction'];
      transactions.add(newTransaction);
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Edit an existing transaction
  Future<void> editTransaction({
    required int transactionId,
    required int serviceId,
    int? membershipId,
    required double discountAmount,
    required double discountPercent,
    required double totalAmount,
    required DateTime departureTime,
    String status = 'open',
  }) async {
    final Map<String, dynamic> transactionData = {
      'serviceId': serviceId,
      'membershipId': membershipId,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'totalAmount': totalAmount,
      'departureTime': departureTime.toIso8601String(),
      'status': status,
    };

    final response = await _putRequest('$baseUrl/edit/$transactionId', body: transactionData);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Delete a transaction by its ID
  Future<void> deleteTransaction(int transactionId) async {
    final response = await _deleteRequest('$baseUrl/delete/$transactionId');

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
