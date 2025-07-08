import 'package:flutter/material.dart';
import 'package:quiz_trivia_app/pages/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = [
    {'id': null, 'name': 'Any Category'},
    {'id': 9, 'name': 'General Knowledge'},
    {'id': 17, 'name': 'Science & Nature'},
    {'id': 21, 'name': 'Sports'},
    {'id': 22, 'name': 'Geography'},
    {'id': 23, 'name': 'History'},
    {'id': 27, 'name': 'Animals'},
  ];
  late Map<String, dynamic> _selectedCategory = categories[0];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];
  String _selectedDifficulty = 'easy';
  int _amount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.quiz_outlined),
            const SizedBox(width: 8.0),
            const Text('Quiz Trivia'),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedCategory,
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                items: _difficulties
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e[0].toUpperCase() + e.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value!),
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _amount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Questions',
                ),
                onChanged: (value) {
                  final val = int.tryParse(value);
                  if (val != null) {
                    _amount = val;
                  } else {
                    _amount = 1;
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () {
                  if (_amount < 1 || _amount > 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a number between 1 and 50'),
                      ),
                    );
                    return;
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          category: _selectedCategory["id"],
                          difficulty: _selectedDifficulty,
                          amount: _amount,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
