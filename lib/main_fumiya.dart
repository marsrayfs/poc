import 'package:flutter/material.dart';
import 'package:poc/flavor/flavor_config.dart';
import 'package:poc/main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.fumiya,
    env: "Fumiya",
    name: "Fumiya",
    values: FlavorValues(
      bundleID: 'com.example.fumiya',
      appID: 'com.example.fumiya',
      baseUrl: '',
      color: Colors.blue,
    ),
  );
  mainCommon();
}
