import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_button.dart';
import 'client/client_home_screen.dart';
import 'stylist/stylist_dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authService = AuthService();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _descricaoController = TextEditingController();

  String _role = 'CLIENTE';
  bool _isLoading = false;

  bool get _isClient => _role == 'CLIENTE';
  bool get _isStylist => _role == 'ESTILISTA';

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    _telefoneController.dispose();
    _especialidadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_senhaController.text != _confirmacaoController.text) {
      _showError('As senhas não conferem');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final session = await _authService.signup(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
        telefone: _telefoneController.text.trim(),
        role: _role,
        especialidade: _especialidadeController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => session.role == 'ESTILISTA'
              ? const StylistDashboardScreen()
              : const ClientHomeScreen(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53935),
      ),
    );
  }

  void _setRole(String role) {
    setState(() => _role = role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Junte-se ao Mist',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Crie sua conta para começar',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    _RoleOption(
                      label: 'Sou Cliente',
                      active: _isClient,
                      onTap: () => _setRole('CLIENTE'),
                    ),
                    _RoleOption(
                      label: 'Sou Estilista',
                      active: _isStylist,
                      onTap: () => _setRole('ESTILISTA'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Label('Nome completo'),
              const SizedBox(height: 4),
              TextField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(hintText: 'Seu nome'),
              ),
              const SizedBox(height: 14),
              _Label('E-mail'),
              const SizedBox(height: 4),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(hintText: 'seu@email.com'),
              ),
              const SizedBox(height: 14),
              _Label('Senha'),
              const SizedBox(height: 4),
              TextField(
                controller: _senhaController,
                obscureText: true,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(hintText: 'Mínimo 8 caracteres'),
              ),
              const SizedBox(height: 14),
              _Label('Confirmar senha'),
              const SizedBox(height: 4),
              TextField(
                controller: _confirmacaoController,
                obscureText: true,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(hintText: 'Repita a senha'),
              ),
              const SizedBox(height: 14),
              _Label('Telefone'),
              const SizedBox(height: 4),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 14, color: AppColors.dark),
                decoration: const InputDecoration(hintText: '(00) 00000-0000'),
              ),
              if (_isStylist) ...[
                const SizedBox(height: 14),
                _Label('Especialidade'),
                const SizedBox(height: 4),
                TextField(
                  controller: _especialidadeController,
                  style: const TextStyle(fontSize: 14, color: AppColors.dark),
                  decoration: const InputDecoration(
                    hintText: 'Ex: Consultoria de Estilo',
                  ),
                ),
                const SizedBox(height: 14),
                _Label('Descrição profissional'),
                const SizedBox(height: 4),
                TextField(
                  controller: _descricaoController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14, color: AppColors.dark),
                  decoration: const InputDecoration(
                    hintText: 'Conte um pouco sobre sua experiência',
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: const [
                    Icon(Icons.check_box, color: AppColors.gold, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Concordo com os Termos de Uso e Política de Privacidade',
                        style: TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
              GoldButton(
                label: _isLoading ? 'Criando...' : 'Criar conta',
                onPressed: _isLoading ? () {} : _signup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.muted),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.muted,
                fontSize: 13,
                fontWeight: active ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
