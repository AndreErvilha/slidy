import 'package:slidy/src/core/models/custom_file.dart';

final _repositoryTemplate = r''' 
i_repository: |
  abstract class I$arg1{
    Future<void> call();
  }
repository: |
  $arg2
  
  class $arg1 implements I$arg1  {
    Future<void> call(){
      // TODO - Write your implementation
      throw UnimplementedError();
    }
  }
''';

final repositoryFile = CustomFile(yaml: _repositoryTemplate);
