import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_trivia_app/models/question_model.dart';
import 'package:quiz_trivia_app/pages/home_page.dart';
import 'package:quiz_trivia_app/pages/result_page.dart';

class QuizPage extends StatefulWidget {
  final int? category;
  final String difficulty;
  final int amount;

  const QuizPage({
    super.key,
    required this.category,
    required this.difficulty,
    required this.amount,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<QuestionModel> _questions;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      _questions = await _fetchQuestions();

      if (_questions.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No questions found for this selection.'),
          ),
        );
        Navigator.pop(context);
        return;
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load questions.')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<List<QuestionModel>> _fetchQuestions() async {
    final categoryParam = widget.category != null
        ? '&category=${widget.category}'
        : '';
    final url = Uri.parse(
      'https://opentdb.com/api.php?amount=${widget.amount}$categoryParam&difficulty=${widget.difficulty}&type=multiple',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((result) => QuestionModel.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load quiz questions');
    }
  }

  void _nextQuestion() {
    if (_selectedAnswer == _questions[_currentIndex].correctAnswer) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultPage(score: _score, total: _questions.length),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar({required String title}) {
    return AppBar(
      leading: IconButton(
        onPressed: _confirmExit,
        icon: const Icon(Icons.exit_to_app),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.quiz_outlined),
          SizedBox(width: 8.0),
          Text(title),
        ],
      ),
      centerTitle: true,
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  bool get isLastQuestion => _currentIndex == _questions.length - 1;

  Widget _buildAnswerButton(String answer) {
    final isSelected = answer == _selectedAnswer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedAnswer = answer),
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected
              ? Theme.of(context).secondaryHeaderColor
              : null,
          backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
        ),
        child: Text(answer, style: const TextStyle(fontSize: 18.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(title: 'Loading...'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final answers = question.allAnswers;

    return Scaffold(
      appBar: _buildAppBar(
        title: 'Question ${_currentIndex + 1} of ${_questions.length}',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                "${_currentIndex + 1}. ${question.question}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              ...answers.map(_buildAnswerButton),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedAnswer != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: _selectedAnswer != null
                      ? Colors.white
                      : null,
                  backgroundColor: _selectedAnswer != null
                      ? Colors.green
                      : null,
                ),
                child: Text(
                  isLastQuestion ? 'Finish' : 'Next',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
