import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/controllers/controllers.dart';
import 'package:worker_app/localizations.dart';
import 'package:worker_app/ui/feedback/feedback_home.dart';

//placeholder for feedback screen
//TODO: fix setting page, now stuck in loading loop after Update button is pressed
// ignore: todo
//TODO: fix image upload stuck in blackscreen after choosing image, fixed by removing Loading()
//TODO: make contact logic & push notification

class FeedbackUI extends StatelessWidget {
  const FeedbackUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context); //TODO: implement translation
    return GetBuilder<AuthController>(
        builder: (controller) => controller?.firestoreUser?.value?.uid != null
            ? FBScreen(
                currentUserId: controller.firestoreUser.value.uid,
              )
            : Text('No user data'));
  }
}
