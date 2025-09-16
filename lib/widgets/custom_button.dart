import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;              // Texto del botón
  final VoidCallback onPressed;   // Función al presionar
  final bool isOutlined;          // Si es un botón con borde o relleno
  final bool isLoading;           // Si está cargando
  final double? width;            // Ancho personalizado
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : AppConstants.primaryBlue,
          foregroundColor: isOutlined ? AppConstants.primaryBlue : Colors.white,
          side: isOutlined ? BorderSide(color: AppConstants.primaryBlue, width: 2) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          elevation: 0,
        ),
        child: isLoading 
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOutlined ? AppConstants.primaryBlue : Colors.white,
                ),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }
}