import 'package:advanced_skill_exam/models/firebase_user.dart';
import 'package:flutter/cupertino.dart';

abstract class IAuthRepository {
  Future signInWithEmailAndPassword(String email, String password);

  Future signUpWithEmailAndPassword(
      String email, String username, String password);

  Future signOut(BuildContext context);

  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe);

  Future resetPass(String email);

  Future deleteUser(String email, String password);
}
