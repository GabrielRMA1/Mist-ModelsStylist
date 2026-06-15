import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';

class ClientBookingsScreen extends StatelessWidget {
  const ClientBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = [
      {
        "service": "Consultoria de Estilo",
        "stylist": "Isabela Moura",
        "date": "20/06/2025",
        "time": "14:00",
        "status": "aceito",
      },
      {
        "service": "Criação de Peças",
        "stylist": "Rafael Duarte",
        "date": "25/06/2025",
        "time": "10:00",
        "status": "pendente",
      },
      {
        "service": "Montagem de Look",
        "stylist": "Camila Vaz",
        "date": "10/06/2025",
        "time": "16:00",
        "status": "concluido",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.dark,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,

        itemBuilder: (context, index) {
          final booking = bookings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Expanded(
                        child: Text(
                          booking["service"]!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      StatusBadge(
                        status: booking["status"]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "com ${booking["stylist"]}",
                    style: const TextStyle(
                      color: AppColors.muted,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "📅 ${booking["date"]} às ${booking["time"]}",
                    style: const TextStyle(
                      color: AppColors.muted,
                    ),
                  ),

                  if (booking["status"] == "aceito")
                    Padding(
                      padding: const EdgeInsets.only(top: 16),

                      child: SizedBox(
                        height: 40,

                        child: OutlinedButton(
                          onPressed: () {},

                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                AppColors.gold,
                            side: const BorderSide(
                              color: AppColors.gold,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Ver detalhes",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}