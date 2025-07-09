import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final Function(Map<String, dynamic>) onChanged;

  const CategoryDropdown({super.key, required this.onChanged});

  static const List<Map<String, dynamic>> categories = [
    {'id': null, 'name': 'Any Category', 'icon': Icons.all_inclusive},
    {'id': 9, 'name': 'General Knowledge', 'icon': Icons.public},
    {'id': 17, 'name': 'Science & Nature', 'icon': Icons.science},
    {'id': 21, 'name': 'Sports', 'icon': Icons.sports_soccer},
    {'id': 22, 'name': 'Geography', 'icon': Icons.map},
    {'id': 23, 'name': 'History', 'icon': Icons.history_edu},
    {'id': 27, 'name': 'Animals', 'icon': Icons.pets},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: categories[0],
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(category['icon'], size: 20),
                  const SizedBox(width: 8),
                  Text(category['name']),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      decoration: const InputDecoration(labelText: 'Category'),
    );
  }
}
