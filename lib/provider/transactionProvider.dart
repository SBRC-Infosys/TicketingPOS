import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  static const String baseUrl =
      'http://[2400:1a00:b030:5aff::2]:5000/api/transaction';

  TransactionProvider();
  List<dynamic> transactions = []; 

  // Create a new transaction
  Future<String?> createTransaction({
    required int serviceId,
    required double totalAmount,
    required String departureTime,
    String? status,
    int? timeDuration,
  }) async {
    final Map<String, dynamic> transactionData = {
      'serviceId': serviceId,
      'totalAmount': totalAmount,
      'departureTime': departureTime,
      'status': status,
      'timeDuration': timeDuration,
    };

    try {
      final response = await _postRequest('$baseUrl', body: transactionData);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newTransactionId = responseData['transactionId'];
        notifyListeners();
        return newTransactionId.toString();
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (error) {
      throw error;
    }
  }

  // Fetch transactions from the API
  Future<List<dynamic>> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transactions = data['transactions'];
        return transactions;
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (error) {
      throw error;
    }
  }

    Future<void> editTransactionStatus({
    required int transactionId,
    required String status,
  }) async {
    final Map<String, dynamic> statusData = {
      'status': status,
    };

    try {
      final response = await _putRequest('$baseUrl/$transactionId', body: statusData);

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to edit transaction status');
      }
    } catch (error) {
      throw error;
    }
  }





  Future<http.Response> _postRequest(String url,
      {required Map<String, dynamic> body}) async {
    return await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }


  Future<http.Response> _putRequest(String url,
      {required Map<String, dynamic> body}) async {
    return await http.put(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }

}
