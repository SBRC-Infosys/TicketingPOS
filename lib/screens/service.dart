import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeDurationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _createService() async {
    if (_formKey.currentState!.validate()) {
      final String serviceName = _serviceNameController.text;
      final String description = _descriptionController.text;
      final String timeDuration = _timeDurationController.text;
      final String price = _priceController.text;

      try {
        final response = await http.post(
          Uri.parse(
              'http://[2400:1a00:b030:5306::2]:5000/api/service'),
          body: {
            'serviceName': serviceName,
            'description': description,
            'timeDuration': timeDuration,
            'price': price,
          },
        );

        if (response.statusCode == 201) {
          // Service created successfully, show an alert
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Service Created'),
                content: const Text('Service has been created successfully.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the alert dialog
                    },
                  ),
                ],
              );
            },
          );

          // Clear the text controllers to reset the form
          _serviceNameController.clear();
          _descriptionController.clear();
          _timeDurationController.clear();
          _priceController.clear();
        } else {}
      } catch (e) {
        // Handle any network or server errors
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeDurationController,
                decoration: const InputDecoration(
                  labelText: 'Time Duration',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a time duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createService,
                child: const Text('Create Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
