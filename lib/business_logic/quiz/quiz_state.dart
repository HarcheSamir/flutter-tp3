import 'package:equatable/equatable.dart';
import '../../data/models/question.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoaded extends QuizState {
  final Question question;
  final int score;
  final int totalQuestions;
  final String? feedbackMessage; // NEW: Holds "Correct!" or "Incorrect!"
  final bool? isCorrect;         // NEW: Helps with SnackBar color

  const QuizLoaded({
    required this.question,
    required this.score,
    required this.totalQuestions,
    this.feedbackMessage,
    this.isCorrect,
  });

  @override
  List<Object?> get props => [question, score, totalQuestions, feedbackMessage, isCorrect];
}

class QuizFinished extends QuizState {
  final int finalScore;
  final int totalQuestions;
  final String? lastFeedbackMessage; // NEW: Feedback for the very last question

  const QuizFinished({
    required this.finalScore, 
    required this.totalQuestions,
    this.lastFeedbackMessage,
  });

  @override
  List<Object?> get props => [finalScore, totalQuestions, lastFeedbackMessage];
}