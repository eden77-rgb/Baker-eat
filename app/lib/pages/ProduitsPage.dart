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

        DbService.getDataPrix(id)
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

                  Text(
                    "Description : ${description}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                          Divider(
                            thickness: 2, 
                            color: Colors.black
                          ),
                          Text("$boulangerie - $prix"),
                          ],
                        ),
                      );
                    },

                  )
                ],
              ),
            ),
            
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$nom ajouté au panier")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 10)
                ),
                child: Text(
                  "Ajouter au panier",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
