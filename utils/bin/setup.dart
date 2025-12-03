import 'dart:io';

void main(List<String> args) async {
  if (args.length != 2) {
    print('Usage: dart setup.dart <directory> <day_number>');
    exit(1);
  }

  final dir = args[0];
  final day = args[1].padLeft(2, '0');

  final directory = Directory(dir);
  if (!directory.existsSync()) {
    print('Directory $dir does not exist.');
    exit(1);
  }

  final binPath = '$dir/bin/Day$day.dart';
  final testPath = '$dir/test/Day${day}_test.dart';
  final inputPath = '$dir/inputs/Day$day.txt';
  final testInputPath = '$dir/test_inputs/Day${day}-A.txt';
  final solutionTemplate = 'utils/bin/templates/solution.dart';
  final testTemplate = 'utils/bin/templates/test.dart';

  if (File(binPath).existsSync()) {
    print('File $binPath already exists.');
    exit(0);
  }

  // Copy solution template
  await File(solutionTemplate).copy(binPath);
  print('Created $binPath');

  // Copy test template and add import
  final testContent = await File(testTemplate).readAsString();
  final importLine = "import '../bin/Day$day.dart' hide main;\n";
  await File(testPath).writeAsString(importLine + testContent);
  print('Created $testPath');

  // Create empty input files
  await File(inputPath).writeAsString('');
  print('Created $inputPath');
  await File(testInputPath).writeAsString('');
  print('Created $testInputPath');
}
