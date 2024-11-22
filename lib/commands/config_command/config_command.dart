import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';

import '../../helpers/config/parsing_yaml.dart';

class ConfigCommand extends Command {
  final String cd;

  ConfigCommand(this.cd);

  @override
  String get description => 'Re-configures the project';

  @override
  String get name => 'config';

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
      ..writeLine('   blockraft config  ');
  }

  @override
  Future<void> run() async {
    PrintArt();
    try {
      File blockraftYamlFile = File(
          '$cd${Platform.pathSeparator}blockraft.yaml');
      Directory homeDirectory = Directory(cd);
      parseYaml(blockraftYamlFile, homeDirectory);
    } catch(e){
      printUsage();
      exit(64);
    }
    Console()
      ..setForegroundColor(ConsoleColor.green)
      ..writeLine()
      ..write('• ')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('Success! ')
      ..resetColorAttributes()
      ..write('blockraft.yaml file is configured successfully :)')
      ..writeLine();

  }
  void parseYaml(File blockraftYamlFile, Directory homeDirectory) async{
    var parsingYaml = ParsingYaml(homeDirectory);
    var config = await parsingYaml.loadConfig(blockraftYamlFile);
    parsingYaml.createScreens(config);
    parsingYaml.handleExtensions(config);
  }
}