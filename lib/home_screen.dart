import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Studentinfo> _studentList = [];
  bool _isProgress = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student database'),
        backgroundColor: Colors.blueAccent,
          actions: [
      PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == "logout") {
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SignIn()));
          _logout();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "logout",
          child: Text("Logout"),
        ),
      ],

      ),
    ]
    ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.hasError) {
            return Center(child: Text('Error: ${snapshots.error}'));
          } else if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          _studentList = snapshots.data!.docs.map((doc) {
            return Studentinfo(
              id: doc.id,
              name: doc.get('name'),
              rollNumber: doc.get('rollNumber'),
              course: doc.get('course'),
              isRunning: doc.get('is running'),
            );
          }).toList();

          return ListView.builder(
            itemCount: _studentList.length,
            itemBuilder: (context, index) {
              final student = _studentList[index];
              return Card(
                color: Colors.greenAccent,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    student.isRunning ? Colors.green : Colors.grey,
                    child: Icon(
                      student.isRunning
                          ? Icons.sports_soccer
                          : Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  title:
                  Text('Student name: ${student.name}'),
                  subtitle: Text(
                    'Course name:${student.rollNumber}\nCourse: ${student.course}',
                  ),
              trailing: Text(
              student.isRunning ? "Active" : "Done",
              style: const TextStyle(
              fontWeight: FontWeight.bold,
              ),
                ),
                )
              );
            },
          );
        },
      ),


    );
  }

  void _logout()async{
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out sucessfully')));
  }
}

class Studentinfo {
  final String id;
  final String name;
  final int rollNumber;
  final String course;
  final bool isRunning;

  Studentinfo({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.course,
    required this.isRunning,
  });
}
