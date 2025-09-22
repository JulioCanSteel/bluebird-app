import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bird_widget.dart';
import '../utils/validators.dart';
import '../services/firebase_auth_service.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false; 

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
                    Spacer(),
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
                  validator: Validators.validateEmail, // Correcto
                  prefixIcon: Icon(
                    Icons.email_outlined, // Corregido
                    color: AppConstants.subtitleColor,
                  ),
                ),

                SizedBox(height: AppConstants.paddingLarge),

                // Campo Contraseña
                CustomTextField(
                  hint: AppConstants.passwordHint,
                  controller: _passwordController,
                  isPassword: !_isPasswordVisible, // Correcto
                  validator: Validators.validatePassword, // Correcto
                  prefixIcon: Icon(
                    Icons.lock_outlined, // Corregido
                    color: AppConstants.subtitleColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen()),
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
                  onPressed: _handleLogin, // Corregido
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
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium),
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

                // Botón de Google Sign In
                _buildGoogleSignInButton(),

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
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
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

  // Widget para el botón de Google Sign In
  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (_isGoogleLoading || _isLoading) ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            side: BorderSide(
              color: AppConstants.subtitleColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: _isGoogleLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de Google (usando imagen de red como en tu código original)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://developers.google.com/identity/images/g-logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Container(),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Continuar con Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      final result = await _authService.signInWithGoogle();

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Inicio de sesión con Google exitoso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Error desconocido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión con Google: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? '¡Bienvenido!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}