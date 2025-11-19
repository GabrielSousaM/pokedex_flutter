class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;
  final String url;
  bool isFavorite;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.url,
    this.isFavorite = false,
  });
}
