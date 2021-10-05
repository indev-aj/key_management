import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/screen/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  final _nameCtrl = TextEditingController();
  final _rfidCtrl = TextEditingController();

  final SnackBar snackBar = const SnackBar(
    content: Text(
      'User does not exist!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
            ),
            TextField(
              controller: _rfidCtrl,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                Map capturedUser = {
                  'rfid': _rfidCtrl.text,
                  'name': _nameCtrl.text,
                };

                databaseReference
                    .child('Users')
                    .once()
                    .then((DataSnapshot snapshot) {
                  Map data = snapshot.value;

                  Map user = {};
                  List users = [];

                  data.forEach((key, value) {
                    user['rfid'] = key;
                    user['name'] = value;
                    users.add(user);
                    user = {};
                  });

                  var loggedIn = users.firstWhere(
                    (user) =>
                        user['rfid'] == capturedUser['rfid'] &&
                        user['name'] == capturedUser['name'],
                    orElse: () => null,
                  );

                  if (loggedIn != null) {
                    // Navigate to Home Screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
