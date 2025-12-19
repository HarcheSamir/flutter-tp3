import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_theme.dart';
import '../models/question.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all themes
  Future<List<QuizTheme>> getThemes() async {
    try {
      final snapshot = await _db.collection('themes').get();
      return snapshot.docs
          .map((doc) => QuizTheme.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching themes: $e");
      rethrow;
    }
  }

  // SEED FUNCTION: Call this ONCE to fill your DB
  Future<void> seedDatabase() async {
    final themesCollection = _db.collection('themes');
    
    // Check if empty to avoid duplicates
    final snapshot = await themesCollection.get();
    if (snapshot.docs.isNotEmpty) return; 

    // Theme 1: Géographie
    await themesCollection.add({
      'title': 'Géographie',
      'description': 'Testez vos connaissances sur le monde !',
      'imageUrl': 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=800&q=80', // Beautiful Earth Image
      'questions': [
        {'text': 'Paris est la capitale de la France.', 'isCorrect': true},
        {'text': 'Le Nil est le plus long fleuve d\'Afrique.', 'isCorrect': true},
        {'text': 'Tokyo est en Chine.', 'isCorrect': false},
      ]
    });

    // Theme 2: Tech
    await themesCollection.add({
      'title': 'Technologie',
      'description': 'Flutter, IA et Robots.',
      'imageUrl': 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80', // Tech Image
      'questions': [
        {'text': 'Flutter est développé par Facebook.', 'isCorrect': false},
        {'text': 'Dart est le langage utilisé par Flutter.', 'isCorrect': true},
        {'text': 'La RAM sert à stocker des données à long terme.', 'isCorrect': false},
      ]
    });
    
    print("Database Seeded Successfully!");
  }

  Future<void> addQuestion(String themeId, Question question) async {
    try {
      await _db.collection('themes').doc(themeId).update({
        // arrayUnion adds the element only if it doesn't exist already
        'questions': FieldValue.arrayUnion([question.toMap()])
      });
    } catch (e) {
      print("Error adding question: $e");
      rethrow;
    }
  }
}