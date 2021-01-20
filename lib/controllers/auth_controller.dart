import 'package:advanced_skill_exam/models/firebase_user.dart';
import 'package:advanced_skill_exam/repositories/auth_repository.dart';
import 'package:advanced_skill_exam/repositories/auth_repository_interface.dart';
import 'package:flutter/material.dart';

class AuthController {
  final IAuthRepository _authRepository = AuthRepository();

  Future signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future signUpWithEmailAndPassword(
    String email,
    String username,
    String pass,
  ) {
    return _authRepository.signUpWithEmailAndPassword(
      email,
      username,
      pass,
    );
  }

  Future signOut(BuildContext context) {
    return _authRepository.signOut(context);
  }

  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe) {
    return _authRepository.saveUserDetailsOnLogin(user, password, rememberMe);
  }

  Future resetPass(String email) {
    return _authRepository.resetPass(email);
  }
}
