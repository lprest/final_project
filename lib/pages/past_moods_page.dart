import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class PastMoodsPage extends StatelessWidget {
  const PastMoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Past Moods')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllMoodEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No past moods found.'));
          }

          final moods = snapshot.data!.docs;

          return ListView.builder(
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final data = mood.data() as Map<String, dynamic>;
              final date = mood.id;
              final moodValue = data['mood'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(moodValue, style: const TextStyle(fontSize: 24)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}