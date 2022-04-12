import '../../../core/domain/entities/command.dart';

abstract class IAddCommandUsecase {
  void call(Map<String, Command> commands, Command command);
}

class AddCommandUsecase implements IAddCommandUsecase {
  @override
  void call(Map<String, Command> commands, Command command) {
    commands[command.name] = command;
  }
}
