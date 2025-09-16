import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bird_widget.dart';
import '../utils/validators.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppConstants.paddingMedium),
                
                // Pájaro pequeño en la esquina superior derecha
                Row(
                  children: [
                    const Spacer(),
                    BirdWidget(
                      width: 70,
                      height: 70,
                      showShadow: false,
                    ),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Título
                Text(
                  AppConstants.welcomeTitle,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: screenWidth < 360 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Campo Email
                CustomTextField(
                  hint: AppConstants.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppConstants.subtitleColor,
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingLarge),
                
                // Campo Contraseña
                CustomTextField(
                  hint: AppConstants.passwordHint,
                  controller: _passwordController,
                  isPassword: !_isPasswordVisible,
                  validator: Validators.validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppConstants.subtitleColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppConstants.subtitleColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Enlace recuperar contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      AppConstants.forgotPassword,
                      style: TextStyle(
                        color: AppConstants.lightBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Botón Ingresar
                CustomButton(
                  text: AppConstants.loginButton,
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppConstants.subtitleColor.withOpacity(0.3),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                      child: Text(
                        AppConstants.continueWith,
                        style: TextStyle(
                          color: AppConstants.subtitleColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppConstants.subtitleColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingLarge),
                
                // Botones sociales placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata, () {
                      _showFeatureNotImplemented('Google');
                    }),
                    SizedBox(width: AppConstants.paddingLarge),
                    _buildSocialButton(Icons.facebook, () {
                      _showFeatureNotImplemented('Facebook');
                    }),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Enlace registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppConstants.noAccount} ',
                      style: TextStyle(
                        color: AppConstants.subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        AppConstants.registerHere,
                        style: TextStyle(
                          color: AppConstants.lightBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: AppConstants.subtitleColor.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppConstants.textColor,
          size: 24,
        ),
      ),
    );
  }

  void _showFeatureNotImplemented(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature login próximamente disponible'),
        backgroundColor: AppConstants.primaryBlue,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      print('Intentando login con: ${_emailController.text.trim()}');
      
      // Login con Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('Login exitoso! Usuario: ${userCredential.user?.email}');
      print('UID: ${userCredential.user?.uid}');
      print('Estado actual: ${FirebaseAuth.instance.currentUser?.email}');

      // Verificar el estado inmediatamente
      await Future.delayed(Duration(milliseconds: 500));
      print('Verificando estado después de 500ms: ${FirebaseAuth.instance.currentUser?.email}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text("¡Bienvenido de nuevo!")),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

    } on FirebaseAuthException catch (e) {
      print('Error de Firebase: ${e.code} - ${e.message}');
      String errorMessage = _getFirebaseErrorMessage(e.code);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error general: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text("Error inesperado: $e")),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'El email no es válido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      case 'invalid-credential':
        return 'Email o contraseña incorrectos';
      default:
        return 'Error de autenticación: $errorCode';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}