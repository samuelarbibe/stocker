import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/providers/user_provider.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/widgets/connection_failed.dart';
import 'package:stocker/widgets/stocker_loader.dart';

class AlpacaLoader extends StatefulWidget {
  final VoidCallback alpacaLoadCallback;
  final String uid;

  AlpacaLoader({Key key, this.alpacaLoadCallback, this.uid}) : super(key: key);

  @override
  AlpacaLoaderState createState() => AlpacaLoaderState();
}

class AlpacaLoaderState extends State<AlpacaLoader> {
  bool loading;
  bool failed;

  @override
  void initState() {
    super.initState();
    loading = false;
    failed = false;

    connect();
  }

  void connect() async {
    String alpacaId = "";
    setState(() {
      loading = true;
      failed = false;
    });

    try {
      User userData = await UserProvider.getUser(widget.uid);

      alpacaId = await ServiceHandler.getAlpaca()
          .connect(userData.alpacaId, userData.alpacaKey, true);

      if (alpacaId != null && alpacaId.isNotEmpty) {
        print('Alpaca user $alpacaId connected successfully');
        connectionSuccessful();
      } else {
        print('connection to alpaca has failed');
        connectionFailed();
      }
    } catch (e) {
      print('connection to alpaca has failed');
      connectionFailed();
    }
  }

  void connectionSuccessful() {
    Timer(Duration(seconds: 0), () {
      widget.alpacaLoadCallback();
    });
  }

  void connectionFailed() {
    Timer(Duration(seconds: 0), () {
      setState(() {
        loading = false;
        failed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: failed
            ? ConnectionFailed(
                retryCallback: connect,
              )
            : StockerLoader(),
      ),
    );
  }
}
