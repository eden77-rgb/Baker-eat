import 'dart:convert';

import 'package:http/http.dart' as http;

class DbService {

  Future<String> getData() async {
    final reponse = await http.get(Uri.parse("https://api-nodejs-production-c1fe.up.railway.app/boulangerie"));
  
    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body).toString();
      return data;
    }

    else {
      throw Exception("Erreur lors de la requête");
    }
  }
}