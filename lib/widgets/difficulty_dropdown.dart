import 'package:flutter/material.dart';

class DifficultyDropdown extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const DifficultyDropdown({super.key, required this.onChanged});

  static const List<String> _difficulties = ['easy', 'medium', 'hard'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _difficulties[0],
      items: _difficulties
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e[0].toUpperCase() + e.substring(1)),
            ),
          )
          .toList(),
      onChanged: (val) => onChanged(val!),
      decoration: const InputDecoration(labelText: 'Difficulty'),
    );
  }
}
