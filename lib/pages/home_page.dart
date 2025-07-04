import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16.0),
            shape: LinearBorder(),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () => () {},
          child: const Text('Start Quiz', style: TextStyle(fontSize: 18.0)),
        ),
      ),
    );
  }
}
