import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_detail.dart';

class ApiService {
  static const String baseUrl = 'https://www.freetogame.com/api';

  Future<List<GameDetail>> getAllGames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/games'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => GameDetail.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil daftar game. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  Future<GameDetail> getGameDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/game?id=$id'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return GameDetail.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengambil detail game. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}