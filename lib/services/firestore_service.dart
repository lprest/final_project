import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get Current User ID
  String? get userId => _auth.currentUser?.uid;

  // Get Today's Date as String (e.g., 2025-05-19)
  String get todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // ---------------------------
  // Save Mood for Today
  // ---------------------------
  Future<void> saveMood(String moodEmoji) async {
    if (userId == null) return;

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(todayDate)
          .set({
        'mood': moodEmoji,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving mood: $e');
    }
  }

  // ---------------------------
  // Get Mood for Today
  // ---------------------------
  Future<String?> getTodayMood() async {
    if (userId == null) return null;

    try {
      var doc = await _db
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(todayDate)
          .get();

      if (userId == null) {
        return null;
      }
    } catch (e) {
      print('Error fetching mood: $e');
      return null;
    }
  }

  // ---------------------------
  // Save Journal Entry for Today
  // ---------------------------
  Future<void> saveJournalEntry(String entryText) async {
    if (userId == null) return;

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(todayDate)
          .set({
        'entry': entryText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving journal entry: $e');
    }
  }

  // ---------------------------
  // Get Journal Entry for Today
  // ---------------------------
  Future<String?> getTodayJournalEntry() async {
    if (userId == null) return null;

    try {
      var doc = await _db
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(todayDate)
          .get();

      if (userId == null) {
        return null;
      }
    } catch (e) {
      print('Error fetching journal entry: $e');
      return null;
    }
  }

  // ---------------------------
  // Get All Past Journal Entries
  // ---------------------------
  Stream<QuerySnapshot> getAllJournalEntries() {
    if (userId == null) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}