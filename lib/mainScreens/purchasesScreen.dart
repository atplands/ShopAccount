import 'package:account/views/dashboard.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({Key? key}) : super(key: key);
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
        actions: [],
        title: Text('Purchases Screen'),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const PurchasesScreen()));
                },
                child: DashBoard(
                  name: 'purchase',
                  type: 'Cash',
                  amount: '40000',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const PurchasesScreen()));
                },
                child: DashBoard(
                  name: 'purchase',
                  type: 'Credit',
                  amount: '40000',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
