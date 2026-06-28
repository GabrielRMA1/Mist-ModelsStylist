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

  factory Stylist.fromJson(Map<String, dynamic> json) {
    final name = json['nome']?.toString() ?? json['name']?.toString() ?? '';
    final specialty =
        json['especialidade']?.toString() ?? json['specialty']?.toString() ?? '';
    final description =
        json['descricao']?.toString() ?? json['bio']?.toString() ?? '';

    return Stylist(
      id: json['id'] as int? ?? 0,
      name: name,
      specialty: specialty,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviews: json['reviews'] as int? ?? 0,
      initials: _initials(name),
      tags: specialty.isEmpty ? const [] : [specialty],
      bio: description.isEmpty
          ? 'Estilista profissional cadastrado na plataforma Mist.'
          : description,
      services: const [
        {'name': 'Consultoria de Estilo', 'price': 'A combinar'},
        {'name': 'Montagem de Look', 'price': 'A combinar'},
        {'name': 'Roupa Sob Medida', 'price': 'A combinar'},
      ],
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  static String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'MS';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
