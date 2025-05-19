import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  final FirestoreService _firestoreService = FirestoreService();

  // List of Emojis to Choose From
  final List<String> _moods = ['😢', '😕', '😐', '🙂', '😊', '😁'];
  String? _selectedMood;

  void _saveMood() async {
    if (_selectedMood != null) {
      await _firestoreService.saveMood(_selectedMood!);
      if (!mounted) return;
      Navigator.pop(context); // Return to Home Page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),

            // Emoji Picker
            Wrap(
              spacing: 20,
              children: _moods.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = emoji;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedMood == emoji ? Colors.blueAccent.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedMood == emoji ? Colors.blueAccent : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveMood,
              child: const Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }
}