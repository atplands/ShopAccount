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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  int suppCashTotal = 0;
  int suppCreditTotal = 0;
  int suppTransTotal = 0;
  DateTime? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashBoardTotals();
    setState(() {
      //name = DateTime.now();
    });
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

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  Future pickRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
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
          actions: [
            IconButton(
                onPressed: pickRange, icon: const Icon(Icons.calendar_month))
          ],
          title: Text('Purchases Screen'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Credit",
              ),
              Tab(
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
                    /*Container(
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        color: Colors.amber,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: ("Search Purchase Orders"),
                          ),
                          onChanged: ((value) {
                            setState(() {
                              name = value;
                            });

                            print("name : ${name}");
                          }),
                        ),
                      ),
                    ),*/
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: PurchaseTextWidgetHeader(
                        title: "Purchases",
                        cashTransType1: "Cash",
                        creditTransType2: "Credit",
                        cashTransamount1: suppCashTotal.toString(),
                        creditTransamount2: suppCreditTotal.toString(),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: name != null
                          ? FirebaseFirestore.instance
                              //.collection("shops")
                              //.doc(sharedPreferences!.getString("uid"))
                              .collection("suppTrans")
                              .where("transDate",
                                  isGreaterThanOrEqualTo: dateRange.start)
                              .where("transDate",
                                  isLessThanOrEqualTo: dateRange.end)
                              //.where("transType", isEqualTo: "Cash")
                              .snapshots()
                          : FirebaseFirestore.instance
                              //.collection("shops")
                              //.doc(sharedPreferences!.getString("uid"))
                              .collection("suppTrans")
                              //.where("transType", isEqualTo: "Credit ")
                              .orderBy("transDueDate", descending: false)
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
                                  return model.transType
                                          .toString()
                                          .contains("Credit")
                                      ? PurInfoDesignWidget(
                                          model: model,
                                          context: context,
                                        )
                                      : Text("");
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
                    /*Container(
                      child: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          color: Colors.amber,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: ("Search Prices"),
                            ),
                            onChanged: ((value) {
                              setState(() {
                                name = value;
                              });

                              print("name : ${name}");
                            }),
                          ),
                        ),
                      ),
                    ),*/

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: PurchaseTextWidgetHeader(
                        title: "Purchases",
                        cashTransType1: "Cash",
                        creditTransType2: "Credit",
                        cashTransamount1: suppCashTotal.toString(),
                        creditTransamount2: suppCreditTotal.toString(),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: name != null
                          ? FirebaseFirestore.instance
                              //.collection("shops")
                              //.doc(sharedPreferences!.getString("uid"))
                              .collection("suppTrans")
                              .where("transDate",
                                  isGreaterThanOrEqualTo: dateRange.start)
                              .where("transDate",
                                  isLessThanOrEqualTo: dateRange.end)
                              //.where("transType", isEqualTo: "Cash")
                              .snapshots()
                          : FirebaseFirestore.instance
                              //.collection("shops")
                              //.doc(sharedPreferences!.getString("uid"))
                              .collection("suppTrans")
                              //.where("transType", isEqualTo: "Cash")
                              .orderBy("transDate", descending: true)
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

                                  return model.transType
                                          .toString()
                                          .contains("Cash")
                                      ? PurInfoDesignWidget(
                                          model: model,
                                          context: context,
                                        )
                                      : Text("");
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
