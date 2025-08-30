import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bird_widget.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pájaro pequeño en header
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
                  AppConstants.createAccount,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: screenWidth < 360 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Campos del formulario
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
                
                CustomTextField(
                  hint: AppConstants.confirmPasswordHint,
                  controller: _confirmPasswordController,
                  isPassword: !_isConfirmPasswordVisible,
                  validator: (value) => Validators.validateConfirmPassword(
                    value, 
                    _passwordController.text,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppConstants.subtitleColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppConstants.subtitleColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingXLarge * 2),
                
                CustomButton(
                  text: "Siguiente",
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                
                SizedBox(height: AppConstants.paddingLarge),
                
                Text(
                  'Al crear una cuenta, aceptas nuestros términos y condiciones',
                  style: TextStyle(
                    color: AppConstants.subtitleColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuenta creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}