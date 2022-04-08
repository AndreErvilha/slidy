import 'package:slidy/src/core/models/custom_file.dart';

final _useCaseTemplate = r''' 
use_case: |
  abstract class I$fileName|pascalcase {
    Future<void> call();
  }
  
  class $fileName|pascalcase extends I$fileName|pascalcase {
    @override
    Future<void> call() async {
      throw UnimplementedError();
    }
  }
''';

final use_case = CustomFile(yaml: _useCaseTemplate);
