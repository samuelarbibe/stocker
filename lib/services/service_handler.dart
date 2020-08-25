import 'package:firebase_auth/firebase_auth.dart';
import 'alpaca/alpaca_service.dart';
import 'firebase/auth.dart';

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN }

class ServiceHandler {
  static Auth firebaseAuth;
  static AlpacaService alpaca;

  static AuthStatus firebaseStatus;
  static AuthStatus alpacaStatus;

  static void init() {
    firebaseAuth = new Auth();
    alpaca = new AlpacaService();
    firebaseStatus = AuthStatus.NOT_DETERMINED;
    alpacaStatus = AuthStatus.NOT_DETERMINED;
  }

  static Future<String> fetchStatus() async {
    FirebaseUser user = await firebaseAuth.getCurrentUser();

    firebaseStatus =
        (user != null) ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;

    Map alpacaAccount = await alpaca.getAlpacaAccount();

    alpacaStatus = (alpacaAccount != null)
        ? AuthStatus.LOGGED_IN
        : AuthStatus.NOT_LOGGED_IN;

    return user != null ? user.uid : "";
  }

  static Auth getFirebaseAuth() {
    return firebaseAuth;
  }

  static AlpacaService getAlpaca() {
    return alpaca;
  }

  static AuthStatus getAlpacaStatus() {
    return alpacaStatus;
  }

  static AuthStatus getFirebaseStatus() {
    return firebaseStatus;
  }

  static bool isStatusUndetermined() {
    return alpacaStatus == AuthStatus.NOT_DETERMINED ||
        firebaseStatus == AuthStatus.NOT_DETERMINED;
  }

  static bool isStatusLoggedIn() {
    return alpacaStatus == AuthStatus.LOGGED_IN &&
        firebaseStatus == AuthStatus.LOGGED_IN;
  }

  static signOutFromServices() async {
    if (isStatusLoggedIn()) {
      await firebaseAuth.signOut();
      alpaca.disconnect();
    }
  }
}
