import 'dart:io';
import 'dart:convert';

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

  // Fetch puzzle title and update README
  final year = _extractYear(dir);
  if (year != null) {
    await _updateReadmeWithPuzzleTitle(dir, year, dayNum);
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

int? _extractYear(String dir) {
  final trimmed = dir.trim();
  final parts = trimmed
      .split(RegExp(r'[\\/]'))
      .where((part) => part.isNotEmpty);
  final lastPart = parts.isEmpty ? trimmed : parts.last;
  return int.tryParse(lastPart);
}

Future<void> _updateReadmeWithPuzzleTitle(
  String dir,
  int year,
  int dayNum,
) async {
  try {
    // Fetch the puzzle title
    final title = await _fetchPuzzleTitle(year, dayNum);
    if (title == null) {
      print('Could not fetch puzzle title for day $dayNum');
      return;
    }

    // Update README
    final readmeFile = File('$dir/README.md');
    if (!await readmeFile.exists()) {
      print('README.md does not exist.');
      return;
    }

    String readmeContent = await readmeFile.readAsString();

    // Find or create Calendar section
    final calendarRegex = RegExp(
      r'## Calendar\n\n((?:- \[Day \d+:.*?\]\(.+?\)\n?)*)',
      multiLine: true,
    );
    final match = calendarRegex.firstMatch(readmeContent);

    if (match == null) {
      print('Could not find Calendar section in README.md');
      return;
    }

    // Parse existing days
    final dayEntries = <int, String>{};
    final dayPattern = RegExp(
      r'- \[Day (\d+): ([^\]]+)\]\(https://adventofcode\.com/\d+/day/(\d+)\)',
    );

    for (final m in dayPattern.allMatches(match.group(1)!)) {
      final day = int.parse(m.group(1)!);
      final dayName = m.group(2)!;
      dayEntries[day] = dayName;
    }

    // Add or update the new day
    dayEntries[dayNum] = title;

    // Build the new calendar list
    final sortedDays = dayEntries.keys.toList()..sort();
    final calendarList = sortedDays
        .map(
          (day) =>
              '- [Day $day: ${dayEntries[day]}](https://adventofcode.com/$year/day/$day)',
        )
        .join('\n');

    // Replace the calendar section
    final newCalendarSection = '## Calendar\n\n$calendarList\n';
    final oldCalendarSection = match.group(0)!;

    readmeContent = readmeContent.replaceFirst(
      oldCalendarSection,
      newCalendarSection,
    );
    await readmeFile.writeAsString(readmeContent);

    print('Updated README.md with puzzle title: Day $dayNum: $title');
  } catch (e) {
    print('Error updating README: $e');
  }
}

Future<String?> _fetchPuzzleTitle(int year, int day) async {
  try {
    final uri = Uri.parse('https://adventofcode.com/$year/day/$day');
    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        return null;
      }

      final body = await response.transform(utf8.decoder).join();

      // Extract h2 from first article
      final articleRegex = RegExp(
        r'<article[^>]*>[\s\S]*?<h2[^>]*>([^<]*)</h2>',
        caseSensitive: false,
      );
      final match = articleRegex.firstMatch(body);

      if (match == null) {
        return null;
      }

      final h2Content = match.group(1)!;

      // Extract name from "--- Day N: Name ---"
      final nameRegex = RegExp(r'^---\s+Day\s+\d+:\s+(.+?)\s+---$');
      final nameMatch = nameRegex.firstMatch(h2Content);

      return nameMatch?.group(1);
    } finally {
      client.close(force: true);
    }
  } catch (e) {
    return null;
  }
}
