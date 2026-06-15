import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/home/client_home_screen.dart';
import 'features/booking/create_booking_screen.dart';
import 'features/booking/client_bookings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIST - Models Stylist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB8965A)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/cliente-home': (context) => const ClientHomeScreen(),
        '/client-bookings': (context) => const ClientBookingsScreen(),
      },
      onGenerateRoute: (settings) {
        // Rota para criar agendamento com parâmetro de ID do estilista
        if (settings.name == '/create-booking') {
          final estilistaId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => CreateBookingScreen(estilistaId: estilistaId),
          );
        }
        return null;
      },
    );
  }
}
