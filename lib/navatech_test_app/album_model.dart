// Album model
class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }
}

// Image model
class Photo {
  final int id;
  final int albumId;
  final String url;

  Photo({required this.id, required this.albumId, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(id: json['id'], albumId: json['albumId'], url: json['url']);
  }
}
