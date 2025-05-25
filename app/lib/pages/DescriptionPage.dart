import 'package:app/widgets/AppBar.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  final int id;

  DescriptionPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: NavBar(),
      body: Center(child: Text("Page : $id")),
    );
  }
}
