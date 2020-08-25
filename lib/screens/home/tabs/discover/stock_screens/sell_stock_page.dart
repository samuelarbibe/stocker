import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:selection_picker/selection_item.dart';
import 'package:stocker/models/position.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/success_screen.dart';

class SellScreen extends StatefulWidget {
  final Position position;

  const SellScreen({Key key, this.position}) : super(key: key);

  @override
  BuyPageState createState() => BuyPageState();
}

class BuyPageState extends State<SellScreen> {
  bool success = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 100, 30, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                widget.position.stock.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: buildStockInfo(),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'Are You sure you want to liquidate your share?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: Text(
                      'After selling, all your share is going to be sold and liquidated. This action cannot be reverted.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(
                'You own ${widget.position.qty} shares, worth',
                style: TextStyle(
                  fontSize: 30,
                  color: AppleColors.gray4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                '${(widget.position.qty * widget.position.stock.quote.currentPrice).toStringAsFixed(2)}\$',
                style: TextStyle(
                  fontSize: 30,
                  color: AppleColors.gray4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 500,
              height: 60,
              child: ArgonButton(
                width: 350,
                height: 60,
                minWidth: 100,
                color: AppleColors.gray5,
                roundLoadingShape: false,
                borderRadius: 5,
                child: Text(
                  "CONFIRM",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitThreeBounce(
                    color: Colors.white70,
                    size: 25.0,
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) async {
                  if (btnState == ButtonState.Idle) {
                    startLoading();
                    await sell(context);
                    stopLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sellingSuccess(context) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SuccessScreen(successCallback: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }));
  }

  Future sell(context) async {
    try {
      Response response =
          await ServiceHandler.getAlpaca().sell(widget.position.stock.symbol);
      if (response.statusCode == 200) {
        sellingSuccess(context);
      } else {
        throw Error();
      }
    } catch (err) {
      print('Could not sell stock!: ' + err);
    }
  }

  Container buildStockInfo() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            '${widget.position.stock.symbol} | ${widget.position.stock.quote.currentPrice}\$ | ',
            style: TextStyle(
              color: AppleColors.gray1,
              fontSize: 25,
              height: 1.0,
            ),
          ),
          buildDailyChange(widget.position.stock.quote.change, fontSize: 25)
        ],
      ),
    );
  }

  Widget buildDailyChange(double percentage, {double fontSize}) {
    final Color accentColor =
        percentage.isNegative ? AppleColors.red : AppleColors.green;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        percentage.isNegative
            ? Icon(
                Icons.arrow_drop_down,
                color: accentColor,
                size: 35,
              )
            : Icon(
                Icons.arrow_drop_up,
                color: accentColor,
                size: 35,
              ),
        Text(
          '${percentage.toStringAsPrecision(2)}%',
          style: TextStyle(
            color: accentColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  List<SelectionItem> getDays() {
    List<SelectionItem> days = [];
    days.add(SelectionItem(name: "1", isSelected: false, identifier: 1));
    days.add(SelectionItem(name: "2", isSelected: false, identifier: 2));
    days.add(SelectionItem(name: "3", isSelected: false, identifier: 3));
    days.add(SelectionItem(name: "Other", isSelected: false, identifier: 4));
    return days;
  }
}
