import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizProvider with ChangeNotifier {
  final List<Question> _questions = [
    Question(questionText: "La France a dû céder l'Alsace et la Moselle à l'Allemagne après la guerre de 1870-1871.", isCorrect: true),
    Question(questionText: "Le Flutter est un langage de programmation.", isCorrect: false),
    Question(questionText: "Paris est la capitale de la France.", isCorrect: true),
    Question(questionText: "Le ciel est vert.", isCorrect: false),
  ];

  int _currentIndex = 0;
  int _score = 0;
  bool _isFinished = false;

  // Getters
  Question get currentQuestion => _questions[_currentIndex];
  int get score => _score;
  bool get isFinished => _isFinished;
  int get totalQuestions => _questions.length;

  // Logic
  bool checkAnswer(bool userChoice) {
    bool isCorrect = _questions[_currentIndex].isCorrect == userChoice;
    
    if (isCorrect) {
      _score++;
    }
    
    // We don't call nextQuestion() here immediately if we want to show the message first
    // But for simplicity, let's keep it fast:
    nextQuestion();
    
    return isCorrect; // Return the result so the UI can use it
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _isFinished = true;
    }
    notifyListeners(); // Updates the UI
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _isFinished = false;
    notifyListeners();
  }
}