import 'dart:io';

import 'package:slidy/slidy.dart';
import 'package:slidy/src/core/interfaces/yaml_service.dart';
import 'package:slidy/src/core/prints/prints.dart';
import 'package:slidy/src/modules/template_creator/domain/models/line_params.dart';
import 'package:yaml/yaml.dart';

Future injectParentModule(String injectionType, String fileNameWithUppeCase,
    String import, Directory directory) async {
  final injection = _injectionTemplate(injectionType, fileNameWithUppeCase);

  final parentModule = await Slidy.instance.getParentModule(directory);

  var result = await Slidy.instance.template.addLine(
      params: LineParams(parentModule, replaceLine: (line) {
    if (line.contains('final List<Bind> binds = [')) {
      return line.replaceFirst('final List<Bind> binds = [',
          'final List<Bind> binds = [$injection,');
    } else if (line.contains('List<Bind> get binds => [')) {
      return line.replaceFirst('List<Bind> get binds => [\n',
          'List<Bind> get binds => [$injection,');
    }
    return line;
  }));

  execute(result);

  if (result.isRight()) {
    result = await Slidy.instance.template
        .addLine(params: LineParams(parentModule, inserts: [import]));
    execute(result);
    if (result.isRight()) {
      await formatFile(parentModule);
    }
  }
}

Future injectParentModuleRouting(String path, String fileNameWithUppeCase,
    String import, Directory directory) async {
  final injection =
      'ChildRoute(\'$path\', child: (_, args) => $fileNameWithUppeCase)';

  final parentModule = await Slidy.instance.getParentModule(directory);

  var result = await Slidy.instance.template.addLine(
      params: LineParams(parentModule, replaceLine: (line) {
    if (line.contains('final List<ModularRoute> routes = [')) {
      return line.replaceFirst('final List<ModularRoute> routes = [',
          'final List<ModularRoute> routes = [$injection,');
    } else if (line.contains('List<ModularRoute> get routes => [')) {
      return line.replaceFirst('List<ModularRoute> get routes => [\n',
          'List<ModularRoute> get routes => [$injection,');
    }
    return line;
  }));

  execute(result);

  if (result.isRight()) {
    result = await Slidy.instance.template
        .addLine(params: LineParams(parentModule, inserts: [import]));
    execute(result);
    if (result.isRight()) {
      await formatFile(parentModule);
    }
  }
}

Future<void> formatFile(File file) async {
  await Process.run('flutter', ['format', file.absolute.path],
      runInShell: true);
}

String _injectionTemplate(String injectionType, String classInstance) {
  if (injectionType == 'lazy-singleton') {
    return 'Bind.lazySingleton((i) => $classInstance)';
  } else if (injectionType == 'singleton') {
    return 'Bind.singleton((i) => $classInstance)';
  } else {
    return 'Bind.factory((i) => $classInstance)';
  }
}

Future<bool> checkDependencyIsExist(String dependency,
    [bool isDev = false]) async {
  try {
    final dependenciesLine = isDev ? 'dev_dependencies' : 'dependencies';
    final pubspec = Slidy.instance.get<YamlService>();
    final map = (pubspec.getValue([dependenciesLine]))?.value as YamlMap;
    return map.containsKey(dependency);
  } catch (e) {
    return false;
  }
}

String getPackageName() {
  final pubspec = Slidy.instance.get<YamlService>();
  return pubspec.getValue(['name'])?.value;
}
