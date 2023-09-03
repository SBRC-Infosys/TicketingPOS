import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/memberProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart'; // Import your ServiceProvider

class CreateTransactionDialog extends StatefulWidget {
  const CreateTransactionDialog({Key? key}) : super(key: key);

  @override
  _CreateTransactionDialogState createState() =>
      _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends State<CreateTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _membershipIdController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _discountPercentController =
      TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  int? _selectedServiceId; // Store the selected service ID
  List<dynamic> _services = []; // List to store fetched services
  int? _selectedMemberId; // Store the selected membership ID
  List<dynamic> _members = []; // List to store fetched members

  @override
  void initState() {
    super.initState();
    // Fetch services when the widget is initialized
    _fetchServices();
    _fetchMembers();
  }

  // Fetch services using the ServiceProvider
  Future<void> _fetchServices() async {
    try {
      final serviceProvider = ServiceProvider();
      await serviceProvider.fetchServices();
      setState(() {
        _services = serviceProvider.services;
      });
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  Future<void> _fetchMembers() async {
    try {
      final memberProvider = MemberProvider(); // Initialize MemberProvider
      await memberProvider.fetchMembers();
      setState(() {
        _members = memberProvider.members;
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
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
                value: _selectedServiceId,
                items: _services.map<DropdownMenuItem<int>>((service) {
                  return DropdownMenuItem<int>(
                    value: service['id'],
                    child: Text(service['serviceName']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedServiceId = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedMemberId,
                items: _members.map<DropdownMenuItem<int>>((member) {
                  return DropdownMenuItem<int>(
                    value: member['id'],
                    child: Text(member['memberName']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMemberId = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Membership Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a membership ID';
                  }
                  return null;
                },
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
                _selectedServiceId != null &&
                _selectedMemberId != null) {
              final membershipId = int.tryParse(_membershipIdController.text);
              final discountAmount =
                  double.tryParse(_discountAmountController.text) ?? 0.0;
              final discountPercent =
                  double.tryParse(_discountPercentController.text) ?? 0.0;
              final totalAmount = double.parse(_totalAmountController.text);

              await TransactionProvider().createTransaction(
                serviceId: _selectedServiceId!,
                membershipId:
                    _selectedMemberId!, // Pass the selected membership ID
                discountAmount: discountAmount,
                discountPercent: discountPercent,
                totalAmount: totalAmount,
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
