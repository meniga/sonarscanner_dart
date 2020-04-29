import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/check.dart';

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
