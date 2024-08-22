
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';

import '../../helpers/print_art.dart';

class BuildCommand extends Command{
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
    final dir = Directory(cd);
    final archive = Archive();

    for (var file in dir.listSync(recursive: true)) {
      if (file is File) {
        final fileBytes = file.readAsBytesSync();
        final relativePath = file.path.replaceFirst(dir.path, '');
        archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
      }
    }

    // Adjust the path for the zip file
    List<String> pathParts = cd.split('.');
    pathParts.removeLast();
    final zipPath = '${pathParts.join('.')}.zip';

    final zipFile = File(zipPath);
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);

    if (zipData != null) {
      zipFile.writeAsBytesSync(zipData);
    } else {
      print('Error: Failed to encode the archive.');
    }
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
}