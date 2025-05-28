import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'journal_entry_page.dart';
import 'mood_tracker_page.dart';
import 'past_entries_page.dart';
import 'past_moods_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestoreService = FirestoreService();

  String? _todayMood;
  String? _todayJournal;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    final mood = await _firestoreService.getTodayMood();
    final journal = await _firestoreService.getTodayJournalEntry();

    setState(() {
      _todayMood = mood;
      _todayJournal = journal;
    });
  }

  Future<void> _navigateAndRefresh(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    await _loadTodayData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.045; // scales dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Mental Health Journal'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: baseFontSize + 4,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Today's Mood:",
              style: TextStyle(
                fontSize: baseFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _todayMood ?? 'No mood selected yet',
              style: TextStyle(fontSize: baseFontSize + 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateAndRefresh(const MoodTrackerPage()),
                  child: const Text('Add Mood'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PastMoodsPage()),
                  ),
                  child: const Text('View Moods'),
                ),
              ],
            ),
            Text(
              "Today's Journal:",
              style: TextStyle(
                fontSize: baseFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _todayJournal ?? 'No journal entry yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: baseFontSize - 2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _navigateAndRefresh(const JournalEntryPage()),
                  child: const Text('Add Journal'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PastEntriesPage()),
                  ),
                  child: const Text('View Journals'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}