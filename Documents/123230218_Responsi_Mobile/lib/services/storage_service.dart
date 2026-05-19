import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';

class StorageService {
  static const String _prefEmailKey = 'user_email';
  static const String _prefIsLoggedInKey = 'is_logged_in';
  static const String _hiveBoxName = 'library_games_box';

  static late SharedPreferences _prefs;
  static late Box _libraryBox;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    _libraryBox = await Hive.openBox(_hiveBoxName);
  }

  static Future<void> saveSession(String email) async {
    await _prefs.setString(_prefEmailKey, email);
    await _prefs.setBool(_prefIsLoggedInKey, true);
  }

  static String getEmail() {
    return _prefs.getString(_prefEmailKey) ?? '';
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_prefIsLoggedInKey) ?? false;
  }

  static Future<void> clearSession() async {
    await _prefs.remove(_prefEmailKey);
    await _prefs.setBool(_prefIsLoggedInKey, false);
  }

  static List<Game> getLibraryGames() {
    final List<Game> list = [];
    for (var key in _libraryBox.keys) {
      final data = _libraryBox.get(key);
      if (data != null) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(data);
        list.add(Game.fromJson(map));
      }
    }
    return list;
  }

  static Future<void> addToLibrary(Game game) async {
    await _libraryBox.put(game.id, game.toJson());
  }

  static Future<void> removeFromLibrary(int gameId) async {
    await _libraryBox.delete(gameId);
  }

  static bool isInLibrary(int gameId) {
    return _libraryBox.containsKey(gameId);
  }

  static int getLibraryCount() {
    return _libraryBox.length;
  }
}
