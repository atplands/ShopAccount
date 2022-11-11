import 'package:account/views/bubble_stories.dart';
import 'package:account/views/dashboard.dart';
import 'package:account/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final List suppliers = [
    "Suppier_name_1",
    "Suppier_name_2",
    "Suppier_name_3",
    "Suppier_name_4",
    "Suppier_name_5",
  ];
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
          Container(
            child: Text(
              'Suppliers Recent Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            height: 130,
            /*child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BubbleStories(text: 'Telugu'),
                  BubbleStories(text: 'English'),
                  BubbleStories(text: 'Hindi'),
                  BubbleStories(text: 'Kanada'),
                  BubbleStories(text: 'Rajasthani'),
                ],
              ),*/
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                return BubbleStories(
                  text: suppliers[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
