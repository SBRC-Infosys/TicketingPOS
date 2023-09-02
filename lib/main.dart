import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/membershipProvider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/screens/first_sceen.dart';
import 'package:ticketing_system/screens/home_page.dart';
import 'package:ticketing_system/screens/login_screen.dart';
import 'package:ticketing_system/screens/memberType.dart';
import 'package:ticketing_system/screens/membership.dart';
import 'package:ticketing_system/screens/membershiplist.dart';
import 'package:ticketing_system/screens/service.dart';






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
          ChangeNotifierProvider(create: (context) => MembershipTypeProvider()), // Add this line
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
        "/": (context) => const CreateMembershipTypeScreen(),
        // Add your other routes here...
      },
    );
  }
}
