import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/companyProvider.dart';


class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch companies when the screen is initialized
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    companyProvider.fetchCompanies();
  }

  void _editCompanyDialog(BuildContext context, Map<String, dynamic> company) {
    String updatedCompanyName = company['companyName'];
    String updatedCompanyAddress = company['companyAddress'];
    String updatedCompanyPanVatNo = company['companyPanVatNo'];
    String updatedCompanyTelPhone = company['companyTelPhone'];
    String selectedStatus = company['status'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Company'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedCompanyName,
                      onChanged: (value) {
                        updatedCompanyName = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedCompanyAddress,
                      onChanged: (value) {
                        updatedCompanyAddress = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Company Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedCompanyPanVatNo,
                      onChanged: (value) {
                        updatedCompanyPanVatNo = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'PAN/VAT Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedCompanyTelPhone,
                      onChanged: (value) {
                        updatedCompanyTelPhone = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Telephone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField<String>(
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
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final companyProvider =
                    Provider.of<CompanyProvider>(context, listen: false);

                companyProvider
                    .editCompany(
                  companyId: company['id'],
                  companyName: updatedCompanyName,
                  companyAddress: updatedCompanyAddress,
                  companyPanVatNo: updatedCompanyPanVatNo,
                  companyTelPhone: updatedCompanyTelPhone,
                  status: selectedStatus,
                )
                    .then((_) {
                  companyProvider
                      .fetchCompanies(); // Fetch the updated list of companies
                }).catchError((error) {
                  // Handle errors here
                  print('Error editing company: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCompany(BuildContext context, int companyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this company?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final companyProvider =
                    Provider.of<CompanyProvider>(context, listen: false);
                companyProvider.deleteCompany(companyId).then((_) {
                  companyProvider
                      .fetchCompanies(); // Fetch the updated list of companies
                }).catchError((error) {
                  // Handle errors here
                  print('Error deleting company: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: companyProvider.companies.length,
        itemBuilder: (BuildContext context, int index) {
          final company = companyProvider.companies[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.business, size: 32), // Use an icon
                  title: Text(
                    company['companyName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address: ${company['companyAddress']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PAN/VAT: ${company['companyPanVatNo']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${company['companyTelPhone']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${company['status']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _editCompanyDialog(context, company);
                      },
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteCompany(context, company['id']);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
