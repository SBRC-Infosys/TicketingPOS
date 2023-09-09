import 'package:flutter/material.dart';
import 'package:ticketing_system/screens/service_card.dart';


class QRScannerHomePage extends StatelessWidget {
  const QRScannerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
    
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout, 
              color: Colors.grey, 
            ),
            onPressed: () {
              // Handle logout button press
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: const ServiceListPage(),
    );
  }
}
