# Template usecase

## Usage

arguments declaration
```yaml
usecase:
  name: usecase
  description: 'Creates an usecase in a custom template'
  args:
    repository:
      help: 'Create repository file'
      abbr: r
      negatable: false
    service:
      help: 'Create service file'
      abbr: s
      negatable: false
    no-test:
      help: 'Avoid test files creation'
      abbr: n
      negatable: false
```

scripts
```yaml
usecase:
  scripts:
    capture:
      regex: '(<feature>[A-z])*@(<name>[A-z])*'
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
            - '{{file_name}}.dart'
      runs:
        generate: usecase
        path: file_path
```

generate template usecase test
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
              - '{{file_name}}_test.dart'
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