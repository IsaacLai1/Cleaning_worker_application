import 'package:flutter/material.dart';
import 'package:worker_app/ui/schedules/calendar_view.dart';

//placeholder for schedules screen
//TODO: add a list screen and a toggle between list view and calendar view
class SchedulesUI extends StatelessWidget {
  const SchedulesUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      body: Container(child: LoadDataFromFireStore()),
    );
  }
}
