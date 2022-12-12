import 'package:account/model/custTrans.dart';
import 'package:account/model/customers.dart';
import 'package:account/uploadScreens/custTrans_upload_screen.dart';
import 'package:account/widgets/custTrans_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:account/global/global.dart';
import 'package:account/model/items.dart';
import 'package:account/model/menus.dart';
import 'package:account/uploadScreens/items_upload_screen.dart';
import 'package:account/uploadScreens/menus_upload_screen.dart';
import 'package:account/widgets/info_design.dart';
import 'package:account/widgets/items_design.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:account/widgets/text_widget_header.dart';

class CustTransScreen extends StatefulWidget {
  final Customers? model;
  CustTransScreen({this.model});

  @override
  _CustTransScreenState createState() => _CustTransScreenState();
}

class _CustTransScreenState extends State<CustTransScreen> {
  List<int> cashTransAmount = [];
  List<int> creditTransAmount = [];
  int cashTotal = 0;
  int creditTotal = 0;
  int transTotal = 0;

  updateFireStore(var custID) {
    final ref = FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("customers");
    cashTransAmount.forEach((e) => cashTotal += e);
    creditTransAmount.forEach((e) => creditTotal += e);
    transTotal = cashTotal + creditTotal;

    ref.doc(custID).update(
      {
        "transTotal": (transTotal),
        "cashTotal": (cashTotal),
        "creditTotal": (creditTotal),
      },
    ).then((value) {
      final suppRef = FirebaseFirestore.instance.collection("customers");
      suppRef.doc(custID).update({
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
                          CustTransUploadScreen(model: widget.model)));
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
                .collection("customers")
                .doc(widget.model!.custID)
                .collection("custTrans")
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
                        CustTrans model = CustTrans.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        model.transType == "Cash"
                            ? cashTransAmount.add(model.transAmount!)
                            : creditTransAmount.add(model.transAmount!);

                        if (index + 1 == snapshot.data!.docs.length) {
                          updateFireStore(model.custID);
                        }
                        return CustTransDesignWidget(
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
