import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/stylist.dart';
import '../../theme/app_theme.dart';
import '../../widgets/avatar_circle.dart';
import 'stylist_profile_screen.dart';

class ClientFavoritesScreen extends StatefulWidget {
  const ClientFavoritesScreen({super.key});

  @override
  State<ClientFavoritesScreen> createState() => _ClientFavoritesScreenState();
}

class _ClientFavoritesScreenState extends State<ClientFavoritesScreen> {
  late List<int> _favoriteIds;

  @override
  void initState() {
    super.initState();
    _favoriteIds = mockStylists
        .where((stylist) => stylist.isFavorite)
        .map((stylist) => stylist.id)
        .toList();
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites =
        mockStylists.where((stylist) => _favoriteIds.contains(stylist.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: favorites.isEmpty
          ? const _EmptyFavorites()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final stylist = favorites[index];
                return _FavoriteCard(
                  stylist: stylist,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StylistProfileScreen(stylist: stylist),
                    ),
                  ),
                  onUnfavorite: () => _toggleFavorite(stylist.id),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 13),
                      const SizedBox(width: 3),
                      Text(
                        stylist.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
