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
  // Save Mood Entry (allow multiple per day)
  // ---------------------------
  Future<void> saveMood(String moodEmoji) async {
    if (userId == null) return;

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('moods')
          .add({
        'mood': moodEmoji,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving mood: $e');
    }
  }

  // ---------------------------
  // Get Most Recent Mood Entry
  // ---------------------------
  Future<String?> getTodayMood() async {
    if (userId == null) return null;

    try {
      var snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('moods')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return snapshot.docs.first.data()['mood'] as String?;
    } catch (e) {
      print('Error fetching mood: $e');
      return null;
    }
  }

  // ---------------------------
  // Save Journal Entry (allow multiple per day)
  // ---------------------------
  Future<void> saveJournalEntry(String entryText) async {
    if (userId == null) return;

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('journals')
          .add({
        'entry': entryText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving journal entry: $e');
    }
  }

  // ---------------------------
  // Get Most Recent Journal Entry
  // ---------------------------
  Future<String?> getTodayJournalEntry() async {
    if (userId == null) return null;

    try {
      var snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('journals')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return snapshot.docs.first.data()['entry'] as String?;
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

  // ---------------------------
  // Get All Past Mood Entries
  // ---------------------------
  Stream<QuerySnapshot> getAllMoodEntries() {
    if (userId == null) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}