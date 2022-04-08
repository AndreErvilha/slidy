import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:slidy/slidy.dart';
import 'package:slidy/src/core/prints/prints.dart';

import '../../templates/test.dart';
import '../../templates/use_case.dart';
import '../../utils/template_file.dart';
import '../../utils/utils.dart';
import '../command_base.dart';
import '../generate_command.dart';
import '../install_command.dart';

class GenerateUseCaseSubCommand extends CommandBase {
  @override
  final name = 'usecase';
  @override
  final description = 'Creates a Use Case file';

  GenerateUseCaseSubCommand() {
    argParser.addFlag('repository',
        abbr: 'r', negatable: false, help: 'Create repository file');
    argParser.addFlag('service',
        abbr: 's', negatable: false, help: 'Create service file');
    argParser.addFlag('notest',
        abbr: 'n', negatable: false, help: 'Don`t create file test');
  }

  @override
  FutureOr run() async {
    final pattern = argResults?.rest.single ?? '';

    final templateFile = TemplateFile(
        pattern: pattern, path: 'domain/usecases', type: 'usecase');

    if (!await checkDependencyIsExist('get_it')) {
      var command = CommandRunner('slidy', 'CLI')..addCommand(InstallCommand());
      await command.run(['install', 'get_it']);
    }

    var result = await Slidy.instance.template.createFile(
        info: TemplateInfo(
            yaml: use_case,
            destiny: templateFile.file,
            key: 'use_case',
            args: [templateFile.packageName]));
    execute(result);

    // compute notest parameter
    if (!argResults!['notest']) {
      if (!await checkDependencyIsExist('mocktail', true)) {
        var command = CommandRunner('slidy', 'CLI')
          ..addCommand(InstallCommand());
        await command.run(['install', 'mocktail', '--dev']);
      }

      result = await Slidy.instance.template.createFile(
          info: TemplateInfo(
              yaml: test,
              destiny: templateFile.testFile,
              key: 'test',
              args: [
            templateFile.fileName.pascalCase,
            templateFile.import,
            '',
            '',
            ''
          ]));
      execute(result);
    }

    // compute repository parameter
    if (argResults!['repository']) {
      var command = CommandRunner('slidy', 'CLI')
        ..addCommand(GenerateCommand());
      await command.run(['generate', 'repository', pattern, '--datasource']);
    }

    // compute service parameter
    if (argResults!['service']) {
      var command = CommandRunner('slidy', 'CLI')
        ..addCommand(GenerateCommand());
      await command.run(['generate', 'service', pattern, '--drive']);
    }
  }

  @override
  String? get invocationSuffix => null;
}

class GenerateUseCaseAbbrSubCommand extends GenerateUseCaseSubCommand {
  @override
  final name = 'u';
}
