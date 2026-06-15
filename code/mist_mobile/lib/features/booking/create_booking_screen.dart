import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/gold_button.dart';
import '../../models/estilista.dart';
import '../../services/agendamento_service.dart';
import '../../services/estilista_service.dart';

class CreateBookingScreen extends StatefulWidget {
  final int estilistaId;

  const CreateBookingScreen({super.key, required this.estilistaId});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  late Estilista estilista;
  DateTime? _selectedDate;
  String? _selectedService;
  final _descricaoController = TextEditingController();
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  final tiposServico = [
    'CONSULTORIA_ESTILO',
    'MONTAGEM_LOOK',
    'ROUPA_SOB_MEDIDA',
    'ACOMPANHAMENTO_EVENTO',
    'OUTRO',
  ];

  @override
  void initState() {
    super.initState();
    _loadEstilista();
  }

  Future<void> _loadEstilista() async {
    try {
      final data = await EstilistaService.buscarPorId(widget.estilistaId);
      setState(() {
        estilista = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar estilista: $e')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleCreateBooking() async {
    if (_selectedDate == null || _selectedService == null) {
      setState(() {
        _errorMessage = 'Por favor, selecione a data e o tipo de serviço';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await AgendamentoService.criar(
        estilistaId: widget.estilistaId,
        data: _selectedDate!,
        tipoServico: _selectedService!,
        descricao: _descricaoController.text.isNotEmpty
            ? _descricaoController.text
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agendamento criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estilista',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.goldLight,
                                child: Text(
                                  estilista.nome[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.dark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      estilista.nome,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      estilista.especialidade,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
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
                  const SizedBox(height: 24),
                  const Text(
                    'Data do Agendamento',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _selectDate,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Selecione uma data'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tipo de Serviço',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedService,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                    ),
                    items: tiposServico.map((service) {
                      return DropdownMenuItem(
                        value: service,
                        child: Text(_formatServiceType(service)),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() => _selectedService = value);
                          },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Descrição (Opcional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descricaoController,
                    enabled: !_isSubmitting,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Descreva suas necessidades, preferências ou dúvidas...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  const SizedBox(height: 16),
                  GoldButton(
                    text: _isSubmitting ? 'Agendando...' : 'Agendar',
                    onPressed: _isSubmitting ? () {} : _handleCreateBooking,
                  ),
                ],
              ),
            ),
    );
  }

  String _formatServiceType(String type) {
    const map = {
      'CONSULTORIA_ESTILO': 'Consultoria de Estilo',
      'MONTAGEM_LOOK': 'Montagem de Look',
      'ROUPA_SOB_MEDIDA': 'Roupa Sob Medida',
      'ACOMPANHAMENTO_EVENTO': 'Acompanhamento de Evento',
      'OUTRO': 'Outro',
    };
    return map[type] ?? type;
  }
}
