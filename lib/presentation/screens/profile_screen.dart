import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

  void _generateRandomAvatar() async {
    // Generate a random string to get a new robot image
    final randomString = Random().nextInt(1000).toString();
    final newUrl = "https://robohash.org/$randomString?set=set1&bgset=bg1";
    
    await _auth.updateAvatar(newUrl);
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _auth.getUserStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) return const Center(child: Text("Erreur de chargement"));

          final String username = userData['username'] ?? "Utilisateur";
          final String email = userData['email'] ?? "";
          final String avatarUrl = userData['avatarUrl'] ?? "";

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar Circle
                GestureDetector(
                  onTap: _generateRandomAvatar,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.deepPurpleAccent,
                    backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl.isEmpty
                        ? const Icon(Icons.person, size: 80, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  username,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _generateRandomAvatar,
                  icon: const Icon(Icons.shuffle),
                  label: const Text("Changer d'Avatar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context); // Close profile
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text("Se déconnecter", style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}