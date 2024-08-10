import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  User? get currentUser {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return User(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        isAdmin: firebaseUser.displayName == 'Admin',
      );
    }
    return null;
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        final isAdmin = userDoc.data()?['isAdmin'] ?? false;
        return User(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          isAdmin: isAdmin,
        );
      }
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create a new user
  Future<User?> createUser(String email, String password, bool isAdmin) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(isAdmin ? 'Admin' : 'User');
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'email': email,
          'isAdmin': isAdmin,
        });
        return User(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          isAdmin: isAdmin,
        );
      }
    } catch (e) {
      print('Create user error: $e');
      return null;
    }
    return null;
  }

  // Check if the current user is admin
  Future<bool> isCurrentUserAdmin() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      return userDoc.data()?['isAdmin'] ?? false;
    }
    return false;
  }

  // Get user by UID
  Future<User?> getUserByUid(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return User(
          uid: uid,
          email: userDoc.data()?['email'] ?? '',
          isAdmin: userDoc.data()?['isAdmin'] ?? false,
        );
      }
    } catch (e) {
      print('Get user error: $e');
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, {String? email, bool? isAdmin}) async {
    try {
      final updateData = <String, dynamic>{};
      if (email != null) updateData['email'] = email;
      if (isAdmin != null) updateData['isAdmin'] = isAdmin;

      await _firestore.collection('users').doc(uid).update(updateData);

      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && email != null) {
        await firebaseUser.updateEmail(email);
      }
    } catch (e) {
      print('Update user profile error: $e');
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && firebaseUser.uid == uid) {
        await firebaseUser.delete();
      }
    } catch (e) {
      print('Delete user error: $e');
      rethrow;
    }
  }
}

class User {
  final String uid;
  final String email;
  final bool isAdmin;

  User({required this.uid, required this.email, required this.isAdmin});
}