import 'package:app/pages/BoulangeriePage.dart';
import 'package:app/pages/ProduitsPage.dart';
import 'package:app/widgets/NavBar.dart';
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
      appBar: NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(3)),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: Text(
                "Boulangeries",
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
                    buildCard("boulangeries", 1, BoulangeriePage(id: 1)),
                    buildCard("boulangeries", 2, BoulangeriePage(id: 2)),
                    buildCard("boulangeries", 3, BoulangeriePage(id: 3)),
                    buildCard("boulangeries", 4, BoulangeriePage(id: 4)),
                  ],
                ),
              ),
            ),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: Text(
                "Produits",
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
                    buildCard("produits", 1, ProduitsPage(id: 1)),
                    buildCard("produits", 2, ProduitsPage(id: 2)),
                    buildCard("produits", 3, ProduitsPage(id: 3)),
                    buildCard("produits", 4, ProduitsPage(id: 4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String table, int id, StatelessWidget page) {
    return FutureBuilder<List<String>>(
      future: Future.wait([DbService.getNom(table, id), DbService.getImg(table, id)]),
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
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => page,
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
