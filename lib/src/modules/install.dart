import 'dart:io';

import 'package:slidy/src/modules/update.dart';
import 'package:slidy/src/services/pub_service.dart';
import 'package:slidy/src/utils/pubspec.dart';
import 'package:slidy/src/utils/utils.dart';
import 'package:slidy/src/utils/output_utils.dart' as output;

void install(List<String> packs, bool isDev, {bool haveTwoLines}) async {
  PubSpec spec = await getPubSpec();
  File yaml = File("pubspec.yaml");
  var node = yaml.readAsLinesSync();
  int indexDependency = node.indexWhere((t) => t.contains("dependencies:")) + 1;
  int indexDependencyDev =
      node.indexWhere((t) => t.contains("dev_dependencies:")) + 1;
  bool isAlter = false;
  haveTwoLines = haveTwoLines ?? false;
  var dependencies = isDev ? spec.devDependencies : spec.dependencies;

  for (String pack in packs) {
    String packName = "";
    String version = "";

    if (pack.contains(":")) {
      packName = pack.split(":")[0];
      version = pack.split(":").length > 1
          ? pack.split(":")[1] + ':' + pack.split(":")[2]
          : pack.split(":")[1];
    } else {
      packName = pack;
    }

    if (dependencies.containsKey(packName) && !haveTwoLines) {
      await update([packName], isDev);
      continue;
    }

    try {
      if (!haveTwoLines) {
        version = await PubService().getPackage(packName, version);
        node.insert(isDev ? indexDependencyDev : indexDependency,
            "  $packName: ^$version");
      } else if (!dependencies.containsKey(packName)) {
        node.insert(isDev ? indexDependencyDev : indexDependency,
            "  $packName: \n    $version");
      }
      output.success("$packName:$version Added in pubspec");
      isAlter = true;
    } catch (e) {
      output.error("Version or package not found");
    }

    // spec = isDev
    //       ? spec.copy(devDependencies: dependencies)
    //       : spec.copy(dependencies: dependencies);
    //   await spec.save(Directory(""));
    if (isAlter) {
      yaml.writeAsStringSync(node.join("\n"));
    }
  }
}
