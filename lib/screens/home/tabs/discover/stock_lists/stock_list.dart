import 'package:flutter/widgets.dart';
import 'package:stocker/screens/home/tabs/discover/cards/small_card.dart';
import 'package:stocker/screens/home/tabs/discover/cards/small_loading_card.dart';

class StockList extends StatefulWidget {
  final stockList;
  final isLoading;
  final double horizontalPadding;

  const StockList(
      {Key key, this.stockList, this.isLoading, this.horizontalPadding = 20})
      : super(key: key);

  @override
  StockListState createState() => StockListState();
}

class StockListState extends State<StockList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.isLoading ? 5 : widget.stockList.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: widget.isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SmallLoadingCard(
              horizontalPadding: widget.horizontalPadding,
            ),
            secondChild: widget.isLoading
                ? Container()
                : SmallCard(
                    stock: widget.stockList[index],
                    horizontalPadding: widget.horizontalPadding,
                  ),
          );
        });
  }
}
