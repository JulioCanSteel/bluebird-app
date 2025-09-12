import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../utils/validators.dart';



class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
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
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppConstants.paddingXLarge),
              
              // Título con número
              Text(
                '12+',
                style: TextStyle(
                  color: AppConstants.lightBlue,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppConstants.paddingMedium),
              
              Text(
                AppConstants.verificationCode,
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
              
              // Campos de código de verificación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildCodeField(index)),
              ),
              
              SizedBox(height: AppConstants.paddingXLarge),
              
              Text(
                '05:59',
                style: TextStyle(
                  color: AppConstants.subtitleColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppConstants.paddingMedium),
              
              TextButton(
                onPressed: () {
                  // Reenviar código
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Código reenviado')),
                  );
                },
                child: Text(
                  'No me llegó el código\nReenviar',
                  style: TextStyle(
                    color: AppConstants.lightBlue,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              Spacer(),
              
              // Botón verificar
              CustomButton(
                text: "Usar código",
                isLoading: _isLoading,
                onPressed: _handleVerification,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          color: AppConstants.textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppConstants.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide(color: AppConstants.primaryBlue, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  void _handleVerification() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verificación exitosa!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Regresar a la pantalla principal
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}