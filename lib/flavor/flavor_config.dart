import 'dart:ui';

enum Flavor {
  akaso,
  fumiya,
}

class FlavorValues {
  final String? bundleID;
  final String? appID;
  final String? baseUrl;
  final Color? color;
  FlavorValues({this.bundleID, this.appID, this.baseUrl, this.color});
}

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String name;
  final FlavorValues? values;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      required String name,
      required String env,
      required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(flavor, name, env, values);
    return _instance!;
  }
  FlavorConfig._internal(this.flavor, this.name, this.env, this.values);
  static FlavorConfig? get instance => _instance;
  static bool isAkaso() => _instance!.flavor == Flavor.akaso;
  static bool isFumiya() => _instance!.flavor == Flavor.fumiya;
}
