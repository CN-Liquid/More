import 'package:flutter/material.dart';
import '../movie_card.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:more/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic>? trendingMovies;
  List<dynamic>? popularMovies;

  @override
  void initState() {
    super.initState();
    getTrendingMovies();
    getPopularMovies();
  }

  void getTrendingMovies() async {
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?language=en-US&api_key=${dotenv.env['API_KEY']}',
      ),
    );
    final List<dynamic> moviesData = jsonDecode(response.body)['results'];
    setState(() {
      trendingMovies = moviesData; // update state and rebuild
    });
  }

  void getPopularMovies() async {
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=${dotenv.env['API_KEY']}',
      ),
    );
    final List<dynamic> moviesData = jsonDecode(response.body)['results'];
    setState(() {
      popularMovies = moviesData; // update state and rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Front Page')),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            trendingMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Trendig Now'),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: trendingMovies!.map((data) {
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
                      ],
                    ),
                  ),
            popularMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Popular Movies'),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: popularMovies!.map((data) {
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
                      ],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
