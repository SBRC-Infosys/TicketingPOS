import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/membershipProvider.dart';


class CreateMembershipTypeDialog extends StatefulWidget {
  const CreateMembershipTypeDialog({Key? key}) : super(key: key);

  @override
  _CreateMembershipTypeDialogState createState() => _CreateMembershipTypeDialogState();
}

class _CreateMembershipTypeDialogState extends State<CreateMembershipTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _membershipTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _discountPercentageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Membership Type'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _membershipTypeController,
                decoration: const InputDecoration(
                  labelText: 'Membership Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountPercentageController,
                decoration: const InputDecoration(
                  labelText: 'Discount Percentage',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount percentage';
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
              final membershipType = _membershipTypeController.text;
              final description = _descriptionController.text;
              final status = _statusController.text;
              final discountPercentage = _discountPercentageController.text;

              await MembershipTypeProvider().createMembershipType(
                membershipType: membershipType,
                description: description,
                status: status,
                discountPercentage: discountPercentage,
              );

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membership Type created successfully'),
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
