import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/stylist.dart';
import '../../widgets/gold_button.dart';
import 'create_booking_screen.dart';

class StylistProfileScreen extends StatelessWidget {
  final Stylist stylist;

  const StylistProfileScreen({super.key, required this.stylist});

  @override
  Widget build(BuildContext context) {
    final isFavorite = stylist.isFavorite;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoCard(
                    title: 'Sobre',
                    child: Text(
                      stylist.bio,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted, height: 1.7),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoCard(
                    title: 'Serviços oferecidos',
                    child: Column(
                      children: stylist.services
                          .map(
                            (s) => Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.border, width: 0.5)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(s['name']!,
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColors.dark)),
                                  Text(s['price']!,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GoldButton(
                    label: isFavorite
                        ? 'Remover dos Favoritos'
                        : 'Adicionar aos Favoritos',
                    onPressed: () {},
                    outline: true,
                  ),
                  const SizedBox(height: 10),
                  GoldButton(
                    label: 'Solicitar Agendamento',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CreateBookingScreen(stylist: stylist)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.gold),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.goldLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        stylist.initials,
                        style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stylist.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(stylist.specialty,
                            style: const TextStyle(
                                color: Color(0xFFAAAAAA), fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${stylist.rating} · ${stylist.reviews} avaliações',
                              style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
