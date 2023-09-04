import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    serviceProvider.fetchServices();
  }

  Future<void> createTransactionAndPrintReceipt(int serviceId, double price,
      String serviceName, String timeDuration) async {
    try {
      final newTransactionId = await transactionProvider.createTransaction(
        serviceId: serviceId,
        totalAmount: price,
        departureTime: '',
      );

      // If the transaction is successfully created, print the receipt
      if (newTransactionId != null) {
        Sunmi printer = Sunmi();
        await printer.initialize();
        await printer.printText('Transaction ID: $newTransactionId');
        await printer.printText(
            'Service: $serviceName'); // Use the selected service name
        await printer.printText('Price: Rs $price');
        await printer
            .printText('Time Duration: $timeDuration'); // Use the time duration
        await printer
            .printQRCode(newTransactionId); // Print transaction ID as QR code
        await printer.closePrinter();
      }
    } catch (error) {
      print('Error creating transaction or printing receipt: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service List'),
      ),
      body: FutureBuilder(
        future: serviceProvider.fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final services = serviceProvider.services;

            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final selectedService = services[index];
                final serviceId = selectedService['id'];
                final price = double.parse(selectedService['price']);
                final serviceName = selectedService['serviceName'];
                final timeDuration = selectedService['timeDuration'];

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      createTransactionAndPrintReceipt(
                        serviceId,
                        price,
                        serviceName,
                        timeDuration
                            .toString(), // Convert the integer to a string
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
                            selectedService['description'],
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            'Price: Rs $price',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Time Duration: $timeDuration',
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
