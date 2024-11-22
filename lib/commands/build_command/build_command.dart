import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:blockraft/helpers/config/parsing_yaml.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';
import 'package:yaml/yaml.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

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
      ..writeLine('   blockraft build <aia or apk>');
  }

  @override
  Future<void> run() async {
    String extension;
    if (argResults!.rest.length == 1) {
      PrintArt();
      extension = argResults!.rest.first;
    } else {
      printUsage();
      exit(64);
    }

    var parseYaml = ParsingYaml(Directory(cd));
    var blockraftYaml = await parseYaml.loadConfig(File('$cd${Platform.pathSeparator}blockraft.yaml'));

    compileAia(parseYaml, blockraftYaml);



    if(extension == 'apk'){
      // TODO: Compiling the aia to apk
    }

    Console()
      ..setForegroundColor(ConsoleColor.green)
      ..writeLine()
      ..write('• ')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('Success! ')
      ..resetColorAttributes()
      ..write('Files copied to output directory successfully')
      ..writeLine();
  }

  void compileAia(ParsingYaml parseYaml, YamlMap blockraftYaml) {
    var assetsDirectory = Directory('$cd${Platform.pathSeparator}assets');
    var projectProperties = File('$cd${Platform.pathSeparator}project.properties');
    var outputDirectory = Directory('$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}')..createSync(recursive: true);
    var screensDirectory = Directory('$cd${Platform.pathSeparator}screens');

    // Initialize archive
    var archive = Archive();

    // Add assets directory to archive
    addDirectoryToArchive(archive, assetsDirectory, 'assets');

    // Add project.properties to archive
    addFileToArchive(archive, projectProperties, 'youngandroidproject/project.properties');

    // Add SCM and BKY files from screens directory to archive
    var scmPath = 'src/com/niotron/${parseYaml.getAuthorName(blockraftYaml)}/${parseYaml.getAppName(blockraftYaml).toLowerCase()}';
    for (var screen in screensDirectory.listSync()) {
      var screenName = screen.path.split(Platform.pathSeparator).last;
      var scmFile = File('${screen.path}${Platform.pathSeparator}$screenName.scm');
      var bkyFile = File('${screen.path}${Platform.pathSeparator}$screenName.bky');

      if (scmFile.existsSync()) {
        addFileToArchive(archive, scmFile, '$scmPath/$screenName.scm');
      }
      if (bkyFile.existsSync()) {
        addFileToArchive(archive, bkyFile, '$scmPath/$screenName.bky');
      }
    }

    // Compress and save as zip
    var zipPath = '$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}.zip';
    var zipFile = File(zipPath);
    zipFile.writeAsBytesSync(ZipEncoder().encode(archive)!);

    // Rename the zip file to .aia
    var aiaPath = zipPath.replaceFirst('.zip', '.aia');
    zipFile.renameSync(aiaPath);

    // Clean up the output directory
    // Directory('$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}').deleteSync(recursive: true);

    print('Successfully created .aia file at $aiaPath');
  }

// Helper function to add a directory to archive
  void addDirectoryToArchive(Archive archive, Directory dir, String basePath) {
    for (var fileEntity in dir.listSync(recursive: true)) {
      if (fileEntity is File) {
        String relativePath = fileEntity.path.replaceFirst(dir.path, basePath);
        addFileToArchive(archive, fileEntity, relativePath);
      }
    }
  }

// Helper function to add a file to archive
  void addFileToArchive(Archive archive, File file, String relativePath) {
    var fileBytes = file.readAsBytesSync();
    var archiveFile = ArchiveFile(relativePath, fileBytes.length, fileBytes);
    archive.addFile(archiveFile);
  }
}
