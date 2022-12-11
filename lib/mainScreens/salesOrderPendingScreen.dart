import 'package:account/global/global.dart';
import 'package:account/mainScreens/salesOrder_editScreen.dart';
import 'package:account/uploadScreens/salesOrder_upload_screen.dart';
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

class SalesOrderPendingList extends StatefulWidget {
  const SalesOrderPendingList({Key? key}) : super(key: key);
  _SalesOrdersPendingListState createState() => _SalesOrdersPendingListState();
}

class _SalesOrdersPendingListState extends State<SalesOrderPendingList> {
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
        title: const Text('Sales Order Lists Pending'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => SalesOrderUploadScreen()));
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
                  //leading: const Icon(Icons.edit),
                  title: Text(item.headerText),
                );
              }),
              body: Container(
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => SalesOrderPendingEditScreen()));
                    }),
                  ),
                  title: Text(item.expandedText),
                  subtitle:
                      const Text("To Delete this, click on the Trash Icon"),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => SalesOrderPendingEditScreen()));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  /*trailing: Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        SalesOrderPendingEditScreen()));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        SalesOrderPendingEditScreen()));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),*/
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => SalesOrderPendingEditScreen()));
                  },
                ),
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
