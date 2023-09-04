import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/companyProvider.dart';
import 'package:ticketing_system/widgets/comapnylist.dart';
import 'package:ticketing_system/widgets/create_company.dart'; // Import your CreateCompanyDialog or widget


class CreateCompanyScreen extends StatelessWidget {
  const CreateCompanyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
      ),
      body: const CompanyListScreen(), // Create a widget for listing companies
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CreateCompanyDialog(); // Use your CreateCompanyDialog widget
            },
          ).then((_) {
            // After creating a new company and returning to this screen,
            // you can optionally fetch the updated list here.
            final companyProvider =
                Provider.of<CompanyProvider>(context, listen: false);
            companyProvider.fetchCompanies();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
