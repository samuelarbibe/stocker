import 'package:flutter/material.dart';
import 'package:stocker/screens/home/tabs/discover/cards/large_card.dart';
import 'package:stocker/screens/home/tabs/discover/cards/large_loading_card.dart';

class CardList extends StatefulWidget {
  final stockList;
  final bool isLoading;

  const CardList({Key key, this.stockList, this.isLoading}) : super(key: key);

  @override
  CardListState createState() => CardListState();
}

class CardListState extends State<CardList> {
  final double height = 260;
  double currentPageValue = 3.0;

  PageController pageViewController;

  @override
  void initState() {
    super.initState();

    pageViewController = PageController(
      initialPage: currentPageValue.floor(),
      viewportFraction: 0.93,
    );

    pageViewController.addListener(() {
      setState(() {
        currentPageValue = pageViewController.page;
      });
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // card height
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.isLoading ? 5 : widget.stockList.length,
        controller: pageViewController,
        itemBuilder: (_, index) {
          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: widget.isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: LargeLoadingCard(),
            secondChild: widget.isLoading
                ? Container()
                : LargeStockCard(
                    stock: widget.stockList[index],
                    height: height,
                  ),
          );
        },
      ),
    );
  }
}
