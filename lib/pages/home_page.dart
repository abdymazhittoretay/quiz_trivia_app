import 'package:flutter/material.dart';
import 'package:quiz_trivia_app/pages/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = [
    {'id': null, 'name': 'Any Category', 'icon': Icons.all_inclusive},
    {'id': 9, 'name': 'General Knowledge', 'icon': Icons.public},
    {'id': 17, 'name': 'Science & Nature', 'icon': Icons.science},
    {'id': 21, 'name': 'Sports', 'icon': Icons.sports_soccer},
    {'id': 22, 'name': 'Geography', 'icon': Icons.map},
    {'id': 23, 'name': 'History', 'icon': Icons.history_edu},
    {'id': 27, 'name': 'Animals', 'icon': Icons.pets},
  ];
  late Map<String, dynamic> _selectedCategory = categories[0];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];
  String _selectedDifficulty = 'easy';
  final _controller = TextEditingController(text: '10');

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
        child: SingleChildScrollView(
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
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Questions',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () {
                  final parsedAmount = int.tryParse(_controller.text);
                  if (parsedAmount == null ||
                      parsedAmount < 1 ||
                      parsedAmount > 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a valid number between 1 and 50'),
                      ),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        category: _selectedCategory["id"],
                        difficulty: _selectedDifficulty,
                        amount: parsedAmount,
                      ),
                    ),
                  );
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
