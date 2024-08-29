
import 'dart:io';

import 'package:args/command_runner.dart';
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
      ..addOption('package', abbr: 'p', help: 'The package name of the project you want to create');
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

    final String propertiesPath = '$_cd\\$appName\\youngandroidproject\\project.properties';
    File file = File(propertiesPath)..createSync(recursive: true);
    file.writeAsString(ProjectProperties(appName, package).content);
    List<String> packagePath = package.split('.');
    String scmPathContent = '';
    for(String pth in packagePath){
      scmPathContent = '$scmPathContent\\$pth';
    }
    final String scmPath = '$_cd\\$appName\\src\\$scmPathContent\\$appName\\Screen1.scm';
    File mfile = File(scmPath)..createSync(recursive: true);
    mfile.writeAsString(ScmContent('Screen1', appName).content);

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