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
                    // Save user info
                    // logInUser(_rfidCtrl.text);

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

    setState(() {
      userId = rfid;
      isLoggedIn = true;
    });
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
