import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_system/screens/company.dart';
import 'package:ticketing_system/screens/home_page.dart';
import 'package:ticketing_system/screens/profile.dart';
import 'package:ticketing_system/screens/service.dart';
import 'package:ticketing_system/screens/transaction.dart';
import 'package:ticketing_system/screens/transactionPage.dart';
import 'package:ticketing_system/style/app_style.dart';
import 'package:ticketing_system/widgets/qr_code_widget.dart';
import 'package:ticketing_system/widgets/transactionlist.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    QRScannerHomePage(),
    QRCodeWidget(),
    // CreateServiceScreen(),
    TransactionListPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.homeIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.homeIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.eventIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.eventIcon),
            label: 'Camera',
          ),
          // BottomNavigationBarItem(
          //   activeIcon: SvgPicture.asset(
          //     AppStyle.reportIcon,
          //     colorFilter: const ColorFilter.mode(
          //       AppStyle.primarySwatch,
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   icon: SvgPicture.asset(AppStyle.reportIcon),
          //   label: 'Services',
          // ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.notificationsIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.notificationsIcon),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.profileIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.profileIcon),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppStyle.primarySwatch,
        onTap: _onItemTapped,
      ),
    );
  }
}
