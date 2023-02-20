import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

part 'colors.g.dart';

class Color {
  static List<ColorEnum> _values = [];

  static List<ColorEnum> get values => List.unmodifiable(_values);

  static Future<void> loadColors() async {
    final config = await rootBundle.loadString('config.yaml');
    final yaml = loadYaml(config);
    final values = yaml['enumValues'] as List<dynamic>;
    _values = values
        .map((v) =>
        ColorEnum.values.firstWhere((e) => e.name == v['name'] as String))
        .toList();
  }
}