import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/widgets/create_service.dart';
import 'package:ticketing_system/widgets/servicelistwidget.dart';

class CreateServiceScreen extends StatelessWidget {
  const CreateServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context); // Use the serviceProvider here

    return Scaffold(
        appBar: AppBar(
          title: const Text('Service'),
        ),
        body: const ServiceListScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CreateServiceDialog();
              },
            ).then((_) {
              // After creating a new service and returning to this screen,
              // you can optionally fetch the updated list here.
              final serviceProvider =
                  Provider.of<ServiceProvider>(context, listen: false);
              serviceProvider.fetchServices();
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
