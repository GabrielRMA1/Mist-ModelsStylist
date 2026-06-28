import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/stylist.dart';
import '../../widgets/avatar_circle.dart';
import 'stylist_profile_screen.dart';
import 'client_bookings_screen.dart';
import 'client_favorites_screen.dart';
import 'client_profile_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _navIndex = 0;
  int _filterIndex = 0;

  static const _filters = ['Todos', 'Consultoria', 'Looks', 'Sob Medida', 'Eventos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${mockStylists.length} estilistas disponíveis',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: mockStylists.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _StylistCard(
                stylist: mockStylists[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StylistProfileScreen(stylist: mockStylists[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientBookingsScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientFavoritesScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientProfileScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.muted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),           label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline),        label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),          label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Olá, Mariana',
                          style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
                      SizedBox(height: 2),
                      Text('Encontre seu estilista',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ClientProfileScreen(),
                      ),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                          color: AppColors.gold, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('MS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF777777), size: 18),
                    SizedBox(width: 8),
                    Text('Buscar estilistas...',
                        style: TextStyle(color: Color(0xFF666666), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => Center(
          child: GestureDetector(
            onTap: () => setState(() => _filterIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _filterIndex == i ? AppColors.gold : AppColors.white,
                border: Border.all(
                    color: _filterIndex == i
                        ? AppColors.gold
                        : AppColors.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: _filterIndex == i ? Colors.white : AppColors.muted,
                  fontSize: 12,
                  fontWeight: _filterIndex == i
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StylistCard extends StatelessWidget {
  final Stylist stylist;
  final VoidCallback onTap;

  const _StylistCard({required this.stylist, required this.onTap});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarCircle(initials: stylist.initials),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stylist.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.dark)),
                      const SizedBox(height: 2),
                      Text(stylist.specialty,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 14),
                        const SizedBox(width: 2),
                        Text(stylist.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gold,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text('${stylist.reviews} avaliações',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: stylist.tags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag,
                            style: const TextStyle(
                                color: Color(0xFF8B6A30), fontSize: 11)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
