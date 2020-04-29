import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:moronepo/moronepo.dart';

abstract class SonarScannerCommand<T> extends Command<T> {
  SonarScannerArgResults get sonarScannerArgResults =>
      SonarScannerArgResults.fromArgResults(globalResults);
}

class SonarScannerArgResults {
  final String workingDirectory;
  final String cacheDirectory;
  final bool verbose;

  SonarScannerArgResults.fromArgResults(ArgResults results)
      : this.workingDirectory = fromResults(results, "working-directory"),
        this.cacheDirectory = fromResults(results, "cache-directory"),
        this.verbose = fromResults(results, "verbose");

  static void addOptions(ArgParser argParser) {
    argParser.addOption(
      "working-directory",
      abbr: "w",
      help: "specifies the working directory",
    );
    argParser.addOption(
      "cache-directory",
      abbr: "c",
      help: "specifies the cache directory",
    );
    argParser.addFlag(
      "verbose",
      abbr: "v",
      defaultsTo: false,
    );
  }
}
