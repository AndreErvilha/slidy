import 'dart:io';

class Markdown {
  final yaml = <String, String>{};

  final templates = <String, String>{};

  void loadMarkdown(File file) {
    final markdown = file.readAsStringSync();

    detectYaml(markdown);
    detectDart(markdown);
  }

  void addYaml(String? script_name, String value) {
    if (script_name == null) {
      final newValue = yaml.entries.last.value + value;
      yaml[yaml.entries.last.key] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else if (yaml.containsKey(script_name)) {
      final newValue = yaml[script_name]! + value;
      yaml[script_name] =
          newValue.split('\n').where((e) => e.isNotEmpty).join('\n');
    } else {
      yaml[script_name] =
          value.split('\n').where((e) => e.isNotEmpty).join('\n');
    }
  }

  void addTemplate(String? template_name, String value) {
    if (template_name == null) {
      final newValue = templates.entries.last.value + value;
      templates[templates.entries.last.key] = newValue;
    } else if (templates.containsKey(template_name)) {
      final newValue = templates[template_name]! + value;
      templates[template_name] = newValue;
    } else {
      templates[template_name] = value;
    }
  }

  void detectYaml(String markdown) {
    final regex = r''
        // capture name of script
        r'(?:\*\*`(?<script_name>(?!\*\*`)[\S]*(?<!`\*\*))`\*\**)?[\s]?'
        // capture yaml
        r'```yaml(?<yaml>(?!```)[\s\S][^`]*(?<!```))```';
    final pattern = RegExp(regex);

    final values = pattern.allMatches(markdown);

    if (values.isEmpty) {
      throw Exception('capture has no match with gave pattern => $regex');
    }

    for (var match in values) {
      final scriptName = match.namedGroup('script_name');
      final yaml = match.namedGroup('yaml');

      addYaml(scriptName, yaml!);
    }
  }

  void detectDart(String markdown) {
    final regex = r''
        // capture name of script
        r'(?:\*\*`(?<template_name>(?!\*\*`)[\S]*(?<!`\*\*))`\*\**)?[\s]?'
        // capture yaml
        r'```dart(?<dart>(?!```)[\s\S][^`]*(?<!```))```';
    final pattern = RegExp(regex);

    final values = pattern.allMatches(markdown);

    if (values.isEmpty) {
      throw Exception('capture has no match with gave pattern => $regex');
    }

    for (var match in values) {
      final scriptName = match.namedGroup('template_name');
      final dart = match.namedGroup('dart');

      addTemplate(scriptName, dart!);
    }
  }
}
