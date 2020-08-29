import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/account.dart';
import 'package:stocker/models/portfolio_history.dart';
import 'package:stocker/models/position.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/providers/stock_provider.dart';
import 'package:stocker/providers/user_provider.dart';
import 'package:stocker/screens/home/tabs/discover/stock_lists/stock_list.dart';
import 'package:stocker/services/service_handler.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/chart/quote_chart.dart';
import 'package:stocker/widgets/connection_failed.dart';
import 'package:stocker/widgets/daily_change.dart';
import 'package:stocker/widgets/stocker_loader.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback logoutCallback;

  const ProfilePage({Key key, this.user, this.logoutCallback})
      : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<Position> positions;
  List<PortfolioHistory> history;
  Account account;
  bool assetsLoading;
  bool historyLoading;
  bool errorLoading;
  double profitLoss = 0;
  final double sidePadding = 30;

  @override
  void initState() {
    super.initState();

    loadAssets();
    loadHistory();
  }

  void loadAssets() async {
    try {
      setState(() {
        assetsLoading = true;
        errorLoading = false;
      });

      await Future.wait(
        [
          StockProvider.getAllPositionStocks(),
          UserProvider.getAccount(),
        ],
      ).then((values) {
        if (values[0] == null || values[1] == null) {
          throw Error();
        }

        positions = values[0];
        account = values[1];
      });
    } catch (err) {
      print(err);
      errorLoading = true;
    } finally {
      setState(() {
        assetsLoading = false;
      });
    }
  }

  void loadHistory() async {
    try {
      setState(() {
        historyLoading = true;
        errorLoading = false;
      });

      dynamic response = await StockProvider.getPotfolioHistory();
      if (response == null || response.length == 0) {
        throw Error();
      }

      history = response;
      profitLoss = history.last.profitLossPct;
    } catch (err) {
      print(err);
      errorLoading = true;
    } finally {
      setState(() {
        historyLoading = false;
      });
    }
  }

  void logout() async {
    try {
      await ServiceHandler.signOutFromServices();
      widget.logoutCallback();
      print('logout was successful');
    } catch (e) {
      print('logout failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorLoading) {
      return ConnectionFailed(
        retryCallback: loadAssets,
      );
    }

    if (assetsLoading) {
      return StockerLoader(
        withLogo: false,
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: logout,
                iconSize: 40,
              ),
            ),
            buildProfileImage(),
            buildUsername(),
            buildAccountInfo(),
            buildAssets(),
            Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Balance Hisotry',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildPortfolioHistory()
          ],
        ),
      ),
    );
  }

  Container buildPortfolioHistory() {
    return Container(
      padding: EdgeInsets.all(sidePadding),
      child: assetsLoading
          ? StockerLoader(
              withLogo: false,
            )
          : QuoteChart.fromPortfolioHistory(history),
    );
  }

  Container buildAssets() {
    return Container(
      child: errorLoading
          ? Center(
              child: ConnectionFailed(
                retryCallback: loadAssets,
              ),
            )
          : StockList(
              stockList: positions?.map((e) => e.stock)?.toList() ?? [],
              isLoading: assetsLoading,
            ),
    );
  }

  Container buildAccountInfo() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  '${account.cash} \$',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppleColors.gray3,
                  ),
                ),
                Text(
                  'Cash',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppleColors.gray1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                DailyChange(
                  percentage: profitLoss,
                  fontSize: 30,
                  iconSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                Text(
                  'Day Profit/Loss',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppleColors.gray1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildUsername() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        '${widget.user.firstName} ${widget.user.lastName}',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container buildProfileImage() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
          widget.user.image,
        ),
      ),
    );
  }
}
