class Stylist {
  final int id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String initials;
  final List<String> tags;
  final String bio;
  final List<Map<String, String>> services;
  final bool isFavorite;

  const Stylist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.initials,
    required this.tags,
    required this.bio,
    required this.services,
    this.isFavorite = false,
  });
}
