// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day05.txt");

  Stopwatch stopwatch = new Stopwatch()..start();
  var inputP1 = parseInput(rawInput);
  var timeParse = stopwatch.elapsed;
  // Parse again for part 2 to allow any mutations,
  // but don't count that time
  stopwatch.stop();
  var inputP2 = parseInput(rawInput);

  stopwatch.start();
  if (runP1) solutionP1 = solvePart1(inputP1);
  var timeP1 = stopwatch.elapsed;
  if (runP2) solutionP2 = solvePart2(inputP2);
  var timeP2 = stopwatch.elapsed;
  stopwatch.stop();

  print('Parse time: ${Utils.timingString(timeParse)}');
  if (runP1)
    print('Part 1 (${Utils.timingString(timeP1 - timeParse)}): ${solutionP1}');
  if (runP2)
    print('Part 2 (${Utils.timingString(timeP2 - timeP1)}): ${solutionP2}');
  print('Ran in ${Utils.timingString(timeP2)}');
}

typedef InputType = (List<Pair<int, int>>, List<int>);

InputType parseInput(String input) {
  var parts = input.splitDoubleNewLine();
  var ranges = parts[0].splitNewLine().listMap((line) {
    var nums = line.split('-').listMap((e) => int.parse(e));
    return new Pair(nums[0], nums[1]);
  });
  var checks = parts[1].splitNewLine().listMap((e) => int.parse(e));
  return (ranges, checks);
}

String solvePart1(InputType input) {
  var (ranges, checks) = input;
  int count = 0;
  ranges.sort((a, b) => a.first.compareTo(b.first));
  for (var check in checks) {
    for (var range in ranges) {
      if (check < range.first) {
        break;
      }
      if (check >= range.first && check <= range.second) {
        count += 1;
        break;
      }
    }
  }

  return count.toString();
}

String solvePart2(InputType input) {
  return "";
}
