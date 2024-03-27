import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        color: Colors.blueAccent,
        child: const Text(
          "Search",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      )),
    );
  }
}
