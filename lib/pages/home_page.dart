import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'journal_entry_page.dart';
import 'mood_tracker_page.dart';
import 'past_entries_page.dart';
import 'past_moods_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  String? _todayMood;
  String? _todayJournal;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    String? mood = await _firestoreService.getTodayMood();
    String? journal = await _firestoreService.getTodayJournalEntry();

    setState(() {
      _todayMood = mood;
      _todayJournal = journal;
    });
  }

  void _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Mental Health Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Today's Mood:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (_todayMood != null)
              Text(_todayMood!, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MoodTrackerPage()),
                    );
                    await _loadTodayData();
                  },
                  child: const Text("Add Mood"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PastMoodsPage()),
                    );
                    await _loadTodayData();
                  },
                  child: const Text("View Moods"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              "Today's Journal:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (_todayJournal != null)
              Text(_todayJournal!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JournalEntryPage()),
                    );
                    await _loadTodayData();
                  },
                  child: const Text("Add Journal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PastEntriesPage()),
                    );
                    await _loadTodayData();
                  },
                  child: const Text("View Journals"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}