# sonarscanner_dart

[![pub package](https://img.shields.io/pub/v/sonarscanner_dart.svg)](https://pub.dev/packages/sonarscanner_dart)
[![Build Status](https://travis-ci.org/sonarscanner_dart/sonarscanner_dart.svg?branch=master)](https://travis-ci.org/meniga/sonarscanner_dart)
[![codecov](https://codecov.io/gh/meniga/sonarscanner_dart/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/sonarscanner_dart)

The SonarScanner for Dart provides an easy way to start SonarQube analysis of a dart project. 

Currently, it supports following commands:

[generate](#generate-command)

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

```bash
sonarscanner_dart generate [--coverage-path <path_to_lcov_file>] [--report-path <path_to_machine_test_output>]
```

For example:

```bash
sonarscanner_dart generate --coverage-path build/lcov.info --report-path build/tests.output
```
