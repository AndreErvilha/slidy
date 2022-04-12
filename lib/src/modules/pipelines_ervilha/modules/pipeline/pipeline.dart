import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart' as args;
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/objects.dart';
import 'package:yaml/yaml.dart';

import '../../../../../slidy.dart';
import '../core/domain/entities/command.dart';
import '../core/domain/entities/world.dart';
import '../core/utils.dart';

class Pipeline {
  final World world;

  final cliCommands = <String, args.Command>{};

  Pipeline() : world = World();

  void addCommand(Command command) => world.addCommand(command);

  void addCliCommand(args.Command command) {
    cliCommands.putIfAbsent(command.name, () => command);
  }

  Future<void> loadPipe(File file) async {
    final YamlMap result = loadYaml(file.readAsStringSync());

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
        success('pipeline => Add var ${command.name}');
      }
    }
  }

  @override
  String get description => _description;

  @override
  String get name => _name;
}
