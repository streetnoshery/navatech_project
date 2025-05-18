import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech/navatech_test_app/bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedAlbum; // Variable to store the selected album ID
  @override
  void initState() {
    super.initState();
    // Access the AlbumBloc via BlocProvider
    final albumBloc = BlocProvider.of<AlbumBloc>(context);

    // Dispatch event to fetch albums
    albumBloc.add(FetchAlbumsEvent());
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infinite Scrolling Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AlbumError) {
            return Center(child: Text(state.message));
          } else if (state is AlbumLoaded) {
            return ListView.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                final album = state.albums[index];
                final albumId = album.id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        album.title,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (selectedAlbum == albumId)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: BlocBuilder<ImageBloc, ImageState>(
                          builder: (context, imageState) {
                            if (imageState is ImageLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (imageState is ImageError) {
                              return Text(imageState.message);
                            } else if (imageState is ImageLoaded) {
                              return SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 20);
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageState.photos.length,
                                  itemBuilder: (context, imageIndex) {
                                    final photo = imageState.photos[imageIndex];
                                    return Image.network(
                                      photo.url,
                                    );
                                  },
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedAlbum =
                                albumId; // Set the selected album ID
                          });
                          // Trigger fetching images for the selected album
                          final imageBloc = BlocProvider.of<ImageBloc>(context);
                          imageBloc.add(FetchImagesEvent(album.id));
                        },
                        child: Text(
                          'Load Images',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
