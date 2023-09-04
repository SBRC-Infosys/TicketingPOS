import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_system/screens/service_card.dart';
import 'package:ticketing_system/widgets/qr_code_widget.dart';

class QRScannerHomePage extends StatelessWidget {
  const QRScannerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "logout",
                child: Text("Logout"),
              ),
            ],
            onSelected: (value) {
              if (value == "logout") {
                // Handle logout
              }
            },
          ),
        ],
      ),
      body: const ServiceListPage()
    );
  }
}

// Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const QRCodeWidget()));
//                   },
//                   child: const Icon(
//                     Icons.qr_code_scanner,
//                     size: 60,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//           ],
//         ),
//       ),
