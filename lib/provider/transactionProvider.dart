import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  static const String baseUrl = 'http://[2400:1a00:b030:5aff::2]:5000/api/transaction';

  // Constructor
  TransactionProvider();

  // Create a new transaction
Future<String?> createTransaction({
  required int serviceId,
  required double totalAmount,
  required String departureTime,
  required String status,
}) async {
  final Map<String, dynamic> transactionData = {
    'serviceId': serviceId,
    'totalAmount': totalAmount,
    'departureTime': departureTime,
    'status': status,
  };

  try {
    final response = await _postRequest('$baseUrl', body: transactionData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newTransactionId = responseData['transactionId'];
      notifyListeners();
      // Return the newly created transaction ID as a string
      return newTransactionId.toString(); // Ensure it's converted to a string
    } else {
      // Handle error response
      throw Exception('Failed to create transaction');
    }
  } catch (error) {
    // Handle any exceptions
    // ignore: use_rethrow_when_possible
    throw error;
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

  getTransactionId() {}
}
