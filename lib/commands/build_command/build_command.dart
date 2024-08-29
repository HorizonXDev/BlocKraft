import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';

import '../../helpers/print_art.dart';

class BuildCommand extends Command {
  final String cd;
  BuildCommand(this.cd);

  @override
  String get description => 'Compiles the directory to aia file';

  @override
  String get name => 'build';

  @override
  void printUsage() {
    PrintArt();

    Console()
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   build: ')
      ..resetColorAttributes()
      ..writeLine('   $description')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   Usage:')
      ..resetColorAttributes()
      ..writeLine('   blockraft build  ');
  }

  @override
  Future<void> run() async {
    PrintArt();
    String name;
    if (argResults!.rest.length == 1) {
      name = argResults!.rest.first;
    } else {
      printUsage();
      exit(64);
    }
    final dir = Directory('$cd${Platform.pathSeparator}$name');
    final archive = Archive();

    for (var file in dir.listSync(recursive: true)) {
      if (file is File) {
        final fileBytes = file.readAsBytesSync();
        final relativePath = file.path.replaceFirst('${dir.path}${Platform.pathSeparator}', '');
        archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
      }
    }

    final zipPath = '$cd${Platform.pathSeparator}${Platform.pathSeparator}$name.zip';

    final zipFile = File(zipPath);
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);

    if (zipData != null) {
      zipFile.writeAsBytesSync(zipData);
    } else {
      print('Error: Failed to encode the archive.');
    }
    changeFileNameOnly(zipFile, '$name.aia');

    Console()
      ..setForegroundColor(ConsoleColor.green)
      ..writeLine()
      ..write('• ')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('Success! ')
      ..resetColorAttributes()
      ..write('AIA Generated Successfully')
      ..writeLine();
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}