# sonarscanner_dart

[![pub package](https://img.shields.io/pub/v/sonarscanner_dart.svg)](https://pub.dev/packages/sonarscanner_dart)
[![Build Status](https://travis-ci.org/meniga/sonarscanner_dart.svg?branch=master)](https://travis-ci.org/meniga/sonarscanner_dart)
[![codecov](https://codecov.io/gh/meniga/sonarscanner_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/sonarscanner_dart)

The SonarScanner for Dart provides an easy way to start SonarQube analysis of a dart project. 

Currently, it supports following commands:

[generate](#generate-command)

[run](#run-command)

# Usage

Activate `sonarscanner_dart`:

```bash
pub global activate sonarscanner_dart
```

or prepend each command with `flutter` if used:

```bash
flutter pub global activate sonarscanner_dart
```

Now it should be possible to run `sonarscanner_dart`:

```bash
sonarscanner_dart [--working-directory <path>] <command>
```

You can also follow [how to set up a global command](https://dart.dev/tools/pub/cmd/pub-global)  
to make it available as a regular shell command by appending `PATH`.

```bash
sonarscanner_dart generate
```

or creating an alias instead:

```bash
alias sonarscanner_dart="flutter pub global run sonarscanner_dart"

sonarscanner_dart generate
```

### generate command

Generates sonar-project.properties

```bash
sonarscanner_dart generate [--coverage-path <path_to_lcov_file>] [--report-path <path_to_machine_test_output>] [path_to_properties_file]
```

For example:

```bash
sonarscanner_dart generate --coverage-path build/lcov.info --report-path build/tests.output
```

### run command

Runs sonar-scanner. It is also possible to pass additional properties after `--`.

```bash
sonarscanner_dart run [--coverage-path <path_to_lcov_file>] [--report-path <path_to_machine_test_output>]
```

For example:

```bash
sonarscanner_dart run --coverage-path build/lcov.info --report-path build/tests.output -- -Dproject.settings=sonar-project.properties
```