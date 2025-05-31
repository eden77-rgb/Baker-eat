import 'package:app/services/DBService.dart';
import 'package:app/widgets/NavBar.dart';
import 'package:flutter/material.dart';

class BoulangeriePage extends StatelessWidget {
  final int id;

  BoulangeriePage({required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<String>>(
      future: Future.wait([
        DbService.getNom("boulangeries", id),
        DbService.getImg("boulangeries", id),
        DbService.getAdresse("boulangeries", id),
        DbService.getDescription("boulangeries", id),
      ]),
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
          final adresse = snapshot.data![2];
          final description = snapshot.data![3];

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

                  Center(
                    child: Image.network(
                      image,
                      width: 350,
                    ),
                  ),

                  Text(adresse),

                  Padding(padding: EdgeInsets.all(2)),

                  Text(
                    "Description : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  Container(
                    width: 350,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
