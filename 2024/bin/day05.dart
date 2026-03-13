// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day05.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<Rule>, List<List<int>>);

enum RuleState { ignored, violated, passed }

class Rule {
  int left, right;

  Rule(String left, String right)
    : this.left = int.parse(left),
      this.right = int.parse(right) {}

  (int?, int?) getLR(List<int> line) {
    int? leftIndex = null, rightIndex = null;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == left) {
        leftIndex = i;
        if (rightIndex != null) break;
      }
      if (line[i] == right) {
        rightIndex = i;
        if (leftIndex != null) break;
      }
    }
    return (leftIndex, rightIndex);
  }

  bool accept(List<int> line) {
    var (leftIndex, rightIndex) = getLR(line);
    if (leftIndex == null || rightIndex == null) return true;
    return leftIndex < rightIndex;
  }

  bool affects(List<int> line) {
    var (leftIndex, rightIndex) = getLR(line);
    return !(leftIndex == null || rightIndex == null);
  }

  (List<int>, bool) acceptOrFlip(List<int> line) {
    var (leftIndex, rightIndex) = getLR(line);
    if (leftIndex == null || rightIndex == null)
      throw Exception("Only necessary rules should try to flip");
    if (leftIndex < rightIndex) return (line, true);
    var hold = line[leftIndex];
    line[leftIndex] = line[rightIndex];
    line[rightIndex] = hold;
    return (line, false);
  }
}

InputType parseInput(String input) {
  var parts = input.splitDoubleNewLine();
  List<Rule> rules = parts[0].splitNewLine().listMap((line) {
    var nums = line.split("|");
    var rule = new Rule(nums[0], nums[1]);
    return rule;
  });
  List<List<int>> lines = parts[1].splitNewLine().listMap(
    (line) => line.split(",").listMap((number) => int.parse(number)),
  );
  return (rules, lines);
}

int getLineValue(List<int> line, List<Rule> rules) {
  for (var rule in rules) {
    if (!rule.accept(line)) return 0;
  }
  return line[line.length ~/ 2];
}

List<Rule> getAffectingRules(List<Rule> rules, List<int> line) {
  return rules.listWhere((rule) => rule.affects(line));
}

List<int> fixLine(List<Rule> rules, List<int> line) {
  bool check = false;
  for (int i = 0; i < rules.length; i++) {
    (line, check) = rules[i].acceptOrFlip(line);
    if (!check) i = -1; // Start over until all rules are satisfied
  }
  return line;
}

String solvePart1(InputType input) {
  var (rules, lines) = input;
  int count = 0;
  for (var line in lines) {
    count += getLineValue(line, rules);
  }
  return count.toString();
}

String solvePart2(InputType input) {
  var (rules, lines) = input;
  int count = 0;
  for (var line in lines) {
    if (getLineValue(line, rules) == 0) {
      var affectingRules = getAffectingRules(rules, line);
      var fixedLine = fixLine(affectingRules, line);
      count += fixedLine[fixedLine.length ~/ 2];
    }
  }
  return count.toString();
}
