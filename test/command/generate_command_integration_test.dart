import 'dart:io';

import 'package:sonarscanner_dart/src/command/sonarscanner_dart_command_runner.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  group("generate", () {
    final testDirectory = "${projectDirectory.path}/test_resources/command/generate_test_project";

    test("should notify if no project found", () async {
      final emptyDirectory = "${testDirectory}/empty_directory";
      expect(
          () => SonarScannerCommandRunner.withDefaultCommands().run([
                "--working-directory",
                emptyDirectory,
                "generate",
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });

    test("should generate sonar-project.properties file", () async {
      // when
      await SonarScannerCommandRunner.withDefaultCommands().run([
        "--working-directory",
        testDirectory,
        "generate",
        "--report-path",
        "build/tests.output",
        "--coverage-path",
        "build/lcov.info",
        "${testDirectory}/build/sonar-project.properties",
      ]);

      // then
      final actualFile = File("${testDirectory}/build/sonar-project.properties");
      expect(actualFile.existsSync(), isTrue);
      expect(actualFile.readAsStringSync(), isNotEmpty);
    });
  });
}
