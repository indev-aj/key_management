import 'package:flutter/material.dart';
import 'package:key_manage/model.dart';

class HistoryScreen extends StatefulWidget {
  final List<UserDetails>? user;
  final int index;

  const HistoryScreen({Key? key, required this.index, required this.user})
      : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key ${widget.index}'),
      ),
      body: Column(
        children: [
          Text(widget.user!.last.name.toString()),
        ],
      ),
    );
  }
}
