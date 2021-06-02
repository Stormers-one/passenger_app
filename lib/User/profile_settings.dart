import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/Styling/buttonStyles.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();

  String currentName;
  String currentphno;

  PickedFile _image;
  Future uploadPicture(BuildContext context) async {
    //File m = await getImageFileFromAssets('images/profile-icon.png');
    firebase_storage.Reference firebaseStorageref = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profile_image/$userID');
    try {
      firebase_storage.UploadTask uploadTask =
          firebaseStorageref.putFile(File(_image.path));
      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      Fluttertoast.showToast(msg: 'Profile Picture Uploaded');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePicker = new ImagePicker();
    Future getImage() async {
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print("Image Path $_image");
      });
    }

    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update Your Profile',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.fname,
                    style: new TextStyle(color: Colors.grey),
                    decoration: new InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: new TextStyle(color: Colors.grey),
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: new BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? 'Enter Full Name' : null,
                    onChanged: (val) => setState(() => currentName = val),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  new TextFormField(
                      initialValue: userData.phno,
                      validator: (val) => val!.length != 10.0
                          ? 'Enter valid 10 Digit Phone Nmber'
                          : null,
                      style: new TextStyle(color: Colors.grey),
                      decoration: new InputDecoration(
                        //labelText: "Password:",
                        //labelStyle: new TextStyle(
                        //    fontSize: 15, color: red),
                        hintText: 'Phone Number',
                        hintStyle: new TextStyle(color: Colors.grey),
                        fillColor: Colors.grey[300],
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() => currentphno = val);
                      }),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  SizedBox(
                    height: 80,
                    width: 150,
                    child: ElevatedButton(
                        child: const Text(
                          'Select image file to upload',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Quicksand-Bold',
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                        style: raisedButtonStyle,
                        onPressed: () async {
                          Fluttertoast.showToast(msg: 'Wait For Upload Status');
                          await getImage();
                          await uploadPicture(context);
                        }),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Quicksand-Bold',
                        ),
                      ),
                      style: raisedButtonStyle,
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              currentName ?? userData.fname,
                              userData.email,
                              currentphno ?? userData.phno);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ));
        } else {
          return Loading();
        }
      },
    );
  }
}
