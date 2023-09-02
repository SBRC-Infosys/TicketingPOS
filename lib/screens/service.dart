import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({Key? key}) : super(key: key);

  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeDurationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _createService() async {
    final String serviceName = _serviceNameController.text;
    final String description = _descriptionController.text;
    final String timeDuration = _timeDurationController.text;
    final String price = _priceController.text;

    try {
      final response = await http.post(
        Uri.parse('http://[2400:1a00:b030:5306::2]:5000/api/service'), // Replace with your API endpoint
        body: {
          'serviceName': serviceName,
          'description': description,
          'timeDuration': timeDuration,
          'price': price,
        },
      );

      if (response.statusCode == 201) {
        // Service created successfully, show a success message or navigate to another page
        // For example:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Service created successfully'),
        //   ),
        // );
      } else {
        // Handle service creation error, display an error message to the user
        // For example:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to create service'),
        //   ),
        // );
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _serviceNameController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _timeDurationController,
              decoration: InputDecoration(labelText: 'Time Duration'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createService,
              child: Text('Create Service'),
            ),
          ],
        ),
      ),
    );
  }
}
