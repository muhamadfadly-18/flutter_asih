import 'package:flutter/material.dart';
import 'DashboardScreen.dart';
import 'InformasiPage.dart';
import 'AgendaPage.dart';
import 'Profile.dart';
import 'detail_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Map<String, dynamic>> products = [
    {
      "image": "assets/images/Smkn_04_bogor.jpg",
      "name": "SMKN 4 BOGOR",
      "text": "SMKN 4 BOGOR",
      "detail": "Merupakan sekolah kejuruan berbasis Teknologi Informasi dan Komunikasi. Sekolah ini didirikan dan dirintis pada tahun 2008 kemudian dibuka pada tahun 2009 yang saat ini terakreditasi A. Terletak di Jalan Raya Tajur Kp. Buntar, Muarasari, Bogor, sekolah ini berdiri di atas lahan seluas 12.724 m2 dengan berbagai fasilitas pendukung di dalamnya. Terdapat 54 staff pengajar dan 22 orang staff tata usaha, dikepalai oleh Drs. Mulya Mulprihartono, M. Si, sekolah ini merupakan investasi pendidikan yang tepat untuk putra/putri anda.",
    },
    {
      "image": "assets/images/upacara.jpg",
      "name": "Ekstrakurikuler Paskibra",
      "text": "Ekstrakurikuler Paskibra",
      "detail": "tes",
    },
    {
      "image": "assets/images/PPLG.jpg",
      "name": "Pengembangan Perangkat Lunak dan GIM",
      "text": "PPLG itu Paling Keren",
      "detail": "tes",
    },
    {
      "image": "assets/images/TKJ.jpg",
      "name": "Teknik Komputer dan Jaringan",
      "text": "TKJ Not bad",
      "detail": "tes",
    },
    {
      "image": "assets/images/teknik_otomotif.jpg",
      "name": "Teknik Otomotif",
      "text": "TOO itu Oke",
      "detail": "tes",
    },
    {
      "image": "assets/images/Pengelasan.jpg",
      "name": "Teknik Pengelasan dan Fabrikasi Logam",
      "text": "Teknik Pengelasan dan Fabrikasi Logam",
      "detail": "tes",
    },
    {
      "image": "assets/images/Pengelasan.jpg",
      "name": "Teknik Pengelasan dan Fabrikasi Logam1",
      "text": "Teknik Pengelasan dan Fabrikasi Logam1",
      "detail": "tes",
    },
  ];

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
          break;
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
          // Tetap di halaman ini
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      name: products[index]['name'],
                      image: products[index]['image'],
                      text: products[index]['text'],
                      detail: products[index]['detail'],
                    ),
                  ),
                );
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(products[index]['image']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            products[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            products[index]['text'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
}
