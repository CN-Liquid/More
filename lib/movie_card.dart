import 'package:flutter/material.dart';
import 'movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/movie_page', arguments: movie);
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: 275 * 2 / 3,
            child: Column(
              children: <Widget>[
                Image.network(height: 275, movie.imageUrl),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        movie.title,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        '${movie.rating}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
