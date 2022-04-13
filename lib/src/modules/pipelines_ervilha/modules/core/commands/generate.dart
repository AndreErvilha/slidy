import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/command.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/objects.dart';
import 'package:slidy/src/modules/pipelines_ervilha/modules/core/domain/entities/world.dart';

class Generate implements Command {
  @override
  Future<void> call(World world, ObjectValue<Value> args) async {
    final template = args.getValue<TextValue>('template');
    final path = args.getValue<TextValue>('path');

    //success('$name => ${template.value}, ${Utils.eval(path, world)}');
  }

  @override
  String get name => 'generate';
}
