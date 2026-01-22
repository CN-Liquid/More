import 'package:flutter/material.dart';
import 'package:more/movie.dart';
import 'package:more/movie_card.dart';

// This class is meant to be used in the home page to show a row of scrollable movies
// Trending Now , Popular movies , Highest Rated are some examples

// TODO : Make the UI more refined

class HorizontalScrollMoviesCard extends StatelessWidget {
  const HorizontalScrollMoviesCard({
    super.key,
    this.title,
    required this.movieList,
  });

  final List<dynamic> movieList;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(title ?? ''),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: movieList.map((data) {
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: MovieCard(
                  movie: Movie(
                    title: data['title'],
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${data['poster_path']}',
                    rating: data['vote_average'],
                    overview: data['overview'] ?? '',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
