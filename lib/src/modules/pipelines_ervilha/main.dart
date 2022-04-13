import 'dart:io';

import 'modules/core/commands/capture.dart';
import 'modules/pipeline/pipeline.dart';

main() {
  final pipe = Pipeline()
    ..addCommand(Capture())
    ..loadMarkdown(File(
        '/Users/andreervilha/StudioProjects/slidy/lib/src/modules/pipelines_ervilha/pipe.md'));
  // ..loadYaml(File(
  //     '/Users/andreervilha/StudioProjects/slidy/lib/src/modules/pipelines_ervilha/pipe.yaml'));

  print('');
}
