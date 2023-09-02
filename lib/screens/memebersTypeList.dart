import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MembershipTypeListScreen extends StatefulWidget {
  const MembershipTypeListScreen({Key? key}) : super(key: key);

  @override
  _MembershipTypeListScreenState createState() => _MembershipTypeListScreenState();
}

class _MembershipTypeListScreenState extends State<MembershipTypeListScreen> {
  List<dynamic> membershipTypes = [];

  Future<void> _fetchMembershipTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://[2400:1a00:b030:9fa0::2]:5000/api/membershipType/fetch'), // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          membershipTypes = data['membershipTypes'];
        });
      } else {
        // Handle error, show an error message to the user
        // For example:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to fetch membership types'),
        //   ),
        // );
      }
    } catch (e) {
      // Handle any network or server errors
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMembershipTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Type List'),
      ),
      body: ListView.builder(
        itemCount: membershipTypes.length,
        itemBuilder: (BuildContext context, int index) {
          final membershipType = membershipTypes[index];
          return Card(
            elevation: 3, // Add shadow to the card
            margin: EdgeInsets.all(10), // Add margin around the card
            child: ListTile(
              title: Text(
                membershipType['membershipType'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${membershipType['description']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Status: ${membershipType['status']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Discount Percentage: ${membershipType['discountPercentage']}%',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
