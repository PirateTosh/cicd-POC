import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        color: Colors.greenAccent,
        child: const Text(
          "Orders",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      )),
    );
  }
}
