import 'package:account/mainScreens/home_screen.dart';
import 'package:account/mainScreens/suppTransScreen.dart';
import 'package:account/model/custTrans.dart';
import 'package:account/model/supTrans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
import 'package:account/model/items.dart';
import 'package:account/splashScreen/splash_screen.dart';
import 'package:account/widgets/simple_app_bar.dart';

class SuppTransDetailsScreen extends StatefulWidget {
  final SupTrans? model;
  SuppTransDetailsScreen({this.model});

  @override
  _SuppTransDetailsScreenState createState() => _SuppTransDetailsScreenState();
}

class _SuppTransDetailsScreenState extends State<SuppTransDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String suppTransID) {
    FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("suppliers")
        .doc(widget.model!.supplierID!)
        .collection("suppTrans")
        .doc(suppTransID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("suppTrans")
          .doc(suppTransID)
          .delete();

      Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      Fluttertoast.showToast(msg: "Transaction Deleted Successfully.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: sharedPreferences!.getString("name"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
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
                deleteItem(widget.model!.supTransID!);
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
