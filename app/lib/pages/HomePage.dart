import 'package:app/services/DBService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> nom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nom = DbService().getNom(1);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<String>(
        future: nom,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } 
          
          else {
            final data = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(3)),

                  Container(
                    width: 350,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Catégorie",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                          buildCard(data),
                          buildCard(data),
                          buildCard(data),
                          buildCard(data),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildCard(String nom) {
    return Card(
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
                nom,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(padding: EdgeInsets.all(1)),

            Image.asset("lib/img.jpg", width: 250, height: 130),

            Padding(padding: EdgeInsets.all(5)),
          ],
        ),
      ),
    );
  }
}
