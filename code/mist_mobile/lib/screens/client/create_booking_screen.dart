import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/stylist.dart';
import '../../widgets/gold_button.dart';
import '../shared/confirmation_screen.dart';
import 'client_bookings_screen.dart';

class CreateBookingScreen extends StatefulWidget {
  final Stylist stylist;

  const CreateBookingScreen({super.key, required this.stylist});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  String? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _descController = TextEditingController();

  static const _services = [
    'Consultoria de Estilo',
    'Montagem de Look',
    'Personal Shopper',
    'Look para Evento',
    'Peça Sob Medida',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  String get _dateText => _selectedDate == null
      ? 'Selecionar data'
      : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
          '${_selectedDate!.month.toString().padLeft(2, '0')}/'
          '${_selectedDate!.year}';

  String get _timeText =>
      _selectedTime == null ? 'Selecionar horário' : _selectedTime!.format(context);

  void _submit() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          message: 'Solicitação enviada!',
          subtitle:
              'O estilista receberá sua solicitação e responderá em até 24 horas.',
          buttonLabel: 'Ver meus agendamentos',
          onContinue: (ctx) => Navigator.pushAndRemoveUntil(
            ctx,
            MaterialPageRoute(builder: (_) => const ClientBookingsScreen()),
            (r) => false,
          ),
        ),
      ),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Solicitar Agendamento'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stylist banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: Center(
                      child: Text(widget.stylist.initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.stylist.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark)),
                      Text(widget.stylist.specialty,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Service dropdown
            const Text('Tipo de serviço',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedService,
              hint: const Text('Selecione...'),
              items: _services
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedService = v),
              decoration: const InputDecoration(),
              style: const TextStyle(fontSize: 14, color: AppColors.dark),
              dropdownColor: AppColors.white,
            ),
            const SizedBox(height: 16),
            // Date + Time
            Row(
              children: [
                Expanded(child: _buildDatePicker()),
                const SizedBox(width: 10),
                Expanded(child: _buildTimePicker()),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            const Text('Descreva sua necessidade',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 4),
            TextField(
              controller: _descController,
              maxLines: 4,
              style: const TextStyle(fontSize: 13, color: AppColors.dark),
              decoration: const InputDecoration(
                hintText: 'Ex: preciso de looks para uma viagem de negócios...',
              ),
            ),
            const SizedBox(height: 24),
            GoldButton(label: 'Enviar Solicitação', onPressed: _submit),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'O estilista terá até 24h para aceitar ou recusar.',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.muted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _dateText,
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedDate == null
                          ? AppColors.muted
                          : AppColors.dark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Horário',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_outlined,
                    size: 14, color: AppColors.muted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _timeText,
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedTime == null
                          ? AppColors.muted
                          : AppColors.dark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
