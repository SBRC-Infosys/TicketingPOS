// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch services when the screen is initialized
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    serviceProvider.fetchServices();
  }

  void _editServiceDialog(BuildContext context, Map<String, dynamic> service) {
    String updatedServiceName = service['serviceName'];
    String updatedDescription = service['description'];
    int updatedTimeInMinutes =
        int.tryParse(service['timeDuration'].toString()) ?? 0;
    String updatedPrice = service['price'];

    TextEditingController _timeDurationController = TextEditingController(
      text:
          '${updatedTimeInMinutes ~/ 60} hours, ${updatedTimeInMinutes % 60} minutes',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Service'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedServiceName,
                      onChanged: (value) {
                        updatedServiceName = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Service Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedDescription,
                      onChanged: (value) {
                        updatedDescription = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      readOnly: true,
                      controller: _timeDurationController, // Use a controller
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: updatedTimeInMinutes ~/ 60,
                            minute: updatedTimeInMinutes % 60,
                          ),
                        );

                        if (selectedTime != null) {
                          final hours = selectedTime.hour;
                          final minutes = selectedTime.minute;
                          setState(() {
                            updatedTimeInMinutes = (hours * 60) + minutes;
                            _timeDurationController.text =
                                '${hours} hours, ${minutes} minutes'; // Update the controller's text
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Time Duration',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedPrice,
                      onChanged: (value) {
                        updatedPrice = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
          
                final serviceProvider =
                    Provider.of<ServiceProvider>(context, listen: false);

                serviceProvider
                    .editService(
                  serviceId: service['id'], 
                  serviceName: updatedServiceName,
                  description: updatedDescription,
                  timeDuration: updatedTimeInMinutes
                      .toString(),
                  price: updatedPrice,
                )
                    .then((_) {
                  serviceProvider
                      .fetchServices(); 
                }).catchError((error) {
                  // Handle errors here
                  print('Error editing service: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteService(BuildContext context, int serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the deleteService function with the service ID
                final serviceProvider =
                    Provider.of<ServiceProvider>(context, listen: false);
                serviceProvider.deleteService(serviceId).then((_) {
                  serviceProvider
                      .fetchServices(); // Fetch the updated list of services
                }).catchError((error) {
                  // Handle errors here
                  print('Error deleting service: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: serviceProvider.services.length,
        itemBuilder: (BuildContext context, int index) {
          final service = serviceProvider.services[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.work, size: 32), // Use an icon
                  title: Text(
                    service['serviceName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description: ${service['description']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Duration: ${service['timeDuration']} minutes',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \$${service['price']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _editServiceDialog(context, service);
                      },
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteService(context, service['id']);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
