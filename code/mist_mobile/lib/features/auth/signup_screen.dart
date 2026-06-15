import 'package:flutter/material.dart';
import '../../core/widgets/gold_button.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String mode = "cliente";
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _telefoneController.dispose();
    _especialidadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos obrigatórios';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService.signup(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        role: mode == "cliente" ? "CLIENTE" : "ESTILISTA",
        telefone: _telefoneController.text.isNotEmpty
            ? _telefoneController.text
            : null,
        especialidade:
            mode == "estilista" && _especialidadeController.text.isNotEmpty
            ? _especialidadeController.text
            : null,
        descricao: mode == "estilista" && _descricaoController.text.isNotEmpty
            ? _descricaoController.text
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacementNamed('/cliente-home');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: "cliente", label: Text("Cliente")),
                ButtonSegment(value: "estilista", label: Text("Estilista")),
              ],
              selected: {mode},
              onSelectionChanged: (value) {
                setState(() {
                  mode = value.first;
                  _errorMessage = null;
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nomeController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "Nome *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              enabled: !_isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              enabled: !_isLoading,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              enabled: !_isLoading,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (mode == "estilista") ...[
              const SizedBox(height: 16),
              TextField(
                controller: _especialidadeController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: "Especialidade",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                enabled: !_isLoading,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
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
              text: _isLoading ? 'Criando conta...' : 'Criar Conta',
              onPressed: _isLoading ? () {} : _handleSignup,
            ),
          ],
        ),
      ),
    );
  }
}
