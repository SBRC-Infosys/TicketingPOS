// import 'package:flutter/material.dart';
// import 'package:ticketing_system/provider/memberProvider.dart';

// class CreateMemberDialog extends StatefulWidget {
//   const CreateMemberDialog({Key? key}) : super(key: key);

//   @override
//   _CreateMemberDialogState createState() => _CreateMemberDialogState();
// }

// class _CreateMemberDialogState extends State<CreateMemberDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _memberNameController = TextEditingController();
//   final TextEditingController _memberAddressController = TextEditingController();
//   final TextEditingController _memberEmailController = TextEditingController();
//   final TextEditingController _memberPhoneController = TextEditingController();
//   DateTime? _selectedStartDate;
//   DateTime? _selectedEndDate;
//   String? _selectedStatus;
//   MembershipType? _selectedMembershipType;
//   double? _discountPercentage;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Create Member'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Membership Type Dropdown
//               DropdownButtonFormField<MembershipType>(
//                 value: _selectedMembershipType,
//                 onChanged: (MembershipType? value) {
//                   setState(() {
//                     _selectedMembershipType = value;
//                     _discountPercentage = value?.discountPercentage;
//                   });
//                 },
//                 items: _membershipTypeDropdownItems(),
//                 decoration: const InputDecoration(
//                   labelText: 'Membership Type',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Member Name
//               TextFormField(
//                 controller: _memberNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Member Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a member name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Member Address
//               TextFormField(
//                 controller: _memberAddressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Member Address',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a member address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Member Email
//               TextFormField(
//                 controller: _memberEmailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Member Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a member email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Member Phone
//               TextFormField(
//                 controller: _memberPhoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Member Phone',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a member phone';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Start Date Calendar
//               _datePickerField(
//                 labelText: 'Start Date',
//                 selectedDate: _selectedStartDate,
//                 onDateSelected: (date) {
//                   setState(() {
//                     _selectedStartDate = date;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),

//               // End Date Calendar
//               _datePickerField(
//                 labelText: 'End Date',
//                 selectedDate: _selectedEndDate,
//                 onDateSelected: (date) {
//                   setState(() {
//                     _selectedEndDate = date;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Membership Status Dropdown
//               _statusDropdown(),

//               // Discount Percentage
//               TextFormField(
//                 initialValue: _discountPercentage?.toString() ?? '',
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Discount Percentage',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         ElevatedButton(
//           child: const Text('Cancel'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (_formKey.currentState!.validate()) {
//               final memberName = _memberNameController.text;
//               final memberAddress = _memberAddressController.text;
//               final memberEmail = _memberEmailController.text;
//               final memberPhone = _memberPhoneController.text;
//               final startDate = _selectedStartDate?.toLocal().toString() ?? '';
//               final endDate = _selectedEndDate?.toLocal().toString() ?? '';
//               final status = _selectedStatus ?? '';
//               final membershipTypeId = _selectedMembershipType?.id;
//               final discountPercentage = _discountPercentage;

//               await MemberProvider().createMember(
//                 membershipTypeId: membershipTypeId,
//                 memberName: memberName,
//                 memberAddress: memberAddress,
//                 memberEmail: memberEmail,
//                 memberPhone: memberPhone,
//                 startDate: startDate,
//                 endDate: endDate,
//                 status: status,
//                 discountPercentage: discountPercentage,
//               );

//               Navigator.of(context).pop();

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Member created successfully'),
//                 ),
//               );
//             }
//           },
//           child: const Text('Create'),
//         ),
//       ],
//     );
//   }

//   List<DropdownMenuItem<MembershipType>> _membershipTypeDropdownItems() {
//     return _membershipTypes.map((type) {
//       return DropdownMenuItem<MembershipType>(
//         value: type,
//         child: Text(type.membershipType),
//       );
//     }).toList();
//   }

//   Widget _datePickerField({
//     required String labelText,
//     required DateTime? selectedDate,
//     required Function(DateTime?) onDateSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(labelText),
//         ElevatedButton(
//           onPressed: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: selectedDate ?? DateTime.now(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2101),
//             );
//             if (date != null) {
//               onDateSelected(date);
//             }
//           },
//           child: Text(
//             selectedDate != null
//                 ? selectedDate.toLocal().toString().split(' ')[0]
//                 : 'Select $labelText',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _statusDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _selectedStatus,
//       onChanged: (value) {
//         setState(() {
//           _selectedStatus = value;
//         });
//       },
//       items: _statusOptions.map((status) {
//         return DropdownMenuItem<String>(
//           value: status,
//           child: Text(status),
//         );
//       }).toList(),
//       decoration: const InputDecoration(
//         labelText: 'Status',
//         border: OutlineInputBorder(),
//       ),
//     );
//   }
// }
