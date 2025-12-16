import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/question.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final List<Question> _questions = [
    Question(questionText: "La France a dû céder l'Alsace et la Moselle à l'Allemagne après la guerre de 1870-1871.", isCorrect: true),
    Question(questionText: "Le Flutter est un langage de programmation.", isCorrect: false),
    Question(questionText: "Paris est la capitale de la France.", isCorrect: true),
  ];

  int _currentIndex = 0;
  int _score = 0;

  QuizBloc() : super(QuizInitial()) {
    
    // Initial Load
    on<LoadQuiz>((event, emit) {
      _currentIndex = 0;
      _score = 0;
      emit(QuizLoaded(
        question: _questions[_currentIndex],
        score: _score,
        totalQuestions: _questions.length,
      ));
    });

    // Handle Answer
    on<AnswerSelectedEvent>((event, emit) {
      // 1. Check logic
      bool isCorrect = _questions[_currentIndex].isCorrect == event.userChoice;
      if (isCorrect) _score++;

      String feedback = isCorrect ? "Correct !" : "Incorrect !";

      // 2. Decide next step
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        // Emit new question with feedback from previous one
        emit(QuizLoaded(
          question: _questions[_currentIndex],
          score: _score,
          totalQuestions: _questions.length,
          feedbackMessage: feedback,
          isCorrect: isCorrect,
        ));
      } else {
        // Quiz is over
        emit(QuizFinished(
          finalScore: _score,
          totalQuestions: _questions.length,
          lastFeedbackMessage: feedback, // Pass feedback for the last question
        ));
      }
    });

    // Reset
    on<ResetQuizEvent>((event, emit) {
      add(LoadQuiz());
    });
  }
}