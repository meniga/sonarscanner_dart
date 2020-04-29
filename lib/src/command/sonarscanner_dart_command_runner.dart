import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:sonarscanner_dart/src/command/sonarscanner_command.dart';

import 'generate_command.dart';
import 'run_command.dart';

class SonarScannerCommandRunner extends CommandRunner<Null> {
  final Logger _logger = Logger.root;

  SonarScannerCommandRunner.withDefaultCommands()
      : this([
          GenerateCommand(),
          RunCommand(),
        ]);

  SonarScannerCommandRunner([List<Command<Null>> commands])
      : super(
          "sonarscanner_dart",
          "The SonarScanner for Dart provides an easy way to start SonarQube analysis of a dart project.",
        ) {
    SonarScannerArgResults.addOptions(argParser);
    commands.forEach((it) => addCommand(it));
  }

  @override
  FutureOr<Null> runCommand(ArgResults topLevelResults) {
    _configureLogger(topLevelResults);
    return super.runCommand(topLevelResults);
  }

  void _configureLogger(ArgResults results) {
    _logger.level =
        SonarScannerArgResults.fromArgResults(results).verbose ? Level.ALL : Level.WARNING;
    _logger.onRecord.listen((LogRecord logRecord) {
      if (logRecord.level >= Level.SEVERE) {
        stderr.writeln(logRecord);
      } else {
        stdout.writeln(logRecord);
      }
    });
  }
}
