import 'dart:io';

import 'package:meta/meta.dart';
import 'package:moronepo/moronepo.dart';

import 'sonar_module.dart';

class ModuleFinder {
  final _projectFinder = ProjectFinder();

  Future<Iterable<SonarModule>> findModules({
    @required String path,
    String testReportPath,
    String coverageReportPath,
  }) async {
    final projects = await _projectFinder.find(path: path);
    return await Stream.fromIterable(projects).asyncMap((project) {
      return SonarModule(
        projectKey: project.name,
        projectBaseDir: project.path,
        sources: _relativePathToDirectoryIfExists(project.path, "lib"),
        tests: project.hasTests ? "test" : null,
        testReportPath: _relativePathToFileIfExists(project.path, testReportPath),
        coverageReportPath: _relativePathToFileIfExists(project.path, coverageReportPath),
        isRoot: project.isRoot,
      );
    }).toList();
  }

  String _relativePathToFileIfExists(String base, String path) {
    final file = File("$base/$path");
    return file.existsSync() ? path : null;
  }

  String _relativePathToDirectoryIfExists(String base, String path) {
    final directory = Directory("$base/$path");
    return directory.existsSync() ? path : null;
  }
}
