import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

//data now streaming from Realtime Database not CloudFirestore
//develop a method to convert Stream of data from CloudFirestore collection Stream<DocumentSnapshot> to a List<Event>
class LoadDataFromFireStore extends StatefulWidget {
  @override
  LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
}

class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
  DataSnapshot querySnapshot;
  dynamic data;
  List<Color> _colorCollection;

  @override
  void initState() {
    _initializeEventColor();
    getDataFromDatabase().then((results) {
      setState(() {
        if (results != null) {
          querySnapshot = results;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _showCalendar(),
    );
  }

  _showCalendar() {
    if (querySnapshot != null) {
      List<Event> collection;
      var showData = querySnapshot.value;
      Map<dynamic, dynamic> values = showData;
      List<dynamic> key = values.keys.toList();
      if (values != null) {
        for (int i = 0; i < key.length; i++) {
          data = values[key[i]];
          collection ??= <Event>[];
          final Random random = new Random(); //generate random color for event
          collection.add(Event(
              eventName: data['JobName'],
              isAllDay: false,
              from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['StartTime']),
              to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['EndTime']),
              background: _colorCollection[random.nextInt(9)]));
        }
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return SafeArea(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 210,
            child: SfCalendar(
              view: CalendarView.week,
              initialDisplayDate: DateTime(2021, 1, 1, 9, 0, 0),
              dataSource: _getCalendarDataSource(collection),
              firstDayOfWeek: 1,
            ),
          ),
          RaisedButton(
              //add a hardcoded dummy event
              onPressed: () {
                final dbRef =
                    FirebaseDatabase.instance.reference().child("CalendarData");
                dbRef.push().set({
                  "StartTime": '30/12/2020 07:00:00',
                  "EndTime": '30/12/2020 10:00:00',
                  "JobName": 'Test workplace',
                }).then((_) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully Added')));
                }).catchError((onError) {
                  print(onError);
                });
              },
              child: Text("Add")),
          /*RaisedButton(
              onPressed: () {
                final dbRef =
                    FirebaseDatabase.instance.reference().child("CalendarData");
                dbRef.remove();
              },
              child: Text("Delete")),*/
        ],
      ));
    }
  }

  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
}

MeetingDataSource _getCalendarDataSource([List<Event> collection]) {
  List<Event> meetings = collection ?? <Event>[];
  return MeetingDataSource(meetings);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}

getDataFromDatabase() async {
  var value = FirebaseDatabase.instance.reference();
  var getValue = await value.child('CalendarData').once();
  return getValue;
}

class Event {
  Event({this.eventName, this.from, this.to, this.background, this.isAllDay});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
