import 'package:account/global/global.dart';
import 'package:account/model/menus.dart';
import 'package:account/views/bubble_stories.dart';
import 'package:account/views/dashboard.dart';
import 'package:account/widgets/transactions_info_design.dart';
//import 'package:account/widgets/transactions_info_design.dartinfo_design.dart';
import '../widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List customers = [
    "Customer_name_1",
    "Customer_name_2",
    "Customer_name_3",
    "Customer_name_4",
    "Customer_name_5",
  ];
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
        actions: [],
        title: Text('Sales Screen'),
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: "Sales"),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Menus model = Menus.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return InfoDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),

      /*body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SalesScreen()));
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
              height: 220,
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
            Container(
              child: Text('Customers Trans'),
            ),
            Container(
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

            /*Container(
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: TextWidgetHeader(title: "Search Suppliers")),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("sellers")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("menus")
                        .orderBy("publishedDate", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: circularProgress(),
                              ),
                            )
                          : SliverStaggeredGrid.countBuilder(
                              crossAxisCount: 1,
                              staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                              itemBuilder: (context, index) {
                                Menus model = Menus.fromJson(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>,
                                );
                                return InfoDesignWidget(
                                  model: model,
                                  context: context,
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                            );
                    },
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),*/
    );
  }
}
