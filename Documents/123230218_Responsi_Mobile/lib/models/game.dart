class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.shortDescription,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    String originalThumbnail = json['thumbnail'] ?? '';
    if (originalThumbnail.contains('freetogame.com') && !originalThumbnail.contains('images.weserv.nl')) {
      originalThumbnail = 'https://images.weserv.nl/?url=${Uri.encodeComponent(originalThumbnail)}';
    }
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: originalThumbnail,
      shortDescription: json['short_description'] ?? '',
      genre: json['genre'] ?? '',
      platform: json['platform'] ?? '',
      publisher: json['publisher'] ?? '',
      developer: json['developer'] ?? '',
      releaseDate: json['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'short_description': shortDescription,
      'genre': genre,
      'platform': platform,
      'publisher': publisher,
      'developer': developer,
      'release_date': releaseDate,
    };
  }
}
