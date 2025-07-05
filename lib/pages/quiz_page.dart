import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'answers': ['Paris', 'London', 'Berlin', 'Madrid'],
      'correct': 'Paris',
    },
    {
      'question': 'What is 2 + 2?',
      'answers': ['3', '4', '5', '6'],
      'correct': '4',
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;

  void _nextQuestion() {
    if (_selectedAnswer == _questions[_currentIndex]['correct']) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final answers = question['answers'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_outlined),
            SizedBox(width: 8.0),
            Text('Question ${_currentIndex + 1} of ${_questions.length}'),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(question['question'], style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 24),
              ...answers.map((answer) {
                final isSelected = answer == _selectedAnswer;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAnswer = answer;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isSelected ? Theme.of(context).secondaryHeaderColor : null,
                    backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                  child: Text(answer),
                );
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedAnswer != null ? _nextQuestion : null,
                child: Text(
                  _currentIndex == _questions.length - 1 ? 'Finish' : 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
