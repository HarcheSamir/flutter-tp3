class Question {
  // We keep the old name 'questionText' to avoid breaking TP2 files
  final String questionText; 
  final bool isCorrect;

  Question({required this.questionText, required this.isCorrect});

  // Convert from Firestore Map (Firestore uses key 'text')
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['text'] ?? '', 
      isCorrect: map['isCorrect'] ?? false,
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'text': questionText,
      'isCorrect': isCorrect,
    };
  }
}