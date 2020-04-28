import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moronepo/moronepo.dart';
import 'package:quiver/check.dart';

class ModuleFinder {
  final _projectFinder = ProjectFinder();

  Future<FindModuleResult> findModules({
    @required String path,
    String testReportPath,
    String coverageReportPath,
  }) async {
    final projects = await _projectFinder.find(path: path);
    final modules = await Stream.fromIterable(projects).asyncMap((project) {
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

    return FindModuleResult(
      modules: modules,
    );
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

class FindModuleResult extends Equatable {
  final Iterable<SonarModule> modules;

  FindModuleResult({
    @required this.modules,
  }) {
    checkNotNull(modules);
  }

  @override
  List<Object> get props => [
        modules,
      ];

  @override
  bool get stringify => true;
}

class SonarModule extends Equatable {
  final String projectKey;
  final String projectBaseDir;
  final String sources;
  final String tests;
  final String testReportPath;
  final String coverageReportPath;
  final bool isRoot;

  SonarModule({
    @required this.projectKey,
    this.projectBaseDir,
    this.sources,
    this.tests,
    this.testReportPath,
    this.coverageReportPath,
    this.isRoot = false,
  }) {
    checkNotNull(projectKey);
    checkNotNull(isRoot);
  }

  @override
  List<Object> get props => [
        projectKey,
        projectBaseDir,
        sources,
        tests,
        testReportPath,
        coverageReportPath,
        isRoot,
      ];

  @override
  bool get stringify => true;
}
