import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/screens/home/tabs/discover/discover_tab.dart';
import 'package:stocker/screens/home/tabs/favorites/watchlist_tab.dart';
import 'package:stocker/screens/home/tabs/profile/profile_tab.dart';
import 'package:stocker/utilities/colors.dart';

class Home extends StatefulWidget {
  Home({Key key, this.logoutCallback, this.user}) : super(key: key);

  final VoidCallback logoutCallback;
  final User user;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int currentTabIndex = 1;

  TextStyle textStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      WatchList(),
      Discover(
        user: widget.user,
      ),
      ProfilePage(
        user: widget.user,
        logoutCallback: widget.logoutCallback,
      ),
    ];

    return Scaffold(
      backgroundColor: AppleColors.white1,
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        backgroundColor: Colors.white,
        onTap: (index) => {
          setState(() {
            currentTabIndex = index;
          })
        },
        items: [
          BottomNavigationBarItem(
            icon: currentTabIndex == 0
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            title: Text(
              "Favorites",
              style: textStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: currentTabIndex == 1
                ? Icon(CupertinoIcons.news_solid)
                : Icon(CupertinoIcons.news),
            title: Text(
              "Discover",
              style: textStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: currentTabIndex == 2
                ? Icon(CupertinoIcons.profile_circled)
                : Icon(CupertinoIcons.person),
            title: Text(
              "My Stocks",
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }
}
