import 'dart:async';
import 'dart:io';

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

    final result = await Process.run('dart', [
      'run',
      './utils/bin/benchmark_day.dart',
      year,
      dd,
      runs.toString(),
    ], workingDirectory: yearDir.parent.path);

    if (result.exitCode != 0) {
      await writeLine('| $dd❌ | ERR | ERR | ERR | ERR |');
      stderr.writeln('Failed to benchmark day $dd.');
      if (result.stderr.toString().isNotEmpty) {
        stderr.writeln(result.stderr.toString().trim());
      }
      continue;
    }

    final row = result.stdout.toString().trim();
    await writeLine(row);

    // Extract total time from row to accumulate year total
    // Row format: | DD[emoji] | parseTime | part1Time | part2Time | totalTime |
    final parts = row.split('|');
    if (parts.length >= 6) {
      final totalStr = parts[5].trim();
      final totalUs = _parseCompactTime(totalStr);
      if (totalUs != null) {
        totalYearUs += totalUs;
      }
    }
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

double? _parseCompactTime(String timeStr) {
  // Convert µ to u for consistency with _durationToUs
  return _durationToUs(timeStr.replaceAll('µ', 'u'));
}
