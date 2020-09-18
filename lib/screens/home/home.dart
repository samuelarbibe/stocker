import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/screens/home/tabs/discover/discover_tab.dart';
import 'package:stocker/screens/home/tabs/favorites/watchlist_tab.dart';
import 'package:stocker/screens/home/tabs/profile/profile_tab.dart';
import 'package:stocker/screens/home/tabs/search/search_tab.dart';
import 'package:stocker/utilities/colors.dart';

class Home extends StatefulWidget {
  Home({Key key, this.logoutCallback, this.user}) : super(key: key);

  final VoidCallback logoutCallback;
  final User user;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  TextStyle textStyle = TextStyle(
    color: AppleColors.gray2,
    fontSize: 13,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Search(),
      WatchList(),
      Discover(
        user: widget.user,
      ),
      ProfilePage(
        user: widget.user,
        logoutCallback: widget.logoutCallback,
      ),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 2,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text(
              "Search",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text(
              "Favorites",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.news_solid,
            ),
            title: Text(
              "Discover",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_solid,
            ),
            title: Text(
              "My Stocks",
            ),
          )
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return Material(child: tabs[index]);
      },
    );
  }
}
