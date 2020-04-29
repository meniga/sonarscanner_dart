import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sonarscanner_dart/src/command/run_command.dart';
import 'package:sonarscanner_dart/src/command/sonarscanner_dart_command_runner.dart';
import 'package:sonarscanner_dart/src/downloader/downloader.dart';
import 'package:sonarscanner_dart/src/process_starter/process_starter.dart';
import 'package:test/test.dart';

import '../directories.dart';

final testProjectPath = "${projectDirectory.path}/test_resources/command/generate_test_project";
final distributionFile =
    File("${projectDirectory.path}/test_resources/sonar-scanner-cli-4.2.0.1873.zip");
Directory cacheDirectory;
final mockProcessStarter = MockProcessStarter();

void main() {
  group("run", () {
    setUp(() {
      cacheDirectory = Directory.systemTemp.createTempSync("run");
      reset(mockProcessStarter);
      final mockProcess = MockProcess();
      when(mockProcess.exitCode).thenAnswer((_) => Future.value(0));
      when(mockProcessStarter.start(any, any, any)).thenAnswer((_) => Future.value(mockProcess));
    });

    tearDown(() {
      cacheDirectory.deleteSync(recursive: true);
    });

    test("should download sonar-scanner to cache if not available and run it", () async {
      // given
      final runner = createRunnerWithDownloader(TestDownloader());

      // when
      await runner.run([
        "--working-directory",
        testProjectPath,
        "--cache-directory",
        cacheDirectory.path,
        "run",
        "--clear-cache",
        "-u",
        distributionFile.path,
      ]);

      // then
      verifySonarScannerWasRun();
    });

    test("should use cached sonar-scanner distribution", () async {
      // given
      final mockDownloader = MockDownloader();
      final runner = createRunnerWithDownloader(mockDownloader);
      createCacheDirectory("${cacheDirectory.path}/sonar-scanner-4.2.0.1873/bin");

      // when
      await runner.run([
        "--working-directory",
        testProjectPath,
        "--cache-directory",
        cacheDirectory.path,
        "run",
        "-u",
        distributionFile.path,
      ]);

      // then
      verifyZeroInteractions(mockDownloader);
      verifySonarScannerWasRun();
    });
  });
}

SonarScannerCommandRunner createRunnerWithDownloader(Downloader downloader) {
  final runCommand = RunCommand(
    processStarter: mockProcessStarter,
    downloader: downloader,
  );
  return SonarScannerCommandRunner([runCommand]);
}

void createCacheDirectory(String path) {
  Directory("$path/").createSync(recursive: true);
}

void verifySonarScannerWasRun() {
  verify(
    mockProcessStarter.start(
      "sh",
      ["${cacheDirectory.path}/sonar-scanner-4.2.0.1873/bin/sonar-scanner"],
      testProjectPath,
    ),
  );
}

class MockProcessStarter extends Mock implements ProcessStarter {}

class MockProcess extends Mock implements Process {}

class MockDownloader extends Mock implements Downloader {}

class TestDownloader implements Downloader {
  @override
  Future<List<int>> download(String url) {
    return File(url).readAsBytes();
  }
}
