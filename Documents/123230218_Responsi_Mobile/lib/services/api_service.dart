import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../models/game_detail.dart';

class ApiService {
  static const String baseUrl = 'https://www.freetogame.com/api';

  Future<List<Game>> _loadLocalGames() async {
    try {
      final jsonString = await rootBundle.loadString('assets/games.json');
      final List<dynamic> data = json.decode(jsonString);
      return data.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Game>> fetchGames() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/games'),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      return _loadLocalGames();
    }
  }

  Future<GameDetail> fetchGameDetail(int gameId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/game?id=$gameId'),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return GameDetail.fromJson(data);
      } else {
        throw Exception('Failed to load game detail');
      }
    } catch (e) {
      try {
        final localGames = await _loadLocalGames();
        final match = localGames.firstWhere((g) => g.id == gameId);
        return GameDetail(
          id: match.id,
          title: match.title,
          thumbnail: match.thumbnail,
          status: "Live",
          shortDescription: match.shortDescription,
          description: match.shortDescription,
          genre: match.genre,
          platform: match.platform,
          publisher: match.publisher,
          developer: match.developer,
          releaseDate: match.releaseDate,
          screenshots: [GameScreenshot(id: 1, image: match.thumbnail)],
        );
      } catch (_) {
        throw Exception('Game detail not found');
      }
    }
  }
}
