import 'dart:async';

import 'package:account/constants/constants.dart';
import 'package:account/mainScreens/purchasesScreen.dart';
import 'package:account/mainScreens/salesScreen.dart';
import 'package:account/views/bubble_stories.dart';
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
  final List suppliers = [
    "Suppier_name_1",
    "Suppier_name_2",
    "Suppier_name_3",
    "Suppier_name_4",
    "Suppier_name_5",
  ];
  final List customers = [
    "Customer_name_1",
    "Customer_name_2",
    "Customer_name_3",
    "Customer_name_4",
    "Customer_name_5",
  ];

  int suppCashTotal = 0;
  int suppCreditTotal = 0;
  int custCashTotal = 0;
  int custCreditTotal = 0;
  int transCashTotal = 0;
  int transCreditTotal = 0;

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
    getDashBoardsData();

    setState(() {});
  }

  void getDashBoardsData() async {
    final DocumentSnapshot shopRef = await FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .get();

    setState(() {
      suppCashTotal = shopRef.get("suppCashTotal");
      suppCreditTotal = shopRef.get("suppCreditTotal");
      custCashTotal = shopRef.get("custCashTotal");
      custCreditTotal = shopRef.get("custCreditTotal");
      transCashTotal = suppCashTotal + custCashTotal;
      transCreditTotal = suppCreditTotal + custCreditTotal;
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
            ),
          ),
        ),
        title: Text('Dashboard'),
        //bottom:
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              //scrollDirection: Axis.horizontal,
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
                    amount: suppCashTotal.toString(),
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
                    amount: suppCreditTotal.toString(),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
                      amount: custCashTotal.toString(),
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
                      amount: custCreditTotal.toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    child: DashBoard(
                      name: 'Total',
                      type: 'Cash',
                      amount: transCashTotal.toString(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    child: DashBoard(
                      name: 'Total',
                      type: 'Credit',
                      amount: transCreditTotal.toString(),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Text(
              'Suppliers Recent Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            height: 200,
            /*child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BubbleStories(text: 'Telugu'),
                  BubbleStories(text: 'English'),
                  BubbleStories(text: 'Hindi'),
                  BubbleStories(text: 'Kanada'),
                  BubbleStories(text: 'Rajasthani'),
                ],
              ),*/
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                return BubbleStories(
                  text: suppliers[index],
                );
              },
            ),
          ),
          Container(
            child: Text(
              'Customers Recent Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            height: 200,
            /*child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BubbleStories(text: 'Telugu'),
                  BubbleStories(text: 'English'),
                  BubbleStories(text: 'Hindi'),
                  BubbleStories(text: 'Kanada'),
                  BubbleStories(text: 'Rajasthani'),
                ],
              ),*/
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return BubbleStories(
                  text: customers[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
