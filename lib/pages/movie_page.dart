import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 500,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: SizedBox(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double parentWidth = constraints.maxWidth;
                          double backdropHeight = parentWidth * 9 / 16;
                          return Stack(
                            children: [
                              Image.network(
                                height: backdropHeight,
                                fit: BoxFit.cover,
                                alignment: Alignment.topLeft,
                                width: parentWidth,
                                movie!.backdropUrl!,
                              ),
                              Positioned(
                                top: 15, // Hardcoded 20px from top
                                bottom:
                                    15, // Hardcoded 20px from bottom (Keeps it inside)
                                left: 20, // Hardcoded 20px from left
                                child: AspectRatio(
                                  aspectRatio:
                                      2 /
                                      3, // Forces the width to scale with height
                                  child: Image.network(
                                    movie!.imageUrl!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    movie!.title,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.star),
                            Text('${movie!.rating}'),
                            SizedBox(width: 20),
                            Text('Genre : '),
                            ...movie!.genres!.map((genres) {
                              return Text('${genres['name']} ');
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Text(textAlign: TextAlign.start, movie!.overview!),
                  ),
                ],
              ),
      ),
    );
  }
}
