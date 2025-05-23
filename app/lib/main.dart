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
            IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
          ],
          backgroundColor: Colors.green,
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(3)),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: Text(
                "Catégorie",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Card(
                      elevation: 10,
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5)),
                            Container(
                              width: 225,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "M ton pain",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(1)),
                            Image.asset("lib/img.jpg", width: 250, height: 130),
                            Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      elevation: 10,
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5)),
                            Container(
                              width: 225,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "M ton pain",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(1)),
                            Image.asset("lib/img.jpg", width: 250, height: 130),
                            Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      elevation: 10,
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5)),
                            Container(
                              width: 225,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "M ton pain",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(1)),
                            Image.asset("lib/img.jpg", width: 250, height: 130),
                            Padding(padding: EdgeInsets.all(5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
