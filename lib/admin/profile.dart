import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String userName = "";
  String userEmail = "";
  String updatedAt = "";

  bool isLoading = true; // Untuk menampilkan loading indicator
  String errorMessage = ""; // Untuk menangani error dari API

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

 Future<void> fetchUserData() async {
  final String apiUrl = "https://b8e4-113-192-30-197.ngrok-free.app/api/user";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        // Ambil pengguna pertama dari array data
        final firstUser = jsonData['data'][0];

        setState(() {
          userName = firstUser['name'] ?? "N/A";
          userEmail = firstUser['email'] ?? "N/A";
          updatedAt = firstUser['updated_at'] ?? "N/A";
          nameController.text = userName;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Unexpected data format from server.";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = "Failed to fetch data. Status code: ${response.statusCode}";
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = "Error fetching user data: $e";
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // User Information Card
                      Card(
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/profile.jpg'), // Placeholder image
                          ),
                          title: Text(userName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email: $userEmail"),
                              Text(
                                "Updated: $updatedAt",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Edit Profile Card
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              // Name Field
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              SizedBox(height: 16),
                              // Password Field
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Leave blank to keep current password',
                                ),
                              ),
                              SizedBox(height: 16),
                              // Update Button
                              ElevatedButton(
                                onPressed: () {
                                  print('Updating profile...');
                                  // Implement API call for updating profile here
                                },
                                child: Text('Update Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
