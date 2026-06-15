import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              60,
              20,
              20,
            ),
            color: AppColors.dark,

            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Olá, Mariana",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "Encontre seu estilista",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    CircleAvatar(
                      backgroundColor: AppColors.gold,
                      child: const Text("MS"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextField(
                  decoration: InputDecoration(
                    hintText:
                        "Buscar estilistas...",
                    prefixIcon:
                        const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (_, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.goldLight,
                      child: const Text("IM"),
                    ),
                    title:
                        const Text("Isabela Moura"),
                    subtitle: const Text(
                      "Consultoria de Estilo",
                    ),
                    trailing: const Text(
                      "⭐ 4.9",
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Agenda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}