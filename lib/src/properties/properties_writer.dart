import 'package:sonarscanner_dart/src/module_finder/sonar_module.dart';
import 'package:sonarscanner_dart/src/properties/properties.dart';

class PropertiesWriter {
  Properties toProperties(Iterable<SonarModule> modules) {
    final map = modules.fold(Map<String, String>(), (Map<String, String> accumulator, module) {
      final prefix = module.isRoot ? "" : "${module.projectKey}.";
      accumulator["${prefix}sonar.projectKey"] = module.projectKey;
      accumulator["${prefix}sonar.projectBaseDir"] = module.projectBaseDir;
      accumulator["${prefix}sonar.sources"] = module.sources;
      accumulator["${prefix}sonar.tests"] = module.tests;
      accumulator["${prefix}sonar.flutter.coverage.reportPath"] = module.coverageReportPath;
      accumulator["${prefix}sonar.flutter.tests.reportPath"] = module.testReportPath;
      return accumulator;
    });
    map["sonar.modules"] = modules.where((it) => !it.isRoot).map((it) => it.projectKey).join(",");
    return Properties(map);
  }
}
