import 'package:args/args.dart';

class OptionsSetter {
  void addGlobalOptions(ArgParser argParser) {
    argParser.addOption("working-directory", abbr: "w", help: "specifies the working directory");
  }
}
