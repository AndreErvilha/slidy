import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/pipeline/pipeline.dart';
import 'package:slidy/src/version.dart';

import 'commands/generate_command.dart';
import 'commands/install_command.dart';
import 'commands/run_command.dart';
import 'commands/start_command.dart';
import 'commands/uninstall_command.dart';

Future main(List<String> arguments) async {
  final runner = configureCommand(arguments);

  final file = File('pipe.md');

  if (await file.exists()) {
    final pipe = Pipeline()..loadMarkdown(file);

    for (var command in pipe.cliCommands.values) {
      runner.addCommand(command);
    }
  }

  var hasCommand = runner.commands.keys.any((x) => arguments.contains(x));

  if (hasCommand) {
    try {
      await executeCommand(runner, arguments);
      exit(ExitCode.success.code);
    } on UsageException catch (error) {
      print(error);
      exit(ExitCode.ioError.code);
    }
  } else {
    var parser = ArgParser();
    parser = runner.argParser;
    var results = parser.parse(arguments);
    executeOptions(results, arguments, runner);
  }
}

void executeOptions(
    ArgResults results, List<String> arguments, CommandRunner runner) {
  if (results.wasParsed('help') || arguments.isEmpty) {
    print(runner.usage);
  } else if (results.wasParsed('version')) {
    version(packageVersion);
  } else {
    print('Command not found!\n');
    print(runner.usage);
  }
}

Future executeCommand(CommandRunner runner, List<String> arguments) {
  return runner.run(arguments);
}

CommandRunner configureCommand(List<String> arguments) {
  var runner =
      CommandRunner('slidy', 'CLI package manager and template for Flutter.')
        ..addCommand(InstallCommand())
        ..addCommand(InstallCommandAbbr())
        ..addCommand(UninstallCommand())
        ..addCommand(StartCommand())
        ..addCommand(GenerateCommand())
        ..addCommand(GenerateCommandAbbr())
        ..addCommand(RunCommand());

  runner.argParser.addFlag('version', abbr: 'v', negatable: false);
  return runner;
}

void version(String version) async {
  //String version = await getVersion();
  //String version = '0.0.13';
  print('''
███████╗██╗     ██╗██████╗ ██╗   ██╗     ██████╗██╗     ██╗
██╔════╝██║     ██║██╔══██╗╚██╗ ██╔╝    ██╔════╝██║     ██║
███████╗██║     ██║██║  ██║ ╚████╔╝     ██║     ██║     ██║
╚════██║██║     ██║██║  ██║  ╚██╔╝      ██║     ██║     ██║
███████║███████╗██║██████╔╝   ██║       ╚██████╗███████╗██║
╚══════╝╚══════╝╚═╝╚═════╝    ╚═╝        ╚═════╝╚══════╝╚═╝                                             
''');
  print('CLI package manager and template for Flutter');
  print('');
  print('Slidy version: $version');
}
