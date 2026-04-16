import 'dart:async';
import 'dart:io';

const _maxRunTime = Duration(seconds: 60);

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.length > 2) {
    stderr.writeln(
      'Usage: dart run utils/bin/benchmark_year.dart <year> [runs]',
    );
    exitCode = 2;
    return;
  }

  final year = args[0].trim();
  final runs = args.length == 2 ? int.tryParse(args[1]) : 3;
  if (runs == null || runs <= 0) {
    stderr.writeln(
      'Invalid runs value: "${args[1]}". Must be a positive integer.',
    );
    exitCode = 2;
    return;
  }

  final yearDir = _findYearDir(year);
  if (yearDir == null) {
    stderr.writeln('Could not find directory for year "$year".');
    exitCode = 2;
    return;
  }

  final rows = <String>[];

  Future<void> writeLine(String line) async {
    rows.add(line);
    stdout.writeln(line);
  }

  final binDir = Directory('${yearDir.path}/bin');
  if (!binDir.existsSync()) {
    stderr.writeln('No bin directory found at ${binDir.path}.');
    exitCode = 2;
    return;
  }

  final dayFiles =
      binDir
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.isEmpty ? '' : f.uri.pathSegments.last)
          .map(_extractDay)
          .whereType<int>()
          .toList()
        ..sort();

  if (dayFiles.isEmpty) {
    stderr.writeln('No day files found in ${binDir.path}.');
    exitCode = 2;
    return;
  }

  await writeLine('| Day | Parse | Part 1 | Part 2 | Total |');
  await writeLine('| --- | ---: | ---: | ---: | ---: |');

  double totalYearUs = 0;

  for (final day in dayFiles) {
    final dd = day.toString().padLeft(2, '0');
    stderr.writeln(
      'Benchmarking $year day $dd ($runs run${runs == 1 ? '' : 's'})...',
    );

    final exePath = 'exe/day$dd.bench.exe';
    final compile = await Process.run('dart', [
      'compile',
      'exe',
      'bin/day$dd.dart',
      '-o',
      exePath,
    ], workingDirectory: yearDir.path);

    if (compile.exitCode != 0) {
      await writeLine('| $dd❌ | ERR | ERR | ERR | ERR |');
      stderr.writeln('Compile failed for day $dd.');
      stderr.writeln((compile.stderr as String).trim());
      continue;
    }

    double parseSumUs = 0;
    double part1SumUs = 0;
    double part2SumUs = 0;
    bool sawPart2 = false;
    bool failed = false;
    bool timedOut = false;

    for (var runIndex = 0; runIndex < runs; runIndex++) {
      final run = await _runWithTimeout(
        './$exePath',
        const [],
        workingDirectory: yearDir.path,
        timeout: _maxRunTime,
      );

      if (run.timedOut) {
        timedOut = true;
        stderr.writeln(
          'Run ${runIndex + 1}/$runs timed out for day $dd after ${_maxRunTime.inSeconds}s.',
        );
        break;
      }

      if (run.exitCode != 0) {
        failed = true;
        stderr.writeln('Run ${runIndex + 1}/$runs failed for day $dd.');
        stderr.writeln(run.stderr.trim());
        break;
      }

      final parsed = _parseTimingOutput(run.stdout);
      if (parsed == null || parsed.parseUs == null || parsed.part1Us == null) {
        failed = true;
        stderr.writeln(
          'Could not parse timing output for day $dd run ${runIndex + 1}.',
        );
        stderr.writeln(run.stdout.trim());
        break;
      }

      parseSumUs += parsed.parseUs!;
      part1SumUs += parsed.part1Us!;
      if (parsed.part2Us != null) {
        sawPart2 = true;
        part2SumUs += parsed.part2Us!;
      }
    }

    if (timedOut) {
      await writeLine('| $dd❌ | TIMEOUT | TIMEOUT | TIMEOUT | TIMEOUT |');
      continue;
    }

    if (failed) {
      await writeLine('| $dd❌ | ERR | ERR | ERR | ERR |');
      continue;
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
    totalYearUs += totalAvgUs;

    await writeLine(
      '| $dayLabel | $parseStr | $part1Str | $part2Str | $totalStr |',
    );
  }

  // Keep full table in memory for future reuse/serialization by this script.
  final tableMarkdown = rows.join('\n');
  if (tableMarkdown.isEmpty) {
    stderr.writeln('No benchmark rows generated.');
    return;
  }

  final totalYearRuntime = _formatUsCompact(totalYearUs);
  final runWord = runs == 1 ? 'run' : 'runs';
  final runtimesBlock =
      '## Runtimes\n\n'
      'Total year runtime: $totalYearRuntime\n\n'
      'The following table has been run as an average of $runs $runWord.\n\n'
      'Legend: 🟢 < 1ms, 🟡 < 1s, 🔴 >= 1s\n\n'
      '$tableMarkdown\n';

  final readmeFile = File('${yearDir.path}/README.md');
  final existingReadme = readmeFile.existsSync()
      ? readmeFile.readAsStringSync()
      : '';
  final updatedReadme = _upsertRuntimesSection(existingReadme, runtimesBlock);
  readmeFile.writeAsStringSync(updatedReadme);
  stderr.writeln('Updated ${readmeFile.path} with benchmark runtimes.');
}

String _upsertRuntimesSection(String doc, String runtimesBlock) {
  final runtimesHeader = RegExp(r'^## Runtimes\s*$', multiLine: true);
  final startMatch = runtimesHeader.firstMatch(doc);

  if (startMatch == null) {
    if (doc.trim().isEmpty) {
      return '$runtimesBlock\n';
    }

    final separator = doc.endsWith('\n') ? '\n' : '\n\n';
    return '$doc$separator$runtimesBlock\n';
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
  return '$before$runtimesBlock\n$after';
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

int? _extractDay(String fileName) {
  final match = RegExp(r'^day(\d{2})\.dart$').firstMatch(fileName);
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(1)!);
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

  // Trim trailing zeros and dangling decimal point for readability.
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
