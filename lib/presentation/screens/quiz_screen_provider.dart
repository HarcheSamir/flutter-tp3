import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';

class QuizScreenProvider extends StatelessWidget {
  const QuizScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz (Provider)'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: Consumer<QuizProvider>(
        builder: (context, quiz, child) {
          // Check if finished
          if (quiz.isFinished) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Terminé !",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Text(
                    "Score: ${quiz.score} / ${quiz.totalQuestions}",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: quiz.resetQuiz,
                    child: const Text("Recommencer"),
                  )
                ],
              ),
            );
          }

          // Show Question
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg",
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        quiz.currentQuestion.questionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, "VRAI", true, quiz),
                      _buildButton(context, "FAUX", false, quiz),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

Widget _buildButton(BuildContext context, String text, bool choice, QuizProvider quiz) {
    return ElevatedButton(
      onPressed: () {
        // 1. Check answer and get result
        bool isCorrect = quiz.checkAnswer(choice);

        // 2. Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCorrect ? "Correct !" : "Incorrect !"),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Text(text),
    );
  }
}