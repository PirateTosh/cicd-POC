import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        color: Colors.orangeAccent,
        child: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      )),
    );
  }
}
