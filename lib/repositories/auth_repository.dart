import 'package:advanced_skill_exam/helper/functions.dart';
import 'package:advanced_skill_exam/models/firebase_user.dart';
import 'package:advanced_skill_exam/repositories/auth_repository_interface.dart';
import 'package:advanced_skill_exam/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser> userFromFirebaseUser(User user) async {
    AppUser _appUser;

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: user.email)
          .get();

      snapshot.docs.map((DocumentSnapshot doc) {
        _appUser = AppUser.fromSnapshot(doc);
      }).toList();

      return _appUser;
    } else {
      return null;
    }
  }

  @override
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;

      return userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //   print('Wrong password provided for that user.');
      }

      //   print('Failed with error code: ${e.code}');
      return null;
      // ignore: avoid_catches_without_on_clauses
    }
  }

  @override
  Future signUpWithEmailAndPassword(
      String email, String username, String password) async {
    try {
      var _appUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Map<String, String> userInfo = {
        "userName": username,
        "email": email,
        "role": "user",
        "uid": _appUser.user.uid,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .add(userInfo)
          .catchError((e) {
        //   print(e);
      }).then((value) {
        HelperFunctions.saveUserNameSharedPreference(username);
        HelperFunctions.saveUserEmailSharedPreference(email);
        HelperFunctions.saveUserPasswordSharedPreference(password);
        HelperFunctions.saveUserRoleSharedPreference("user");
      });

      User firebaseUser = _appUser.user;
      return userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // errorMessage = e.code;
      } else if (e.code == 'wrong-password') {
        //     errorMessage = e.code;
      }

      return null;
    }
  }

  @override
  Future signOut(BuildContext context) async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.removeUserNameSharedPreference();
      await HelperFunctions.removeUserEmailSharedPreference();
      await HelperFunctions.removeUserPasswordSharedPreference();

      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUp()));

      return await _auth.signOut();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }

  @override
  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe) async {
    if (rememberMe) {
      await HelperFunctions.saveUserLoggedInSharedPreference(rememberMe);

      await HelperFunctions.saveUserNameSharedPreference(user.userName);
      await HelperFunctions.saveUserEmailSharedPreference(user.email);
      await HelperFunctions.saveUserPasswordSharedPreference(password);
    }
  }

  @override
  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }

  Future deleteUser(String email, String password) async {}
}
