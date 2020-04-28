import 'package:args/command_runner.dart';
import 'package:moronepo/moronepo.dart';

abstract class SonarScannerCommand<T> extends Command<T> {
  SonarScannerResults get sonarScannerResults => SonarScannerResults(
    workingDirectory: _fromGlobalResults("working-directory"),
  );

  R _fromGlobalResults<R>(String name) => fromResults(globalResults, name);
}

class SonarScannerResults {
  final String workingDirectory;

  SonarScannerResults({
    this.workingDirectory,
  });
}
