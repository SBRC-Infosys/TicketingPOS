import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
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
    String updatedTimeDuration = service['timeDuration'].toString();

    String updatedPrice = service['price'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Service'),
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
                      initialValue: updatedTimeDuration,
                      onChanged: (value) {
                        updatedTimeDuration = value;
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the editService function with updated data
                final serviceProvider =
                    Provider.of<ServiceProvider>(context, listen: false);
                serviceProvider.editService(
                  serviceId: service['id'], // Pass the service ID
                  serviceName: updatedServiceName,
                  description: updatedDescription,
                  timeDuration: updatedTimeDuration,
                  price: updatedPrice,
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
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
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the deleteService function with the service ID
                final serviceProvider =
                    Provider.of<ServiceProvider>(context, listen: false);
                serviceProvider.deleteService(serviceId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
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
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteService(context, service['id']);
                      },
                      child: Text('Delete'),
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
