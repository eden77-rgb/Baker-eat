import 'dart:convert';

import 'package:http/http.dart' as http;

class DbService {

  Future<List<dynamic>> getData(id) async {
    final reponse = await http.get(Uri.parse("https://api-nodejs-production-c1fe.up.railway.app/boulangerie/getDataId?id=${id.toString()}"));
  
    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return data;
    }

    else {
      throw Exception("Erreur lors de la requête");
    }
  }

  Future<String> getNom(int id) async {
    final List<dynamic> jsonData = await getData(id);

    return jsonData[0]["nom"];
  }
}