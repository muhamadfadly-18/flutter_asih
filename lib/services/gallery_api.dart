import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gallery_item.dart';

Future<List<Gallery>> fetchGallery() async {
  final response = await http.get(Uri.parse('https://b8e4-113-192-30-197.ngrok-free.app/api/datagallery'));

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    return data.map((item) => Gallery.fromJson(item)).toList();
  } else {
    print('Failed to load gallery data. Status Code: ${response.statusCode}');
    throw Exception('Failed to load gallery data');
  }
}
