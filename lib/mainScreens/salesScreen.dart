import 'package:account/views/dashboard.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
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
        title: Text('Sales Screen'),
      ),
      drawer: MyDrawer(),
      body: Column(children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const SalesScreen()));
              },
              child: Container(
                child: DashBoard(
                  name: 'Sales',
                  type: 'Cash',
                  amount: '40000',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const SalesScreen()));
              },
              child: Container(
                child: DashBoard(
                  name: 'Sales',
                  type: 'Credit',
                  amount: '40000',
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
