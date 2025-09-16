import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Archivo generado con flutterfire configure

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'constants/app_constants.dart';

void main() async {
  // Asegurar inicialización de widgets
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente');
  } catch (e) {
    print('❌ Error inicializando Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        fontFamily: 'Poppins', // Si configuraste la fuente
      ),
      home: const AuthWrapper(), // 👈 Aquí controlamos la sesión
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Debug información
        print('🔄 AuthWrapper - Estado de conexión: ${snapshot.connectionState}');
        print('🔄 AuthWrapper - Tiene datos: ${snapshot.hasData}');
        print('🔄 AuthWrapper - Usuario: ${snapshot.data?.email ?? 'null'}');
        print('🔄 AuthWrapper - Error: ${snapshot.error}');

        // ⏳ Mientras se verifica el estado del usuario
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('⏳ AuthWrapper - Esperando...');
          return Scaffold(
            backgroundColor: AppConstants.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.flutter_dash,
                      size: 60,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  CircularProgressIndicator(
                    color: AppConstants.primaryBlue,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Cargando ${AppConstants.appName}...',
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ❌ Si hay error, mostrar pantalla de bienvenida
        if (snapshot.hasError) {
          print('❌ AuthWrapper - Error: ${snapshot.error}');
          return const WelcomeScreen();
        }

        // ✅ Si ya hay usuario logueado → Home
        if (snapshot.hasData && snapshot.data != null) {
          print('✅ AuthWrapper - Navegando a HomeScreen para: ${snapshot.data!.email}');
          return const HomeScreen();
        }

        // 🟦 Si no hay usuario logueado → Welcome/Login
        print('🟦 AuthWrapper - Sin usuario, navegando a WelcomeScreen');
        return const WelcomeScreen();
      },
    );
  }
}