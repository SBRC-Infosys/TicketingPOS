import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/transactionProvider.dart'; // Import your TransactionProvider

class CreateTransactionDialog extends StatefulWidget {
  const CreateTransactionDialog({Key? key}) : super(key: key);

  @override
  _CreateTransactionDialogState createState() => _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends State<CreateTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceIdController = TextEditingController();
  final TextEditingController _membershipIdController = TextEditingController();
  final TextEditingController _discountAmountController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Transaction'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _serviceIdController,
                decoration: const InputDecoration(
                  labelText: 'Service ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _membershipIdController,
                decoration: const InputDecoration(
                  labelText: 'Membership ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountAmountController,
                decoration: const InputDecoration(
                  labelText: 'Discount Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountPercentController,
                decoration: const InputDecoration(
                  labelText: 'Discount Percent',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a total amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departureTimeController,
                decoration: const InputDecoration(
                  labelText: 'Departure Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a departure time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
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
              final serviceId = int.parse(_serviceIdController.text);
              final membershipId = int.tryParse(_membershipIdController.text);
              final discountAmount = double.tryParse(_discountAmountController.text) ?? 0.0;
              final discountPercent = double.tryParse(_discountPercentController.text) ?? 0.0;
              final totalAmount = double.parse(_totalAmountController.text);
              final departureTime = DateTime.tryParse(_departureTimeController.text) ?? DateTime.now();
              final status = _statusController.text;

              await TransactionProvider().createTransaction(
                serviceId: serviceId,
                membershipId: membershipId,
                discountAmount: discountAmount,
                discountPercent: discountPercent,
                totalAmount: totalAmount,
                departureTime: departureTime,
                status: status,
              );

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction created successfully'),
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
