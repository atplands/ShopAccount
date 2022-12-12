import 'package:account/mainScreens/salesScreen.dart';
import 'package:account/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SalesTextWidgetHeader extends SliverPersistentHeaderDelegate {
  String? title;
  String? cashTransType = '';
  String? creditTransType = '';
  String? cashTransamount = '';
  String? creditTransamount = '';
  SalesTextWidgetHeader(
      {this.title,
      this.cashTransType,
      this.creditTransType,
      this.cashTransamount,
      this.creditTransamount});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        height: 420.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 1.0,
              //width: 10.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SalesScreen()));
                    },
                    child: DashBoard(
                      name: title.toString(),
                      type: cashTransType.toString(),
                      amount: cashTransamount.toString(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SalesScreen()));
                    },
                    child: DashBoard(
                      name: title.toString(),
                      type: creditTransType.toString(),
                      amount: creditTransamount.toString(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
              width: 80.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
