import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';

class PrintExcelPage extends StatefulWidget {
  const PrintExcelPage({Key? key}) : super(key: key);

  @override
  _PrintExcelPageState createState() => _PrintExcelPageState();
}

class _PrintExcelPageState extends State<PrintExcelPage> {
  final transactionProvider = TransactionProvider();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = 'Open'; // Default status value
  }

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
                _fetchAndSaveTransactionsAsExcel(
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                  status: selectedStatus,
                );
              },
              child: const Text('Fetch and Save as Excel'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: 'Enter File Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: startDateController,
              readOnly: true,
              onTap: () => _selectDate(context, startDateController),
              decoration: const InputDecoration(
                labelText: 'Start Date',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: endDateController,
              readOnly: true,
              onTap: () => _selectDate(context, endDateController),
              decoration: const InputDecoration(
                labelText: 'End Date',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
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
              hint: const Text('Select Status'),
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
}
