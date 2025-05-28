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
  final List<String> moodOptions = ['😊', '😢', '😡', '😴', '😨'];

  void selectMood(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

  void saveMood() async {
    if (selectedMood != null) {
      await _firestoreService.saveMood(selectedMood!);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood "$selectedMood" saved!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.deepPurple,
        ),
      );
      setState(() {
        selectedMood = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Mood'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Your Mood:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              children: moodOptions.map((emoji) {
                return GestureDetector(
                  onTap: () => selectMood(emoji),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selectedMood == emoji
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: selectedMood == null ? null : saveMood,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).primaryColor,
                disabledBackgroundColor: Colors.grey.shade400,
              ),
              child: const Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }
}