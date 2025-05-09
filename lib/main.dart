import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Baker'eat"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            )
          ],
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}