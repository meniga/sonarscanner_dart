import 'package:sonarscanner_dart/src/module_finder/module_finder.dart';
import 'package:sonarscanner_dart/src/properties/properties_writer.dart';
import 'package:test/test.dart';

void main() {
  group("properties_writer", () {
    test("should convert modules to properties", () {
      // given
      final writer = PropertiesWriter();
      final modules = [
        SonarModule(
          projectKey: "root",
          isRoot: true,
        ),
        SonarModule(
          projectKey: "first",
          sources: "lib",
          tests: "test",
          projectBaseDir: "feature/first",
          coverageReportPath: "build/lcov.info",
          testReportPath: "build/tests.output",
        ),
        SonarModule(
          projectKey: "second",
          sources: "lib",
          tests: "test",
          projectBaseDir: "feature/second",
          coverageReportPath: "build/lcov.info",
          testReportPath: "build/tests.output",
        ),
      ];

      // when
      final properties = writer.toProperties(modules);

      // then
      expect(properties["sonar.projectKey"], "root");
      expect(properties["sonar.modules"], "first,second");
      expect(properties["first.sonar.projectKey"], "first");
      expect(properties["first.sonar.projectBaseDir"], "feature/first");
      expect(properties["first.sonar.sources"], "lib");
      expect(properties["first.sonar.tests"], "test");
      expect(properties["first.sonar.flutter.tests.reportPath"], "build/tests.output");
      expect(properties["first.sonar.flutter.coverage.reportPath"], "build/lcov.info");
      expect(properties["second.sonar.projectKey"], "second");
      expect(properties["second.sonar.projectBaseDir"], "feature/second");
      expect(properties["second.sonar.sources"], "lib");
      expect(properties["second.sonar.tests"], "test");
      expect(properties["second.sonar.flutter.tests.reportPath"], "build/tests.output");
      expect(properties["second.sonar.flutter.coverage.reportPath"], "build/lcov.info");
    });
  });
}
