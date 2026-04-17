import 'dart:io';

void main(List<String> args) async {
  if (args.length != 2) {
    print('Usage: dart setup.dart <directory> <day_number>');
    exit(1);
  }

  final dir = args[0];
  final directory = Directory(dir);
  if (!directory.existsSync()) {
    print('Directory "$dir" does not exist.');
    exit(1);
  }

  final maxDay = _maxDayForDirectory(dir);
  final dayStr = args[1].trim();
  final dayNum = int.tryParse(dayStr);
  if (dayNum == null || dayNum < 1 || dayNum > maxDay) {
    print('Invalid day: "$dayStr". Must be an integer between 1 and $maxDay.');
    exit(1);
  }
  final day = dayNum.toString().padLeft(2, '0');

  final binPath = '$dir/bin/day$day.dart';
  final testPath = '$dir/test/day${day}_test.dart';
  final inputPath = '$dir/inputs/day$day.txt';
  final testInputPath = '$dir/test_inputs/day${day}-A.txt';
  final solutionTemplate = 'utils/bin/templates/solution.dart';
  final testTemplate = 'utils/bin/templates/test.dart';

  if (File(binPath).existsSync()) {
    print('File "$binPath" already exists.');
    exit(0);
  }

  // Copy solution template
  await File(solutionTemplate).copy(binPath);
  print('Created $binPath');

  // Replace {day_num} in solution file
  final binFile = File(binPath);
  String binContent = await binFile.readAsString();
  binContent = binContent.replaceAll('{day_num}', day);
  await binFile.writeAsString(binContent);

  // Copy test template and add import
  final testContent = await File(testTemplate).readAsString();
  final importLine = "import '../bin/day$day.dart' hide main;\n";
  await File(testPath).writeAsString(importLine + testContent);
  print('Created $testPath');

  // Replace {day_num} in test file
  final testFile = File(testPath);
  String testFileContent = await testFile.readAsString();
  testFileContent = testFileContent.replaceAll('{day_num}', day);
  await testFile.writeAsString(testFileContent);

  // Create empty input files
  if (!File(inputPath).existsSync()) {
    await File(inputPath).writeAsString('');
    print('Created $inputPath');
  } else {
    print('File "$inputPath" already exists.');
  }
  if (!File(testInputPath).existsSync()) {
    await File(testInputPath).writeAsString('');
    print('Created $testInputPath');
  } else {
    print('File "$testInputPath" already exists.');
  }
}

int _maxDayForDirectory(String dir) {
  final trimmed = dir.trim();
  final parts = trimmed
      .split(RegExp(r'[\\/]'))
      .where((part) => part.isNotEmpty);
  final lastPart = parts.isEmpty ? trimmed : parts.last;
  final year = int.tryParse(lastPart);
  return year != null && year > 2024 ? 12 : 25;
}
