**`pipe.yaml`**
```yaml
pipeline_example:  
 name: usecase1
 abbr: w
 description: 'Creates an usecase in a custom template'
```

```yaml
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

```yaml
 execute:
  - capture:
     text: '{{rest}}'
     regex: '(?<feature>[A-z]*)@(?<name>[A-z]*)'
  - file_name: '{{name}}_usecase'
  - file_path: 'lib/{{feature}}/domain/usecase/{{file_name}}.dart'
  - install:
     - get_it
  - print: '{{file_path}}'
  - generate:
     template: usecase
     path: '{{file_path}}'
```

#  **`interface_usecase`**
```dart
abstract class I$file_name {
	Future<void> call();
}
```  

# **`usecase`**
```dart
class $file_name extends I$file_name {  
 @override Future<void> call() async { throw UnimplementedError(); }}  
```