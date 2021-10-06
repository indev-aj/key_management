import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/model.dart';
import 'package:key_manage/screen/history_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:key_manage/screen/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<UserDetails> users = [];

  @override
  void initState() {
    super.initState();

    // Update every time there's any changes in the database
    databaseReference.child('Test').onValue.listen((event) {
      Map keyMap = event.snapshot.value;
      users = [];
      keyMap.forEach((key, value) {
        setState(() {
          users.add(UserDetails.fromJson(value));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('rfid', '');
            Get.offAll(const SignIn());
          },
          child: const Text("Yes"),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Management'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return alert;
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.8,
            crossAxisCount: 2,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: keyCard(index + 1, users[index]),
              onTap: () {
                databaseReference.once().then((DataSnapshot snapshot) {
                  List<UserDetails> user = [];
                  var data = snapshot.value['Key_${index + 1}'];

                  if (data != null) {
                    data.forEach(
                        (key, value) => user.add(UserDetails.fromJson(value)));
                  }

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HistoryScreen(index: index + 1, userDetails: user)));
                });
              },
            );
          },
        ),
      ),
    );
  }

  keyCard(int keyNum, UserDetails user) {
    final String status = user.keyStatus == "0" ? "Available" : "Not Available";
    String name;

    if (status == "Available" || user.name == null) {
      name = "None";
    } else {
      name = user.name.toString();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            Text(
              'KEY $keyNum',
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
            Text('Used By: $name'),
          ],
        ),
      ),
    );
  }
}
