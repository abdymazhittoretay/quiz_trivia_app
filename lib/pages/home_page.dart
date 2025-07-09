import 'package:flutter/material.dart';
import 'package:quiz_trivia_app/pages/quiz_page.dart';
import 'package:quiz_trivia_app/widgets/category_dropdown.dart';
import 'package:quiz_trivia_app/widgets/difficulty_dropdown.dart';
import 'package:quiz_trivia_app/widgets/question_count_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _selectedCategory;
  String _selectedDifficulty = 'easy';
  final _controller = TextEditingController(text: '10');

  void _startQuiz() {
    final amount = int.tryParse(_controller.text);
    if (amount == null || amount < 1 || amount > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid number between 1 and 50')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          category: _selectedCategory?["id"] ?? 9,
          difficulty: _selectedDifficulty,
          amount: amount,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_outlined),
            SizedBox(width: 8),
            Text('Quiz Trivia'),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CategoryDropdown(
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DifficultyDropdown(
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value),
              ),
              const SizedBox(height: 16),
              QuestionCountInput(controller: _controller),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
