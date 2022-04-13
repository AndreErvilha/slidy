import 'dart:io';

import 'package:slidy/src/modules/pipelines_ervilha/modules/markdown/markdown.dart';

import 'modules/core/commands/capture.dart';
import 'modules/pipeline/pipeline.dart';

main() {
  final markdown = Markdown()
    ..loadMarkdown(File(
        '/Users/andreervilha/StudioProjects/slidy/lib/src/modules/pipelines_ervilha/modules/markdown/pipe.md'));

  Pipeline()
    ..addCommand(Capture())
    ..loadYaml(File(
        '/Users/andreervilha/StudioProjects/slidy/lib/src/modules/pipelines_ervilha/pipe.yaml'));

  print('');
}
