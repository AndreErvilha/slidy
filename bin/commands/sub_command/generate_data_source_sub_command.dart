import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:slidy/slidy.dart';
import 'package:slidy/src/core/prints/prints.dart';

import '../../templates/data_source.dart';
import '../../templates/test.dart';
import '../../utils/template_file.dart';
import '../../utils/utils.dart';
import '../command_base.dart';
import '../install_command.dart';

class GenerateDataSourceSubCommand extends CommandBase {
  @override
  final name = 'datasource';
  @override
  final description = 'Creates a Data Source file';

  GenerateDataSourceSubCommand() {
    argParser.addFlag('notest',
        abbr: 'n', negatable: false, help: 'Don`t create file test');
  }

  @override
  FutureOr run() async {
    final pattern = argResults?.rest.single ?? '';

    final templateFile = TemplateFile(
        pattern: pattern, path: 'external/datasources', type: 'datasource');

    if (!await checkDependencyIsExist('dio')) {
      var command = CommandRunner('slidy', 'CLI')..addCommand(InstallCommand());
      await command.run(['install', 'dio@4.0.0-beta6']);
    }

    var result = await Slidy.instance.template.createFile(
      info: TemplateInfo(
        yaml: data_source,
        destiny: templateFile.interfaceFileFrom('infra/datasources'),
        key: 'i_data_source',
        args: [templateFile.fileName.pascalCase],
      ),
    );
    execute(result);

    result = await Slidy.instance.template.createFile(
      info: TemplateInfo(
        yaml: data_source,
        destiny: templateFile.file,
        key: 'data_source',
        args: [
          templateFile.fileName.pascalCase,
          templateFile.interfaceImportFrom('infra/datasources'),
        ],
      ),
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
            templateFile.interfaceImportFrom('infra/datasources'),
            'class Mock${templateFile.fileName.pascalCase} extends Mock implements I${templateFile.fileName.pascalCase} {}',
            'GetIt.I.registerSingleton<I${templateFile.fileName.pascalCase}>(Mock${templateFile.fileName.pascalCase}());'
          ],
        ),
      );

      execute(result);
    }
  }

  @override
  String? get invocationSuffix => null;
}

class GenerateDataSourceAbbrSubCommand extends GenerateDataSourceSubCommand {
  @override
  final name = 'd';
}
