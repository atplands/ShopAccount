//
import 'package:account/mainScreens/suppTransScreen.dart';
import 'package:account/mainScreens/suppliersEditScreen.dart';
import 'package:account/model/suppliers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
//import 'package:foodpanda_sellers_app/mainScreens/itemsScreen.dart';

class SuppliersInfoDesignWidget extends StatefulWidget {
  Suppliers? model;
  BuildContext? context;

  SuppliersInfoDesignWidget({this.model, this.context});

  @override
  _SuppliersInfoDesignWidgetState createState() =>
      _SuppliersInfoDesignWidgetState();
}

class _SuppliersInfoDesignWidgetState extends State<SuppliersInfoDesignWidget> {
  deleteMenu(String custID) {
    FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("customers")
        .doc(custID)
        .delete()
        .then(
      (value) {
        FirebaseFirestore.instance.collection("customers").doc(custID).delete();
      },
    );

    //Fluttertoast.showToast(msg: "Menu Deleted Successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => SuppTransScreen(model: widget.model),
          ),
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 5,
          child: ExpansionTile(
            leading: Image.network(
              widget.model!.thumbnailUrl!.toString(),
              //width: 80.0,
            ),
            title: Text(widget.model!.supplierName!.toString()),
            children: [
              ListTile(
                leading: Text("Credit₹" + widget.model!.creditTotal.toString()),
                /*IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => SupplierEditScreen(
                                  model: widget.model!,
                                  context: context,
                                )));
                  }),
                ),*/
                title: Text("Cash₹" + widget.model!.cashTotal.toString()),
                trailing: Text("Total₹" + widget.model!.transTotal.toString()),
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => SupplierEditScreen(
                                  model: widget.model!,
                                  context: context,
                                )));
                  }),
                ), //Text("₹" + widget.model!.supplierName!.toString()),
                title: Text("Stock" + widget.model!.status.toString()),
                trailing: Text("♢" + widget.model!.supplierContact.toString()),
              ),
              ListTile(
                  title: Text(
                      "address :" + widget.model!.supplierAddress!.toString())
                  //: Text("query not matched."),
                  ),
            ],
            onExpansionChanged: (isExpanded) {
              //print("Expanded: ${isExpanded}");
            },
          ),
        ),
      ),
    );
  }
}
