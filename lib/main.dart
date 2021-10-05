import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_manage/screen/home_screen.dart';
import 'package:key_manage/screen/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String rfid = '';

  @override
  void initState() {
    super.initState();
    validateSignIn().whenComplete(() async {
      Get.off(rfid == '' ? const SignIn() : const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Material App',
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSansProTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future validateSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var storedData = prefs.getString('rfid');

    setState(() {
      rfid = storedData.toString();
      print(rfid);
    });
  }
}
