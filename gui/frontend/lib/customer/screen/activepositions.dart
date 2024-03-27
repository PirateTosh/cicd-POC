import 'package:flutter/material.dart';

class ActivePositions extends StatelessWidget {
  const ActivePositions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        color: Colors.greenAccent,
        child: const Text(
          "Subscriptions",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      )),
    );
  }
}
