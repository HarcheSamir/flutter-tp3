import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // For sound
import '../../data/models/quiz_theme.dart';

class QuizScreenFirestore extends StatefulWidget {
  final QuizTheme theme;

  const QuizScreenFirestore({super.key, required this.theme});

  @override
  State<QuizScreenFirestore> createState() => _QuizScreenFirestoreState();
}

class _QuizScreenFirestoreState extends State<QuizScreenFirestore> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isFinished = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _answerQuestion(bool userChoice) async {
    bool isCorrect = widget.theme.questions[_currentIndex].isCorrect == userChoice;

    if (isCorrect) {
      _score++;
      // Exercise 3: Play Win Sound
      await _audioPlayer.play(AssetSource('audio/win.mp3'));
    } else {
      // Exercise 3: Play Loss Sound
      await _audioPlayer.play(AssetSource('audio/loss.mp3'));
    }

    // Feedback Logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "Correct ! 🎉" : "Mauvaise réponse... 😕"),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      if (_currentIndex < widget.theme.questions.length - 1) {
        _currentIndex++;
      } else {
        _isFinished = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.theme.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF000000)], // Dark Gradient
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _isFinished ? _buildResult() : _buildQuiz(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final question = widget.theme.questions[_currentIndex];
    final total = widget.theme.questions.length;
    final progress = (_currentIndex + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white10,
          color: Colors.pinkAccent,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 10),
        Text("Question ${_currentIndex + 1}/$total", style: const TextStyle(color: Colors.white54)),

        const SizedBox(height: 40),

        // Image Card
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(widget.theme.imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 15, offset: const Offset(0, 10))],
            ),
          ),
        ),
        
        const SizedBox(height: 30),

        // Question Text
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Buttons
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: _buildButton("VRAI", true, Colors.green)),
              const SizedBox(width: 20),
              Expanded(child: _buildButton("FAUX", false, Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, bool value, Color color) {
    return ElevatedButton(
      onPressed: () => _answerQuestion(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
          const SizedBox(height: 20),
          const Text("Quiz Terminé !", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Votre Score: $_score / ${widget.theme.questions.length}", 
              style: const TextStyle(color: Colors.white70, fontSize: 24)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: const Text("Retour aux Thèmes"),
          )
        ],
      ),
    );
  }
}