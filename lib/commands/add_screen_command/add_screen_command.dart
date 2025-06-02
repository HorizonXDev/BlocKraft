import 'package:args/command_runner.dart';
import 'package:blockraft/helpers/print_art.dart';
import 'package:dart_console/dart_console.dart';

class AddScreenCommand extends Command{

  String _cd;
  AddScreenCommand(this._cd) {
    argParser
      .addOption('template', abbr: 't', help: 'The selected templated will be used to create the screen');
  }

  @override
  String get description => 'Adds new screen to the project';

  @override
  String get name => 'new-screen';

   @override
  void printUsage() {
    PrintArt();

    Console()
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   new-screen: ')
      ..resetColorAttributes()
      ..writeLine('   $description')
      ..setForegroundColor(ConsoleColor.brightGreen)
      ..write('   Usage:')
      ..resetColorAttributes()
      ..writeLine('   blockraft new-screen <screen-name> [--template <template>]');
  }

  @override
  Future<void> run() async{}
}