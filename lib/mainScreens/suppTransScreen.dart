import 'package:account/model/supTrans.dart';
import 'package:account/model/suppliers.dart';
import 'package:account/uploadScreens/suppTrans_upload_screen.dart';
import 'package:account/widgets/suppTrans_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:account/global/global.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';

class SuppTransScreen extends StatefulWidget {
  final Suppliers? model;
  SuppTransScreen({this.model});

  @override
  _SuppTransScreenState createState() => _SuppTransScreenState();
}

class _SuppTransScreenState extends State<SuppTransScreen> {
  List<double> cashTransAmount = [];
  List<double> creditTransAmount = [];
  double cashTotal = 0;
  double creditTotal = 0;
  double transTotal = 0;

  updateFireStore(var SupplierID) {
    final ref = FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("suppliers");
    cashTransAmount.forEach((e) => cashTotal += e);
    creditTransAmount.forEach((e) => creditTotal += e);
    transTotal = cashTotal + creditTotal;

    ref.doc(SupplierID).update(
      {
        "transTotal": (transTotal),
        "cashTotal": (cashTotal),
        "creditTotal": (creditTotal),
      },
    ).then((value) {
      final suppRef = FirebaseFirestore.instance.collection("suppliers");
      suppRef.doc(SupplierID).update({
        "transTotal": (transTotal),
        "cashTotal": (cashTotal),
        "creditTotal": (creditTotal),
      });
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
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.library_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) =>
                          SuppTransUploadScreen(model: widget.model)));
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          /*SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title:
                      "My " + widget.model!.menuTitle.toString() + "'s Items"),
                      ),*/
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("shops")
                .doc(sharedPreferences!.getString("uid"))
                .collection("suppliers")
                .doc(widget.model!.supplierID)
                .collection("suppTrans")
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
                        SupTrans model = SupTrans.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        model.transType == "Cash"
                            ? cashTransAmount.add(model.transAmount!)
                            : creditTransAmount.add(model.transAmount!);

                        if (index + 1 == snapshot.data!.docs.length) {
                          updateFireStore(model.supplierID);
                        }

                        return SuppTransDesignWidget(
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
