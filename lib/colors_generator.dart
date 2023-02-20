import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder colorEnumGeneratorBuilder(BuilderOptions options) =>
    ColorEnumGenerator();

class ColorEnumGenerator implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final config = await buildStep.readAsString(inputId);
    final yaml = loadYaml(config);
    final values = yaml['enumValues'] as List<dynamic>;
    final buffer = StringBuffer();
    buffer.writeln('enum Color {');
    for (final value in values) {
      final name = value['name'] as String;
      final valueHex = value['value'] as int;
      final valueString = valueHex.toRadixString(16).toUpperCase().padLeft(6, '0');
      buffer.writeln('  $name, // 0x$valueString');
    }
    buffer.writeln('}');
    final outputId =
    inputId.changeExtension('.g.dart', '.color_enum.dart');
    await buildStep.writeAsString(outputId, buffer.toString());
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
    '.yaml': ['.color_enum.dart']
  };
}