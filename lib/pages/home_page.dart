import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:more/horizontal_scroll_movies_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic>? trendingMovies;
  List<dynamic>? popularMovies;
  List<dynamic>? nowPlayingMovies;
  List<dynamic>? topRatedMovies;

  @override
  void initState() {
    super.initState();
    getTrendingMovies();
    getPopularMovies();
    getNowPlayingMovies();
    getTopratedMovies();
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

  void getNowPlayingMovies() async {
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=${dotenv.env['API_KEY']}',
      ),
    );
    final List<dynamic> moviesData = jsonDecode(response.body)['results'];

    setState(() {
      nowPlayingMovies = moviesData;
    });
  }

  void getTopratedMovies() async {
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=${dotenv.env['API_KEY']}',
      ),
    );
    final List<dynamic> moviesData = jsonDecode(response.body)['results'];

    setState(() {
      topRatedMovies = moviesData;
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
            SizedBox(height: 10),
            trendingMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : HorizontalScrollMoviesCard(
                    movieList: trendingMovies!,
                    title: 'Trending Now',
                  ),
            popularMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : HorizontalScrollMoviesCard(
                    movieList: popularMovies!,
                    title: 'Popular Movies',
                  ),
            nowPlayingMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : HorizontalScrollMoviesCard(
                    movieList: nowPlayingMovies!,
                    title: 'Now Playing',
                  ),
            topRatedMovies == null
                ? SizedBox(
                    height: 275,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : HorizontalScrollMoviesCard(
                    movieList: topRatedMovies!,
                    title: 'Top Rated',
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
