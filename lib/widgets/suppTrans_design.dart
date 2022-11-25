import 'package:account/mainScreens/custTran_detail_screen.dart';
import 'package:account/mainScreens/suppTran_details_screen.dart';
import 'package:account/model/custTrans.dart';
import 'package:account/model/supTrans.dart';
import 'package:flutter/material.dart';
import 'package:account/mainScreens/item_detail_screen.dart';
import 'package:account/mainScreens/itemsScreen.dart';
import 'package:account/model/items.dart';
import 'package:account/model/menus.dart';

class SuppTransDesignWidget extends StatefulWidget {
  SupTrans? model;
  BuildContext? context;

  SuppTransDesignWidget({this.model, this.context});

  @override
  _SuppTransDesignWidgetState createState() => _SuppTransDesignWidgetState();
}

class _SuppTransDesignWidgetState extends State<SuppTransDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => SuppTransDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
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
    );
  }
}
