class Movie {
  final String title;
  final double rating;
  final String? imageUrl;
  final String? overview;
  final int id;
  final String? backdropUrl;
  final List<dynamic>? genres;
  Movie({
    required this.title,
    required this.rating,
    this.imageUrl = 'https://www.content.numetro.co.za/ui_images/no_poster.png',
    this.overview,
    required this.id,
    this.backdropUrl =
        'https://www.content.numetro.co.za/ui_images/no_poster.png',
    this.genres,
  });
}
