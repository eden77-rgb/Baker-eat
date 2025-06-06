import 'dart:convert';

import 'package:http/http.dart' as http;

class DbService {
  static Future<List<dynamic>> getData(String table, int id) async {
    final reponse = await http.get(
      Uri.parse(
        "https://api-nodejs-production-c1fe.up.railway.app/${table.toString()}/getDataId?id=${id.toString()}",
      ),
    );

    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return data;
    } else {
      throw Exception("Erreur lors de la requête");
    }
  }

  static Future<String> getNom(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["nom"];
  }

  static Future<String> getImg(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["image"];
  }

  static Future<String> getAdresse(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["adresse"];
  }

  static Future<String> getDescription(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["description"];
  }

  static Future<String> getCategorie(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["categorie"];
  }

  static Future<List<dynamic>> getDataPrix(int id) async {
    final reponse = await http.get(
      Uri.parse(
        "https://api-nodejs-production-c1fe.up.railway.app/boulangeries_produits/getPrix?id=${id.toString()}",
      ),
    );

    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return data;
    } else {
      throw Exception("Erreur lors de la requête");
    }
  }

  static Future<List<dynamic>> getProduitsBoulangeries() async {
    final reponse = await http.get(
      Uri.parse(
        "https://api-nodejs-production-c1fe.up.railway.app/paniers_produits/getProduit",
      ),
    );

    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return data;
    } else {
      throw Exception("Erreur lors de la requête");
    }
  }

  static Future<String> getTaille(int id) async {
    final List<dynamic> jsonData = await getDataPrix(id);

    return jsonData.length.toString();
  }

  static Future<String> getBoulangerie(int index, int id) async {
    final List<dynamic> jsonData = await getDataPrix(id);

    return jsonData[index]["boulangerie"];
  }

  static Future<String> getProduit(int index, int id) async {
    final List<dynamic> jsonData = await getDataPrix(id);

    return jsonData[index]["produit"];
  }

  static Future<String> getPrix(int index, int id) async {
    final List<dynamic> jsonData = await getDataPrix(id);

    return jsonData[index]["prix"];
  }

  static Future<String> getDisponible(int index, int id) async {
    final List<dynamic> jsonData = await getDataPrix(id);

    return jsonData[index]["disponible"].toString();
  }

  static Future<void> ajouterAuPanier(int panierId, int boulangerieProduitId, int quantite,) async {
    final response = await http.post(
      Uri.parse("https://api-nodejs-production-c1fe.up.railway.app/paniers_produits/ajouter"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "panier_id": panierId,
        "boulangerie_produit_id": boulangerieProduitId,
        "quantite": quantite,
      }),
    );

    if (response.statusCode == 201) {
      print("✅ Produit ajouté au panier");
    } else {
      print("❌ Erreur: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<void> viderPanier() async {}

  static Future<void> supprimerArticlePanier(int id) async {}
}
