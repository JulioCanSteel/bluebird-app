import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';
import '../widgets/bird_widget.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 📱 Obtener datos del usuario actual automáticamente
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Fondo con degradado azul similar al welcome
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 3, 74, 120),
              Color.fromARGB(20, 26, 47, 80),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer superior
                Spacer(flex: 1),
                
                // Mensaje de bienvenida
                Text(
                  '¡Bienvenido!',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth < 360 ? 28 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Submensaje
                Text(
                  'Has ingresado exitosamente a',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingSmall),
                
                // Nombre de la app
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.lightBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Pájaro principal con animación suave
                Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    child: BirdWidget(
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.6,
                      showShadow: true,
                      shadowBlur: 25.0,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                
                // Spacer medio
                Spacer(flex: 2),
                
                // Email del usuario si está disponible
                if (currentUser?.email != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.paddingMedium,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                        SizedBox(width: AppConstants.paddingSmall),
                        Flexible(
                          child: Text(
                            currentUser!.email!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingLarge),
                ],
                
                // Botones de acción
                Row(
                  children: [
                    // Botón Configuración
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Navegar a configuraciones
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Configuraciones - Próximamente'),
                                backgroundColor: AppConstants.lightBlue,
                              ),
                            );
                          },
                          icon: Icon(Icons.settings_outlined, size: 20),
                          label: Text(
                            'Config',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.15),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: AppConstants.paddingMedium),
                    
                    // Botón Cerrar Sesión
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          icon: Icon(Icons.logout_outlined, size: 20),
                          label: Text(
                            'Cerrar Sesión',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.8),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Spacer inferior
                Spacer(flex: 1),
                
                // Información adicional
                Container(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    children: [
                      Text(
                        '🎉 ¡Todo listo para comenzar!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'Versión 1.0.0',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Cerrar Sesión',
                style: GoogleFonts.poppins(
                  color: AppConstants.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro que deseas cerrar sesión?',
            style: GoogleFonts.poppins(
              color: AppConstants.subtitleColor,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  color: AppConstants.subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo

                try {
                  // ✅ Cerrar sesión en Firebase
                  await FirebaseAuth.instance.signOut();

                  // ✅ AuthWrapper detectará automáticamente el cambio
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text('¡Hasta pronto! 👋')),
                          ],
                        ),
                        backgroundColor: AppConstants.lightBlue,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  // Error al cerrar sesión
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al cerrar sesión: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
              ),
              child: Text(
                'Cerrar Sesión',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}