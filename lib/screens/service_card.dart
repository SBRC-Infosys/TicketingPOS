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

        // Header: Ticket Summary
        await printer.printText('Ticket Summary');

        // Company Name
        final companies = companyProvider.companies;
        if (companies.isNotEmpty) {
          final companyData = companies[0];
          final companyName = companyData['companyName'];
          await printer.printText(companyName);
        }

        // Company Address
        if (companies.isNotEmpty) {
          final companyData = companies[0];
          final companyAddress = companyData['companyAddress'];
          await printer.printText(companyAddress);
        }

        // Service Name
        await printer.printText(
          'Service: $serviceName',
        );

        // QR Code (larger size)
        await printer.printQRCode(
          newTransactionId,
        ); // Replace with your preferred size

        // Time Duration and Price
        await printer.printText(
            'Time Duration: ${formatTimeDuration(int.parse(timeDuration))}');
        await printer.printText('Price: Rs $price');

        // Entry Time (Random Date)
        await printer.printText('Entry Time: ${DateTime.now()}');

        // Footer: Happy Playing
        // await printer.printText(
        //   '*** $description ***',
        // );
        await printer.printText(
          '<b>*** $description ***</b>',
        );

        await printer.closePrinter();
        // Show a SnackBar with the message
        showSnackBar('Bill printed and transaction created');
      }
    } catch (error) {
      print('Error creating transaction or printing receipt: $error');
    }
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
                        timeDuration.toString(),
                        selectedService['description'],
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
                          // Text(
                          //   selectedService['description'],
                          //   style: const TextStyle(
                          //     fontSize: 14.0,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 8.0,
                          // ),
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
