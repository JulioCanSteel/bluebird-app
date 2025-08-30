import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bird_widget.dart';
import '../utils/validators.dart';
import 'verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: AppConstants.paddingXLarge),
                
                // Título con asteriscos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '***',
                      style: TextStyle(
                        color: AppConstants.lightBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                Text(
                  AppConstants.changePassword,
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                Text(
                  'Ingresa el código que hemos enviado a tu correo anterior',
                  style: TextStyle(
                    color: AppConstants.subtitleColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppConstants.paddingXLarge * 2),
                
                // Nueva contraseña
                CustomTextField(
                  hint: AppConstants.newPasswordHint,
                  controller: _newPasswordController,
                  isPassword: !_isNewPasswordVisible,
                  validator: Validators.validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppConstants.subtitleColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppConstants.subtitleColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                
                SizedBox(height: AppConstants.paddingMedium),
                
                // Confirmar contraseña
                CustomTextField(
                  hint: AppConstants.confirmPasswordHint,
                  controller: _confirmPasswordController,
                  isPassword: !_isConfirmPasswordVisible,
                  validator: (value) => Validators.validateConfirmPassword(
                    value, 
                    _newPasswordController.text,
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
                
                // Botón cambiar
                CustomButton(
                  text: "Cambiar",
                  isLoading: _isLoading,
                  onPressed: _handleChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Navegar a pantalla de verificación
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerificationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
