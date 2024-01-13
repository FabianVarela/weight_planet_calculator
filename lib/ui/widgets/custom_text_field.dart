import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.label,
    this.hint,
    super.key,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: theme.inputDecorationTheme.labelStyle!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
      ),
    );
  }
}
