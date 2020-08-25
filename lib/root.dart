import 'package:flutter/material.dart';
import 'package:stocker/providers/user_provider.dart';
import 'package:stocker/screens/loading_pages/alpaca_loader.dart';
import 'package:stocker/screens/home/home.dart';
import 'package:stocker/screens/loading_pages/login.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/widgets/stocker_loader.dart';

import 'models/user.dart';

class RootPage extends StatefulWidget {
  RootPage();

  @override
  State<StatefulWidget> createState() => new RootPageState();
}

class RootPageState extends State<RootPage> {
  User currentUser;
  String uid;

  @override
  void initState() {
    super.initState();
    ServiceHandler.init();

    uid = "";
  }

  void fetchStatus() async {
    uid = await ServiceHandler.fetchStatus();
    currentUser =
        (uid != null && uid != '') ? await UserProvider.getUser(uid) : null;
    setState(() {});
  }

  void callback() {
    fetchStatus();
  }

  Widget buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: StockerLoader(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ServiceHandler.isStatusUndetermined()) {
      fetchStatus();
      return buildLoadingScreen();
    }

    if (ServiceHandler.getFirebaseStatus() == AuthStatus.NOT_LOGGED_IN) {
      return Login(
        auth: ServiceHandler.getFirebaseAuth(),
        loginCallback: callback,
      );
    }

    if (ServiceHandler.getAlpacaStatus() == AuthStatus.NOT_LOGGED_IN) {
      return AlpacaLoader(
        uid: uid,
        alpacaLoadCallback: callback,
      );
    }

    if (ServiceHandler.isStatusLoggedIn()) {
      return Home(
        logoutCallback: callback,
        user: currentUser,
      );
    }

    return buildLoadingScreen();
  }
}
