import 'package:flutter/material.dart';
import 'package:ticketing_system/widgets/create_service.dart';
import 'package:ticketing_system/widgets/servicelistwidget.dart';

class CreateServiceScreen extends StatelessWidget {
  const CreateServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          );
        },
        child: const Icon(
          Icons.add,

        ),
      ),
    );
  }
}
