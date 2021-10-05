import 'package:flutter/material.dart';
import 'package:key_manage/model.dart';

class HistoryScreen extends StatefulWidget {
  final List<UserDetails> userDetails;
  final int index;

  const HistoryScreen(
      {Key? key, required this.index, required this.userDetails})
      : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List user = [];
  List userList = [];

  @override
  void initState() {
    for (var users in widget.userDetails) {
      user.add(users.name);
      user.add(users.rfid);
      user.add(users.time);
      userList.add(user);
      user = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userDetails.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Key ${widget.index}'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Key ${widget.index}'),
        ),
        body: Container(),
      );
    }
  }
}
