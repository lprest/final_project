import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get Current User
  User? get currentUser => _auth.currentUser;

  // Stream for Auth Changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // ---------------------------
  // Google Sign-In
  // ---------------------------
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Cancelled by user

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // ---------------------------
  // Email & Password Sign-In
  // ---------------------------
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Email Sign-In Error: $e');
      return null;
    }
  }

  // ---------------------------
  // Email & Password Sign-Up
  // ---------------------------
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Email Sign-Up Error: $e');
      return null;
    }
  }

  // ---------------------------
  // Sign Out
  // ---------------------------
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}