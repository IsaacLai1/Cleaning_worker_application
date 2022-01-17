import 'package:flutter/material.dart';
import 'package:worker_app/localizations.dart';
import 'package:worker_app/ui/components/components.dart';
import 'package:worker_app/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:worker_app/ui/home/settings_ui.dart';
import 'package:worker_app/ui/home/timer_ui.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return GetBuilder<AuthController>(
      builder: (controller) => controller?.firestoreUser?.value?.uid != null
          ? Scaffold(
              appBar: AppBar(
                title: Text(labels?.home?.title),
                actions: [
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Get.to(SettingsUI());
                      }),
                ],
              ),
              body: Column(
                children: <Widget>[
                  SizedBox(height: 120),
                  Avatar(controller.firestoreUser.value),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormVerticalSpace(),
                      Text(
                          labels.home.uidLabel +
                              ': ' +
                              controller.firestoreUser.value.uid,
                          style: TextStyle(fontSize: 16)),
                      FormVerticalSpace(),
                      Text(
                          labels.home.nameLabel +
                              ': ' +
                              controller.firestoreUser.value.name,
                          style: TextStyle(fontSize: 16)),
                      FormVerticalSpace(),
                      Text(
                          labels.home.emailLabel +
                              ': ' +
                              controller.firestoreUser.value.email,
                          style: TextStyle(fontSize: 16)),
                      FormVerticalSpace(),
                      Text(
                          labels.home.adminUserLabel +
                              ': ' +
                              controller.admin.value.toString(),
                          style: TextStyle(fontSize: 16)),
                      FormVerticalSpace(),
                      RaisedButton(
                        onPressed: () => Get.to(TimerCounter()),
                        child:
                            const Text('Timer', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Text('No user data'),
    );
  }
}
