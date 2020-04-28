import 'package:sonarscanner_dart/src/module_finder/module_finder.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  group("module_finder", () {
    final testProjectPath = "${projectDirectory.path}/test_resources/command/generate_test_project";
    ModuleFinder moduleFinder;

    setUp(() {
      moduleFinder = ModuleFinder();
    });

    test("should find sonar modules", () async {
      // when
      final result = await moduleFinder.findModules(
        path: testProjectPath,
        coverageReportPath: "coverage/lcov.info",
        testReportPath: "tests.output",
      );

      // then
      final modules = result.modules;
      expect(
          modules,
          containsAll([
            SonarModule(
              projectKey: "root",
              projectBaseDir: "$testProjectPath",
              isRoot: true,
            ),
            SonarModule(
              projectKey: "project_inside_directory",
              projectBaseDir: "$testProjectPath/directory/project_inside_directory",
            ),
            SonarModule(
              projectKey: "project1",
              projectBaseDir: "$testProjectPath/project1",
            ),
            SonarModule(
              projectKey: "project_inside_project",
              projectBaseDir: "$testProjectPath/project1/project_inside_project",
            ),
            SonarModule(
              projectKey: "project_with_tests",
              projectBaseDir: "$testProjectPath/project_with_tests",
              sources: "lib",
              tests: "test",
              coverageReportPath: "coverage/lcov.info",
              testReportPath: "tests.output",
            ),
          ]));
    });
  });
}
