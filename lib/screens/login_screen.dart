import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bird_widget.dart';
import '../utils/validators.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart'; 

class LoginScreen extends StatefulWidget {
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
                    Spacer(),
                    BirdWidget(
                      width: 70,
                      height: 70,
                      showShadow: false, // Sin sombra para el header
                    ),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Título
                Text(
                  AppConstants.welcomeTitle,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: screenWidth < 360 ? 24 : 28, // Responsive font
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge * 2),
                
                // Campo de email
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
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Campo de contraseña
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
                
                // Enlace olvidar contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
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
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Botón ingresar
                CustomButton(
                  text: AppConstants.loginButton,
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Separador
                Row(
                  children: [
                    Expanded(child: Divider(color: AppConstants.subtitleColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                      child: Text(
                        AppConstants.continueWith,
                        style: TextStyle(
                          color: AppConstants.subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppConstants.subtitleColor)),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingLarge),
                
                // Botón Google
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Simular login con Google
                        _handleGoogleLogin();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'G',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Continuar con Google',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Enlace registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConstants.noAccount + ' ',
                      style: TextStyle(
                        color: AppConstants.subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simular proceso de login
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar mensaje de éxito temporal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Login exitoso! Bienvenido de vuelta 👋'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navegar a la pantalla de inicio después de un breve delay
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userEmail: _emailController.text, // Pasar el email del login
            ),
          ),
          (Route<dynamic> route) => false, // Limpiar todo el stack de navegación
        );
      });
    }
  }

  void _handleGoogleLogin() async {
    // Simular login con Google
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Login con Google exitoso!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navegar a home con un email simulado de Google
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userEmail: 'usuario@gmail.com', // Email simulado de Google
          ),
        ),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}