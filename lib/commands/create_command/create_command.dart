import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:blockraft/file_templates/blockraft_yaml.dart';
import 'package:blockraft/file_templates/project_properties.dart';
import 'package:blockraft/helpers/config/parsing_yaml.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';

import '../../helpers/question/simple_question.dart';

class CreateCommand extends Command {
  final String _cd;

  CreateCommand(this._cd) {
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
    final String appName = _getArgument('name', 'App Name');
    final String package = _getArgument('package', 'Package Name');
    final String developerName = _getArgument('developer', 'Author Name');
    final String description = _getArgument('description', 'Description');
    String? builder = _getBuilder();

    _createProject(appName, package, developerName, description, builder!);
  }

  String _getArgument(String argName, String question) {
    return argResults![argName]?.toString().trim() ?? SimpleQuestion(question: question).ask();
  }

  String? _getBuilder() {
    final builder = argResults!['builder']?.toString().trim();
    if (builder == null || builder != 'n') {
      _printError('Please provide the correct builder name');
    }
    return builder;
  }

  void _printError(String message) {
    Console()
      ..setForegroundColor(ConsoleColor.red)
      ..write('• ')
      ..setForegroundColor(ConsoleColor.brightRed)
      ..write('Error! ')
      ..resetColorAttributes()
      ..write(message)
      ..writeLine()
      ..setForegroundColor(ConsoleColor.green)
      ..write('• blockraft create <App Name> -b <builder code>');
    exit(64);
  }

  File createBlockraftYaml(Directory homeDirectory, String appName, String developerName, String packageName){
    //Creating the main blockraft.yaml file
    final blockraftYamlPath = '${homeDirectory.path}\\blockraft.yaml';
    final blockraftYamlFile = File(blockraftYamlPath)..createSync(recursive: true);
    blockraftYamlFile.writeAsString(BlockraftYamlContent(appName, developerName, description, packageName).content);

    return blockraftYamlFile;
  }

  void parseYaml(File blockraftYamlFile, Directory homeDirectory) async{
    var parsingYaml = ParsingYaml(homeDirectory);
    var config = await parsingYaml.loadConfig(blockraftYamlFile);
    parsingYaml.createScreens(config);
    parsingYaml.handleExtensions(config);
  }

  Future<void> _createProject(String appName, String package, String developerName, String description, String builder) async {
    final homeDirectory = Directory('$_cd\\$appName')..createSync(recursive: true);

    var blockraftYamlFile = createBlockraftYaml(homeDirectory, appName, developerName, package);

    final projectProperties = ProjectProperties(appName, package, developerName);
    parseYaml(blockraftYamlFile, homeDirectory);

    // Creating Assets and Extensions Directory...
    Directory('${homeDirectory.path}\\assets').createSync(recursive: true);
    Directory('${homeDirectory.path}\\extensions').createSync(recursive: true);

    // Creating project.properties file
    final propertiesPath = '${homeDirectory.path}\\project.properties';
    final propertiesFile = File(propertiesPath)..createSync(recursive: true);
    if(builder == 'n') {
      propertiesFile.writeAsString(projectProperties.getContentForNiotron());
    }
    else if(builder == 'k'){
      // TODO: Properties file's content for Kodular
    }
    else if(builder == 'm'){
      // TODO: Properties file's content for MIT App Inventor
    }

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