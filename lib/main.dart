import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/components/bar.dart';
import 'package:ticketing_system/components/bottom_bar.dart';
import 'package:ticketing_system/provider/companyProvider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';

import 'package:ticketing_system/screens/first_sceen.dart';

import 'package:ticketing_system/screens/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

String initialRoute = '/'; // Default value in case of no login or unknown role

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Check if the user is logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userRole = prefs.getString('userRole');

  if (isLoggedIn) {
    if (userRole == 'user') {
      initialRoute = '/UserHome';
    } else if (userRole == 'admin') {
      initialRoute = '/AdminHome';
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => CompanyProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ticket",
      theme: ThemeData(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        "/": (context) => const FirstScreen(),
        "/LoginScreen": (context) => const LoginScreen(),
        "/UserHome": (context) => const Bar(),
        "/AdminHome": (context) => const BottomBar(),
        // Add your other routes here...
      },
    );
  }
}
