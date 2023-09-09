import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/userProvider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Future<void> _fetchUsers(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchAllUsers();
    } catch (error) {
      // Handle the error, e.g., show an error message
      print('Error fetching users: $error');
      _showSnackBar('Error fetching users: $error');
    }
  }

  Future<void> _editUser(BuildContext context, String userId,
      Map<String, dynamic> updatedUserData) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .editUser(userId, updatedUserData);
      // Show a success message
      _showSnackBar('User information updated successfully');
    } catch (error) {
      // Handle the error and show an error message
      print('Error editing user: $error');
      _showSnackBar('Error editing user: $error');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    // Fetch the list of users when the page is first loaded
    _fetchUsers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchUsers(context), // Refresh button
          ),
        ],
      ),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context).fetchAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No users found.'),
          );
        } else {
          final users = snapshot.data;
          return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId =
                  user['id']; // Assuming 'id' is the user's unique identifier

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${user['firstname']} ${user['lastname']}'),
                  subtitle: Text('Email: ${user['email']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Show a dialog to edit the user's information
                      _showEditDialog(context, userId.toString(), user);
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, String userId,
      Map<String, dynamic> userData) async {
    final TextEditingController firstnameController =
        TextEditingController(text: userData['firstname']);
    final TextEditingController lastnameController =
        TextEditingController(text: userData['lastname']);
    final TextEditingController emailController =
        TextEditingController(text: userData['email']);
    final TextEditingController mobileController =
        TextEditingController(text: userData['mobile']);
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Namer',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedUserData = {
                  'firstname': firstnameController.text,
                  'lastname': lastnameController.text,
                  'email': emailController.text,
                  'mobile': mobileController.text,
                  'password': passwordController.text, // Include password
                };
                // Call the _editUser method to update the user
                await _editUser(context, userId, updatedUserData);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
