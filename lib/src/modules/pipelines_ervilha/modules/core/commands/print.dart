import 'package:slidy/src/modules/pipelines_ervilha/modules/core/utils.dart';

import '../../../../../../slidy.dart';
import '../domain/entities/command.dart';
import '../domain/entities/objects.dart';
import '../domain/entities/world.dart';

class Print implements Command {
  @override
  String get name => 'print';

  @override
  Future<void> call(World world, ObjectValue args) async {
    final msg = args.value as TextValue;

    success('$name => ${Utils.eval(msg, world)}');
  }
}
