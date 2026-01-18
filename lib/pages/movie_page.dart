import 'package:flutter/material.dart';
import 'package:more/movie.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instead of the constructor pass the argument via the navigator
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey, title: Text('MovieDetails')),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(width: 2 * 275 / 3, movie.imageUrl),
                SizedBox(width: 10),
                Expanded(
                  child: Text(textAlign: TextAlign.start, movie.overview!),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(movie.title),
            Text('${movie.rating}'),
          ],
        ),
      ),
    );
  }
}
