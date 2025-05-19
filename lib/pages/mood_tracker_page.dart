import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  final FirestoreService _firestoreService = FirestoreService();
  String? selectedMood;

  void _saveMood() async {
    if (selectedMood != null) {
      await _firestoreService.saveMood(selectedMood!);
      Navigator.pop(context); // Return to HomePage after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Your Mood')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select Your Mood:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: ['😊', '😢', '😡', '😴', '😰'].map((mood) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedMood == mood ? Colors.blue : null,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                  child: Text(mood, style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedMood == null ? null : _saveMood,
              child: const Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }
}