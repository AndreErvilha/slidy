import 'package:slidy/src/core/models/custom_file.dart';

final _dataSourceTemplate = r'''
i_data_source: |
  abstract class I$arg1 {
    Future<void> call();
  }
data_source: |
  $arg2
  
  class $arg1 implements I$arg1 {
    Future<void> call(){
      // TODO - Write your implementation
      throw UnimplementedError();
    }
  }
''';

final data_source = CustomFile(yaml: _dataSourceTemplate);
