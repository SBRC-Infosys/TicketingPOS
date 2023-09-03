// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceProvider with ChangeNotifier {
  static const String baseUrl =
      'http://[2400:1a00:b030:5aff::2]:5000/api/service';

  List<dynamic> services = [];

  // Constructor
  ServiceProvider();

  // Fetch services from the API
  Future<void> fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        services = data['services'];
        notifyListeners();
      } else {

        handleErrorResponse(response);
      }
    } catch (e) {
     
      print('Error: $e');
    }
  }

  // Create a new service
  Future<void> createService({
    required String serviceName,
    required String description,
    required String timeDuration,
    required String price,
  }) async {
    final Map<String, dynamic> serviceData = {
      'serviceName': serviceName,
      'description': description,
      'timeDuration': timeDuration,
      'price': price,
    };

    // ignore: unnecessary_string_interpolations
    final response = await _postRequest('$baseUrl', body: serviceData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newService = responseData['service'];
      services.add(newService);
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Edit an existing service
  Future<void> editService({
    required int serviceId,
    required String serviceName,
    required String description,
    required String timeDuration,
    required String price,
  }) async {
    final Map<String, dynamic> serviceData = {
      'serviceName': serviceName,
      'description': description,
      'timeDuration': timeDuration,
      'price': price,
    };

    final response = await _putRequest('$baseUrl/edit/$serviceId', body: serviceData);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      handleErrorResponse(response);
    }
  }

  // Delete a service by its ID
  Future<void> deleteService(int serviceId) async {
    final response = await _deleteRequest('$baseUrl/services/$serviceId');

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


