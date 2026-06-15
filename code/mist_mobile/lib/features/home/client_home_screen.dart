import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/estilista.dart';
import '../../services/estilista_service.dart';
import '../../services/auth_service.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  List<Estilista> estilistas = [];
  List<Estilista> filtrados = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEstilistas();
  }

  Future<void> _loadEstilistas() async {
    try {
      setState(() => _isLoading = true);
      final data = await EstilistaService.listarTodos();
      setState(() {
        estilistas = data;
        filtrados = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar estilistas: $e')),
        );
      }
    }
  }

  void _filterEstilistas(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        filtrados = estilistas;
      } else {
        filtrados = estilistas
            .where(
              (e) =>
                  e.nome.toLowerCase().contains(query.toLowerCase()) ||
                  e.especialidade.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao sair: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            color: AppColors.dark,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Olá!", style: TextStyle(color: Colors.white70)),
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
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Meus Agendamentos'),
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed('/client-bookings'),
                        ),
                        PopupMenuItem(
                          child: const Text('Sair'),
                          onTap: _handleLogout,
                        ),
                      ],
                      child: const CircleAvatar(
                        backgroundColor: AppColors.gold,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: _filterEstilistas,
                  decoration: InputDecoration(
                    hintText: "Buscar estilistas...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtrados.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'Nenhum estilista encontrado'
                          : 'Nenhum estilista corresponde à busca',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtrados.length,
                    itemBuilder: (_, index) {
                      final estilista = filtrados[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.goldLight,
                            child: Text(
                              estilista.nome[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.dark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            estilista.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                estilista.especialidade,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                              if (estilista.descricao != null)
                                Text(
                                  estilista.descricao!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/create-booking',
                                arguments: estilista.id,
                              );
                            },
                            child: const Text('Agendar'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
