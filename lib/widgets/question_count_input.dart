import 'package:flutter/material.dart';

class QuestionCountInput extends StatelessWidget {
  final TextEditingController controller;

  const QuestionCountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Number of Questions'),
    );
  }
}
