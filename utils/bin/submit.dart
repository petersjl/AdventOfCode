import 'dart:convert';
import 'dart:io';

/// Submits an Advent of Code answer for a given year, day, and part.
/// Requires AOC_TOKEN environment variable for authentication.
///
/// Usage:
///   dart run utils:submit <year> <day> <part>
/// Examples:
///   dart run utils:submit 2023 5 1
///   dart run utils:submit 2024 12 2
Future<void> main(List<String> args) async {
  if (args.length != 3) {
    stderr.writeln('Usage: dart run utils:submit <year> <day> <part>');
    exitCode = 2;
    return;
  }

  final yearStr = args[0].trim();
  final dayStr = args[1].trim();
  final partStr = args[2].trim();

  final year = int.tryParse(yearStr);
  if (year == null) {
    stderr.writeln('Invalid year: "$yearStr". Year must be an integer.');
    exitCode = 2;
    return;
  }

  final maxDay = year > 2024 ? 12 : 25;

  final day = int.tryParse(dayStr);
  if (day == null || day < 1 || day > maxDay) {
    stderr.writeln(
      'Invalid day: "$dayStr". Day must be an integer between 1 and $maxDay.',
    );
    exitCode = 2;
    return;
  }

  final part = int.tryParse(partStr);
  if (part == null || (part != 1 && part != 2)) {
    stderr.writeln('Invalid part: "$partStr". Part must be 1 or 2.');
    exitCode = 2;
    return;
  }

  // Validate AOC_TOKEN
  final token = Platform.environment['AOC_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln('Environment variable AOC_TOKEN is not set.');
    exitCode = 2;
    return;
  }

  // Validate git config.email
  final gitEmailResult = await Process.run('git', ['config', 'user.email']);
  final gitEmail = gitEmailResult.stdout.toString().trim();
  if (gitEmail.isEmpty) {
    stderr.writeln(
      'git config user.email is not set. This is required for the User-Agent header.',
    );
    exitCode = 2;
    return;
  }

  final dayPadded = day.toString().padLeft(2, '0');
  final scriptPath = '$year/bin/day$dayPadded.dart';
  final testPath = 'test/day${dayPadded}_test.dart';

  // Run tests
  stdout.writeln('Running tests for day $dayPadded...');
  final testResult = await Process.run('dart', ['run', '$year/$testPath']);

  final testOutput = testResult.stdout.toString();
  final testStderr = testResult.stderr.toString();

  if (testResult.exitCode != 0) {
    // Check if there are actual failures (not just skips/passes with warnings)
    final hasFailures =
        testOutput.contains('test failed') ||
        testOutput.contains('Some tests failed') ||
        testStderr.contains('test failed') ||
        testStderr.contains('Some tests failed');

    if (hasFailures) {
      stderr.writeln('Tests failed. Aborting submission.');
      stderr.writeln(testOutput);
      if (testStderr.isNotEmpty) stderr.writeln(testStderr);
      exitCode = 1;
      return;
    }
  }

  stdout.writeln('Tests passed.');

  // Run the day solution
  stdout.writeln('Running day $dayPadded...');
  final runResult = await Process.run('dart', [
    'run',
    scriptPath,
  ], workingDirectory: '.');

  if (runResult.exitCode != 0) {
    stderr.writeln('Failed to run day $dayPadded:');
    stderr.writeln(runResult.stderr.toString());
    exitCode = 1;
    return;
  }

  final runOutput = runResult.stdout.toString();

  // Parse the answer for the requested part
  // Output format: "Part 1 (timing): answer"
  final partPattern = RegExp(
    r'^Part ' + part.toString() + r' \([^)]+\): (.*)$',
    multiLine: true,
  );
  final match = partPattern.firstMatch(runOutput);
  if (match == null) {
    stderr.writeln('Could not find Part $part answer in output:');
    stderr.writeln(runOutput);
    exitCode = 1;
    return;
  }

  final answer = match.group(1)!.trim();
  if (answer.isEmpty) {
    stderr.writeln('Part $part produced an empty answer. Aborting submission.');
    exitCode = 1;
    return;
  }
  stdout.writeln('Found answer for Part $part: $answer');

  // Check previous wrong guesses
  final guessesDir = Directory('$year/guesses');
  final guessesFile = File('$year/guesses/day$dayPadded.json');

  if (await guessesFile.exists()) {
    final guessesContent = await guessesFile.readAsString();
    final guessesJson = jsonDecode(guessesContent) as Map<String, dynamic>;
    final partKey = 'part$part';
    final previousGuesses =
        (guessesJson[partKey] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    if (previousGuesses.contains(answer)) {
      stderr.writeln(
        'Answer "$answer" was already submitted and is wrong. Aborting.',
      );
      exitCode = 1;
      return;
    }
  }

  // Submit the answer
  stdout.writeln(
    'Submitting answer "$answer" for year $year, day $day, part $part...',
  );

  final uri = Uri.parse('https://adventofcode.com/$year/day/$day/answer');
  final body = 'level=$part&answer=${Uri.encodeQueryComponent(answer)}';

  final client = HttpClient();
  try {
    final request = await client.postUrl(uri);
    request.headers.set(HttpHeaders.cookieHeader, 'session=$token');
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/x-www-form-urlencoded',
    );
    request.headers.set('User-Agent', gitEmail);
    request.headers.contentLength = utf8.encode(body).length;
    request.write(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    // Extract <main> tag content
    final mainMatch = RegExp(
      r'<main[^>]*>([\s\S]*?)</main>',
      caseSensitive: false,
    ).firstMatch(responseBody);

    final mainContent = mainMatch?.group(1) ?? responseBody;

    // Strip HTML tags
    final plainText = mainContent
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    if (mainContent.contains("That's the right answer")) {
      stdout.writeln('Got the correct answer: $answer');
    } else {
      stderr.writeln('Wrong answer: "$answer"');

      // Save to guesses file
      await guessesDir.create(recursive: true);

      Map<String, dynamic> guessesJson = {};
      if (await guessesFile.exists()) {
        final existing = await guessesFile.readAsString();
        guessesJson = jsonDecode(existing) as Map<String, dynamic>;
      }

      final partKey = 'part$part';
      final List<String> partGuesses =
          (guessesJson[partKey] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      partGuesses.add(answer);
      guessesJson[partKey] = partGuesses;

      await guessesFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(guessesJson),
      );
      stdout.writeln('Saved wrong guess to ${guessesFile.path}');

      stderr.writeln('\n--- AoC Response ---\n$plainText');
      exitCode = 1;
    }
  } on HandshakeException catch (e) {
    stderr.writeln('TLS handshake failed: ${e.message}');
    exitCode = 1;
  } on SocketException catch (e) {
    stderr.writeln('Network error: ${e.message}');
    exitCode = 1;
  } catch (e) {
    stderr.writeln('Unexpected error: $e');
    exitCode = 1;
  } finally {
    client.close(force: true);
  }
}
