import 'package:flutter/material.dart';
import 'package:app/services/DBService.dart';

class PanierPage extends StatelessWidget {
  const PanierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: DbService.getProduitsBoulangeires(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Panier vide"));
          } else {
            final produits = snapshot.data!;

            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final produit = produits[index];
                final nomProduit = produit["produit"];
                final nomBoulangerie = produit["boulangerie"];
                final quantite = produit["quantite"];
                final prix = produit["prix"];
                final prixTotal = produit["prix_total"];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      nomProduit,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Boulangerie : $nomBoulangerie"),
                        Text("Quantité : $quantite"),
                        Text("Prix unitaire : $prix €"),
                        Text("Total : $prixTotal €"),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
