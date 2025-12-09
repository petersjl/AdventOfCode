import 'dart:io';
import 'dart:convert';

/// Fetches Advent of Code input for a given year and day using AOC_TOKEN
/// from the environment, and saves it under `{year}/inputs/Day{day}.txt`.
///
/// Usage:
///   dart run utils:fetch <year> <day>
/// Examples:
///   dart run utils:fetch 2025 9
Future<void> main(List<String> args) async {
	if (args.length != 2) {
		stderr.writeln('Usage: dart run utils:fetch <year> <day>');
		exitCode = 2;
		return;
	}

	final yearStr = args[0].trim();
	final dayStr = args[1].trim();

	final year = int.tryParse(yearStr);
	final day = int.tryParse(dayStr);
	if (year == null || day == null || day < 1 || day > 25) {
		stderr.writeln('Invalid arguments. Year must be an int. Day must be 1-25.');
		exitCode = 2;
		return;
	}

	final token = Platform.environment['AOC_TOKEN'];
	if (token == null || token.isEmpty) {
		stderr.writeln('Environment variable AOC_TOKEN is not set.');
		exitCode = 2;
		return;
	}

	final uri = Uri.parse('https://adventofcode.com/$year/day/$day/input');

	final client = HttpClient();
	// AoC uses the session cookie for authentication.
	client.userAgent = 'utils-fetch-script (Dart)';

	try {
		final request = await client.getUrl(uri);
		request.headers.set(HttpHeaders.cookieHeader, 'session=$token');
		final response = await request.close();

		if (response.statusCode != 200) {
			final body = await response.transform(utf8.decoder).join();
			stderr.writeln('Failed to fetch input: HTTP ${response.statusCode}');
			if (body.isNotEmpty) {
				stderr.writeln(body);
			}
			exitCode = 1;
			return;
		}

		final inputText = await response.transform(utf8.decoder).join();

		// Build destination path: {year}/inputs/Day{DD}.txt
		final dayPadded = day.toString().padLeft(2, '0');
		final inputsDir = Directory('$year/inputs');
		if (!await inputsDir.exists()) {
			await inputsDir.create(recursive: true);
		}
		final outFile = File('${inputsDir.path}/Day$dayPadded.txt');
		await outFile.writeAsString(inputText);

		stdout.writeln('Saved input to ${outFile.path}');
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

