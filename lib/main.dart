import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/companyProvider.dart';

import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/screens/company.dart';

import 'package:ticketing_system/screens/first_sceen.dart';
import 'package:ticketing_system/screens/home_page.dart';
import 'package:ticketing_system/screens/login_screen.dart';

import 'package:ticketing_system/screens/service.dart';
import 'package:ticketing_system/screens/service_card.dart';
import 'package:ticketing_system/widgets/qr_code_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ServiceProvider()),
          ChangeNotifierProvider(create: (context) => CompanyProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ticket",
      theme: ThemeData(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const ServiceListPage(),
        // Add your other routes here...
      },
    );
  }
}
