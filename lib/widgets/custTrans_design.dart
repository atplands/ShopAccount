import 'package:account/global/global.dart';
import 'package:account/mainScreens/custTran_detail_screen.dart';
import 'package:account/model/custTrans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:account/mainScreens/item_detail_screen.dart';
import 'package:account/mainScreens/itemsScreen.dart';
import 'package:account/model/items.dart';
import 'package:account/model/menus.dart';

class CustTransDesignWidget extends StatefulWidget {
  CustTrans? model;
  BuildContext? context;

  CustTransDesignWidget({this.model, this.context});

  @override
  _CustTransDesignWidgetState createState() => _CustTransDesignWidgetState();
}

class _CustTransDesignWidgetState extends State<CustTransDesignWidget> {
  getCustomerData() {
    var doc = FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("priceList")
        .doc(widget.model!.custID)
        .get()
        .then((QuerySnapshot) => print(QuerySnapshot.metadata));
    //print(document.getElementsByName("priceListName"));

    //return doc;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => CustTransDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 280,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Divider(
                  height: 4,
                  thickness: 3,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.transName!,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 18,
                    fontFamily: "Train",
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 220.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Text(
                  widget.model!.transInfo!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Divider(
                  height: 4,
                  thickness: 3,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
