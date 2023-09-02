// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MemberListScreen extends StatefulWidget {
//   const MemberListScreen({Key? key}) : super(key: key);

//   @override
//   _MemberListScreenState createState() => _MemberListScreenState();
// }

// class _MemberListScreenState extends State<MemberListScreen> {
//   List<dynamic> members = [];

//   Future<void> _fetchMembers() async {
//     try {
//       final response = await http.get(
//          Uri.parse('http://[2400:1a00:b030:9fa0::2]:5000/api/member/fetch'), // Replace with your API endpoint
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           members = data['members'];
//         });
//       } else {
//         // Handle error, show an error message to the user
//         // For example:
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text('Failed to fetch members'),
//         //   ),
//         // );
//       }
//     } catch (e) {
//       // Handle any network or server errors
//       print('Error: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchMembers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Member List'),
//       ),
//       body: ListView.builder(
//         itemCount: members.length,
//         itemBuilder: (BuildContext context, int index) {
//           final member = members[index];
//           return Card(
//             elevation: 3, // Add shadow to the card
//             margin: EdgeInsets.all(10), // Add margin around the card
//             child: ListTile(
//               title: Text(
//                 member['memberName'],
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Membership Type ID: ${member['membershipTypeId']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Address: ${member['memberAddress']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Email: ${member['memberEmail']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Phone: ${member['memberPhone']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Start Date: ${member['startDate']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'End Date: ${member['endDate'] ?? 'N/A'}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Status: ${member['status']}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Discount Percentage: ${member['discountPercentage']}%',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }