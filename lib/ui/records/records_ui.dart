import 'package:flutter/material.dart';

//placeholder for records screen
class RecordsUI extends StatelessWidget {
  const RecordsUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: Center(child: Text('records')),
    );
  }
}
