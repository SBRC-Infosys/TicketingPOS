import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/companyProvider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';
import 'package:ticketing_system/widgets/print.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({Key? key}) : super(key: key);

  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final serviceProvider = ServiceProvider();
  final transactionProvider = TransactionProvider();
  final companyProvider = CompanyProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Add a variable to store the selected service
  Map<String, dynamic>? selectedService;

  @override
  void initState() {
    super.initState();
    serviceProvider.fetchServices();
    companyProvider.fetchCompanies();
  }

  String formatTimeDuration(int minutes) {
    if (minutes >= 60) {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      if (remainingMinutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''}, $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}';
      }
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Future<void> createTransactionAndPrintReceipt(
    int serviceId,
    double price,
    String serviceName,
    String timeDuration,
    String description,
  ) async {
    try {
      final newTransactionId = await transactionProvider.createTransaction(
        serviceId: serviceId,
        totalAmount: price,
        departureTime: '',
        timeDuration: int.parse(timeDuration),
        status: 'open',
      );

      if (newTransactionId != null) {
        Sunmi printer = Sunmi();
        await printer.initialize();

        await printer.printText('Service: $serviceName');
        await printer.printQRCode(newTransactionId);
        await printer.printText(
            'Time Duration: ${formatTimeDuration(int.parse(timeDuration))}');
        await printer.printText('Price: Rs $price');
        await printer.printText('Entry Time: ${DateTime.now()}');
        await printer.printText('*** $description ***');

       await printer.printText('');
       await printer.printText('');

        await printer.closePrinter();
        // Show a SnackBar with the message
        showSnackBar('Bill printed and transaction created');
      }
    } catch (error) {
      print('Error creating transaction or printing receipt: $error');
    }
  }

  // Function to sort services alphabetically
  List<Map<String, dynamic>> sortServicesAlphabetically(
      List<Map<String, dynamic>> services) {
    services.sort((a, b) {
      final serviceNameA = a['serviceName'] as String;
      final serviceNameB = b['serviceName'] as String;
      return serviceNameA.compareTo(serviceNameB);
    });
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: serviceProvider.fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final services = serviceProvider.services;

            // Cast services to List<Map<String, dynamic>> before sorting
            final servicesList = List<Map<String, dynamic>>.from(services);

            // Sort the services alphabetically
            final sortedServices = sortServicesAlphabetically(servicesList);

            return ListView.builder(
              itemCount: sortedServices.length,
              itemBuilder: (context, index) {
                final service = sortedServices[index];
                final serviceId = service['id'];
                final price = double.parse(service['price']);
                final serviceName = service['serviceName'];
                final timeDuration = service['timeDuration'];

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Store the selected service
                      selectedService = service;

                      // Show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Create Transaction"),
                            content: Text(
                                "Do you want to create a transaction for $serviceName?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();

                                  // Create the transaction and print the receipt
                                  createTransactionAndPrintReceipt(
                                    serviceId,
                                    price,
                                    serviceName,
                                    timeDuration.toString(),
                                    service['description'],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: Rs $price',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Time Duration: ${formatTimeDuration(timeDuration)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
