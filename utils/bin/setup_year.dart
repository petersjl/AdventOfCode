import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run utils/bin/setup_year.dart <year>');
    exitCode = 2;
    return;
  }

  final year = args[0].trim();
  if (!RegExp(r'^\d{4}$').hasMatch(year)) {
    stderr.writeln('Invalid year: "$year". Expected a 4-digit year.');
    exitCode = 2;
    return;
  }

  final yearDir = Directory(year);
  if (!yearDir.existsSync()) {
    yearDir.createSync(recursive: true);
    stdout.writeln('Created ${yearDir.path}');
  } else {
    stdout.writeln('Directory "${yearDir.path}" already exists.');
  }

  for (final subDir in const ['bin', 'inputs', 'test', 'test_inputs']) {
    final dir = Directory('${yearDir.path}/$subDir');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      stdout.writeln('Created ${dir.path}');
    } else {
      stdout.writeln('Directory "${dir.path}" already exists.');
    }
  }

  final pubspecFile = File('${yearDir.path}/pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    pubspecFile.writeAsStringSync('''name: AOC$year
publish_to: none
environment:
  sdk: ^3.10.0
resolution: workspace
dependencies:
  utils:
    path: ../utils
''');
    stdout.writeln('Created ${pubspecFile.path}');
  } else {
    stdout.writeln('File "${pubspecFile.path}" already exists.');
  }

  final readmeFile = File('${yearDir.path}/README.md');
  if (!readmeFile.existsSync()) {
    readmeFile.writeAsStringSync('''# $year

## Calendar

- [Day 1: ](https://adventofcode.com/$year/day/1)
''');
    stdout.writeln('Created ${readmeFile.path}');
  } else {
    stdout.writeln('File "${readmeFile.path}" already exists.');
  }

  final workspacePubspec = _findWorkspacePubspec();
  if (workspacePubspec == null) {
    stderr.writeln(
      'Could not find a root pubspec.yaml with a workspace section.',
    );
  } else {
    final updated = _upsertYearInWorkspace(workspacePubspec, year);
    if (updated) {
      stdout.writeln('Updated ${workspacePubspec.path} workspace list.');
    } else {
      stdout.writeln('Workspace list already contains $year in sorted order.');
    }
  }

  stdout.writeln('Running day 1 setup...');
  final setupDayOne = await Process.run('dart', [
    'run',
    './utils/bin/setup.dart',
    year,
    '1',
  ]);

  if (setupDayOne.stdout.toString().isNotEmpty) {
    stdout.write(setupDayOne.stdout);
  }
  if (setupDayOne.stderr.toString().isNotEmpty) {
    stderr.write(setupDayOne.stderr);
  }

  if (setupDayOne.exitCode != 0) {
    stderr.writeln(
      'Day 1 setup failed with exit code ${setupDayOne.exitCode}.',
    );
    exitCode = setupDayOne.exitCode;
    return;
  }

  stdout.writeln('Year $year setup complete.');
}

File? _findWorkspacePubspec() {
  var dir = Directory.current.absolute;

  while (true) {
    final candidate = File('${dir.path}/pubspec.yaml');
    if (candidate.existsSync()) {
      final content = candidate.readAsStringSync();
      if (content.contains(RegExp(r'^workspace:\s*$', multiLine: true))) {
        return candidate;
      }
    }

    final parent = dir.parent;
    if (parent.path == dir.path) {
      return null;
    }
    dir = parent;
  }
}

bool _upsertYearInWorkspace(File pubspecFile, String year) {
  final original = pubspecFile.readAsStringSync();
  final lines = original.split('\n');

  final workspaceIndex = lines.indexWhere(
    (line) => RegExp(r'^workspace:\s*$').hasMatch(line),
  );

  if (workspaceIndex == -1) {
    final updated = original.trimRight() + '\nworkspace:\n  - "$year"\n';
    pubspecFile.writeAsStringSync(updated);
    return true;
  }

  int firstItem = workspaceIndex + 1;
  while (firstItem < lines.length && lines[firstItem].trim().isEmpty) {
    firstItem++;
  }

  int endExclusive = firstItem;
  while (endExclusive < lines.length &&
      RegExp(r'^\s*-\s+').hasMatch(lines[endExclusive])) {
    endExclusive++;
  }

  final entries = <String>[];
  final itemPattern = RegExp('^\\s*-\\s*(?:"([^"]+)"|([^\\s#]+))');
  for (var i = firstItem; i < endExclusive; i++) {
    final match = itemPattern.firstMatch(lines[i]);
    if (match == null) {
      continue;
    }
    final value = match.group(1) ?? match.group(2);
    if (value != null && value.isNotEmpty) {
      entries.add(value);
    }
  }

  final years = <String>{
    ...entries.where((e) => RegExp(r'^\d{4}$').hasMatch(e)),
    year,
  }.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

  final others = entries.where((e) => !RegExp(r'^\d{4}$').hasMatch(e)).toList();

  final rebuilt = <String>[
    ...years.map((y) => '  - "$y"'),
    ...others.map((e) => '  - $e'),
  ];

  final updatedLines = <String>[
    ...lines.sublist(0, firstItem),
    ...rebuilt,
    ...lines.sublist(endExclusive),
  ];

  final updated = updatedLines.join('\n');
  if (updated == original) {
    return false;
  }

  pubspecFile.writeAsStringSync(updated);
  return true;
}
