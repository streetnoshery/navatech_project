// Fetch album data from API and local database
import 'package:dio/dio.dart';
import 'package:navatech/navatech_test_app/album_model.dart';

class AlbumRepository {
  final Dio dio;

  AlbumRepository({required this.dio});

  Future<List<Album>> fetchAlbums() async {
    // Check if data is available in the local database
    List<Album> albums = [];
    // If no data, fetch from API
      final response = await dio.get('https://jsonplaceholder.typicode.com/albums');
      albums = (response.data as List).map((album) => Album.fromJson(album)).toList();
    return albums;
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/photos', queryParameters: {'albumId': albumId});
    return (response.data as List).map((photo) => Photo.fromJson(photo)).toList();
  }
}
