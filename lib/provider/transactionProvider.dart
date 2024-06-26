import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
static const String baseUrl = 'https://demo.sbrcinfosys.com.np/api/transaction';


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
Future<List<dynamic>> fetchTransactions({
  String? startDate,
  String? endDate,
  String? status,
}) async {
  try {
    // Create a map to store the filter parameters
    final Map<String, dynamic> queryParams = {};

    // Add filter parameters to the queryParams map if they are provided
    if (startDate != null) {
      queryParams['startDate'] = startDate;
    }

    if (endDate != null) {
      queryParams['endDate'] = endDate;
    }


    if (status != null) {
      queryParams['status'] = status;
    }

    // Construct the URL with query parameters
    final Uri url = Uri.parse('$baseUrl/fetch').replace(queryParameters: queryParams);

    // Make the HTTP GET request
    final response = await http.get(url);

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

   Future<void> deleteTransaction(int transactionId) async {
    try {
      final response = await _deleteRequest('$baseUrl/$transactionId');

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to delete transaction');
      }
    } catch (error) {
      throw error;
    }
  }

    Future<Map<String, dynamic>> fetchServiceEarnings(int serviceId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/earnings/$serviceId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch service earnings');
      }
    } catch (error) {
      throw error;
    }
  }

  // Add a method to get transaction statistics by service ID
  Future<Map<String, dynamic>> getTransactionStatsByService(int serviceId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/stats/$serviceId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to get transaction statistics by service ID');
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

  Future<http.Response> _deleteRequest(String url) async {
    return await http.delete(
      Uri.parse(url),
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
