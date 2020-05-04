import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/args.dart';
import 'package:moronepo/moronepo.dart';
import 'package:path/path.dart' as path;
import 'package:sonarscanner_dart/src/downloader/downloader.dart';
import 'package:sonarscanner_dart/src/process_starter/process_starter.dart';

import 'sonarscanner_command.dart';

class RunCommand extends SonarScannerCommand<Null> {
  @override
  String get description => "Runs sonar-scanner";

  @override
  String get name => "run";

  _RunArgResults get _runArgResults => _RunArgResults.fromArgResults(argResults);

  final ProcessStarter _processStarter;
  final Downloader _downloader;

  RunCommand({
    ProcessStarter processStarter,
    Downloader downloader,
  })  : this._processStarter = processStarter ?? ProcessStarter(),
        this._downloader = downloader ?? Downloader() {
    _RunArgResults.addOptions(argParser);
  }

  @override
  FutureOr<Null> run() async {
    final rootDirectory = sonarScannerArgResults.workingDirectory ?? Directory.current.path;
    final cacheDirectory = sonarScannerArgResults.cacheDirectory ?? _getCacheDirectoryPath();
    final distributionName = _extractDistributionName(_runArgResults._distributionUrl);
    final distributionDirectory = Directory("${cacheDirectory}/${distributionName}");
    if (_shouldDownloadDistribution(distributionDirectory)) {
      final archive = await _downloadDistributionArchive(_runArgResults._distributionUrl);
      _extractArchive(archive, cacheDirectory);
    }
    final processExitCode = await _startProcess(
      distributionDirectory.path,
      argResults.rest,
      rootDirectory,
    ).then((process) => process.exitCode);

    if (processExitCode != 0) {
      exitCode = processExitCode;
    }
  }

  String _getCacheDirectoryPath() {
    final basePath = Platform.environment[Platform.isWindows ? "APPDATA" : "HOME"];
    return Directory(path.join(basePath, ".sonar-scanner")).path;
  }

  String _extractDistributionName(String distributionUrl) {
    return "sonar-scanner-${RegExp(r"cli-(.+).zip").firstMatch(distributionUrl).group(1)}";
  }

  bool _shouldDownloadDistribution(Directory distributionDirectory) {
    return _runArgResults._clearCache || !distributionDirectory.existsSync();
  }

  Future<Archive> _downloadDistributionArchive(String distributionUrl) async {
    final data = await _downloader.download(distributionUrl);
    return ZipDecoder().decodeBytes(data);
  }

  void _extractArchive(Archive archive, String destination) {
    for (final file in archive) {
      if (file.isFile) {
        File("${destination}/${file.name}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      } else {
        Directory("${destination}/${file.name}")..createSync(recursive: true);
      }
    }
  }

  Future<Process> _startProcess(
    String distributionPath,
    Iterable<String> arguments,
    String workingDirectory,
  ) {
    final command = Platform.isWindows ? "${distributionPath}/bin/sonar-scanner.bat" : "sh";
    final platformArguments =
        Platform.isWindows ? <String>[] : ["${distributionPath}/bin/sonar-scanner"];
    return _processStarter.start(
      command,
      platformArguments.followedBy(arguments).toList(),
      workingDirectory,
    );
  }
}

class _RunArgResults {
  static const _distributionUrlParameterName = "distribution-url";
  static const _clearCacheParameterName = "clear-cache";

  final String _distributionUrl;
  final bool _clearCache;

  _RunArgResults.fromArgResults(ArgResults results)
      : this._distributionUrl = fromResults(results, _distributionUrlParameterName),
        this._clearCache = fromResults(results, _clearCacheParameterName);

  static void addOptions(ArgParser argParser) {
    argParser.addOption(
      _distributionUrlParameterName,
      abbr: "u",
      defaultsTo:
          "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873.zip",
    );
    argParser.addFlag(
      _clearCacheParameterName,
      abbr: "c",
      defaultsTo: false,
    );
  }
}
