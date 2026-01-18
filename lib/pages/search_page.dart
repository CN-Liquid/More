import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:more/movie_card.dart';
import 'package:more/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic>? searchResults;

  void searchMovies() async {
    Response response = await get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=${dotenv.env['API_KEY']}&query=$searchTerm',
      ),
    );

    setState(() {
      searchResults = jsonDecode(response.body)['results'];
    });
  }

  String searchTerm = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Search Page')),
      body: Column(
        children: <Widget>[
          TextField(
            onSubmitted: (result) {
              searchTerm = result;
              if (searchTerm != '') {
                searchMovies();
              }
            },
          ),
          Expanded(
            child: searchResults == null
                ? (searchTerm.isEmpty
                      ? SizedBox.shrink()
                      : Center(child: CircularProgressIndicator()))
                : SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        children: searchResults!.map((data) {
                          return MovieCard(
                            movie: Movie(
                              title: data['original_title'],
                              imageUrl: data['poster_path'] != null
                                  ? 'https://image.tmdb.org/t/p/w500${data['poster_path']}'
                                  : 'https://www.content.numetro.co.za/ui_images/no_poster.png',
                              rating: data['vote_average'],
                              overview: data['overview'] ?? '',
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
