import 'package:flutter/material.dart';

import '../../models/stylist.dart';
import '../../services/estilista_service.dart';
import '../../services/favorite_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/avatar_circle.dart';
import 'stylist_profile_screen.dart';

class ClientFavoritesScreen extends StatefulWidget {
  const ClientFavoritesScreen({super.key});

  @override
  State<ClientFavoritesScreen> createState() => _ClientFavoritesScreenState();
}

class _ClientFavoritesScreenState extends State<ClientFavoritesScreen> {
  final _estilistaService = EstilistaService();
  final _favoriteService = FavoriteService();

  late Future<List<Stylist>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
  }

  Future<List<Stylist>> _loadFavorites() async {
    final ids = await _favoriteService.getFavoriteStylistIds();
    final stylists = await _estilistaService.listarTodos();
    return stylists.where((stylist) => ids.contains(stylist.id)).toList();
  }

  Future<void> _toggleFavorite(int stylistId) async {
    await _favoriteService.toggleFavorite(stylistId);

    if (!mounted) return;

    setState(() {
      _favoritesFuture = _loadFavorites();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estilista removido dos favoritos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder<List<Stylist>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const _EmptyFavorites();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final stylist = favorites[index];
              return _FavoriteCard(
                stylist: stylist,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StylistProfileScreen(stylist: stylist),
                    ),
                  ).then((_) {
                    if (!mounted) return;

                    setState(() {
                      _favoritesFuture = _loadFavorites();
                    });
                  });
                },
                onUnfavorite: () => _toggleFavorite(stylist.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 56, color: AppColors.border),
            SizedBox(height: 14),
            Text(
              'Nenhum favorito ainda',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Toque no coração no perfil de um estilista para adicioná-lo aos favoritos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.stylist,
    required this.onTap,
    required this.onUnfavorite,
  });

  final Stylist stylist;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            AvatarCircle(initials: stylist.initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stylist.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stylist.specialty,
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onUnfavorite,
              icon: const Icon(
                Icons.favorite,
                color: Color(0xFFE53935),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
