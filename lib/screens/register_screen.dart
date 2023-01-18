import 'package:flutter/material.dart';
import 'package:poc/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final String color;

  const RegisterScreen({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package and Target POC"),
        backgroundColor: getColor(color),
      ),
      body: const RegisterForm(),
    );
  }

  Color getColor(String color) {
    switch (color) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
    }
    return Colors.black;
  }
}
