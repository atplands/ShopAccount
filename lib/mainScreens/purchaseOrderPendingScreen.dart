import 'package:account/global/global.dart';
import 'package:account/mainScreens/po_pendingEditScreen.dart';
import 'package:account/uploadScreens/customers_upload_screen.dart';
import 'package:account/uploadScreens/purchaseOrder_upload_screen.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class Item {
  Item({
    required this.expandedText,
    required this.headerText,
    this.isExpanded = false,
  });

  String headerText;
  String expandedText;
  bool isExpanded;
}

class PurchaseOrdersPending extends StatefulWidget {
  const PurchaseOrdersPending({Key? key}) : super(key: key);
  _PurchaseOrdersPendingListState createState() =>
      _PurchaseOrdersPendingListState();
}

class _PurchaseOrdersPendingListState extends State<PurchaseOrdersPending> {
  final List<Item> _data = List<Item>.generate(
    10,
    (index) {
      return Item(
        expandedText: 'Item ${index}',
        headerText: 'This is Item Number ${index}',
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Orders Pending'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => PurchaseOrderListUploadScreen()));
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: ((int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          }),
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: ((BuildContext context, bool isExpanded) {
                return ListTile(
                  leading: FadeInImage.assetNetwork(
                      placeholder: '',
                      image: sharedPreferences!.getString("photoUrl")!),
                  /*leading: Icon(
                    Icons.edit,
                    color: Colors.greenAccent,
                  ),*/
                  title: Text(item.headerText),
                );
              }),
              body: ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => PoPendingEditScreen()));
                  },
                  icon: Icon(Icons.edit),
                ),
                title: Text(item.expandedText),
                subtitle: Text("To Delete this, click on the Trash Icon"),
                trailing: IconButton(
                  onPressed: () {
                    print("Delete clicked button");
                  },
                  icon: const Icon(Icons.delete),
                ),
                /*onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => PoPendingEditScreen()));
                },*/
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
