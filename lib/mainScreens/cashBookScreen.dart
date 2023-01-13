// ignore_for_file: prefer_const_constructors

import 'package:account/global/global.dart';
import 'package:account/mainScreens/cashBookEditScreen.dart';
import 'package:account/model/cashBook.dart';
import 'package:account/uploadScreens/cashBook_upload_screen.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({Key? key}) : super(key: key);
  _CashBookScreenState createState() => _CashBookScreenState();
}

class _CashBookScreenState extends State<CashBookScreen> {
  bool isExpand = false;
  String name = "";
  CollectionReference ref = FirebaseFirestore.instance
      .collection("shops")
      .doc(sharedPreferences!.getString("uid"))
      .collection("cashBook");
  @override
  void initState() {
    super.initState();
    setState(() {});
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
        title: Text("Cash Flow Book"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => CashBookUploadScreen()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Colors.amber,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: ("Search CashBook"),
              ),
              onChanged: ((value) {
                setState(() {
                  name = value;
                });

                debugPrint("name : $name");
              }),
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? circularProgress()
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    CashBook model = CashBook.fromJson(
                        snapshots.data!.docs[index].data()!
                            as Map<String, dynamic>);
                    return model.cashBookInfo.toString().contains(name)
                        ? SingleChildScrollView(
                            child: Card(
                              elevation: 5,
                              child: ExpansionTile(
                                leading: Text(model.publishedDate!
                                    .toDate()
                                    .toString()) //width: 80.0,
                                ,
                                title: Text(model.cashBookInfo.toString()),
                                children: [
                                  ListTile(
                                    leading: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: (() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    CashBookEditScreen(
                                                      model: model,
                                                      context: context,
                                                    )));
                                      }),
                                    ),
                                    title: Text(model.cashBookInfo.toString()),
                                    trailing:
                                        Text(model.cashInAmount.toString()),
                                  ),
                                  ListTile(
                                    leading: Text(
                                        "₹" + model.cashInAmount.toString()),
                                    title: Text("Stock" +
                                        model.cashOutAmount.toString()),
                                    trailing: Text(
                                        "♢" + model.onlineInAmount.toString()),
                                  ),
                                  /*ListTile(
                              title: Text("Query String ${name}" +
                                  model.inStockCount.toString()),
                              trailing: model.priceListName
                                      .toString()
                                      .startsWith(name)
                                  ? Text(
                                      "query matched ${model.priceListName.toString().startsWith(name)}")
                                  : Text("query not matched."),
                          ),*/
                                ],
                                onExpansionChanged: (isExpanded) {
                                  //print("Expanded: ${isExpanded}");
                                },
                              ),
                            ),
                          )
                        : Center(child: Text(""));
                  },
                );
        },
      ),
    );
  }
}
