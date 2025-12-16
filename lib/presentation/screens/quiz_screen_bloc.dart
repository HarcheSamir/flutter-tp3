import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/quiz/quiz_bloc.dart';
import '../../business_logic/quiz/quiz_event.dart';
import '../../business_logic/quiz/quiz_state.dart';

class QuizScreenBloc extends StatelessWidget {
  const QuizScreenBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz (BLoC)"), backgroundColor: Colors.blueGrey),
      backgroundColor: Colors.blueGrey,
      body: BlocConsumer<QuizBloc, QuizState>(
        // LISTENER: Handles side effects like SnackBar
        listener: (context, state) {
          String? message;
          bool isCorrect = false;

          if (state is QuizLoaded && state.feedbackMessage != null) {
            message = state.feedbackMessage;
            isCorrect = state.isCorrect ?? false;
          } else if (state is QuizFinished && state.lastFeedbackMessage != null) {
            message = state.lastFeedbackMessage;
            // For the last question, we assume logic or check locally, 
            // but for simplicity let's just show neutral or check string content
            isCorrect = message == "Correct !";
          }

          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: isCorrect ? Colors.green : Colors.red,
                duration: const Duration(milliseconds: 500),
              ),
            );
          }
        },
        // BUILDER: Draws the UI
        builder: (context, state) {
          if (state is QuizInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuizFinished) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Terminé !",
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Score: ${state.finalScore} / ${state.totalQuestions}",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<QuizBloc>().add(ResetQuizEvent()),
                    child: const Text("Recommencer"),
                  )
                ],
              ),
            );
          }

          if (state is QuizLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. IMAGE SECTION 
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.error, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                  
                  // 2. QUESTION TEXT
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          state.question.questionText,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // 3. BUTTONS
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.read<QuizBloc>().add(const AnswerSelectedEvent(true)),
                          child: const Text("VRAI"),
                        ),
                        ElevatedButton(
                          onPressed: () => context.read<QuizBloc>().add(const AnswerSelectedEvent(false)),
                          child: const Text("FAUX"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}