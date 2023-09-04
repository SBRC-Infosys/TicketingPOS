import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';

class CreateServiceDialog extends StatefulWidget {
  const CreateServiceDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateServiceDialogState createState() => _CreateServiceDialogState();
}

class _CreateServiceDialogState extends State<CreateServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeDurationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int selectedTimeInMinutes = 0; // Store the selected time in minutes

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: _timeDurationController,
                decoration: const InputDecoration(
                  labelText: 'Time Duration',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    final hours = selectedTime.hour;
                    final minutes = selectedTime.minute;
                    setState(() {
                      selectedTimeInMinutes = (hours * 60) + minutes;
                      _timeDurationController.text =
                          '$hours hours, $minutes minutes';
                    });
                  }
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final serviceName = _serviceNameController.text;
              final description = _descriptionController.text;
              final price = _priceController.text;

              await ServiceProvider().createService(
                serviceName: serviceName,
                description: description,
                timeDuration:
                    selectedTimeInMinutes.toString(), // Pass as a string
                price: price,
              );

              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service created successfully'),
                ),
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
