import 'dart:io';

import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/command.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/objects.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/world.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/utils.dart';

import '../../../../../../slidy.dart';

class Generate implements Command {
  @override
  Future<void> call(World world, ObjectValue<Value> args) async {
    final template = args.getValue<TextValue>('template');
    final path = args.getValue<TextValue>('path');

    final file = File(Utils.eval(path, world));
    await file.create(recursive: true);
    await file.writeAsString(Utils.eval(template, world));

    success('$name => Created file: ${Utils.eval(path, world)}');
  }

  @override
  String get name => 'generate';
}
