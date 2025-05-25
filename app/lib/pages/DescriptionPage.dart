import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  final int id;

  DescriptionPage({
      required this.id
    }
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baker'eat"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
        backgroundColor: Colors.green,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      ),
      body: Center(child: Text("Page : $id"),),
    );
  }
}