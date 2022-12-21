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
  List<int> cashTransAmount = [];
  List<int> creditTransAmount = [];

  int cashTotal = 0;
  int creditTotal = 0;
  int transTotal = 0;
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
          'Customers Screen',
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
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              scrollPadding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              decoration: InputDecoration(
                prefix: Icon(
                  Icons.search,
                ),
                hintText: ("its an search bar"),
              ),
              onChanged: ((value) {
                setState() {
                  query = value;
                  print("values of query ${query}");
                  //print("quey display: ${query}");
                }
              }),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: "Search Customers"),
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
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Customers model = Customers.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        cashTransAmount.add(model.cashTotal!);
                        creditTransAmount.add(model.creditTotal!);

                        if (index + 1 == snapshot.data!.docs.length) {
                          updateDashBoardTotal();
                        }
                        return model.customerName!.contains(query.toString())
                            ? CustInfoDesignWidget(
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
    );
  }
}
