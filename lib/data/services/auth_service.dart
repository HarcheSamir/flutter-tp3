import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to listen to auth changes (Logged In vs Logged Out)
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign Up
  Future<User?> signUp(String email, String password, String username) async {
    try {
      // 1. Create User in Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;

      // 2. Create User Document in Firestore (for Avatar later)
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'avatarUrl': '', // Empty for now (Exercise 3)
          'createdAt': DateTime.now(),
        });
      }
      return user;
    } catch (e) {
      throw e;
    }
  }

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw e;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }


Future<void> updateAvatar(String url) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({
        'avatarUrl': url,
      });
    }
  }

  // Get current user details from Firestore
  Stream<DocumentSnapshot> getUserStream() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _db.collection('users').doc(user.uid).snapshots();
    }
    return const Stream.empty();
  }


}