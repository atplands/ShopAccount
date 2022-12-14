import 'package:account/mainScreens/custTransScreen.dart';
import 'package:account/mainScreens/customersEditScreen.dart';
import 'package:account/mainScreens/itemsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
//import 'package:foodpanda_sellers_app/mainScreens/itemsScreen.dart';
import 'package:account/model/customers.dart';

class CustInfoDesignWidget extends StatefulWidget {
  Customers? model;
  BuildContext? context;

  CustInfoDesignWidget({this.model, this.context});

  @override
  _CustInfoDesignWidgetState createState() => _CustInfoDesignWidgetState();
}

class _CustInfoDesignWidgetState extends State<CustInfoDesignWidget> {
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
            builder: (c) => CustTransScreen(model: widget.model),
          ),
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.custName!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "Train",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.lightGreenAccent,
                    ),
                    onPressed: () {
                      //delete menu
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  CustomerEditScreen(model: widget.model!)));
                      //deleteMenu(widget.model!.custID!);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      //delete menu
                      deleteMenu(widget.model!.custID!);
                    },
                  ),
                ],
              ),

              // Text(
              //   widget.model!.menuInfo!,
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 12,
              //   ),
              // ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
