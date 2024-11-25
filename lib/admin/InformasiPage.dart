import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AgendaPage.dart';
import 'GalleryPage.dart';
import 'Profile.dart';
import 'DashboardScreen.dart';

void main() {
  runApp(InformasiPage());
}

class InformasiPage extends StatefulWidget {
  @override
  _InformasiPageState createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage> {
  late Future<List<dynamic>> futureGalleryData;
  int _selectedIndex = 1; // Set index to Informasi

  @override
  void initState() {
    super.initState();
    futureGalleryData = fetchGalleryData();
  }

  Future<List<dynamic>> fetchGalleryData() async {
    const String apiUrl = "https://b8e4-113-192-30-197.ngrok-free.app/api/datagallery";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['data']; // Pastikan field 'data' ada di API
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
        case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformasiPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgendaPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Page'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureGalleryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          var galleryData = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Scroll horizontal
            child: SingleChildScrollView(
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Foto')),
                  DataColumn(label: Text('Judul')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Action')),
                ],
                rows: galleryData.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var item = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(index.toString())),
                    DataCell(
                      item['foto_url'] != null
                          ? Image.network(
                              item['foto_url'],
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                              },
                            )
                          : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                    DataCell(Text(item['text'] ?? 'Unknown')),
                    DataCell(Text(item['tanggal'] ?? 'Unknown')),
                    DataCell(
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditModal(context, item); // Modal untuk edit
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteGallery(context, item['id']); // Aksi hapus
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showEditModal(BuildContext context, dynamic item) {
    TextEditingController textController = TextEditingController(text: item['text']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Gallery"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Judul'),
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                _updateGallery(item['id'], textController.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateGallery(int id, String text) async {
    // Tambahkan logika API untuk update data
    print('Updating gallery ID: $id, New Text: $text');
    setState(() {
      futureGalleryData = fetchGalleryData(); // Reload data setelah update
    });
  }

  void _deleteGallery(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Gallery"),
          content: Text("Are you sure you want to delete this gallery?"),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                _deleteGalleryFromApi(id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGalleryFromApi(int id) async {
    // Tambahkan logika API untuk delete data
    print('Deleting gallery ID: $id');
    setState(() {
      futureGalleryData = fetchGalleryData(); // Reload data setelah hapus
    });
  }
}
