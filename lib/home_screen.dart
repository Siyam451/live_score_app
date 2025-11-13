import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FootballMatch> _matchList = [];
  bool _isProgress = false;

  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.log('Entered the home screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Score'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('football').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.hasError) {
            return Center(child: Text('Error: ${snapshots.error}'));
          } else if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          _matchList = snapshots.data!.docs.map((doc) {
            return FootballMatch(
              id: doc.id,
              team1: doc.get('team1'),
              team1Score: doc.get('team1_score'),
              team2: doc.get('team2'),
              team2Score: doc.get('team2_score'),
              winner: doc.get('winner_team'),
              isRunning: doc.get('is_running'),
            );
          }).toList();

          return ListView.builder(
            itemCount: _matchList.length,
            itemBuilder: (context, index) {
              final footballMatch = _matchList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    footballMatch.isRunning ? Colors.green : Colors.grey,
                    child: Icon(
                      footballMatch.isRunning
                          ? Icons.sports_soccer
                          : Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  title:
                  Text('${footballMatch.team1} vs ${footballMatch.team2}'),
                  trailing: Text(
                    '${footballMatch.team1Score} - ${footballMatch.team2Score}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Winner: ${footballMatch.isRunning ? 'Pending' : footballMatch.winner}',
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          try {
            // Example: Delete document (for testing)
            await FirebaseFirestore.instance
                .collection('football')
                .doc('USA VS Iran')
                .delete();

            // Trigger a custom Crashlytics error (for testing only)
            throw Exception('Manual test exception');
          } catch (e, s) {
            debugPrint('----------------FIREBASE CRASHLYTICS----------------');
            debugPrint('Exception: $e');
            await FirebaseCrashlytics.instance.recordError(
              e,
              s,
              printDetails: true,
            );
          }

          // ✅ FIXED: Firebase Analytics event name must use underscores
          await FirebaseAnalytics.instance.logEvent(
            name: 'tap_on_button',
            parameters: {'button': 'add_match'},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FootballMatch {
  final String id;
  final String team1;
  final int team1Score;
  final String team2;
  final int team2Score;
  final String winner;
  final bool isRunning;

  FootballMatch({
    required this.id,
    required this.team1,
    required this.team1Score,
    required this.team2,
    required this.team2Score,
    required this.winner,
    required this.isRunning,
  });
}
