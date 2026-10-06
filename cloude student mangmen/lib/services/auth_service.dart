import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register
  Future<String?> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(name);

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'role': role,
          'createdAt': Timestamp.now(),
        });
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current user
  User? get currentUser {
    return _auth.currentUser;
  }

  // Get user data
  Future<DocumentSnapshot> getUserData() async {
    String uid = _auth.currentUser!.uid;

    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  // Update profile
  Future<String?> updateProfile(
    String name,
    String email,
  ) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        return 'User not logged in';
      }

      await user.updateDisplayName(name);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'email': email,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
