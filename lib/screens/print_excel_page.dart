import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';

class PrintExcelPage extends StatefulWidget {
  const PrintExcelPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrintExcelPageState createState() => _PrintExcelPageState();
}

class _PrintExcelPageState extends State<PrintExcelPage> {
  final transactionProvider = TransactionProvider();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String? selectedStatus;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Excel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: ListView(
          children: [
            Card(
              elevation: 4, // Add elevation for a card-like effect
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: fileNameController,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: startDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, startDateController),
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: endDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, endDateController),
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            items: ['Open', 'Closed'].map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Select Status',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _resetFields,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      _fetchAndSaveTransactionsAsExcel(
                        startDate: startDateController.text,
                        endDate: endDateController.text,
                        status: selectedStatus,
                      );
                    },
              child: Text(isLoading ? 'Saving...' : 'Save as Excel'),
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

  Future<void> _fetchAndSaveTransactionsAsExcel({
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    try {
      final transactions = await transactionProvider.fetchTransactions(
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
      final fileName = fileNameController.text.isEmpty
          ? 'transactions'
          : fileNameController.text;

      final serviceProvider = ServiceProvider();
      await serviceProvider.fetchServices();

      final services = serviceProvider.services;
      final serviceMap = <int, String>{};

      for (final service in services) {
        final id = service['id'];
        final serviceName = service['serviceName'];
        serviceMap[id] = serviceName;
      }

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Write headers
      sheet.appendRow([
        'Transaction ID',
        'Service Name',
        'Total Amount',
        'Time Duration',
        'Departure Time',
        'Status',
        'Created At',
        'Updated At',
      ]);

      // Write transaction data
      for (final transaction in transactions) {
        sheet.appendRow([
          transaction['id'],
          serviceMap[transaction['serviceId']],
          transaction['totalAmount'],
          formatTimeDuration(transaction['timeDuration']),
          transaction['departureTime'],
          transaction['status'],
          transaction['created_at'],
          transaction['updated_at'],
        ]);
      }

      final dir = await getExternalStorageDirectory();
      final excelPath = '${dir?.path}/$fileName.xlsx';

      final file = File(excelPath);
      final excelBytes = excel.encode();
      if (excelBytes != null) {
        await file.writeAsBytes(excelBytes);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transactions saved as Excel: $excelPath'),
          ),
        );
      } else {
        throw Exception('Error encoding Excel data.');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(const Duration(days: 365)),
      lastDate: currentDate,
    );

    if (selectedDate != null) {
      controller.text = selectedDate.toLocal().toString().split(' ')[0];
    }
  }

  @override
  void dispose() {
    fileNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  void _resetFields() {
    fileNameController.clear();
    startDateController.clear();
    endDateController.clear();
    setState(() {
      selectedStatus = null; // Reset the status to no selection
    });
  }
}
