import 'package:account/global/global.dart';
import 'package:account/model/customers.dart';
import 'package:account/uploadScreens/customers_upload_screen.dart';
import 'package:account/uploadScreens/menus_upload_screen.dart';
import 'package:account/widgets/cust_info_design.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String query = "";
  List<double> cashTransAmount = [];
  List<double> creditTransAmount = [];

  double cashTotal = 0;
  double creditTotal = 0;
  double transTotal = 0;
  initState() {
    setState(() {});
  }

  updateDashBoardTotal() {
    cashTransAmount.forEach((e) => cashTotal += e);
    creditTransAmount.forEach((e) => creditTotal += e);
    transTotal = cashTotal + creditTotal;

    final ref = FirebaseFirestore.instance.collection("shops");

    ref.doc(sharedPreferences!.getString("uid")).update(
      {
        "custCashTotal": (cashTotal),
        "custCreditTotal": (creditTotal),
      },
    );
    print("values of query ${query}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
        title: Text(
          //sharedPreferences!.getString("name")!,
          'Customers',
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const CustomersUploadScreen()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Colors.cyan,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: ("Search Customers"),
              ),
              onChanged: ((value) {
                setState(() {
                  query = value;
                });

                //print("name : ${query}");
              }),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: query),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("shops")
                .doc(sharedPreferences!.getString("uid"))
                .collection("customers")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                        //child: Text("its working upto streaming"),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        print("printed at ItemBuilder");
                        Customers model = Customers.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        cashTransAmount.add(model.cashTotal!);
                        creditTransAmount.add(model.creditTotal!);

                        if (index + 1 == snapshot.data!.docs.length) {
                          updateDashBoardTotal();
                        }
                        return model.customerName!
                                .toString()
                                .contains(query.toString())
                            ? CustInfoDesignWidget(
                                model: model,
                                context: context,
                              )
                            : const Text("");
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
