import 'package:account/mainScreens/custTran_detail_screen.dart';
import 'package:account/mainScreens/itemsScreen.dart';
import 'package:account/model/custTrans.dart';
import 'package:account/model/supTrans.dart';
import 'package:account/views/bubble_stories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
//import 'package:foodpanda_sellers_app/mainScreens/itemsScreen.dart';
import 'package:account/model/menus.dart';

//import 'purchase_transScreen.dart';

class SaleInfoDesignWidget extends StatefulWidget {
  CustTrans? model;
  BuildContext? context;

  SaleInfoDesignWidget({this.model, this.context});

  @override
  _SaleInfoDesignWidgetState createState() => _SaleInfoDesignWidgetState();
}

class _SaleInfoDesignWidgetState extends State<SaleInfoDesignWidget> {
  deleteMenu(String menuID) {
    FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .delete();

    //Fluttertoast.showToast(msg: "Menu Deleted Successfully.");
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
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 40.0,
                width: 40.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10.0,
              ),

              Container(
                //width: 220.0,
                child: Text(
                  widget.model!.transName!,
                  style: const TextStyle(
                    color: Colors.cyan,
                    //fontSize: 20,
                    fontFamily: "Train",
                  ),
                ),
              ),
              /*IconButton(
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.pinkAccent,
                ),
                onPressed: () {
                  //delete menu
                  deleteMenu(widget.model!.menuID!);
                },
              ),*/
              Container(
                child: Text(
                  widget.model!.transAmount!.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Train",
                  ),
                ),
              ),
              Container(
                child: Text(
                  widget.model!.transDueDate!.toString(),
                  //widget.model!.transDate!  DateTime.now(),

                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Train",
                  ),
                ),
              ),
              Container(
                child: Text(
                  widget.model!.transAmount!.toString(),
                  //widget.model!.transDate!  DateTime.now(),

                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Train",
                  ),
                ),
              ),

              // Text(
              //   widget.model!.menuInfo!,
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 12,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
