import 'package:flutter/material.dart';
import 'package:ujikom/models/Agenda.dart';
import 'package:ujikom/services/Agenda.dart';
import 'DashboardScreen.dart';

import 'GalleryPage.dart';
import 'Profile.dart';
import 'InformasiPage.dart';


class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Future<List<Agenda>> futureAgendas;
  int _selectedIndex = 2; // Indicating that we are on the Agenda page

  @override
  void initState() {
    super.initState();
    futureAgendas = AgendaService().fetchAgendaData();  // Fetching agenda data
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Navigating to the respective pages
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
          title: const Text('Agenda'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showAddModal(context),
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Agenda>>(
          future: futureAgendas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available"));
            }

            var agendas = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Judul')),
                    DataColumn(label: Text('Deskripsi')),
                    DataColumn(label: Text('Kategori')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: agendas.map((agenda) {
                    return DataRow(cells: [
                      DataCell(Text(agenda.id.toString())),
                      DataCell(Text(agenda.judul)),
                      DataCell(Text(agenda.deskripsi)),
                      DataCell(Text(agenda.kategori)),
                      DataCell(
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditModal(context, agenda); // Trigger Edit Modal
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteAgenda(context, agenda.id); // Trigger Delete action
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

  // Edit Modal to update agenda
  void _showEditModal(BuildContext context, Agenda agenda) {
    TextEditingController judulController = TextEditingController(text: agenda.judul);
    TextEditingController deskripsiController = TextEditingController(text: agenda.deskripsi);
    String selectedKategori = agenda.kategori;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Agenda"),
          content: Column(
            children: <Widget>[
              TextField(controller: judulController, decoration: InputDecoration(labelText: 'Judul')),
              TextField(controller: deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi')),
              // Uncomment and update if categories need to be selected
              // DropdownButton<String>(
              //   value: selectedKategori,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedKategori = value!;
              //     });
              //   },
              //   items: ['Kategori 1', 'Kategori 2', 'Kategori 3'].map((String kategori) {
              //     return DropdownMenuItem<String>(
              //       value: kategori,
              //       child: Text(kategori),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                _updateAgenda(agenda.id, judulController.text, deskripsiController.text, selectedKategori);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Update agenda through API
  Future<void> _updateAgenda(int id, String judul, String deskripsi, String kategori) async {
    try {
      print('Updating agenda with ID: $id, Judul: $judul, Deskripsi: $deskripsi, Kategori: $kategori');
      await AgendaService().updateAgenda(id, judul, deskripsi, kategori);
      setState(() {
        futureAgendas = AgendaService().fetchAgendaData();  // Reload data
      });
    } catch (e) {
      print('Error updating agenda: $e');
    }
  }

  // Delete agenda through API
  void _deleteAgenda(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Agenda"),
          content: Text("Are you sure you want to delete this agenda?"),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                _deleteAgendaFromApi(id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  

  // Delete agenda from API
  Future<void> _deleteAgendaFromApi(int id) async {
    try {
      await AgendaService().deleteAgenda(id);
      setState(() {
        futureAgendas = AgendaService().fetchAgendaData();  // Reload the data
      });
    } catch (e) {
      print('Error deleting agenda: $e');
    }
  }


void _showAddModal(BuildContext context) {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  int selectedKategoriId = 1; // Default category ID (adjust according to your categories)

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Tambah Agenda"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            // DropdownButton<int>(
            //   value: selectedKategoriId,
            //   onChanged: (int? newValue) {
            //     setState(() {
            //       selectedKategoriId = newValue!;
            //     });
            //   },
            //   items: [
            //     DropdownMenuItem<int>(
            //       value: 1, // Example category ID
            //       child: Text('Kategori 1'),
            //     ),
            //     DropdownMenuItem<int>(
            //       value: 2, // Example category ID
            //       child: Text('Kategori 2'),
            //     ),
            //     DropdownMenuItem<int>(
            //       value: 3, // Example category ID
            //       child: Text('Kategori 3'),
            //     ),
            //   ],
            // ),
          ],
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              await _addAgenda(judulController.text, deskripsiController.text, selectedKategoriId);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}


Future<void> _addAgenda(String judul, String deskripsi, int kategoriId) async {
  try {
    await AgendaService().addAgenda(judul, deskripsi, kategoriId); // Passing kategoriId as an integer
    setState(() {
      futureAgendas = AgendaService().fetchAgendaData(); // Reload data after adding
    });
  } catch (e) {
    print('Error adding agenda: $e');
  }
}


}