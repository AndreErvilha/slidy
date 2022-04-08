import 'dart:io';

import 'package:recase/recase.dart';

import 'utils.dart';

class TemplateFile {
  late final File file;
  late final String _fileName;
  late final String feature;
  late final String name;
  late final String type;
  late final String path;
  late final String packageName;

  TemplateFile({
    required pattern,
    required this.path,
    required this.type,
    isInterface = false,
    isTest = false,
  }) {
    final list = pattern.split('@');
    feature = list.first;
    name = list.last;

    _fileName = [
      if (isInterface) 'i',
      name,
      type,
      if (isTest) 'test',
    ].join('_');

    final finalPath = ['lib/features', feature, path].join('/');
    file = File('$finalPath/$_fileName.dart');

    packageName = getPackageName();
  }

  String get import {
    final list = file.path.split('/');
    list.removeAt(0);
    final finalPath = list.join('/');

    return 'import \'package:$packageName/$finalPath\';';
  }

  String interfaceImportFrom(String path) {
    final list = interfaceFileFrom(path).path.split('/');
    list.removeAt(0);
    final finalPath = list.join('/');

    return 'import \'package:$packageName/$finalPath\';';
  }

  String get interfaceFileName => [
        'i',
        name,
        type,
      ].join('_');

  String get testFileName => [
        name,
        type,
        'test',
      ].join('_');

  File interfaceFileFrom(String path) {
    final finalPath = ['lib/features', feature, path].join('/');
    return File('$finalPath/$interfaceFileName.dart');
  }

  File get testFile {
    final finalPath = ['test/features', feature, path].join('/');
    return File('$finalPath/$testFileName.dart');
  }

  ReCase get fileName => ReCase(_fileName);
}
