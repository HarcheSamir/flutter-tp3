import 'package:flutter/material.dart';
import '../../data/services/quiz_service.dart';
import '../../data/models/quiz_theme.dart';
import '../../data/models/question.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final QuizService _quizService = QuizService();
  
  // State
  String? _selectedThemeId;
  bool _isCorrect = true; // Default answer is True
  bool _isLoading = false;
  List<QuizTheme> _themes = [];

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  void _loadThemes() async {
    try {
      final themes = await _quizService.getThemes();
      setState(() {
        _themes = themes;
        if (themes.isNotEmpty) {
          _selectedThemeId = themes.first.id; // Select first by default
        }
      });
    } catch (e) {
      // Handle error
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedThemeId != null) {
      setState(() => _isLoading = true);

      final newQuestion = Question(
        questionText: _questionController.text.trim(),
        isCorrect: _isCorrect,
      );

      try {
        await _quizService.addQuestion(_selectedThemeId!, newQuestion);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Question ajoutée avec succès !"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Go back
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une Question")),
      body: _themes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Contribuer au Quiz",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // 1. Select Theme
                    DropdownButtonFormField<String>(
                      value: _selectedThemeId,
                      decoration: const InputDecoration(
                        labelText: "Choisir le Thème",
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      dropdownColor: const Color(0xFF2C3E50),
                      items: _themes.map((theme) {
                        return DropdownMenuItem(
                          value: theme.id,
                          child: Text(theme.title, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedThemeId = value),
                    ),
                    const SizedBox(height: 20),

                    // 2. Question Text
                    TextFormField(
                      controller: _questionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Question",
                        hintText: "Ex: Le ciel est bleu ?",
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Entrez une question" : null,
                    ),
                    const SizedBox(height: 20),

                    // 3. Is Correct Switch
                    SwitchListTile(
                      title: const Text("La réponse est VRAI ?", style: TextStyle(color: Colors.white)),
                      value: _isCorrect,
                      activeColor: Colors.green,
                      onChanged: (val) => setState(() => _isCorrect = val),
                    ),
                    const SizedBox(height: 40),

                    // 4. Submit Button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.save),
                            label: const Text("ENREGISTRER LA QUESTION"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}