import 'command_base.dart';
import 'sub_command/generate_data_source_sub_command.dart';
import 'sub_command/generate_repository_sub_command.dart';
import 'sub_command/generate_use_case_sub_command.dart';

class GenerateCommand extends CommandBase {
  @override
  final name = 'generate';
  @override
  final description =
      'Creates a module, page, widget or repository according to the option.';

  GenerateCommand() {
    // addSubcommand(GenerateModuleSubCommand());
    // addSubcommand(GenerateModuleAbbrSubCommand());
    // addSubcommand(GenerateMobxSubCommand());
    // addSubcommand(GenerateMobxAbbrSubCommand());
    addSubcommand(GenerateRepositorySubCommand());
    addSubcommand(GenerateRepositoryAbbrSubCommand());
    // addSubcommand(GenerateServiceSubCommand());
    // addSubcommand(GenerateServiceAbbrSubCommand());
    // addSubcommand(GeneratePageSubCommand());
    // addSubcommand(GeneratePageAbbrSubCommand());
    // addSubcommand(GenerateWidgetSubCommand());
    // addSubcommand(GenerateWidgetAbbrSubCommand());
    addSubcommand(GenerateUseCaseSubCommand());
    addSubcommand(GenerateUseCaseAbbrSubCommand());
    addSubcommand(GenerateDataSourceSubCommand());
    addSubcommand(GenerateDataSourceAbbrSubCommand());
  }

  @override
  String? get invocationSuffix => null;
}

class GenerateCommandAbbr extends GenerateCommand {
  @override
  final name = 'g';
}
