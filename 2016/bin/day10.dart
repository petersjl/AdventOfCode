// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({Map<int, Bot> bots, Map<int, List<int>> outputs});

InputType parseInput(String input) {
  Map<int, Bot> bots = {};
  Map<int, List<int>> outputs = {};
  input.splitNewLine().forEach((line) {
    if (line.startsWith("bot")) {
      parseTargetLine(line, bots, outputs);
    } else {
      var parts = line.splitWhitespace();
      var chipValue = int.parse(parts[1]);
      var botId = int.parse(parts[5]);
      var bot = bots.getOrSetDefault(botId, () => Bot(botId));
      bot.give(chipValue);
    }
  });
  return (bots: bots, outputs: outputs);
}

void parseTargetLine(
  String line,
  Map<int, Bot> bots,
  Map<int, List<int>> outputs,
) {
  var parts = line.splitWhitespace();
  var botId = int.parse(parts[1]);
  var lowDest = parts[5] == "output" ? Destination.output : Destination.bot;
  var lowId = int.parse(parts[6]);
  var highDest = parts[10] == "output" ? Destination.output : Destination.bot;
  var highId = int.parse(parts[11]);
  var bot = bots.getOrSetDefault(botId, () => Bot(botId));
  if (lowDest == Destination.bot) {
    bots.getOrSetDefault(lowId, () => Bot(lowId));
  } else {
    outputs[lowId] = outputs[lowId] ?? [];
  }
  if (highDest == Destination.bot) {
    bots.getOrSetDefault(highId, () => Bot(highId));
  } else {
    outputs[highId] = outputs[highId] ?? [];
  }
  bot.low = (dest: lowDest, id: lowId);
  bot.high = (dest: highDest, id: highId);
}

String solvePart1(InputType input, {List<int> targetChips = const [61, 17]}) {
  if (targetChips.length != 2)
    throw Exception("Expected exactly 2 target chips");
  int i = 0;
  var botsList = input.bots.values.toList();
  while (true) {
    var bot = botsList[i % botsList.length];
    if (bot.chips.length == 2) {
      if (bot.chips.contains(targetChips[0]) &&
          bot.chips.contains(targetChips[1])) {
        return bot.id.toString();
      }
      bot.giveAway(input.bots, input.outputs);
    }
    i++;
  }
  throw Exception("No bot compares the target chips");
}

String solvePart2(InputType input) {
  return "";
}

enum Destination { bot, output }

class Bot {
  final int id;
  ({Destination dest, int id})? low;
  ({Destination dest, int id})? high;
  List<int> chips = [];
  Bot(this.id);

  void give(int chip) {
    chips.add(chip);
  }

  void giveAway(Map<int, Bot> bots, Map<int, List<int>> outputs) {
    if (chips.length != 2) return;
    chips.sort();
    if (low == null || high == null)
      throw Exception("Bot $id does not have instructions");
    if (low!.dest == Destination.output) {
      outputs[low!.id]!.add(chips[0]);
    } else {
      bots[low!.id]!.give(chips[0]);
    }
    if (high!.dest == Destination.output) {
      outputs[high!.id]!.add(chips[1]);
    } else {
      bots[high!.id]!.give(chips[1]);
    }
    chips.clear();
  }
}
