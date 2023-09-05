

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({Key? key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";
  bool showSuccessMessage = false;
  Map<String, dynamic>? transactionDetails;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData.code!;
      });

      if (result.isNotEmpty) {
        await _updateTransactionStatus(result);
      }
    });
  }

  Future<void> _updateTransactionStatus(String transactionId) async {
    try {
      final response = await http.post(
          Uri.parse('http://sbrcinfosys.com.np/api/transaction/$transactionId'),
        body: {
          'status': 'closed',
          'departureTime': DateTime.now().toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final totalAmount = responseBody['totalAmount'];

        print('Transaction status updated successfully');
        setState(() {
          showSuccessMessage = true;
          transactionDetails = {
            'transactionId': transactionId,
            'totalAmount': totalAmount, // Include totalAmount in transactionDetails
          };
        });
      } else {
        print('Error updating transaction status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _resetScan() {
    setState(() {
      result = "";
      showSuccessMessage = false;
      transactionDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                children: [
                  Text(
                    showSuccessMessage ? "Token Closed!" : "Scan Result: $result",
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (transactionDetails != null)
                    Column(
                      children: [
                        Text("Transaction ID: ${transactionDetails!['transactionId']}"),
                        Text("Total Amount: \$${transactionDetails!['totalAmount']}"), // Display total amount here
                        // Display more transaction details here
                      ],
                    ),
                  if (showSuccessMessage)
                    ElevatedButton(
                      onPressed: _resetScan,
                      child: const Text("Scan Again"),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}