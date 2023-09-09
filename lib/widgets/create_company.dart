import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/companyProvider.dart';

class CreateCompanyDialog extends StatefulWidget {
  const CreateCompanyDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateCompanyDialogState createState() => _CreateCompanyDialogState();
}

class _CreateCompanyDialogState extends State<CreateCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyPanVatNoController =
      TextEditingController();
  final TextEditingController _companyTelPhoneController =
      TextEditingController();
  String selectedStatus = 'Inactive'; // Default status

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Company'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyPanVatNoController,
                decoration: const InputDecoration(
                  labelText: 'PAN/VAT Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PAN/VAT number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyTelPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Telephone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a telephone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Active', 'Inactive'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
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
              final companyName = _companyNameController.text;
              final companyAddress = _companyAddressController.text;
              final companyPanVatNo = _companyPanVatNoController.text;
              final companyTelPhone = _companyTelPhoneController.text;

              await CompanyProvider().createCompany(
                companyName: companyName,
                companyAddress: companyAddress,
                companyPanVatNo: companyPanVatNo,
                companyTelPhone: companyTelPhone,
                status: selectedStatus,
              );

              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(); // Close the dialog
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Company created successfully'),
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
