import 'package:flutter/material.dart';
import 'package:worker_app/localizations.dart';
import 'package:worker_app/controllers/controllers.dart';
import 'package:worker_app/ui/ui.dart';
import 'package:get/get.dart';

class HomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => controller?.firestoreUser?.value?.uid == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: GetBuilder<BottomNavBarController>(
                init: BottomNavBarController(),
                builder: (s) => IndexedStack(
                  index: s.selectedIndex,
                  children: <Widget>[
                    HomeBody(),
                    SchedulesUI(),
                    RecordsUI(),
                    GuidesUI(),
                    FeedbackUI(),
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavBar(),
            ),
    );
  }
}

class BottomNavBarController extends GetxController {
  final _selectedIndex = 0.obs;
  set selectedIndex(value) => this._selectedIndex.value = value;
  get selectedIndex => this._selectedIndex.value;

  onItemTapped(int index) {
    this.selectedIndex = index;
    update();
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarController>(
        builder: (s) => BottomNavigationBar(
              currentIndex: s.selectedIndex,
              onTap: (index) => s.onItemTapped(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.amber,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label:
                      'Home', //implement localization later, bottomNavbar.home
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label:
                      'Schedules', //implement localization later, bottomNavbar.schedules
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_copy),
                  label:
                      'Records', //implement localization later, bottomNavbar.records
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label:
                      'Guides', //implement localization later, bottomNavbar.guides
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label:
                      'Feedback', //implement localization later, bottomNavbar.feedback
                ),
              ],
            ));
  }
}
