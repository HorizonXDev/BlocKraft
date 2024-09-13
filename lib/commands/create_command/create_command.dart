
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:blockraft/file_templates/blockraft_yaml.dart';
import 'package:blockraft/file_templates/project_properties.dart';
import 'package:blockraft/file_templates/scm_content.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';

import '../../helpers/simple_question.dart';

class CreateCommand extends Command{
  final String _cd;

  CreateCommand(this._cd){
    argParser
      ..addOption('name', abbr: 'n', help: 'The name of the project you want to create')
      ..addOption('package', abbr: 'p', help: 'The package name of the project you want to create')
      ..addOption('developer', abbr: 'd', help: 'The developer name of the project you want to create')
      ..addOption('description', abbr: 'u', help: 'The description of the project you want to create')
      ..addOption('builder', abbr: 'b', help: 'The builder name of the project you want to create. Default is n for Niotron, k for Kodular, m for MIT AI2');
  }
  @override
  String get description => 'Creates a new project for AI2 applications';

  @override
  String get name => 'create';

  @override
  void printUsage() {
    PrintArt();

    Console()
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   create: ')
      ..resetColorAttributes()
      ..writeLine('   $description')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   Usage:')
      ..resetColorAttributes()
      ..writeLine('   blockraft create <project-name> <args>(optional)');
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 1) {
      printUsage();
      exit(64);
    }

    PrintArt();
    String appName;
    final String package;
    final String developerName;
    final String builder;
    final String description;


    if (argResults!['builder'] != null) {
      builder = argResults!['builder'].toString().trim();
      if(builder.toString() != 'n') {
        Console()
          ..setForegroundColor(ConsoleColor.red)
          ..write('• ')
          ..setForegroundColor(ConsoleColor.brightRed)
          ..write('Error! ')
          ..resetColorAttributes()
          ..write('Please provide the correct builder name')
          ..writeLine()
          ..setForegroundColor(ConsoleColor.green)
          ..write('• blockraft create [App Name] -b {builder code}');
        exit(64);
      }
    } else {
      Console()
        ..setForegroundColor(ConsoleColor.red)
        ..write('• ')
        ..setForegroundColor(ConsoleColor.brightRed)
        ..write('Error! ')
        ..resetColorAttributes()
        ..write('Please provide the builder name')
        ..writeLine()
        ..setForegroundColor(ConsoleColor.green)
        ..write('• blockraft create [App Name] -b {builder code}');
      exit(64);
    }

    if (argResults!['name'] == null) {
      appName = SimpleQuestion(question: 'App Name').ask();
    } else {
      appName = argResults!['name'].toString().trim();
    }

    if (argResults!['package'] == null) {
      package = SimpleQuestion(question: 'Package Name').ask();
    } else {
      package = argResults!['package'].toString().trim();
    }

    if (argResults!['developer'] == null) {
      developerName = SimpleQuestion(question: 'Author Name').ask();
    } else {
      developerName = argResults!['developer'].toString().trim();
    }

    if (argResults!['description'] == null) {
      description = SimpleQuestion(question: 'Description').ask();
    } else {
      description = argResults!['description'].toString().trim();
    }

    var projectProperties = ProjectProperties(appName, package, developerName);

    // Create project.properties file
    var homeDirectory = Directory('$_cd\\$appName')..createSync(recursive: true);
    print(homeDirectory);
    var assetsDirectory = Directory('${homeDirectory.path}\\assets')..createSync(recursive: true);
    var extDirectory = Directory('${homeDirectory.path}\\extensions')..createSync(recursive: true);
    var screensDirectory = Directory('${homeDirectory.path}\\screens')..createSync(recursive: true);
    var componentsDirectory = Directory('${homeDirectory.path}\\components')..createSync(recursive: true);
    var outputDirectory = Directory('${homeDirectory.path}\\output')..createSync(recursive: true);

    final String blockraftYamlPath = '${homeDirectory.path}\\blockraft.yaml';
    final String propertiesPath = '${homeDirectory.path}\\project.properties';
    final String screen1ScmPath = '${homeDirectory.path}\\screens\\Screen1\\Screen1.scm';

    File blockraftYamlFile = File(blockraftYamlPath)..createSync(recursive: true);
    File propertiesFile = File(propertiesPath)..createSync(recursive: true);
    File screen1ScmFile = File(screen1ScmPath)..createSync(recursive: true);


    blockraftYamlFile.writeAsString(BlockraftYamlContent(appName, developerName, description).content);
    propertiesFile.writeAsString(projectProperties.getContentForNiotron());
    screen1ScmFile.writeAsString(ScmContent('Screen1', appName).content);

    Console()
      ..setForegroundColor(ConsoleColor.green)
      ..writeLine()
      ..write('• ')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('Success! ')
      ..resetColorAttributes()
      ..write('Generated Project at $_cd\\$appName\\')
      ..writeLine();
  }
}