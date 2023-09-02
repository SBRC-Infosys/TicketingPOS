import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/memberProvider.dart'; // Import your member provider
import 'package:ticketing_system/screens/membership.dart';
import 'package:ticketing_system/screens/membershiplist.dart';
import 'package:ticketing_system/widgets/create_member.dart';
import 'package:ticketing_system/widgets/memberlistwidget.dart'; // Import your create member dialog


class CreateMemberScreen extends StatelessWidget {
  const CreateMemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: const MemberListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CreateMemberDialog();
            },
          ).then((_) {
            // After creating a new member and returning to this screen,
            // you can optionally fetch the updated list here.
            final memberProvider =
                Provider.of<MemberProvider>(context, listen: false);
            memberProvider.fetchMembers();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
