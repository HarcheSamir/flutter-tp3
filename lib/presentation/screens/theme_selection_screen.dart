import 'package:flutter/material.dart';
import '../../data/services/quiz_service.dart';
import '../../data/models/quiz_theme.dart';
import 'quiz_screen_firestore.dart'; 
import '../../data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'profile_screen.dart';    
import 'add_question_screen.dart'; 
                      
class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  final QuizService _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    // Auto-seed if empty (Just for the first run convenience)
    _quizService.seedDatabase().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un Thème"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
           IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
            },
          ),
          // StreamBuilder to listen to Avatar changes live!
          StreamBuilder<DocumentSnapshot>(
            stream: AuthService().getUserStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final url = data['avatarUrl'] as String?;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.purple,
                      backgroundImage: (url != null && url.isNotEmpty)
                          ? NetworkImage(url)
                          : null,
                      child: (url == null || url.isEmpty)
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddQuestionScreen()));
        },
        label: const Text("Ajouter Question"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<QuizTheme>>(
        future: _quizService.getThemes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          final themes = snapshot.data ?? [];
          if (themes.isEmpty)
            return const Center(child: Text("Aucun thème trouvé."));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 Columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Taller cards
              ),
              itemCount: themes.length,
              itemBuilder: (context, index) {
                return _buildThemeCard(context, themes[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, QuizTheme theme) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Quiz Screen with the selected theme
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuizScreenFirestore(theme: theme)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(theme.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.4,
              ), // Darken image for text readability
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                theme.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                theme.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
