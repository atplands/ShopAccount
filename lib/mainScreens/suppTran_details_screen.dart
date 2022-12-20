import 'package:account/mainScreens/home_screen.dart';
import 'package:account/mainScreens/suppTransEditScreen.dart';
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
  BuildContext? context;
  SuppTransDetailsScreen({this.model, this.context});

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
        .doc(widget.model!.supplierID!)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("suppTrans")
          .doc(widget.model!.supplierID!)
          .delete();

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
          TextButton(
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Varela",
                letterSpacing: 3,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => SuppTransEditScreen(
                            model: widget.model!,
                            context: context,
                          )));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180.0,
              child: Image.network(widget.model!.thumbnailUrl.toString(),
                  height: 180.0, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.transName.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.transInfo.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.transAmount.toString() + " €",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Date: " + widget.model!.transDate!.toDate().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  Text(
                    "Due: " + widget.model!.transDueDate!.toDate().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  Text(
                    "Close: " +
                        widget.model!.transClosedDate!.toDate().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  //delete item
                  deleteItem(widget.model!.suppTransID!);
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
      ),
    );
  }
}
