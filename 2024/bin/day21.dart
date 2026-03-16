// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day21.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

enum RobType { Number, Direction }

class Robot {
  RobType type;
  Map<String, Point> buttons;
  Point armPos;
  Map<(Point, Point), String> cache;

  static Map<String, Point> numberButtons = {
    "7": Point(0, 0), "8": Point(1, 0), "9": Point(2, 0), //789
    "4": Point(0, 1), "5": Point(1, 1), "6": Point(2, 1), //456
    "1": Point(0, 2), "2": Point(1, 2), "3": Point(2, 2), //123
    "0": Point(1, 3), "A": Point(2, 3), //_0A
  };
  static Map<String, Point> directionButtons = {
    "^": Point(1, 0), "A": Point(2, 0), //_^A
    "<": Point(0, 1), "v": Point(1, 1), ">": Point(2, 1), //<v>
  };

  Robot(this.type)
    : armPos = type == RobType.Number ? Point(2, 3) : Point(2, 0),
      buttons = type == RobType.Number ? numberButtons : directionButtons,
      cache = {};

  String getMovementsForSequence(String target) {
    StringBuffer buff = StringBuffer();
    for (var char in target.characters) {
      var goal = buttons[char]!;
      var check = cache[(armPos, goal)];
      var moves = "";
      if (check != null) {
        moves = check;
      } else {
        moves = getMovementsToPoint(goal);
        cache[(armPos, goal)] = moves;
      }
      buff.write(moves);
      buff.write("A");
      armPos = goal;
    }
    return buff.toString();
  }

  String getMovementsToPoint(Point goal) {
    var vertical = goal.y - armPos.y;
    var horizontal = goal.x - armPos.x;
    var verticalChar = vertical > 0 ? "v" : "^";
    var horizontalChar = horizontal > 0 ? ">" : "<";
    bool verticalFirst = true;

    // preference ^>, v>, <^, <v orderings unless passing through dead zone
    if (verticalChar == "^") {
      if (horizontalChar == ">") {
        if (type == RobType.Direction && armPos.x == 0) {
          verticalFirst = false;
        } else {
          verticalFirst = true;
        }
      }
      // <^
      else {
        if (type == RobType.Number && armPos.y == 3 && goal.x == 0) {
          verticalFirst = true;
        } else {
          verticalFirst = false;
        }
      }
    }
    // v
    else {
      if (horizontalChar == ">") {
        if (type == RobType.Number && armPos.x == 0 && goal.y == 3) {
          verticalFirst = false;
        } else {
          verticalFirst = true;
        }
      }
      // <v
      else {
        if (type == RobType.Direction && goal.x == 0) {
          verticalFirst = true;
        } else {
          verticalFirst = false;
        }
      }
    }

    StringBuffer buff = StringBuffer();
    if (verticalFirst) {
      for (int i = 0; i < vertical.abs(); i++) buff.write(verticalChar);
      for (int i = 0; i < horizontal.abs(); i++) buff.write(horizontalChar);
    } else {
      for (int i = 0; i < horizontal.abs(); i++) buff.write(horizontalChar);
      for (int i = 0; i < vertical.abs(); i++) buff.write(verticalChar);
    }

    return buff.toString();
  }
}

InputType parseInput(String input) {
  return input.splitNewLine();
}

String getFullSequenceForCode(
  Robot numberBot,
  Robot directionBot,
  String code,
) {
  code = numberBot.getMovementsForSequence(code);
  for (int i = 0; i < 2; i++) {
    code = directionBot.getMovementsForSequence(code);
  }
  return code;
}

int getCodeComplexity(String code, String movements) {
  int number = int.parse(code.substring(0, code.length - 1));
  return number * movements.length;
}

String solvePart1(InputType input) {
  int complexity = 0;
  var numBot = Robot(RobType.Number);
  var dirBot = Robot(RobType.Direction);
  for (var code in input) {
    var movements = getFullSequenceForCode(numBot, dirBot, code);
    complexity += getCodeComplexity(code, movements);
  }
  return complexity.toString();
}

String solvePart2(InputType input) {
  return "";
}
