import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:slidy/src/utils/utils.dart';

class PubService {
  Future<String> getPackage(String pack, String version) async {
    var url = _getUrlPackages() + '/$pack';

    if (version.isNotEmpty) {
      url += '/versions/$version';
    }

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var map = version.isEmpty ? json['latest']['pubspec'] : json['pubspec'];
      return map['version'];
    } else {
      throw Exception('error');
    }
  }

  String _getUrlPackages() {
    var URLBase = 'https://pub.dev';

    final envVars = Platform.environment;
    final URLBaseEnv = envVars['PUB_HOSTED_URL'];

    if (URLBaseEnv != null && validateUrl(URLBaseEnv)) {
      URLBase = URLBaseEnv;
    }

    return '$URLBase/api/packages';
  }
}
