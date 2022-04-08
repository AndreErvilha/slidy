import 'package:slidy/src/core/models/custom_file.dart';

final _testTemplate = r''' 
test: |
  import 'package:flutter_test/flutter_test.dart';
  import 'package:get_it/get_it.dart';
  import 'package:mocktail/mocktail.dart';
  
  $arg2
  $arg3
  
  $arg4
   
  void main() {
    late I$arg1 _usecase;
  
    setUpAll(() async {
      await GetIt.I.reset();
      $arg5
      
      // TODO - register your dependency injection
      // GetIt.I.GetIt.I.registerSingleton<interface>(mockInstance);
      
      _usecase = $arg1();
    });
    
    void setupSuccessMocks() {
      // TODO - register your mock answers
      // final mockInstance = GetIt.I.get<interface>();
      // when(() => mockInstance.method()).thenAnswer(() async => Result());
      throw UnimplementedError();
    }
    
    setUp((){
      setupSuccessMocks();
    });
  
    test('Must completes with success', () async {
      final future = _usecase();
      
      await expectLater(future, completes);
      // await expectLater(result, completion(isA<Void>()));
      // expect(actual, matcher);
    });
  }
''';

final test = CustomFile(yaml: _testTemplate);
