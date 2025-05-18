import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech/navatech_test_app/bloc.dart';
import 'package:navatech/navatech_test_app/home_view.dart';
import 'package:navatech/navatech_test_app/repo.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumBloc(AlbumRepository(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => ImageBloc(AlbumRepository(dio: Dio())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}