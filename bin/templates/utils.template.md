# Template usecase

## Usage

```yaml
object:
  template:
    description: 'Describe a template' 
    args:
      - path
      - vars
```

arguments declaration
```yaml
utils:
  args:
```

scripts
```yaml
utils:
  funcs:
    generate_file:
      args:
    get_feature:
      capture:
        regex: '([A-z])*@([A-z])*'
        vars:
          - feature
          - name
    file_name:
      join:
        pattern: '_'
        args:
          - name
          - 'usecase.dart'
```

generate template usecase
```yaml
usecase:
  execute:
    usecase:
      dependencies:
        - get_it
      variables:
        file_path:
          join:
          pattern: '/'
          args:
            - 'lib'
            - feature
            - 'domain/usecase'
            - '${file_name}.dart'
      runs:
        generate: usecase
        path: file_path
```

generate template usecase
```yaml
usecase:
  execute:
    usecase_test:
      if_args:
        not_contains: no-test
      dependencies:
        - get_it
        - mocktail
      variables:
        file_path:
          join:
            pattern: '/'
            args:
              - 'test'
              - feature
              - 'domain/usecase'
              - '${file_name}_test.dart'
      runs:
        generate:
          template: usecase
          path:
```

## interface

```dart
abstract class $class_nameUsecase {
  Future<void> call();
}
```