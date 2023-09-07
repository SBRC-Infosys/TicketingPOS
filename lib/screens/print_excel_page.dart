import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // To get the directory for file storage
import 'package:excel/excel.dart'; // To work with Excel files
import 'package:ticketing_system/provider/transactionProvider.dart';

class PrintExcelPage extends StatefulWidget {
  @override
  _PrintExcelPageState createState() => _PrintExcelPageState();
}

class _PrintExcelPageState extends State<PrintExcelPage> {
  final transactionProvider = TransactionProvider();
  TextEditingController fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Excel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _fetchAndSaveTransactionsAsExcel();
              },
              child: const Text('Fetch and Save as Excel'),
            ),
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: 'Enter File Name',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimeDuration(int timeDurationInMinutes) {
  if (timeDurationInMinutes < 60) {
    return '$timeDurationInMinutes minutes';
  } else {
    final hours = timeDurationInMinutes ~/ 60;
    final minutes = timeDurationInMinutes % 60;

    if (minutes == 0) {
      return '$hours hr';
    } else {
      return '$hours hr $minutes min';
    }
  }
}


  // Function to fetch transactions and save as Excel
  Future<void> _fetchAndSaveTransactionsAsExcel() async {
    try {
      final transactions = await transactionProvider.fetchTransactions();
      final fileName = fileNameController.text.isEmpty
          ? 'transactions' // Default file name if not specified by the user
          : fileNameController.text;

      // Create an Excel workbook
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Write headers
      sheet.appendRow([
        'Transaction ID',
        'Service ID',
        'Total Amount',
        'Time Duration',
        'Departure Time',
        'Status',
        'Created At', // Add this
        'Updated At', // Add this
      ]);

      // Write transaction data
      for (final transaction in transactions) {
        sheet.appendRow([
          transaction['id'],
          transaction['serviceId'],
          transaction['totalAmount'],
          formatTimeDuration(transaction['timeDuration']),
          // transaction['timeDuration'],
          transaction['departureTime'],
          transaction['status'],
          transaction['created_at'], // Add this
          transaction['updated_at'], // Add this
        ]);
      }

      // Get the document directory for saving the Excel file
      final dir =
          await getExternalStorageDirectory(); // Use getExternalStorageDirectory() for external storage
      final excelPath = '${dir?.path}/$fileName.xlsx';

// Save the Excel file
      final file = File(excelPath);
      final excelBytes = excel.encode();
      if (excelBytes != null) {
        await file.writeAsBytes(excelBytes);

        // Show a success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transactions saved as Excel: $excelPath'),
          ),
        );
      } else {
        // Handle encoding failure
        throw Exception('Error encoding Excel data.');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching or saving transactions as Excel: $error');

      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red, // Customize the error message appearance
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController
    fileNameController.dispose();
    super.dispose();
  }
}
