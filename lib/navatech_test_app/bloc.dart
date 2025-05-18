// Album Event
import 'package:bloc/bloc.dart';
import 'package:navatech/navatech_test_app/album_model.dart';
import 'package:navatech/navatech_test_app/repo.dart';

abstract class AlbumEvent {}

class FetchAlbumsEvent extends AlbumEvent {}

// Album State
abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  AlbumLoaded(this.albums);
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);
}

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc(this.albumRepository) : super(AlbumInitial()) {
    // Register the event handler for FetchAlbumsEvent
    on<FetchAlbumsEvent>(_onFetchAlbumsEvent);
  }

  // Event handler to fetch albums
  Future<void> _onFetchAlbumsEvent(
    FetchAlbumsEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.fetchAlbums();
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError('Failed to load albums'));
    }
  }
}


// Image Event
abstract class ImageEvent {}

class FetchImagesEvent extends ImageEvent {
  final int albumId;

  FetchImagesEvent(this.albumId);
}

// Image State
abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<Photo> photos;

  ImageLoaded(this.photos);
}

class ImageError extends ImageState {
  final String message;

  ImageError(this.message);
}

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final AlbumRepository albumRepository;
  final Map<int, ImageState> _albumImageStates = {}; // Track image states for specific albums

  ImageBloc(this.albumRepository) : super(ImageInitial()) {
    on<FetchImagesEvent>(_onFetchImagesEvent);
  }

  // Event handler to fetch images for the selected album
  Future<void> _onFetchImagesEvent(
    FetchImagesEvent event,
    Emitter<ImageState> emit,
  ) async {

    // Otherwise, fetch images for the given album
    emit(ImageLoading());
    try {
      final photos = await albumRepository.fetchPhotos(event.albumId);
      final loadedState = ImageLoaded(photos);

      // Cache the loaded state for this album
      _albumImageStates[event.albumId] = loadedState;
      
      emit(loadedState);
    } catch (e) {
      emit(ImageError('Failed to load images'));
    }
  }
}
