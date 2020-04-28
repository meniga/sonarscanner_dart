import 'package:sonarscanner_dart/src/command/sonarscanner_dart_command_runner.dart';

void main(List<String> arguments) {
  SonarScannerCommandRunner.withDefaultCommands().run(arguments);
}
