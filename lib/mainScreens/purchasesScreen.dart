import 'package:account/global/global.dart';
//import 'package:account/mainScreens/purchase_Info_design.dart';
import 'package:account/model/menus.dart';
import 'package:account/model/supTrans.dart';
import 'package:account/views/bubble_stories.dart';
import 'package:account/views/dashboard.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/purchase_Info_design.dart';
import 'package:account/widgets/pur_text_widget_header.dart';
import 'package:account/widgets/transactions_info_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final List suppliers = [
    "Suppier_name_1",
    "Suppier_name_2",
    "Suppier_name_3",
    "Suppier_name_4",
    "Suppier_name_5",
  ];
  int suppCashTotal = 0;
  int suppCreditTotal = 0;
  int suppTransTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashBoardTotals();
    setState(() {});
  }

  void getDashBoardTotals() async {
    final DocumentSnapshot suppRef = await FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .get();

    setState(() {
      suppCashTotal = suppRef.get("suppCashTotal");
      suppCreditTotal = suppRef.get("suppCreditTotal");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: Text('Purchases Screen'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                text: "Credit",
              ),
              Tab(
                icon: Icon(
                  Icons.money_off_csred_outlined,
                  color: Colors.white,
                ),
                text: "Cash",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        drawer: MyDrawer(),
        body: Container(
          child: TabBarView(
            children: [
              Container(
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: TextWidgetHeader(
                        title: "Purchases",
                        cashTransType1: "Cash",
                        creditTransType2: "Credit",
                        cashTransamount1: suppCashTotal.toString(),
                        creditTransamount2: suppCreditTotal.toString(),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          //.collection("shops")
                          //.doc(sharedPreferences!.getString("uid"))
                          .collection("suppTrans")
                          .where("transType", isEqualTo: "Credit ")
                          //.orderBy("publishedDate", descending: true)
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
                                staggeredTileBuilder: (c) =>
                                    StaggeredTile.fit(1),
                                itemBuilder: (context, index) {
                                  SupTrans model = SupTrans.fromJson(
                                    snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>,
                                  );
                                  if (index + 1 ==
                                      snapshot.data!.docs.length) {}
                                  return PurInfoDesignWidget(
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
              ),
              Container(
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: TextWidgetHeader(
                        title: "Purchases",
                        cashTransType1: "Cash",
                        creditTransType2: "Credit",
                        cashTransamount1: suppCashTotal.toString(),
                        creditTransamount2: suppCreditTotal.toString(),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          //.collection("shops")
                          //.doc(sharedPreferences!.getString("uid"))
                          .collection("suppTrans")
                          .where("transType", isEqualTo: "Cash")
                          //.orderBy("publishedDate", descending: true)
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
                                staggeredTileBuilder: (c) =>
                                    StaggeredTile.fit(1),
                                itemBuilder: (context, index) {
                                  SupTrans model = SupTrans.fromJson(
                                    snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>,
                                  );
                                  if (index + 1 ==
                                      snapshot.data!.docs.length) {}

                                  return PurInfoDesignWidget(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
