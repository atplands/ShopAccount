import 'package:account/mainScreens/itemsScreen.dart';
import 'package:account/mainScreens/purchase_transScreen.dart';
import 'package:account/mainScreens/suppTran_details_screen.dart';
import 'package:account/model/supTrans.dart';
import 'package:account/views/bubble_stories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:account/global/global.dart';
//import 'package:foodpanda_sellers_app/mainScreens/itemsScreen.dart';
import 'package:account/model/menus.dart';
import 'package:flutter/rendering.dart';

//import 'purchase_transScreen.dart';

class PurInfoDesignWidget extends StatefulWidget {
  SupTrans? model;
  BuildContext? context;

  PurInfoDesignWidget({this.model, this.context});

  @override
  _PurInfoDesignWidgetState createState() => _PurInfoDesignWidgetState();
}

class _PurInfoDesignWidgetState extends State<PurInfoDesignWidget> {
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
                builder: (c) => SuppTransDetailsScreen(
                      model: widget.model,
                    )));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 3.0,
                ),
                Divider(
                  height: 4,
                  thickness: 3,
                  color: Colors.grey[300],
                ),
                Container(
                  child: Image.network(
                    widget.model!.thumbnailUrl!,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                ),

                Container(
                  width: 240.0,
                  child: Text(
                    widget.model!.transInfo!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
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
                  width: 80.0,
                  child: Text(
                    widget.model!.transAmount!.toString(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
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
