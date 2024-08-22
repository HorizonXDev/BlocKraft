
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:blockraft/commands/build_command/build_command.dart';
import 'package:blockraft/commands/create_command/create_command.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';

void main(List<String> args) {
  final cd = Directory.current.path;
  final runner = BlocKraftCommandRunner('blockraft', 'A command-line tool for creating AI2 applications');
  runner
    ..addCommand(CreateCommand(cd))
    ..addCommand(BuildCommand(cd))
    ..run(args).catchError((Object err) {
      if (err is UsageException) {
        runner.printUsage();
      } else {
        throw err;
      }
    });
}

class BlocKraftCommandRunner extends CommandRunner {
  BlocKraftCommandRunner(super.executableName, super.description);

  @override
  void printUsage() {
    PrintArt();

    final console = Console();
    console
      ..setForegroundColor(ConsoleColor.cyan)
      ..write('Usage: ')
      ..resetColorAttributes()
      ..writeLine('  blockraft create <file-name> <args>(optional)')
      ..writeLine()
      ..setForegroundColor(ConsoleColor.yellow)
      ..writeLine('Commands Available')
      ..writeLine()
      ..setForegroundColor(ConsoleColor.cyan)
      ..write('create :   ')
      ..resetColorAttributes()
      ..writeLine(
          'Creates a new project for AI2 applications. The <file-name> is the name of the project you want to create.')
      ..writeLine();
  }
}