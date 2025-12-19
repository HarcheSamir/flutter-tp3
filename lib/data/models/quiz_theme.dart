import 'question.dart';

class QuizTheme {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Question> questions;

  QuizTheme({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.questions,
  });

  // Convert from Firestore Map
  factory QuizTheme.fromMap(String id, Map<String, dynamic> map) {
    return QuizTheme(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      questions: (map['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q))
              .toList() ??
          [],
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}