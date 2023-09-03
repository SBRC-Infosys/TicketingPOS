import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/memberProvider.dart';

import 'package:ticketing_system/provider/transactionProvider.dart'; // Import your TransactionProvider

class CreateTransactionDialog extends StatefulWidget {
  const CreateTransactionDialog({Key? key}) : super(key: key);

  @override
  _CreateTransactionDialogState createState() =>
      _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends State<CreateTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _discountPercentController =
      TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  int? selectedServiceId;
  int? selectedMemberId;

  List<int> serviceIds = []; // Manually create a list to hold service IDs

  @override
  void initState() {
    super.initState();
    // ServiceProvider().fetchServices(); Comment this out for now
    MemberProvider().fetchMembers();
  }

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
              DropdownButtonFormField<int>(
                value: selectedServiceId,
                onChanged: (value) {
                  setState(() {
                    selectedServiceId = value;
                  });
                },
                items: serviceIds.map<DropdownMenuItem<int>>((id) {
                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text('Service ID: $id'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Service',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedMemberId,
                onChanged: (value) {
                  setState(() {
                    selectedMemberId = value;
                  });
                },
                items: MemberProvider()
                    .members
                    .map<DropdownMenuItem<int>>((member) {
                  return DropdownMenuItem<int>(
                    value: member['id'],
                    child: Text(member['memberName']),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Member',
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
            if (_formKey.currentState!.validate() &&
                selectedServiceId != null &&
                selectedMemberId != null) {
              final serviceId = selectedServiceId!;
              final membershipId = selectedMemberId!;
              final discountAmount =
                  double.tryParse(_discountAmountController.text) ?? 0.0;
              final discountPercent =
                  double.tryParse(_discountPercentController.text) ?? 0.0;
              final totalAmount = double.parse(_totalAmountController.text);
              final status = 'open'; // Set the default status to 'open'

              await TransactionProvider().createTransaction(
                serviceId: serviceId,
                membershipId: membershipId,
                discountAmount: discountAmount,
                discountPercent: discountPercent,
                totalAmount: totalAmount,
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
