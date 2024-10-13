import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:args/command_runner.dart';
import 'package:blockraft/helpers/config/parsing_yaml.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';
import 'package:yaml/yaml.dart';

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

  void compileAia(ParsingYaml parseYaml, YamlMap blockraftYaml){
    var assetsDirectory = Directory('$cd${Platform.pathSeparator}assets');
    var projectProperties = File('$cd${Platform.pathSeparator}project.properties');
    var outputDirectory = Directory('$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}')..createSync(recursive: true);
    var screensDirectory = Directory('$cd${Platform.pathSeparator}screens');

    // Copy assets directory
    var outputAssetsDirectory = Directory('${outputDirectory.path}${Platform.pathSeparator}assets')..createSync(recursive: true);
    for (var file in assetsDirectory.listSync(recursive: true)) {
      if (file is File) {
        var relativePath = file.path.replaceFirst(assetsDirectory.path, '');
        var newFile = File('${outputAssetsDirectory.path}$relativePath')..createSync(recursive: true);
        newFile.writeAsBytesSync(file.readAsBytesSync());
      }
    }

    // Copy project.properties file
    var youngAndroidProjectDirectory = Directory('${outputDirectory.path}${Platform.pathSeparator}youngandroidproject')..createSync(recursive: true);
    var outputProjectProperties = File('${youngAndroidProjectDirectory.path}${Platform.pathSeparator}project.properties')..createSync(recursive: true);
    outputProjectProperties.writeAsBytesSync(projectProperties.readAsBytesSync());

    // Copy SCM files
    var outputScmDirectory = Directory('${outputDirectory.path}${Platform.pathSeparator}src${Platform.pathSeparator}com${Platform.pathSeparator}niotron${Platform.pathSeparator}${parseYaml.getAuthorName(blockraftYaml)}${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}')..createSync(recursive: true);
    for (var screen in screensDirectory.listSync()) {
      var scmPath = '${screen.path}${Platform.pathSeparator}${screen.path.split(Platform.pathSeparator).last}.scm';
      var scmFile = File(scmPath);
      if (scmFile.existsSync()) {
        var relativePath = '${screen.path.split(Platform.pathSeparator).last}.scm';
        var newFile = File('${outputScmDirectory.path}$relativePath')..createSync(recursive: true);
        newFile.writeAsBytesSync(scmFile.readAsBytesSync());
      }
    }

    // Create a zip archive
    var encoder = ZipFileEncoder();
    var zipPath = '$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}.zip';
    encoder.create(zipPath);

    // Add specific directories to the zip archive
    encoder.addDirectory(Directory('${outputDirectory.path}${Platform.pathSeparator}youngandroidproject'));
    encoder.addDirectory(Directory('${outputDirectory.path}${Platform.pathSeparator}src'));
    encoder.addDirectory(Directory('${outputDirectory.path}${Platform.pathSeparator}assets'));

    encoder.close();

    // Rename the zip file to .aia
    var zipFile = File(zipPath);
    var aiaPath = zipPath.replaceFirst('.zip', '.aia');
    zipFile.renameSync(aiaPath);
    Directory('$cd${Platform.pathSeparator}output${Platform.pathSeparator}${parseYaml.getAppName(blockraftYaml)}').delete(recursive: true);
  }
}
