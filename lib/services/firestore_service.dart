import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  String get todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

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