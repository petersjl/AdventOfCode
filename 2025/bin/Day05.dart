// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day05.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
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
  ranges = mergeRanges(ranges);
  checks.sort();
  int currentRangeIndex = 0;
  int currentCheckIndex = 0;
  while (currentCheckIndex < checks.length &&
      currentRangeIndex < ranges.length) {
    var check = checks[currentCheckIndex];
    var range = ranges[currentRangeIndex];
    if (check < range.first) {
      currentCheckIndex += 1;
    } else if (check > range.second) {
      currentRangeIndex += 1;
    } else {
      count += 1;
      currentCheckIndex += 1;
    }
  }

  return count.toString();
}

String solvePart2(InputType input) {
  var (ranges, _) = input;

  var mergedRanges = mergeRanges(ranges);
  var validIdCount = 0;
  for (var range in mergedRanges) {
    validIdCount += (range.second - range.first + 1);
  }
  return validIdCount.toString();
}

List<Pair<int, int>> mergeRanges(List<Pair<int, int>> ranges) {
  if (ranges.isEmpty) return [];

  ranges.sort((a, b) => a.first.compareTo(b.first));
  var merged = <Pair<int, int>>[];
  var current = ranges[0];

  for (int i = 1; i < ranges.length; i++) {
    var next = ranges[i];
    if (current.second >= next.first) {
      current = new Pair(
        current.first,
        current.second > next.second ? current.second : next.second,
      );
    } else {
      merged.add(current);
      current = next;
    }
  }
  merged.add(current);

  return merged;
}
