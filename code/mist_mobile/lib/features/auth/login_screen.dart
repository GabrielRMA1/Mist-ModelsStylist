import 'package:flutter/material.dart';
import '../../core/widgets/gold_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String mode = "cliente";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 60),

            const Text(
              "MIST",
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: "cliente",
                  label: Text("Cliente"),
                ),
                ButtonSegment(
                  value: "estilista",
                  label: Text("Estilista"),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (value) {
                setState(() {
                  mode = value.first;
                });
              },
            ),

            const SizedBox(height: 24),

            TextField(
              decoration: InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            GoldButton(
              text: "Entrar",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}