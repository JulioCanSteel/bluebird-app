// main.dart unificado
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Este archivo se genera con flutterfire configure
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'constants/app_constants.dart';

// ⬇️ Importa la llave global del ScaffoldMessenger para usarla en HomeScreen
// Debes crear un nuevo archivo en tu proyecto, por ejemplo 'core/app_scaffold.dart'
// con este contenido: final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
// Aún si no usas esta funcionalidad, es una buena práctica tenerla para el futuro
// si no lo usas, solo borra esta linea y el scaffoldMessengerKey en MaterialApp
// import 'core/app_scaffold.dart';

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
    // La app puede seguir funcionando sin Firebase
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
        fontFamily: 'Poppins', // Si tienes la fuente configurada
      ),
      // ⬇️ Agrega esta linea para que los SnackBar sean globales
      // scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const AuthWrapper(), // Widget que maneja el estado de autenticación
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
        // Mostrar loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(color: AppConstants.primaryBlue),
                  ),
                  SizedBox(height: AppConstants.paddingLarge),
                  Text(
                    'Cargando...',
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

        // Si hay error de conexión, mostrar WelcomeScreen
        if (snapshot.hasError) {
          print('Error en AuthWrapper: ${snapshot.error}');
          return WelcomeScreen();
        }

        // Si hay usuario autenticado, ir a HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Si no hay usuario, mostrar WelcomeScreen
        return WelcomeScreen();
      },
    );
  }
}