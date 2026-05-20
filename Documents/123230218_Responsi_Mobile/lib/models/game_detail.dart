class GameScreenshot {
  final int id;
  final String image;

  GameScreenshot({required this.id, required this.image});

  factory GameScreenshot.fromJson(Map<String, dynamic> json) {
    String originalImage = json['image'] ?? '';
    if (originalImage.contains('freetogame.com') && !originalImage.contains('images.weserv.nl')) {
      originalImage = 'https://images.weserv.nl/?url=${Uri.encodeComponent(originalImage)}';
    }
    return GameScreenshot(
      id: json['id'] ?? 0,
      image: originalImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}

class GameDetail {
  final int id;
  final String title;
  final String thumbnail;
  final String status;
  final String shortDescription;
  final String description;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final List<GameScreenshot> screenshots;

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    String originalThumbnail = json['thumbnail'] ?? '';
    if (originalThumbnail.contains('freetogame.com') && !originalThumbnail.contains('images.weserv.nl')) {
      originalThumbnail = 'https://images.weserv.nl/?url=${Uri.encodeComponent(originalThumbnail)}';
    }
    var screenshotsList = json['screenshots'] as List? ?? [];
    List<GameScreenshot> screenshotsObj = screenshotsList
        .map((screenshotJson) => GameScreenshot.fromJson(screenshotJson))
        .toList();

    return GameDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: originalThumbnail,
      status: json['status'] ?? '',
      shortDescription: json['short_description'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      platform: json['platform'] ?? '',
      publisher: json['publisher'] ?? '',
      developer: json['developer'] ?? '',
      releaseDate: json['release_date'] ?? '',
      screenshots: screenshotsObj,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'status': status,
      'short_description': shortDescription,
      'description': description,
      'genre': genre,
      'platform': platform,
      'publisher': publisher,
      'developer': developer,
      'release_date': releaseDate,
      'screenshots': screenshots.map((s) => s.toJson()).toList(),
    };
  }
}
