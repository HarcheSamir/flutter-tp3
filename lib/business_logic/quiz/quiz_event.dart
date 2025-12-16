import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class LoadQuiz extends QuizEvent {}

class AnswerSelectedEvent extends QuizEvent {
  final bool userChoice;

  const AnswerSelectedEvent(this.userChoice);

  @override
  List<Object> get props => [userChoice];
}

class ResetQuizEvent extends QuizEvent {}