class Movie {
  final String title;
  final double rating;
  final String imageUrl;
  final String? overview;
  Movie({
    required this.title,
    required this.rating,
    required this.imageUrl,
    this.overview,
  });
}
