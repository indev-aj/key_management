import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:key_manage/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String userId = "";
  bool isLoggedIn = false;

  final SnackBar snackBar = const SnackBar(
    content: Text(
      'User does not exist!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

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
            const SizedBox(height: 30),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _rfidCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'RFID',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              onPressed: () {
                Map capturedUser = {
                  'rfid': _rfidCtrl.text,
                  'name': _nameCtrl.text,
                };

                databaseReference
                    .child('Users')
                    .once()
                    .then((DataSnapshot snapshot) async {
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
                    // Save user info
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('rfid', _rfidCtrl.text);

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

  Future logInUser(String rfid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('rfid', rfid);
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rfid = prefs.getString('rfid');

    if (userId != 'null') {
      setState(() {
        isLoggedIn = true;
        userId = rfid.toString();
      });
      return;
    }
  }
}
