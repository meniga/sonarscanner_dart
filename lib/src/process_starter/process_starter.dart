import 'dart:io';

class ProcessStarter {
  Future<Process> start(
    String command,
    List<String> arguments,
    String workingDirectory,
  ) {
    return Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: true,
    ).then((process) async {
      await stdout.addStream(process.stdout);
      await stderr.addStream(process.stderr);
      return process;
    });
  }
}
