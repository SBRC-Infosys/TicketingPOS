import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:ticketing_system/screens/company.dart';
import 'package:ticketing_system/screens/edit_user.dart';
import 'package:ticketing_system/screens/print_excel_page.dart';
import 'package:ticketing_system/screens/register_screen.dart';
import 'package:ticketing_system/screens/service.dart';
import 'package:ticketing_system/screens/stats.dart';
import 'package:ticketing_system/screens/userList_page.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        title: const Text(
          "Profile and Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  icons: Icons.verified_user,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Create User',
                  subtitle: "Create a new user",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.language,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Language',
                  subtitle: "English",
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateServiceScreen(),
                      ),
                    );
                  },
                  icons: Icons.local_offer,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Services',
                  subtitle: "Add new services",
                ),
                SettingsItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateCompanyScreen(),
                      ),
                    );
                  },
                  icons: Icons.business,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Company',
                  subtitle: "Add company",
                ),
                SettingsItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrintExcelPage(),
                      ),
                    );
                  },
                  icons: Icons.file_download,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Download Data',
                  subtitle: "Download transaction data in excel file",
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
                SettingsItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>   const UserListPage(),
                      ),
                    );
                  },
                  icons: Icons.lock,
                  title: "Change User Details",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
