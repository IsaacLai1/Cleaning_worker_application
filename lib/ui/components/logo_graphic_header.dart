import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worker_app/controllers/controllers.dart';

final AuthController authController = AuthController.to;

class LogoGraphicHeader extends StatefulWidget {
  LogoGraphicHeader();

  @override
  _LogoGraphicHeaderState createState() => _LogoGraphicHeaderState();
}

class _LogoGraphicHeaderState extends State<LogoGraphicHeader> {
  final ThemeController themeController = ThemeController.to;

  String uid = authController.firestoreUser.value.uid;

  String photoUrl = authController.firestoreUser.value.photoUrl;

  File avatarImageFile;
  bool isLoading = false;

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'photoUrl': photoUrl}).then((data) async {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'App Logo',
        child: Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                (avatarImageFile == null)
                    ? (photoUrl != ''
                        ? Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                width: 90.0,
                                height: 90.0,
                                padding: EdgeInsets.all(20.0),
                              ),
                              imageUrl: photoUrl,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 90.0,
                            color: Colors.grey[300],
                          ))
                    : Material(
                        child: Image.file(
                          avatarImageFile,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.blue.withOpacity(0.5),
                  ),
                  onPressed: getImage,
                  padding: EdgeInsets.all(30.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.grey[300],
                  iconSize: 30.0,
                ),
              ],
            ),
          ),
          width: double.infinity,
          margin: EdgeInsets.all(20.0),
        ));
  }
}
