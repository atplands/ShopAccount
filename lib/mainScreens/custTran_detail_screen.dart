import 'package:account/mainScreens/custTransEditScreen.dart';
import 'package:account/mainScreens/home_screen.dart';
import 'package:account/model/custTrans.dart';
import 'package:account/uploadScreens/custTrans_upload_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
import 'package:account/model/items.dart';
import 'package:account/splashScreen/splash_screen.dart';
import 'package:account/widgets/simple_app_bar.dart';

class CustTransDetailsScreen extends StatefulWidget {
  final CustTrans? model;
  CustTransDetailsScreen({this.model});

  @override
  _CustTransDetailsScreenState createState() => _CustTransDetailsScreenState();
}

class _CustTransDetailsScreenState extends State<CustTransDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String custTransID) {
    FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("customers")
        .doc(widget.model!.custID!)
        .collection("custTrans")
        .doc(custTransID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("items").doc(custTransID).delete();

      Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      Fluttertoast.showToast(msg: "Transaction Deleted Successfully.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sharedPreferences!.getString("name").toString()),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              semanticLabel: ("Edit"),
              color: Color(0xff09a20e),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) =>
                          CustTransEditScreen(model: widget.model!)));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 80,
            child: Image.network(widget.model!.thumbnailUrl.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.transName.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.transInfo.toString(),
              textAlign: TextAlign.justify,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.transAmount.toString() + " €",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: () {
                //delete item
                deleteItem(widget.model!.custTransID!);
              },
              child: Container(
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
                width: MediaQuery.of(context).size.width - 13,
                height: 50,
                child: const Center(
                  child: Text(
                    "Delete this Transaction",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
