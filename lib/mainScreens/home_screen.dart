import 'dart:async';

import 'package:account/constants/constants.dart';
import 'package:account/mainScreens/purchasesScreen.dart';
import 'package:account/mainScreens/salesScreen.dart';
import 'package:account/views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:account/authentication/auth_screen.dart';
import 'package:account/global/global.dart';
import 'package:account/model/menus.dart';
import 'package:account/uploadScreens/menus_upload_screen.dart';
import 'package:account/widgets/info_design.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/text_widget_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String timeText = "";
  String dateText = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentDate(DateTime date) {
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  getCurrentLiveTime() {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentDate(timeNow);

    if (this.mounted) {
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //time
    timeText = formatCurrentLiveTime(DateTime.now());

    //date
    dateText = formatCurrentDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
          )),
        ),
        title: Text('Dashboard'),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const PurchasesScreen()));
                },
                child: DashBoard(
                  name: 'purchase',
                  type: 'Cash',
                  amount: '40000',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const PurchasesScreen()));
                },
                child: DashBoard(
                  name: 'purchase',
                  type: 'Credit',
                  amount: '40000',
                ),
              ),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SalesScreen()));
                },
                child: Container(
                  child: DashBoard(
                    name: 'Sales',
                    type: 'Cash',
                    amount: '40000',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SalesScreen()));
                },
                child: Container(
                  child: DashBoard(
                    name: 'Sales',
                    type: 'Credit',
                    amount: '40000',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  child: DashBoard(
                    name: 'Total',
                    type: 'Cash',
                    amount: '40000',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  child: DashBoard(
                    name: 'Total',
                    type: 'Credit',
                    amount: '40000',
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
