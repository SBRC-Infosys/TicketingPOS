import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateMembershipTypeScreen extends StatefulWidget {
  const CreateMembershipTypeScreen({Key? key}) : super(key: key);

  @override
  _CreateMembershipTypeScreenState createState() =>
      _CreateMembershipTypeScreenState();
}

class _CreateMembershipTypeScreenState
    extends State<CreateMembershipTypeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _membershipTypeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedStatus = 'active';
  final TextEditingController _discountPercentageController =
      TextEditingController();

  List<String> _statusOptions = ['active', 'inactive'];

  Future<void> _createMembershipType() async {
    if (_formKey.currentState!.validate()) {
      final String membershipType = _membershipTypeController.text;
      final String description = _descriptionController.text;
      final String status = _selectedStatus;
      final String discountPercentage = _discountPercentageController.text;

      try {
        final response = await http.post(
          Uri.parse('http://[2400:1a00:b030:9fa0::2]:5000/api/membershipType'),
          body: {
            'membershipType': membershipType,
            'description': description,
            'status': status,
            'discountPercentage': discountPercentage,
          },
        );

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text(
                    'Membership type has been created successfully.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the alert dialog
                    },
                  ),
                ],
              );
            },
          );

          _membershipTypeController.clear();
          _descriptionController.clear();
          _selectedStatus = 'active'; // Reset status dropdown
          _discountPercentageController.clear();
        } else {}
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Membership Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _membershipTypeController,
                decoration: const InputDecoration(
                  labelText: 'Membership Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a membership type';
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
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountPercentageController,
                decoration: const InputDecoration(
                  labelText: 'Discount Percentage',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a discount percentage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createMembershipType,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
