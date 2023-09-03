import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';

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

  Future<void> createTransaction(
      int serviceId, double price, BuildContext context) async {
    try {
      final newTransactionId = await transactionProvider.createTransaction(
        serviceId: serviceId,
        totalAmount: price,
        departureTime: '',
        status: 'open',
      );
    } catch (error) {
      print('Error creating transaction: $error');
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
                final service = services[index];
                final serviceId = service['id'];
                final price = service['price'];

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      createTransaction(
                          serviceId, double.parse(price), context);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        service['serviceName'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['description'],
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
                            'Time Duration: ${service['timeDuration']}',
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
