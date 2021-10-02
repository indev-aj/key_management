import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// import 'package:key_manage/screen/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  final _usernameCtrl = TextEditingController();
  final _rfidCtrl = TextEditingController();

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
              controller: _usernameCtrl,
            ),
            TextField(
              controller: _rfidCtrl,
            ),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                // int count = 0;

                databaseReference
                    .child("user")
                    .once()
                    .then((DataSnapshot snapshot) {
                  // final data = snapshot.value;
                  // for (var val in data) {
                  //   count++;
                  // }

                  // for (var item in data) {
                  //   if () {
                  //     print('User existed!');
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (builder) => const HomeScreen(),
                  //       ),
                  //     );
                  //   } else {
                  //     print(count);
                  //     count++;
                  //     databaseReference.child("user").child("$count").set({
                  //       "Name": _usernameCtrl.text,
                  //       "Rfid": _rfidCtrl.text,
                  //     });
                  //     print(count);
                  //   }
                  //   break;
                  // }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
