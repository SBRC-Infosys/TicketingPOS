import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceProvider with ChangeNotifier {
  static const String baseUrl =
      'http://[2400:1a00:b030:9869::2]:5000/api/service';

  List<dynamic> services = [];

  Future<void> fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        services = data['services'];
        notifyListeners();
      } else {
        // Handle error cases, e.g., show an error message to the user
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }

  Future<void> createService({
    required String serviceName,
    required String description,
    required String timeDuration,
    required String price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        body: {
          'serviceName': serviceName,
          'description': description,
          'timeDuration': timeDuration,
          'price': price,
        },
      );

      if (response.statusCode == 201) {
      // Service created successfully, you can handle the response if needed
      // For example, you can parse and store the created service data
      // Then notify listeners to update UI if needed

      // Parse the response data if needed and add it to the services list
      final responseData = json.decode(response.body);
      final newService = responseData['service'];

      // Add the new service to the services list
      services.add(newService);

      // Notify listeners to update UI
      notifyListeners();
    } else {
      // Handle error cases, e.g., show an error message to the user
    }
  } catch (e) {
    // Handle any network or server errors
    print('Error: $e');
  }
}

  Future<void> editService({
    required int serviceId,
    required String serviceName,
    required String description,
    required String timeDuration,
    required String price,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/edit/$serviceId'),
        body: {
          'serviceName': serviceName,
          'description': description,
          'timeDuration': timeDuration,
          'price': price,
        },
      );

      if (response.statusCode == 200) {
        // Service edited successfully, you can handle the response if needed
        // For example, you can parse and store the updated service data
        // Then notify listeners to update UI if needed
        notifyListeners();
      } else {
        // Handle error cases, e.g., show an error message to the user
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }

  Future<void> deleteService(int serviceId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/services/$serviceId'),
      );

      if (response.statusCode == 200) {
        // Service deleted successfully, you can handle the response if needed
        // Then notify listeners to update UI if needed
        notifyListeners();
      } else {
        // Handle error cases, e.g., show an error message to the user
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }
}
