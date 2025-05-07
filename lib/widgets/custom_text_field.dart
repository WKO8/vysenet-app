import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final InputBorder border;
  final TextEditingController? editingController;
  final Icon? icon;
  

  const CustomTextField({
    required this.text,
    required this.textStyle, 
    required this.backgroundColor,
    required this.border,
    this.editingController,
    this.icon,
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: textStyle,
        fillColor: backgroundColor,
        filled: true,
        border: border, // Remove a borda do TextField para evitar conflitos
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adiciona padding interno
        suffixIcon: icon,
      ),
    );
  }
}