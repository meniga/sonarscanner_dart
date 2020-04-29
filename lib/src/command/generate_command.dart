import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
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
    _GenerateArgResults.addOptions(argParser);
  }

  @override
  FutureOr<Null> run() async {
    final rootDirectory = sonarScannerArgResults.workingDirectory ?? Directory.current.path;
    final generateArgResults = _GenerateArgResults.fromArgResults(argResults);
    final sonarProjectProperties =
        argResults.rest.isNotEmpty ? argResults.rest[0] : "sonar-project.properties";

    Iterable<Project> projects = await ProjectFinder().find(path: rootDirectory);
    if (projects.isEmpty) {
      print("No projects found in $rootDirectory");
      return;
    }

    final modules = await ModuleFinder().findModules(
      path: rootDirectory,
      testReportPath: generateArgResults.testReportPath,
      coverageReportPath: generateArgResults.coverageReportPath,
    );

    final properties = await PropertiesWriter().toProperties(modules);
    File(sonarProjectProperties)
      ..createSync(recursive: true)
      ..writeAsStringSync(properties.asString());
  }
}

class _GenerateArgResults {
  final String testReportPath;
  final String coverageReportPath;

  _GenerateArgResults.fromArgResults(ArgResults results)
      : this.testReportPath = fromResults(results, "report-path"),
        this.coverageReportPath = fromResults(results, "coverage-path");

  static void addOptions(ArgParser argParser) {
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
}
