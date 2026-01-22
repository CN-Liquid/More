import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:more/movie.dart';

//TODO : Incorporate more data from the TMDB api

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Movie? movie;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getDetails());
  }

  void getDetails() async {
    int movieId = ModalRoute.of(context)!.settings.arguments as int;
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=${dotenv.env['API_KEY']}',
      ),
    );
    Map<String, dynamic> result = jsonDecode(response.body);

    setState(() {
      movie = Movie(
        title: result['original_title'],
        imageUrl: result['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
            : null,
        rating: result['vote_average'],
        overview: result['overview'] ?? '',
        id: movieId,
        backdropUrl: result['backdrop_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${result['backdrop_path']}'
            : null,
        genres: result['genres'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey, title: Text('MovieDetails')),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: movie == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(movie!.backdropUrl!),
                  SizedBox(
                    height: 275,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(width: 2 * 275 / 3, movie!.imageUrl!),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.start,
                            movie!.overview!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 2 * 275 / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(movie!.title),
                                Text('${movie!.rating}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      ...movie!.genres!.map((genres) {
                        return Text('${genres['name']} ');
                      }),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
