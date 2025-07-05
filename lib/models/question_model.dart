import 'dart:math';

class QuestionModel {
  final String question;
  final String correctAnswer;
  final List<String> allAnswers;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final List<String> answers = List<String>.from(json['incorrect_answers']);
    answers.add(json['correct_answer']);
    answers.shuffle(Random());

    return QuestionModel(
      question: htmlDecode(json['question']),
      correctAnswer: json['correct_answer'],
      allAnswers: answers.map(htmlDecode).toList(),
    );
  }
}

String htmlDecode(String input) {
  return input
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
}
