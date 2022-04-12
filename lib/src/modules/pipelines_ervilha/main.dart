import 'dart:io';

import 'package:slidy/src/modules/pipelines_ervilha/modules/core/commands/capture.dart';

import 'modules/pipeline/pipeline.dart';

main() {
  Pipeline()
    ..addCommand(Capture())
    ..loadPipe(File(
        '/Users/andreervilha/StudioProjects/slidy/lib/src/modules/pipelines_ervilha/pipe.yaml'));
}
