import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:key_manage/model.dart';
import 'package:key_manage/screen/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.8,
            crossAxisCount: 2,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              child: keyCard(index + 1, 'Amrin'),
              onTap: () {
                databaseReference.once().then((DataSnapshot snapshot) {
                  List<UserDetails> user = [];
                  Map<dynamic, dynamic> data =
                      snapshot.value['Key_${index + 1}'];

                  data.forEach(
                      (key, value) => user.add(UserDetails.fromJson(value)));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HistoryScreen(index: index + 1, user: user)));
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget keyCard(int key, String name) {
    final randomNumberGenerator = Random();
    final randomBoolean = randomNumberGenerator.nextBool();

    final String status = randomBoolean ? "Available" : "Not Available";
    final String user = status == "Available" ? "None" : name;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            Text(
              'KEY $key',
              // ignore: prefer_const_constructors
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // ignore: prefer_const_constructors
            Divider(
              thickness: 1,
            ),
            Text(
              'Status: $status',
              // ignore: prefer_const_constructors
              style: TextStyle(fontSize: 14),
            ),
            // ignore: prefer_const_constructors
            Text('Used By: $user'),
          ],
        ),
      ),
    );
  }
}
