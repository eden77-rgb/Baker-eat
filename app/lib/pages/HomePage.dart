import 'package:app/pages/DescriptionPage.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(3)),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: Text(
                "Boulangerie",
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
                    buildCard(1),
                    buildCard(2),
                    buildCard(3),
                    buildCard(4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(int id) {
    return FutureBuilder<List<String>>(
      future: Future.wait([DbService.getNom(id), DbService.getImg(id)]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 250,
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        } 
        
        else if (snapshot.hasError) {
          return SizedBox(
            width: 250,
            height: 180,
            child: Center(child: Text("Erreur: ${snapshot.error}")),
          );
        } 
        
        else {
          final nom = snapshot.data![0];
          final image = snapshot.data![1];

          return InkWell(
            onTap: () {
              print("Card $id cliqué");
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => DescriptionPage(id: id),
                )
              );
            },
            child: Card(
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.all(1)),

                    Image.network(image, width: 250, height: 130),

                    Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
