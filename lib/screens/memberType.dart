import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/membershipProvider.dart';



import 'package:ticketing_system/widgets/create_type.dart';
import 'package:ticketing_system/widgets/typelistwidget.dart';

class CreateMembershipTypeScreen extends StatelessWidget {
  const CreateMembershipTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final membershipTypeProvider = Provider.of<MembershipTypeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Types'),
      ),
      body: const MembershipTypeListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CreateMembershipTypeDialog();
            },
          ).then((_) {
            // After creating a new membership type and returning to this screen,
            // you can optionally fetch the updated list here.
            final membershipTypeProvider =
                Provider.of<MembershipTypeProvider>(context, listen: false);
            membershipTypeProvider.fetchMembershipTypes();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
