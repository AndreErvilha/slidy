import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:slidy/slidy.dart';
import 'package:slidy/src/core/prints/prints.dart';

import '../../templates/repository.dart';
import '../../templates/test.dart';
import '../../utils/template_file.dart';
import '../../utils/utils.dart';
import '../command_base.dart';
import '../generate_command.dart';
import '../install_command.dart';

class GenerateRepositorySubCommand extends CommandBase {
  @override
  final name = 'repository';
  @override
  final description = 'Creates a Repository';

  GenerateRepositorySubCommand() {
    argParser.addFlag('datasource',
        abbr: 'd', negatable: false, help: 'Create datasource file');
    argParser.addFlag('notest',
        abbr: 'n', negatable: false, help: 'Don`t create file test');
  }

  @override
  FutureOr run() async {
    final pattern = argResults?.rest.single ?? '';

    final templateFile = TemplateFile(
        pattern: pattern, path: 'infra/repositories', type: 'repository');

    var result = await Slidy.instance.template.createFile(
        info: TemplateInfo(
            yaml: repositoryFile,
            destiny: templateFile.interfaceFileFrom('domain/repositories'),
            key: 'i_repository',
            args: [
          templateFile.fileName.pascalCase,
        ]));
    execute(result);

    result = await Slidy.instance.template.createFile(
      info: TemplateInfo(
          yaml: repositoryFile,
          destiny: templateFile.file,
          key: 'repository',
          args: [
            templateFile.fileName.pascalCase,
            templateFile.interfaceImportFrom('domain/repositories'),
          ]),
    );
    execute(result);

    if (!argResults!['notest']) {
      if (!await checkDependencyIsExist('get_it')) {
        var command = CommandRunner('slidy', 'CLI')
          ..addCommand(InstallCommand());
        await command.run(['install', 'get_it']);
      }
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
            templateFile.interfaceImportFrom('domain/repositories'),
            'class Mock${templateFile.fileName.pascalCase} extends Mock implements I${templateFile.fileName.pascalCase} {}',
            'GetIt.I.registerSingleton<I${templateFile.fileName.pascalCase}>(Mock${templateFile.fileName.pascalCase}());'
          ]));
      execute(result);
    }

    if (argResults!['datasource']) {
      var command = CommandRunner('slidy', 'CLI')
        ..addCommand(GenerateCommand());
      await command.run(['generate', 'datasource', pattern]);
    }
  }

  @override
  String? get invocationSuffix => null;
}

class GenerateRepositoryAbbrSubCommand extends GenerateRepositorySubCommand {
  @override
  final name = 'r';
}
