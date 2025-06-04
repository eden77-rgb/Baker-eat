import 'package:app/pages/PanierPage.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: const Text("Baker'eat"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.shopping_cart), 
          onPressed: () {
            Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => PanierPage(),
                )
              );
          }),
      ],
      backgroundColor: Colors.green,
      leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
