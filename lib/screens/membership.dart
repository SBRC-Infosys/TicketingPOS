import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipType {
  final int id;
  final String membershipType;
  final double discountPercentage;

  MembershipType(this.id, this.membershipType, this.discountPercentage);
}

class CreateMemberDialog extends StatefulWidget {
  const CreateMemberDialog({Key? key}) : super(key: key);

  @override
  _CreateMemberDialogState createState() => _CreateMemberDialogState();
}

class _CreateMemberDialogState extends State<CreateMemberDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _memberNameController = TextEditingController();
  final TextEditingController _memberAddressController =
      TextEditingController();
  final TextEditingController _memberEmailController = TextEditingController();
  final TextEditingController _memberPhoneController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _selectedStatus;
  MembershipType? _selectedMembershipType;
  double? _discountPercentage;
  List<String> _statusOptions = [
    'Active',
    'Inactive'
  ]; // Membership status options

  List<MembershipType> _membershipTypes = [];

  Future<void> _fetchMembershipTypes() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://[2400:1a00:b030:3592::2]:5000/api/membershipType/fetch'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final membershipTypeList = (data['membershipTypes'] as List)
            .map((typeData) => MembershipType(
                  typeData['id'],
                  typeData['membershipType'],
                  double.parse(typeData['discountPercentage']),
                ))
            .toList();

        setState(() {
          _membershipTypes = membershipTypeList;
          print('Membership Types: $_membershipTypes');
        });
      } else {
        // Handle error
        print('Failed to fetch membership types');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMembershipTypes();
  }

  Future<void> _createMember() async {
    if (_formKey.currentState!.validate()) {
      final String memberName = _memberNameController.text;
      final String memberAddress = _memberAddressController.text;
      final String memberEmail = _memberEmailController.text;
      final String memberPhone = _memberPhoneController.text;
      final String startDate = _selectedStartDate?.toLocal().toString() ?? '';
      final String endDate = _selectedEndDate?.toLocal().toString() ?? '';
      final String status = _selectedStatus ?? '';
      final int? membershipTypeId = _selectedMembershipType?.id;
      final double? discountPercentage =
          _selectedMembershipType?.discountPercentage;

      try {
        final response = await http.post(
          Uri.parse('http://[2400:1a00:b030:3592::2]:5000/api/member/create'),
          body: {
            'membershipTypeId': membershipTypeId.toString(),
            'memberName': memberName,
            'memberAddress': memberAddress,
            'memberEmail': memberEmail,
            'memberPhone': memberPhone,
            'startDate': startDate,
            'endDate': endDate,
            'status': status,
            'discountPercentage': discountPercentage?.toStringAsFixed(2) ?? '',
          },
        );

        if (response.statusCode == 201) {
          // Member created successfully, show an alert
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Member Created'),
                content: const Text('Member has been created successfully.'),
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

          // Clear the text controllers and selected values to reset the form
          _memberNameController.clear();
          _memberAddressController.clear();
          _memberEmailController.clear();
          _memberPhoneController.clear();
          _selectedStartDate = null;
          _selectedEndDate = null;
          _selectedStatus = null;
          _selectedMembershipType = null;
        } else {
          // Handle API response status codes other than 201 as needed
        }
      } catch (e) {
        // Handle any network or server errors
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Member'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Membership Type Dropdown
              DropdownButtonFormField<MembershipType>(
                value: _selectedMembershipType,
                onChanged: (MembershipType? value) {
                  setState(() {
                    _selectedMembershipType = value;
                  });
                },
                items: _membershipTypes.map((type) {
                  return DropdownMenuItem<MembershipType>(
                    value: type,
                    child: Text(type.membershipType),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Membership Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Member Name
              TextFormField(
                controller: _memberNameController,
                decoration: const InputDecoration(
                  labelText: 'Member Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a member name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Member Address
              TextFormField(
                controller: _memberAddressController,
                decoration: const InputDecoration(
                  labelText: 'Member Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a member address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Member Email
              TextFormField(
                controller: _memberEmailController,
                decoration: const InputDecoration(
                  labelText: 'Member Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a member email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Member Phone
              TextFormField(
                controller: _memberPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Member Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a member phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Start Date Calendar
              Text('Start Date'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedStartDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  _selectedStartDate != null
                      ? _selectedStartDate!.toLocal().toString().split(' ')[0]
                      : 'Select Start Date',
                ),
              ),
              const SizedBox(height: 16),

              // End Date Calendar
              Text('End Date'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedEndDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  _selectedEndDate != null
                      ? _selectedEndDate!.toLocal().toString().split(' ')[0]
                      : 'Select End Date',
                ),
              ),
              const SizedBox(height: 16),

              // Membership Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Discount Percentage

              const SizedBox(height: 20),

              // Create Member Button
              ElevatedButton(
                onPressed: _createMember,
                child: const Text('Create Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
