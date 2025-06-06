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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(3)),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: const Text(
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
                  children: buildCardList("boulangeries", 20),
                ),
              ),
            ),

            Container(
              width: 350,
              alignment: Alignment.centerLeft,
              child: const Text(
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
                  children: buildCardList("produits", 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Génère une liste de widgets `buildCard` à partir d'un index
  List<Widget> buildCardList(String table, int count) {
    return List.generate(count, (index) {
      final id = index + 1;
      final page = (table == "boulangeries")
          ? BoulangeriePage(id: id)
          : ProduitsPage(id: id);
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: buildCard(table, id, page),
      );
    });
  }

  /// Crée une carte avec image + nom depuis la base
  Widget buildCard(String table, int id, StatelessWidget page) {
    return FutureBuilder<List<String>>(
      future: Future.wait([
        DbService.getNom(table, id),
        DbService.getImg(table, id)
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 250,
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: 250,
            height: 180,
            child: Center(child: Text("Erreur: ${snapshot.error}")),
          );
        } else {
          final nom = snapshot.data![0];
          final image = snapshot.data![1];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            child: Card(
              elevation: 10,
              color: Colors.grey[300],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
                  Container(
                    width: 225,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      nom,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(1)),
                  Image.network(image, width: 250, height: 130),
                  const Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
