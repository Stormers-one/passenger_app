import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:passenger_app/shared/model/user.dart';
import 'package:passenger_app/Shared/services/firebaseServices/database.dart';

class Authservice {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Image m = Image.asset('assets/images/profile_icon.jpg');

  //create user obj based on FirebaseUser

  User _userFromFirebaseUser(firebase_auth.User? user) {
    // if (user == null) {
    //   return null;
    // }
    return User(uid: user?.uid ?? null);
  }

  // auth change user stream

  Stream<User> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Stream<firebase_auth.User?> get onAuthStateChanged =>
      _auth.authStateChanges();

  // GET UID
  Future<String> getCurrentUID() async {
    return _auth.currentUser!.uid;
  }

  //sign in annonymously

  Future signInAnon() async {
    try {
      firebase_auth.UserCredential? result = await _auth.signInAnonymously();
      firebase_auth.User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in the user with email and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential? result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register user with email and password

  Future registerWithEmailAndPassword(
      String fname, String email, String password, String phno) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase_auth.User user = result.user!;

      // create a new document for the user with the uid

      await DatabaseService(uid: user.uid).updateUserData(fname, email, phno);

      return _userFromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out the user

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //RESET PASSWORD

  Future sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
