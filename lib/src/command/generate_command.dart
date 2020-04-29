import 'dart:async';
import 'dart:io';

import 'package:moronepo/moronepo.dart';
import 'package:sonarscanner_dart/src/module_finder/module_finder.dart';
import 'package:sonarscanner_dart/src/properties/properties_writer.dart';

import 'sonarscanner_command.dart';

class GenerateCommand extends SonarScannerCommand<Null> {
  @override
  String get description => "Generates sonar-project.properties file";

  @override
  String get name => "generate";

  GenerateCommand() {
    argParser.addOption(
      "report-path",
      abbr: "r",
      help: "specifies the test report path for subprojects",
      defaultsTo: "build/tests.output",
    );
    argParser.addOption(
      "coverage-path",
      abbr: "c",
      help: "specifies the coverage file path for subprojects",
      defaultsTo: "coverage/lcov.info",
    );
  }

  @override
  FutureOr<Null> run() async {
    final rootDirectory = sonarScannerResults.workingDirectory ?? Directory.current.path;
    final sonarProjectProperties =
        argResults.rest.isNotEmpty ? argResults.rest[0] : "sonar-project.properties";
    final String testReportPath = fromResults(argResults, "report-path");
    final String coverageReportPath = fromResults(argResults, "coverage-path");

    Iterable<Project> projects = await ProjectFinder().find(path: rootDirectory);
    if (projects.isEmpty) {
      print("No projects found in $rootDirectory");
      return;
    }

    final modules = await ModuleFinder().findModules(
      path: rootDirectory,
      testReportPath: testReportPath,
      coverageReportPath: coverageReportPath,
    );

    final properties = await PropertiesWriter().toProperties(modules);
    File(sonarProjectProperties)
      ..createSync(recursive: true)
      ..writeAsStringSync(properties.asString());
  }
}
