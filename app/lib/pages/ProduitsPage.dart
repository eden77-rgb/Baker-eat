import 'package:app/services/DBService.dart';
import 'package:app/widgets/NavBar.dart';
import 'package:flutter/material.dart';

class ProduitsPage extends StatelessWidget {
  final int id;

  ProduitsPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        DbService.getNom("produits", id),
        DbService.getImg("produits", id),
        DbService.getCategorie("produits", id),
        DbService.getDescription("produits", id),

        DbService.getDataPrix(id),
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
          final categorie = snapshot.data![2];
          final description = snapshot.data![3];

          final produits = snapshot.data![4];

          return Scaffold(
            appBar: NavBar(),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5)),

                  Center(
                    child: Text(
                      nom,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(5)),

                  Center(child: Image.network(image, width: 350)),

                  Text("Categorie : ${categorie}"),

                  Padding(padding: EdgeInsets.all(2)),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Description :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Text(
                          description,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(10)),

                  Center(
                    child: Text(
                      "Disponibilité :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: produits.length,
                    itemBuilder: (context, index) {
                      final produit = produits[index];
                      final boulangerie = produit["boulangerie"];
                      final prix = produit["prix"];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Divider(thickness: 2, color: Colors.black),
                            Text("$boulangerie - $prix€"),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  final produits = snapshot.data![4];

                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: produits.length,
                        itemBuilder: (context, index) {
                          final produit = produits[index];
                          final nomBoulangerie = produit["boulangerie"];
                          final prix = produit["prix"];
                          final boulangeriesProduisId = produit["id"];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.grey[100],
                              elevation: 3,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                title: Text(
                                  nomBoulangerie,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "$prix €",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[700],
                                  ),
                                ),
                                onTap: () {
                                  print("$boulangeriesProduisId -> $nomBoulangerie - $prix €");
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "$nom ajouté au panier chez $nomBoulangerie",
                                      ),
                                    ),
                                  );
                                },
                                trailing: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 10),
                ),
                child: Text(
                  "Ajouter au panier",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
