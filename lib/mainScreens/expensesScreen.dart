// ignore_for_file: prefer_const_constructors

import 'package:account/global/global.dart';
import 'package:account/mainScreens/expenseEditScreen.dart';
import 'package:account/model/expenses.dart';
import 'package:account/uploadScreens/expense_upload_screen.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:account/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  bool isExpand = false;
  String name = "";
  CollectionReference ref = FirebaseFirestore.instance
      .collection("shops")
      .doc(sharedPreferences!.getString("uid"))
      .collection("expenses");
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: Text("Expenses Screen"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => ExpenseUploadScreen()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Colors.amber,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: ("Search Expenses"),
              ),
              onChanged: ((value) {
                setState(() {
                  name = value;
                });

                debugPrint("name : $name");
              }),
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? circularProgress()
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    Expenses model = Expenses.fromJson(
                        snapshots.data!.docs[index].data()!
                            as Map<String, dynamic>);
                    return model.expenseInfo.toString().contains(name)
                        ? SingleChildScrollView(
                            child: Card(
                              elevation: 5,
                              child: ExpansionTile(
                                leading: Image.network(
                                  model.thumbnailUrl.toString(),
                                  //width: 80.0,
                                ),
                                title: Text(model.expenseInfo.toString()),
                                children: [
                                  ListTile(
                                    leading: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: (() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    ExpenseEditScreen(
                                                      model: model,
                                                      context: context,
                                                    )));
                                      }),
                                    ),
                                    title: Text(model.cashOutAmount.toString()),
                                    trailing: Text(model.expenseID.toString()),
                                  ),
                                  ListTile(
                                    leading: Text(
                                        "₹" + model.cashOutAmount.toString()),
                                    title: Text("Stock" +
                                        model.onlineOutAmount.toString()),
                                    trailing: Text(
                                        "♢" + model.expenseType.toString()),
                                  ),
                                ],
                                onExpansionChanged: (isExpanded) {
                                  //print("Expanded: ${isExpanded}");
                                },
                              ),
                            ),
                          )
                        : Center(child: Text("Testing"));
                  },
                );
        },
      ),
    );
  }
}
