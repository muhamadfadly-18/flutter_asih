// import 'package:flutter/material.dart';



// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
  
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: '/', // Set the initial route
//       
//     );
//   }
// }


// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/login'); // Navigate to Login screen
//           },
//           child: const Text('Go to Login'),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'register.dart';
import 'admin/DashboardScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      routes: {
        // '/': (context) => const MyApp(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin/DashboardScreen': (context) => DashboardScreen(),
        // Tambahkan rute ke halaman Gallery
      },
    );
  }
}

class MainPage extends StatelessWidget {
  Future<List<dynamic>> fetchGalleryData() async {
    const String apiUrl = "https://b8e4-113-192-30-197.ngrok-free.app/api/datagallery";
    
    try {
      final response = await http.get(Uri.parse(apiUrl)); // Menggunakan await untuk menangani HTTP request
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['data'];  // Mengambil data dari respons
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.photo_library),
            SizedBox(width: 10),
            Text("Gallery Sekolah"),
            Spacer(),  // Spacer agar tombol terpisah ke kanan
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Login"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Register"),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchGalleryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final galleryData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Smkn_04_bogor.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "SMKN 04 BOGOR",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Latest Photos",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Gallery Section - Using ListView instead of GridView
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),  // Prevent ListView from scrolling
                    shrinkWrap: true,
                    itemCount: galleryData.length,
                    itemBuilder: (context, index) {
                      final item = galleryData[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item['foto_url'], // Menggunakan Image.network untuk gambar dari URL
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,  // Set a fixed height for the image
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['text'], // Title from API
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text("Tanggal: ${item['tanggal']}"), // Date from API
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Footer Section
                  Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "© 2024 Ashinovatech Company. All rights reserved.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
