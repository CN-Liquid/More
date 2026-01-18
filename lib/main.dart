import 'package:flutter/material.dart';
import 'pages/search_page.dart';
import 'pages/home_page.dart';
import 'pages/movie_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/movie_page': (context) => MoviePage(),
};
Future<void> main() async {
  await dotenv.load(fileName: 'secret/.env');
  runApp(MaterialApp(home: Home(), routes: routes));
}
