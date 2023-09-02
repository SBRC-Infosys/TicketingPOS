import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/memberProvider.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch members when the screen is initialized
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.fetchMembers();
  }

  void _editMemberDialog(BuildContext context, Map<String, dynamic> member) {
    String updatedMembershipTypeId = member['membershipTypeId'].toString();
    String updatedMemberName = member['memberName'];
    String updatedMemberAddress = member['memberAddress'];
    String updatedMemberEmail = member['memberEmail'];
    String updatedMemberPhone = member['memberPhone'];
    String updatedStartDate = member['startDate'];
    String updatedEndDate = member['endDate'];
    String updatedStatus = member['status'];
    String updatedDiscountPercentage = member['discountPercentage'].toString();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Member'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMembershipTypeId,
                      onChanged: (value) {
                        updatedMembershipTypeId = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Membership Type ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMemberName,
                      onChanged: (value) {
                        updatedMemberName = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Member Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMemberAddress,
                      onChanged: (value) {
                        updatedMemberAddress = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Member Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMemberEmail,
                      onChanged: (value) {
                        updatedMemberEmail = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Member Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedMemberPhone,
                      onChanged: (value) {
                        updatedMemberPhone = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Member Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedStartDate,
                      onChanged: (value) {
                        updatedStartDate = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: updatedEndDate,
                      onChanged: (value) {
                        updatedEndDate = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'End Date',
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
                // Call the editMember function with updated data
                final memberProvider =
                    Provider.of<MemberProvider>(context, listen: false);

                memberProvider
                    .editMember(
                  memberId: member['id'], // Pass the member ID
                  membershipTypeId: int.parse(updatedMembershipTypeId),
                  memberName: updatedMemberName,
                  memberAddress: updatedMemberAddress,
                  memberEmail: updatedMemberEmail,
                  memberPhone: updatedMemberPhone,
                  startDate: updatedStartDate,
                  endDate: updatedEndDate,
                  status: updatedStatus,
                  discountPercentage: updatedDiscountPercentage,
                )
                    .then((_) {
                  memberProvider
                      .fetchMembers(); // Fetch the updated list of members
                }).catchError((error) {
                  // Handle errors here
                  print('Error editing member: $error');
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

  void _confirmDeleteMember(BuildContext context, int memberId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this member?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the deleteMember function with the member ID
                final memberProvider =
                    Provider.of<MemberProvider>(context, listen: false);
                memberProvider.deleteMember(memberId).then((_) {
                  memberProvider
                      .fetchMembers(); // Fetch the updated list of members
                }).catchError((error) {
                  // Handle errors here
                  print('Error deleting member: $error');
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
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: memberProvider.members.length,
        itemBuilder: (BuildContext context, int index) {
          final member = memberProvider.members[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, size: 32), // Use an icon
                  title: Text(
                    member['memberName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Membership Type ID: ${member['membershipTypeId']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${member['memberAddress']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${member['memberEmail']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${member['memberPhone']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start Date: ${member['startDate']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'End Date: ${member['endDate']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${member['status']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discount Percentage: ${member['discountPercentage']}',
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
                        _editMemberDialog(context, member);
                      },
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteMember(context, member['id']);
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
