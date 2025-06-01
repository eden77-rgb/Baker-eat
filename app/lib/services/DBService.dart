import 'dart:convert';

import 'package:http/http.dart' as http;

class DbService {

  static Future<List<dynamic>> getData(String table, int id) async {
    final reponse = await http.get(Uri.parse("https://api-nodejs-production-c1fe.up.railway.app/${table.toString()}/getDataId?id=${id.toString()}"));
  
    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return data;
    }

    else {
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

  static Future<String> getPrix(String table, int id) async {
    final List<dynamic> jsonData = await getData(table, id);

    return jsonData[0]["prix"];
  }
}