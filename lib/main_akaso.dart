import 'package:flutter/material.dart';
import 'package:poc/flavor/flavor_config.dart';

import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.akaso,
    env: "Akaso",
    name: "Akaso",
    values: FlavorValues(
      bundleID: 'com.example.akaso',
      appID: 'com.example.akaso',
      baseUrl: '',
      color: Colors.amber,
    ),
  );
  mainCommon();
}
