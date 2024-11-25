import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ujikom/models/Agenda.dart';  // Model Agenda

class AgendaService {
  static const String apiUrl = "https://b8e4-113-192-30-197.ngrok-free.app/api/dataagenda";

  // Fetch agendas
  Future<List<Agenda>> fetchAgendaData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response.body);  // Log the response body for debugging
        var jsonData = json.decode(response.body);
        List<Agenda> agendas = [];
        for (var agenda in jsonData['data']) {
          agendas.add(Agenda.fromJson(agenda));
        }
        return agendas;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Update an agenda
  Future<void> updateAgenda(int id, String judul, String deskripsi, String kategori) async {
  try {
    print('Request body: ${json.encode({
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
    })}');

    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori': kategori,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update agenda');
    }
  } catch (e) {
    throw Exception('Failed to update agenda: $e');
  }
}

  // Delete an agenda
  Future<void> deleteAgenda(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),  // Delete endpoint
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete agenda');
      }
    } catch (e) {
      throw Exception('Failed to delete agenda: $e');
    }
  }


// Tambahkan di dalam class AgendaService
Future<void> addAgenda(String judul, String deskripsi, int kategoriId) async {
  try {
    final response = await http.post(
      Uri.parse('https://b8e4-113-192-30-197.ngrok-free.app  /api/agenda'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori_id': kategoriId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add agenda');
    }
  } catch (e) {
    throw Exception('Failed to add agenda: $e');
  }
}


}