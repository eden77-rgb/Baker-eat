import 'package:flutter/material.dart';
import 'package:app/services/DBService.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({super.key});

  @override
  State<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  late Future<List<dynamic>> _futurePanier;

  @override
  void initState() {
    super.initState();
    _futurePanier = DbService.getProduitsBoulangeries();
  }

  // Re-charge les données après une suppression
  void _reload() {
    setState(() => _futurePanier = DbService.getProduitsBoulangeries());
  }

  double _total(List<dynamic> list) => list.fold(
        0.0,
        (sum, p) => sum + (double.tryParse(p['prix_total'].toString()) ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            tooltip: 'Vider le panier',
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Vider le panier ?'),
                  content: const Text('Cette action supprimera tous les articles.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmer')),
                  ],
                ),
              );
              if (ok == true) {
                await DbService.viderPanier();   // <-- implémente cette méthode côté API
                _reload();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futurePanier,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erreur : ${snap.error}'));
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('Panier vide'));
          }

          final produits = snap.data!;
          final total = _total(produits);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: produits.length,
                  itemBuilder: (_, i) {
                    final p = produits[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      child: ListTile(
                        title: Text(p['produit'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Boulangerie : ${p['boulangerie']}'),
                            Text('Quantité : ${p['quantite']}'),
                            Text('Prix unitaire : ${p['prix']} €'),
                            Text('Total ligne : ${p['prix_total']} €'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DbService.supprimerArticlePanier(p['id']); // <-- implémente cette méthode
                            _reload();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${total.toStringAsFixed(2)} €',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
