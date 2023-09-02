import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  List<dynamic> services = [];

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://[2400:1a00:b030:5306::2]:5000/api/service/services'), // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          services = data['services'];
        });
      } else {
        // Handle error, show an error message to the user
        // For example:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to fetch services'),
        //   ),
        // );
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service List'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          final service = services[index];
          return Card(
            elevation: 3, // Add shadow to the card
            margin: EdgeInsets.all(10), // Add margin around the card
            child: ListTile(
              title: Text(
                service['serviceName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${service['description']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Duration: ${service['timeDuration']} minutes',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Price: \$${service['price']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
