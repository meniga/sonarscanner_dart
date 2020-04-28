import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';

import 'generate_command.dart';
import 'options_setter.dart';

class SonarScannerCommandRunner extends CommandRunner<Null> {
  final Logger _logger = Logger.root;

  SonarScannerCommandRunner.withDefaultCommands()
      : this([
          GenerateCommand(),
        ]);

  SonarScannerCommandRunner([List<Command<Null>> commands])
      : super(
          "sonarscanner_dart",
          "The SonarScanner for Dart provides an easy way to start SonarQube analysis of a dart project.",
        ) {
    OptionsSetter().addGlobalOptions(argParser);
    commands.forEach((it) => addCommand(it));
  }

  @override
  FutureOr<Null> runCommand(ArgResults topLevelResults) {
    _configureLogger();
    return super.runCommand(topLevelResults);
  }

  void _configureLogger() {
    _logger.level = Level.ALL;
    _logger.onRecord.listen((LogRecord logRecord) {
      if (logRecord.level >= Level.SEVERE) {
        stderr.writeln(logRecord);
      } else {
        stdout.writeln(logRecord);
      }
    });
  }
}
