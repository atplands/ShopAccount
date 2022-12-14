import 'package:account/global/global.dart';
import 'package:account/model/suppliers.dart';
import 'package:account/uploadScreens/suppliers_upload_screen.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/supplier_info_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SuppliersScreen extends StatefulWidget {
  SuppliersScreen({Key? key}) : super(key: key);

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<int> cashTransAmount = [];
  List<int> creditTransAmount = [];
  int cashTotal = 0;
  int creditTotal = 0;
  int transTotal = 0;
  String? query = "";

  updateDashBoardTotal() {
    cashTransAmount.forEach((e) => cashTotal += e);
    creditTransAmount.forEach((e) => creditTotal += e);
    transTotal = cashTotal + creditTotal;

    final ref = FirebaseFirestore.instance.collection("shops");

    ref.doc(sharedPreferences!.getString("uid")).update(
      {
        "suppCashTotal": (cashTotal),
        "suppCreditTotal": (creditTotal),
      },
    );
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
          'Suppliers Screen',
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
                      builder: (c) => const SuppliersUploadScreen()));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          /*SliverPersistentHeader(
              pinned: true,
              delegate: 
              TextWidgetHeader(title: "Search Suppliers"),
              ),*/
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("shops")
                .doc(sharedPreferences!.getString("uid"))
                .collection("suppliers")
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
                        Suppliers model = Suppliers.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );

                        cashTransAmount.add(model.cashTotal!);
                        creditTransAmount.add(model.creditTotal!);

                        if (index + 1 == snapshot.data!.docs.length) {
                          updateDashBoardTotal();
                        }

                        return SuppliersInfoDesignWidget(
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
    );
  }
}
