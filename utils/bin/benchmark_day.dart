import 'dart:async';
import 'dart:io';

const _maxRunTime = Duration(seconds: 60);

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run utils/bin/benchmark_day.dart <year> <day> [--write|-w] [runs]',
    );
    exitCode = 2;
    return;
  }

  final year = args[0].trim();
  final dayStr = args[1].trim();
  final day = int.tryParse(dayStr);
  if (day == null || day < 1 || day > 25) {
    stderr.writeln('Invalid day: "$dayStr". Must be 1-25.');
    exitCode = 2;
    return;
  }

  final dd = day.toString().padLeft(2, '0');
  final shouldWrite = args.contains('--write') || args.contains('-w');
  int runs = 1;
  for (int i = 2; i < args.length; i++) {
    final parsed = int.tryParse(args[i]);
    if (parsed != null && parsed > 0) {
      runs = parsed;
      break;
    }
  }

  final yearDir = _findYearDir(year);
  if (yearDir == null) {
    stderr.writeln('Could not find directory for year "$year".');
    exitCode = 2;
    return;
  }

  final exePath = 'exe/day$dd.bench.exe';
  final compile = await Process.run('dart', [
    'compile',
    'exe',
    'bin/day$dd.dart',
    '-o',
    exePath,
  ], workingDirectory: yearDir.path);

  if (compile.exitCode != 0) {
    print('| $dd❌ | ERR | ERR | ERR | ERR |');
    exitCode = 1;
    return;
  }

  double parseSumUs = 0;
  double part1SumUs = 0;
  double part2SumUs = 0;
  bool sawPart2 = false;

  for (var runIndex = 0; runIndex < runs; runIndex++) {
    final run = await _runWithTimeout(
      './$exePath',
      const [],
      workingDirectory: yearDir.path,
      timeout: _maxRunTime,
    );

    if (run.timedOut) {
      print('| $dd❌ | TIMEOUT | TIMEOUT | TIMEOUT | TIMEOUT |');
      exitCode = 1;
      return;
    }

    if (run.exitCode != 0) {
      print('| $dd❌ | ERR | ERR | ERR | ERR |');
      exitCode = 1;
      return;
    }

    final parsed = _parseTimingOutput(run.stdout);
    if (parsed == null || parsed.parseUs == null || parsed.part1Us == null) {
      print('| $dd❌ | ERR | ERR | ERR | ERR |');
      exitCode = 1;
      return;
    }

    parseSumUs += parsed.parseUs!;
    part1SumUs += parsed.part1Us!;
    if (parsed.part2Us != null) {
      sawPart2 = true;
      part2SumUs += parsed.part2Us!;
    }
  }

  final parseAvgUs = parseSumUs / runs;
  final part1AvgUs = part1SumUs / runs;
  final double part2AvgUs = sawPart2 ? (part2SumUs / runs) : 0.0;
  final totalAvgUs = parseAvgUs + part1AvgUs + part2AvgUs;

  final parseStr = _formatUsCompact(parseAvgUs);
  final part1Str = _formatUsCompact(part1AvgUs);
  final part2Str = sawPart2 ? _formatUsCompact(part2AvgUs) : '-';
  final totalStr = _formatUsCompact(totalAvgUs);
  final dayLabel = '$dd${_dayMarker(totalAvgUs)}';

  final row = '| $dayLabel | $parseStr | $part1Str | $part2Str | $totalStr |';
  print(row);

  if (shouldWrite) {
    final readmeFile = File('${yearDir.path}/README.md');
    final existingReadme = readmeFile.existsSync()
        ? readmeFile.readAsStringSync()
        : '';
    final updatedReadme = _upsertDayInRuntimesTable(existingReadme, day, row);
    readmeFile.writeAsStringSync(updatedReadme);
  }
}

String _upsertDayInRuntimesTable(String doc, int day, String newRow) {
  final runtimesHeader = RegExp(r'^## Runtimes\s*$', multiLine: true);
  final startMatch = runtimesHeader.firstMatch(doc);

  if (startMatch == null) {
    return doc;
  }

  final sectionStart = startMatch.start;
  int sectionEnd = doc.length;
  final h2Header = RegExp(r'^##\s+', multiLine: true);
  for (final match in h2Header.allMatches(doc, startMatch.end)) {
    sectionEnd = match.start;
    break;
  }

  final before = doc.substring(0, sectionStart);
  final after = doc.substring(sectionEnd);
  final runtimesSection = doc.substring(sectionStart, sectionEnd);

  final lines = runtimesSection.split('\n');
  int separatorIdx = -1;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('---') && lines[i].contains('|')) {
      separatorIdx = i;
      break;
    }
  }

  if (separatorIdx == -1) {
    return doc;
  }

  // Parse table rows: extract day number from each row
  final tableRows = <int, String>{};
  final dayRegex = RegExp(r'^\|\s*(\d{2})');
  for (int i = separatorIdx + 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final match = dayRegex.firstMatch(line);
    if (match != null) {
      final rowDay = int.tryParse(match.group(1)!);
      if (rowDay != null) {
        tableRows[rowDay] = line;
      }
    }
  }

  // Insert or replace target day
  tableRows[day] = newRow;

  // Rebuild section in order
  final headerLines = lines.sublist(0, separatorIdx + 1);
  final sortedDays = tableRows.keys.toList()..sort();
  final newLines = [...headerLines, ...sortedDays.map((d) => tableRows[d]!)];

  final newRuntimesSection = newLines.join('\n');
  return '$before$newRuntimesSection\n$after';
}

Directory? _findYearDir(String year) {
  final direct = Directory(year);
  if (direct.existsSync()) {
    return direct;
  }

  final parent = Directory('../$year');
  if (parent.existsSync()) {
    return parent;
  }

  return null;
}

class _ParsedTimings {
  final double? parseUs;
  final double? part1Us;
  final double? part2Us;

  const _ParsedTimings({this.parseUs, this.part1Us, this.part2Us});
}

_ParsedTimings? _parseTimingOutput(String output) {
  final lines = output
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  double? parseUs;
  double? part1Us;
  double? part2Us;

  for (final line in lines) {
    if (line.startsWith('Parse time: ')) {
      final value = line.substring('Parse time: '.length).trim();
      parseUs = _durationToUs(value);
      continue;
    }

    final p1 = RegExp(r'^Part 1 \(([^)]+)\):').firstMatch(line);
    if (p1 != null) {
      part1Us = _durationToUs(p1.group(1)!);
      continue;
    }

    final p2 = RegExp(r'^Part 2 \(([^)]+)\):').firstMatch(line);
    if (p2 != null) {
      part2Us = _durationToUs(p2.group(1)!);
      continue;
    }
  }

  return _ParsedTimings(parseUs: parseUs, part1Us: part1Us, part2Us: part2Us);
}

double? _durationToUs(String s) {
  final normalized = s.replaceAll('µ', 'u').trim();
  final match = RegExp(
    r'^([0-9]+(?:\.[0-9]+)?)(us|ms|s)$',
  ).firstMatch(normalized);
  if (match == null) {
    return null;
  }

  final value = double.tryParse(match.group(1)!);
  final unit = match.group(2)!;
  if (value == null) {
    return null;
  }

  switch (unit) {
    case 'us':
      return value;
    case 'ms':
      return value * 1000.0;
    case 's':
      return value * 1000000.0;
    default:
      return null;
  }
}

String _dayMarker(double totalUs) {
  if (totalUs < 1000.0) {
    return '🟢';
  }
  if (totalUs < 1000000.0) {
    return '🟡';
  }
  return '🔴';
}

String _formatUsCompact(double us) {
  late final double value;
  late final String unit;

  if (us < 1000.0) {
    value = us;
    unit = 'µs';
  } else if (us < 1000000.0) {
    value = us / 1000.0;
    unit = 'ms';
  } else {
    value = us / 1000000.0;
    unit = 's';
  }

  final formatted = _formatWithSigDigits(value, 4);
  return '$formatted$unit';
}

String _formatWithSigDigits(double value, int sigDigits) {
  if (value == 0) {
    return '0';
  }

  final absVal = value.abs();
  final digitsBeforeDecimal = absVal < 1 ? 1 : absVal.toInt().toString().length;
  final decimals = (sigDigits - digitsBeforeDecimal).clamp(0, sigDigits);
  final fixed = value.toStringAsFixed(decimals);

  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

class _RunResult {
  final int exitCode;
  final String stdout;
  final String stderr;
  final bool timedOut;

  const _RunResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.timedOut,
  });
}

Future<_RunResult> _runWithTimeout(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  required Duration timeout,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
  );

  final stdoutFuture = process.stdout.transform(systemEncoding.decoder).join();
  final stderrFuture = process.stderr.transform(systemEncoding.decoder).join();

  var timedOut = false;
  late final int exitCode;
  try {
    exitCode = await process.exitCode.timeout(timeout);
  } on TimeoutException {
    timedOut = true;
    process.kill(ProcessSignal.sigkill);
    exitCode = await process.exitCode;
  }

  return _RunResult(
    exitCode: exitCode,
    stdout: await stdoutFuture,
    stderr: await stderrFuture,
    timedOut: timedOut,
  );
}
