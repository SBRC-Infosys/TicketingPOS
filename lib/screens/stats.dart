import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';

class ServiceSelectionPage extends StatefulWidget {
  @override
  _ServiceSelectionPageState createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  final ServiceProvider serviceProvider = ServiceProvider();
  int? selectedServiceId;

  @override
  void initState() {
    super.initState();
    // Fetch services when the page is initialized
    fetchServices();
  }

  // Fetch services from your ServiceProvider
  void fetchServices() async {
    try {
      await serviceProvider.fetchServices();
      setState(() {}); // Update the UI to reflect the fetched data
    } catch (error) {
      // Handle error if needed
      print('Error fetching services: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Choose a Service:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: selectedServiceId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedServiceId = newValue;
                });
              },
              items: serviceProvider.services.map<DropdownMenuItem<int>>(
                (dynamic service) {
                  final int serviceId = service['id']; // Replace 'id' with the actual key for the service ID in your data
                  final String serviceName = service['serviceName']; // Replace 'serviceName' with the actual key for the service name in your data
                  return DropdownMenuItem<int>(
                    value: serviceId,
                    child: Text(serviceName),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform an action based on the selectedServiceId
                if (selectedServiceId != null) {
                  print('Selected Service ID: $selectedServiceId');
                  // You can navigate to another page or perform further actions here.
                } else {
                  // Handle the case where no service is selected
                  print('Please select a service.');
                }
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
