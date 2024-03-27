import 'package:flutter/material.dart';

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        color: Colors.redAccent,
        child: const Text(
          "Discover",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      )),
    );
  }
}
