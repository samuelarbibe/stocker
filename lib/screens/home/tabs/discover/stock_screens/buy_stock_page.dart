import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:selection_picker/selection_item.dart';
import 'package:stocker/models/stock.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/share_number_button.dart';
import 'package:stocker/widgets/success_screen.dart';

class BuyScreen extends StatefulWidget {
  final Stock stock;

  const BuyScreen({Key key, this.stock}) : super(key: key);

  @override
  BuyPageState createState() => BuyPageState();
}

class BuyPageState extends State<BuyScreen> {
  int selectedValue;
  bool success = false;
  bool isCustomShare = false;

  @override
  void initState() {
    super.initState();
    selectedValue = 1;
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
                widget.stock.name,
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
                    'How much do you want to buy?',
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
                      'All transfers are being handled by the Alpaca® stock broker.\nAll your private information is safe.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ShareNumberButton(
                    value: 1,
                    selected: selectedValue,
                    callback: shareButtonClicked,
                  ),
                  ShareNumberButton(
                    value: 2,
                    selected: selectedValue,
                    callback: shareButtonClicked,
                  ),
                  ShareNumberButton(
                    value: 3,
                    selected: selectedValue,
                    callback: shareButtonClicked,
                  ),
                  ShareNumberButton(
                    value: "Other",
                    selected: selectedValue,
                    callback: shareButtonClicked,
                    isOther: true,
                  ),
                ],
              ),
            ),
            isCustomShare
                ? Container(
                    child: Slider(
                      value: selectedValue.toDouble(),
                      label: selectedValue.toString(),
                      min: 1,
                      max: 10,
                      divisions: 10,
                      onChanged: (double value) {
                        setState(() {
                          selectedValue = value.toInt();
                        });
                      },
                    ),
                  )
                : Container(),
            Container(
              child: Text(
                '${(selectedValue * widget.stock.quote.currentPrice).toStringAsFixed(2)}\$',
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
                    await buy(context);
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

  void buyingSuccess(context) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SuccessScreen(successCallback: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }));
  }

  Future buy(context) async {
    try {
      Response response = await ServiceHandler.getAlpaca()
          .buy(widget.stock.symbol, selectedValue);
      if (response.statusCode == 200) {
        buyingSuccess(context);
      } else {
        throw Error();
      }
    } catch (err) {
      print('Could not buy stock!: ' + err);
    }
  }

  void shareButtonClicked(int value) {
    if (value == -1) {
      isCustomShare = true;
      value = 1;
    } else {
      isCustomShare = false;
    }
    setState(() {
      selectedValue = value;
    });
  }

  Container buildStockInfo() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            '${widget.stock.symbol} | ${widget.stock.quote.currentPrice}\$ | ',
            style: TextStyle(
              color: AppleColors.gray1,
              fontSize: 25,
              height: 1.0,
            ),
          ),
          buildDailyChange(widget.stock.quote.change, fontSize: 25)
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
