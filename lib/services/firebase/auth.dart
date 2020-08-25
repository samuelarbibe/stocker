import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'database/user_database_service.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(
      String email, String password, String firstName, String lastName);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<String> signIn(String email, String password) async {
    AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(
      String email, String password, String firstName, String lastName) async {
    AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    await UserDatabaseService(uid: user.uid)
        .updateUserData(firstName, lastName, email);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
