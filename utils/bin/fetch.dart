import 'dart:io';
import 'dart:convert';

/// Fetches Advent of Code input for a given year and day using AOC_TOKEN
/// from the environment, and saves it under `{year}/inputs/day{day}.txt`.
///
/// Usage:
///   dart run utils:fetch <year> [day]
/// Examples:
///   dart run utils:fetch 2025 9
///   dart run utils:fetch 2025
Future<void> main(List<String> args) async {
  if (args.isEmpty || args.length > 2) {
    stderr.writeln('Usage: dart run utils:fetch <year> [day]');
    exitCode = 2;
    return;
  }

  final yearStr = args[0].trim();
  final year = int.tryParse(yearStr);
  if (year == null) {
    stderr.writeln('Invalid year: "$yearStr". Year must be an integer.');
    exitCode = 2;
    return;
  }

  final maxDay = year > 2024 ? 12 : 25;

  final token = Platform.environment['AOC_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln('Environment variable AOC_TOKEN is not set.');
    exitCode = 2;
    return;
  }

  final List<int> days;
  if (args.length == 2) {
    final dayStr = args[1].trim();
    final day = int.tryParse(dayStr);
    if (day == null || day < 1 || day > maxDay) {
      stderr.writeln(
        'Invalid day: "$dayStr". Day must be an integer between 1 and $maxDay.',
      );
      exitCode = 2;
      return;
    }
    days = [day];
  } else {
    days = List.generate(maxDay, (i) => i + 1);
  }

  final client = HttpClient();
  client.userAgent = 'utils-fetch-script (Dart)';

  try {
    for (final day in days) {
      await _fetchDay(client, token, year, day);
    }
  } finally {
    client.close(force: true);
  }
}

Future<void> _fetchDay(
  HttpClient client,
  String token,
  int year,
  int day,
) async {
  final uri = Uri.parse('https://adventofcode.com/$year/day/$day/input');

  try {
    final request = await client.getUrl(uri);
    // AoC uses the session cookie for authentication.
    request.headers.set(HttpHeaders.cookieHeader, 'session=$token');
    final response = await request.close();

    if (response.statusCode != 200) {
      final body = await response.transform(utf8.decoder).join();
      stderr.writeln('Failed to fetch day $day: HTTP ${response.statusCode}');
      if (body.isNotEmpty) {
        stderr.writeln(body);
      }
      exitCode = 1;
      return;
    }

    final inputText = await response.transform(utf8.decoder).join();

    // Build destination path: {year}/inputs/day{DD}.txt
    final dayPadded = day.toString().padLeft(2, '0');
    final inputsDir = Directory('$year/inputs');
    if (!await inputsDir.exists()) {
      await inputsDir.create(recursive: true);
    }
    final outFile = File('${inputsDir.path}/day$dayPadded.txt');
    await outFile.writeAsString(inputText);

    stdout.writeln('Saved input to ${outFile.path}');
  } on HandshakeException catch (e) {
    stderr.writeln('TLS handshake failed for day $day: ${e.message}');
    exitCode = 1;
  } on SocketException catch (e) {
    stderr.writeln('Network error for day $day: ${e.message}');
    exitCode = 1;
  } catch (e) {
    stderr.writeln('Unexpected error for day $day: $e');
    exitCode = 1;
  }
}
