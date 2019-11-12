import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:slidy/src/command/generate_command.dart';
import 'package:slidy/src/templates/templates.dart' as templates;
import 'package:slidy/src/utils/file_utils.dart';
import 'package:slidy/src/utils/output_utils.dart' as output;
import 'package:slidy/src/utils/utils.dart';

import 'package:slidy/src/modules/install.dart';

bool _isContinue() {
  String result = stdin.readLineSync();
  if (result == "Y") {
    return true;
  } else {
    return false;
  }
}

_initWith(bool flutter_bloc, bool mobx) {
  if (flutter_bloc) {
    output.title("Starting a new project with flutter_bloc");
  } else if (mobx) {
    output.title("Starting a new project with Mobx");
  } else {
    output.title("Starting a new project with RX BLoC");
  }
  print("");
}

start(completeStart, flutter_bloc, mobx) async {
  _initWith(flutter_bloc, mobx);

  var dir = Directory("lib");
  if (await dir.exists()) {
    if (dir.listSync().isNotEmpty) {
      output.warn(
          "WARNING! This command will delete everything inside the \"lib /\" and \"test\" folders.");
      output.msg("Do you wish to continue? [Y]es or [n]o");
      if (_isContinue()) {
        output.msg("Removing lib folder");
        await dir.delete(recursive: true);
      } else {
        output.error("The lib folder must be empty");
        exit(1);
      }
    }
  }

  var dirTest = Directory("test");
  if (await dirTest.exists()) {
    if (dirTest.listSync().isNotEmpty) {
      output.msg("Removing test folder");
      await dirTest.delete(recursive: true);
    }
  }

  var command =
      CommandRunner("slidy", "CLI package manager and template for Flutter.");
  command.addCommand(GenerateCommand());
  String package = await getNamePackage();

  createStaticFile(
      libPath('app_module.dart'), templates.startAppModule(package));
  await _installPackages(flutter_bloc, mobx);

  //createStaticFile(libPath('app_bloc.dart'), templates.startAppBloc());

  if (completeStart) {
    createStaticFile(
        '${dir.path}/main.dart', templates.startMainComplete(package));

    createStaticFile(
        libPath('app_widget.dart'), templates.startAppWidgetComplete(package));

    createStaticFile(libPath('routes.dart'), templates.startRoutes(package));

    createStaticFile(
        libPath('shared/styles/theme_style.dart'), templates.startThemeStyle());

    createStaticFile(
        libPath('shared/locale/locales.dart'), templates.startLocales(package));

    createStaticFile(libPath('shared/locale/pt-BR_locale.dart'),
        templates.startPtBrLocale());

    createStaticFile(libPath('shared/locale/en-US_locale.dart'),
        templates.startEnUSLocale());

    await command.run(['generate', 'module', 'modules/login', '-c']);
    await command.run(['generate', 'module', 'modules/home', '-c']);

    await install(["flutter_localizations: sdk: flutter"], false,
        haveTwoLines: true);
  } else {
    createStaticFile('${dir.path}/main.dart', templates.startMain(package));

    createStaticFile(
        libPath('app_widget.dart'), templates.startAppWidget(package));

    await command.run(['generate', 'module', 'modules/home', '-c']);
  }
  await command.run(['generate', 'bloc', 'app']);

  output.msg("Project started! enjoy!");
}

_installPackages(bool flutter_bloc, bool mobx) async {
  await removeAllPackages();
  await install(["bloc_pattern", "rxdart", "dio"], false);
  await install(["mockito"], true);

  if (flutter_bloc) {
    await install(["flutter_bloc", "bloc"], false);
  } else if (mobx) {
    await install(["mobx", "flutter_mobx"], false);
    await install(["build_runner", "mobx_codegen"], true);
  }
}
