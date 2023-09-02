import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/membershipProvider.dart';


class MembershipTypeListScreen extends StatefulWidget {
  const MembershipTypeListScreen({Key? key}) : super(key: key);

  @override
  _MembershipTypeListScreenState createState() => _MembershipTypeListScreenState();
}

class _MembershipTypeListScreenState extends State<MembershipTypeListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch membership types when the screen is initialized
    final membershipTypeProvider =
        Provider.of<MembershipTypeProvider>(context, listen: false);
    membershipTypeProvider.fetchMembershipTypes();
  }

  void _editMembershipTypeDialog(BuildContext context, Map<String, dynamic> membershipType) {
    String updatedMembershipType = membershipType['membershipType'];
    String updatedDescription = membershipType['description'];
    String updatedStatus = membershipType['status'];
    String updatedDiscountPercentage = membershipType['discountPercentage'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Membership Type'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMembershipType,
                      onChanged: (value) {
                        updatedMembershipType = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Membership Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedDescription,
                      onChanged: (value) {
                        updatedDescription = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedStatus,
                      onChanged: (value) {
                        updatedStatus = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedDiscountPercentage,
                      onChanged: (value) {
                        updatedDiscountPercentage = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Discount Percentage',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the editMembershipType function with updated data
                final membershipTypeProvider =
                    Provider.of<MembershipTypeProvider>(context, listen: false);

                membershipTypeProvider
                    .editMembershipType(
                  membershipTypeId: membershipType['id'], // Pass the membership type ID
                  membershipType: updatedMembershipType,
                  description: updatedDescription,
                  status: updatedStatus,
                  discountPercentage: updatedDiscountPercentage,
                )
                    .then((_) {
                  membershipTypeProvider
                      .fetchMembershipTypes(); // Fetch the updated list of membership types
                }).catchError((error) {
                  // Handle errors here
                  print('Error editing membership type: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteMembershipType(BuildContext context, int membershipTypeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this membership type?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the deleteMembershipType function with the membership type ID
                final membershipTypeProvider =
                    Provider.of<MembershipTypeProvider>(context, listen: false);
                membershipTypeProvider.deleteMembershipType(membershipTypeId).then((_) {
                  membershipTypeProvider
                      .fetchMembershipTypes(); // Fetch the updated list of membership types
                }).catchError((error) {
                  // Handle errors here
                  print('Error deleting membership type: $error');
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final membershipTypeProvider = Provider.of<MembershipTypeProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: membershipTypeProvider.membershipTypes.length,
        itemBuilder: (BuildContext context, int index) {
          final membershipType = membershipTypeProvider.membershipTypes[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.card_membership, size: 32), // Use an icon
                  title: Text(
                    membershipType['membershipType'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description: ${membershipType['description']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${membershipType['status']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discount Percentage: ${membershipType['discountPercentage']}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _editMembershipTypeDialog(context, membershipType);
                      },
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteMembershipType(context, membershipType['id']);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
