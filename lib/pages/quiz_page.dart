import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz_trivia_app/models/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_trivia_app/pages/home_page.dart';
import 'package:quiz_trivia_app/pages/result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuestionModel>? _questions;
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
      _questions = await fetchQuestions();
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<QuestionModel>> fetchQuestions() async {
    final url = Uri.parse(
      'https://opentdb.com/api.php?amount=10&difficulty=easy&type=multiple',
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
    if (_selectedAnswer == _questions![_currentIndex].correctAnswer) {
      _score++;
    }

    if (_currentIndex < _questions!.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultPage(score: _score, total: _questions!.length),
        ),
      );
    }
  }

  PreferredSizeWidget? _buildAppBar({required String title}) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        },
        icon: Icon(Icons.exit_to_app),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(title: 'Question 1 of 10'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions![_currentIndex];
    final answers = question.allAnswers;

    return Scaffold(
      appBar: _buildAppBar(
        title: 'Question ${_currentIndex + 1} of ${_questions!.length}',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              ...answers.map((answer) {
                final isSelected = answer == _selectedAnswer;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAnswer = answer;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isSelected
                          ? Theme.of(context).secondaryHeaderColor
                          : null,
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    child: Text(answer, style: const TextStyle(fontSize: 18.0)),
                  ),
                );
              }),
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
                  _currentIndex == _questions!.length - 1 ? 'Finish' : 'Next',
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
