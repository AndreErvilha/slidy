import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart' as args;
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/commands/capture.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/commands/generate.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/objects.dart';
import 'package:yaml/yaml.dart' as _yaml;

import '../core/commands/install.dart';
import '../core/commands/print.dart';
import '../core/domain/entities/command.dart';
import '../core/domain/entities/world.dart';
import '../core/utils.dart';

class Pipeline {
  final World world;

  final cliCommands = <String, args.Command>{};

  final yaml = <String, String>{};

  //final templates = <String, String>{};

  Pipeline() : world = World() {
    addCommand(Capture());
    addCommand(Generate());
    addCommand(Install());
    addCommand(Print());
    addCommand(Capture());
  }

  void addCommand(Command command) {
    world.addCommand(command);
  }

  void addCliCommand(args.Command command) {
    cliCommands.putIfAbsent(command.name, () => command);
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

  // void addTemplate(String? template_name, String value) {
  //   if (template_name == null) {
  //     final newValue = templates.entries.last.value + value;
  //     templates[templates.entries.last.key] = newValue;
  //   } else if (templates.containsKey(template_name)) {
  //     final newValue = templates[template_name]! + value;
  //     templates[template_name] = newValue;
  //   } else {
  //     templates[template_name] = value;
  //   }
  // }

  void loadYaml(File file) {
    addYaml(file.path.split('/').last, file.readAsStringSync());

    createCliCommands();
  }

  void loadMarkdown(File file) {
    final markdown = file.readAsStringSync();

    _detectYaml(markdown);
    _detectDart(markdown);

    createCliCommands();
  }

  void createCliCommands() {
    for (var yamlDoc in yaml.values) {
      final _yaml.YamlMap result = _yaml.loadYaml(yamlDoc);

      final steps = Utils.parseValues(result);

      if (steps is ObjectValue) {
        addCliCommand(
          CliCommands(
            world,
            steps,
          ),
        );
      }
    }
  }

  void _detectYaml(String markdown) {
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

  void _detectDart(String markdown) {
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

      //addTemplate(scriptName, dart!);
      world.addObject(ObjectValue(scriptName!, TextValue(dart!)));
    }
  }
}

class CliCommands extends args.Command {
  final World _world;
  final ObjectValue _declaration;
  late ListValue _execute;
  late ListValue _args;

  // command declaration variables
  late String _pipeName;
  late String _name;
  late String _description;
  late String _abbr;

  CliCommands(
    this._world,
    this._declaration,
  ) {
    _args = _declaration.getValue<ListValue>('args');
    _execute = _declaration.getValue<ListValue>('execute');

    // command declaration variables
    _pipeName = _declaration.name;
    _name = _declaration.getValue<TextValue>('name').value;
    _description = _declaration.getValue<TextValue>('description').value;
    _abbr = _declaration.getValue<TextValue>('abbr').value;

    // Parse flags
    for (var arg in _args.value) {
      arg as ObjectValue;
      final help = arg.getValue<TextValue>('help');
      final abbr = arg.getValue<TextValue>('abbr');
      final negatable = arg.getValue<BoolValue>('negatable');

      argParser.addFlag(
        arg.name,
        help: help.value,
        abbr: abbr.value,
        negatable: negatable.value,
      );
    }
  }

  @override
  FutureOr run() async {
    final rest = argResults?.rest.single ?? '';

    _world.addObject(ObjectValue('rest', TextValue(rest)));

    for (var command in _execute.value) {
      command as ObjectValue;

      if (_world.commands.containsKey(command.name)) {
        await _world.commands[command.name]?.call(_world, command);
      } else if (!_world.objects.containsKey(command.name)) {
        _world.addObject(command);
        //success('pipeline => Add var ${command.name}');
      }
    }
  }

  @override
  String get description => _description;

  @override
  String get name => _name;
}
