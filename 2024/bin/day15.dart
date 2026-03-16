// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day15.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<List<int>>, String, Point);

InputType parseInput(String input) {
  var parts = input.splitDoubleNewLine();
  Point? bot = null;
  List<List<int>> map = [];
  List<String> rawMapLines = parts[0].splitNewLine();
  for (int row = 0; row < rawMapLines.length; row++) {
    List<int> mapLine = [];
    for (int col = 0; col < rawMapLines[0].length; col++) {
      switch (rawMapLines[row][col]) {
        case "#":
          mapLine.add(1);
        case "O":
          mapLine.add(2);
        case "@":
          {
            bot = Point(col, row);
            mapLine.add(0);
          }
        default:
          mapLine.add(0);
      }
    }
    map.add(mapLine);
  }
  if (bot == null) throw Exception("Could not find bot in input");
  String instructions = parts[1]
      .splitNewLine()
      .fold(StringBuffer(), (run, value) => run..write(value))
      .toString();

  return (map, instructions, bot);
}

bool push(List<List<int>> map, Point object, Point direction) {
  var dest = object + direction;
  switch (map[dest.y][dest.x]) {
    case 1:
      return false;
    case 2:
      if (!push(map, dest, direction)) return false;
  }
  map[dest.y][dest.x] = 2;
  map[object.y][object.x] = 0;
  return true;
}

Point moveBot(List<List<int>> map, Point bot, Point direction) {
  var newPos = bot + direction;
  switch (map[newPos.y][newPos.x]) {
    case 1:
      return bot;
    case 2:
      return push(map, newPos, direction) ? newPos : bot;
    default:
      return newPos;
  }
}

int scoreMap(List<List<int>> map) {
  int count = 0;
  for (int row = 1; row < map.length - 1; row++) {
    for (int col = 1; col < map[0].length - 1; col++) {
      if (map[row][col] == 2) count += (100 * row) + col;
    }
  }
  return count;
}

String solvePart1(InputType input) {
  var (map, instructions, bot) = input;
  for (var command in instructions.characters) {
    bot = moveBot(map, bot, switch (command) {
      "^" => Point.up,
      "v" => Point.down,
      "<" => Point.left,
      ">" => Point.right,
      _ => throw Exception("Got an invalid command: $command"),
    });
  }
  return scoreMap(map).toString();
}

List<List<int>> expandMap(List<List<int>> map) {
  List<List<int>> expanded = [];
  List<int> edge = List.generate(map[0].length * 2, (i) => 1);
  expanded.add(edge);
  for (int row = 1; row < map.length - 1; row++) {
    List<int> line = [];
    for (int col = 0; col < map.length; col++) {
      if (map[row][col] == 2) {
        line.add(2);
        line.add(3);
      } else {
        line.add(map[row][col]);
        line.add(map[row][col]);
      }
    }
    expanded.add(line);
  }
  expanded.add(edge);
  return expanded;
}

Point moveBotExpanded(List<List<int>> map, Point bot, Point direction) {
  var newPos = bot + direction;
  var object = map[newPos.y][newPos.x];
  switch (object) {
    case 1:
      return bot;
    case 2:
    case 3:
      if (direction == Point.left || direction == Point.right) {
        if (!tryPush(map, newPos + direction, direction))
          return bot;
        else {
          pushExpanded(map, newPos, direction);
          return newPos;
        }
      } else {
        var otherHalf = newPos + (object == 2 ? Point.right : Point.left);
        if (!(tryPush(map, newPos, direction) &&
            tryPush(map, otherHalf, direction)))
          return bot;
        else {
          pushExpanded(map, newPos, direction);
          pushExpanded(map, otherHalf, direction);
          return newPos;
        }
      }
    default:
      return newPos;
  }
}

bool tryPush(List<List<int>> map, Point blocker, Point direction) {
  var object = map[blocker.y][blocker.x];
  switch (object) {
    case 1:
      return false;
    case 2:
    case 3:
      if (direction == Point.left || direction == Point.right) {
        return tryPush(map, blocker + direction + direction, direction);
      } else {
        var otherHalf = blocker + (object == 2 ? Point.right : Point.left);
        return tryPush(map, blocker + direction, direction) &&
            tryPush(map, otherHalf + direction, direction);
      }
    default:
      return true;
  }
}

void pushExpanded(List<List<int>> map, Point blocker, Point direction) {
  var object = map[blocker.y][blocker.x];
  switch (object) {
    case 2:
    case 3:
      if (direction == Point.left || direction == Point.right) {
        pushExpanded(map, blocker + direction + direction, direction);
        var otherHalf = blocker + direction;
        var dest = otherHalf + direction;
        map[dest.y][dest.x] = map[otherHalf.y][otherHalf.x];
        map[otherHalf.y][otherHalf.x] = map[blocker.y][blocker.x];
        map[blocker.y][blocker.x] = 0;
      } else {
        var otherHalf = blocker + (object == 2 ? Point.right : Point.left);
        pushExpanded(map, blocker + direction, direction);
        var dest = blocker + direction;
        map[dest.y][dest.x] = map[blocker.y][blocker.x];
        map[blocker.y][blocker.x] = 0;
        pushExpanded(map, otherHalf + direction, direction);
        dest = otherHalf + direction;
        map[dest.y][dest.x] = map[otherHalf.y][otherHalf.x];
        map[otherHalf.y][otherHalf.x] = 0;
      }
    default:
      ;
  }
}

int scoreExtendedMap(List<List<int>> map) {
  int score = 0;
  for (int row = 0; row < map.length; row++) {
    int col = 0;
    for (col; col < map[row].length ~/ 2; col++) {
      if (map[row][col] == 2) score += (100 * row) + col;
    }
    col++; // if a box is right on the center, it is already counted
    for (col; col < map.length; col++) {
      if (map[row][col] == 3) score += (100 * row) + col;
    }
  }
  return score;
}

String solvePart2(InputType input) {
  var (map, instructions, bot) = input;
  var expandedMap = expandMap(map);
  bot = Point(bot.x * 2, bot.y);
  for (var command in instructions.characters) {
    bot = moveBotExpanded(expandedMap, bot, switch (command) {
      "^" => Point.up,
      "v" => Point.down,
      "<" => Point.left,
      ">" => Point.right,
      _ => throw Exception("Got an invalid command: $command"),
    });
    expandedMap[bot.y][bot.x] = 4;
    expandedMap.printFlat((ele) {
      switch (ele) {
        case 0:
          return ".";
        case 1:
          return "#";
        case 2:
          return "[";
        case 3:
          return "]";
        case 4:
          return "@";
        default:
          return '';
      }
    });
    print("\n");
    expandedMap[bot.y][bot.x] = 0;
  }
  return scoreExtendedMap(expandedMap).toString();
}
