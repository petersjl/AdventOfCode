// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show PriorityQueue;

void main() {
  var rawInput = Utils.readToString("../inputs/day11.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Building;

InputType parseInput(String input) {
  final lines = input.splitNewLine();
  var building = Building();
  for (int i = 0; i < 3; ++i) {
    var line = lines[i];
    var parts = line
        .split(' ')
        .listMap(
          (String e) => e[e.length - 1] == ',' || e[e.length - 1] == '.'
              ? e.substring(0, e.length - 1)
              : e,
        );
    int index = parts.indexOf('generator');
    while (index != -1) {
      building.placeItem(i, parts[index - 1], false);
      index = parts.indexOf('generator', index + 1);
    }
    index = parts.indexOf('microchip');
    while (index != -1) {
      building.placeItem(i, parts[index - 1].split('-')[0], true);
      index = parts.indexOf('microchip', index + 1);
    }
  }
  return building;
}

String solvePart1(InputType input) {
  var moves = movesToFourthFloor(input);
  if (moves == null)
    throw Exception("No valid solutions found");
  else {
    return moves.toString();
  }
}

String solvePart2(InputType input) {
  // Add the four new generators
  input.placeItem(0, 'e', false);
  input.placeItem(0, 'e', true);
  input.placeItem(0, 'd', false);
  input.placeItem(0, 'd', true);
  var moves = movesToFourthFloor(input);
  if (moves == null)
    throw Exception("No valid solutions found");
  else {
    return moves.toString();
  }
}

int? movesToFourthFloor(Building building) {
  var queue = PriorityQueue<Pair<int, Building>>((queueItem, toInsert) {
    if (queueItem.first == toInsert.first)
      return queueItem.second.score - toInsert.second.score;
    else
      return queueItem.first - toInsert.first;
  });
  Set seen = Set<String>(); // Keep track of what we have seen
  queue.enqueue(
    Pair(0, building),
  ); // Start with the given building with zero steps
  seen.add(building.identity()); // Mark that we have seen it
  Pair<int, Building>? found;
  while (queue.length != 0) {
    Pair currentPair = queue.dequeue(); // Pop the best candidate
    int currentIndex = currentPair.first;
    Building currentBuild = currentPair.second;
    var moves = currentBuild
        .getAllMoves(); // Get all valid moves from the current state
    for (var move in moves) {
      var newPair = Pair(currentIndex + 1, move);
      if (move.completed) {
        // If everything is on the top floor
        found = newPair; // Save the building
        queue.clear(); // Clear the list to exit the while loop
        break;
      }
      if (seen.add(move.identity())) {
        // If we haven't yet seen this building state
        queue.enqueue(newPair); // put it in the queue
      }
    }
  }
  return found?.first;
}

class Building {
  List<List<Pair<bool, String>>> floors;
  int elevatorPos;
  Building() : floors = [[], [], [], []], elevatorPos = 0;

  @override
  int get hashCode => identity().hashCode;

  bool get completed => score == 0;
  int get score =>
      ((floors[0].length * 5) +
      (floors[1].length * 3) +
      (floors[2].length * 1)); // Lower scores are closer to complete

  Building? parent = null;

  // Place the given item on the given floor
  void placeItem(int floor, String name, bool isChip) {
    floors[floor].add(new Pair(isChip, name));
  }

  // Move one or two items up or down a floor
  bool MoveItems(
    bool up,
    Pair<bool, String> first, [
    Pair<bool, String>? second = null,
  ]) {
    if ((elevatorPos == 3 && up) || (elevatorPos == 0 && !up))
      return false; // Don't move things out of bounds
    if (!(floors[elevatorPos].remove(first)))
      return false; // If current floor has the first item, remove it, otherwise return false
    if (second != null) {
      // If we were given a second item
      if (!(floors[elevatorPos].remove(second))) {
        // If the current floor has the second item, remove it
        floors[elevatorPos].add(
          first,
        ); // Otherwise add the first item back to the list
        return false;
      }
    }
    elevatorPos += up ? 1 : -1; // Move the elevator to the new position
    floors[elevatorPos].add(first); // Add first item to the list
    if (second != null)
      floors[elevatorPos].add(
        second,
      ); // If we had a second item, add it to the list
    return true;
  }

  // Return list of buildings that display every possible valid
  // move for the current building state
  List<Building> getAllMoves() {
    var currentFloor = floors[elevatorPos];
    List<Building> moves = [];
    for (int i = 0; i < currentFloor.length; ++i) {
      // For each item in the current floor
      Pair<bool, String> p = currentFloor[i];
      List<Pair<bool, String>?> list = [...currentFloor, null]
        ..remove(p); // Create a list without that item and add null
      for (int j = i; j < list.length; ++j) {
        // For every item in the new list
        Pair<bool, String>? p2 = list[j];
        Building newBuild;
        if (elevatorPos > 0) {
          // If we aren't on the lowest floor
          newBuild = this.copy();
          if (newBuild.MoveItems(false, p, p2)) {
            // Move the pair of items (or item and null)
            if (newBuild.CheckValid())
              moves.add(
                newBuild,
              ); // If that is a valid move, add it to the list of moves
          }
        }
        if (elevatorPos < 3) {
          // If we aren't on the highest floor
          newBuild = this.copy();
          if (newBuild.MoveItems(
            true,
            p,
            p2,
          )) // Move the pair of items (or item and null)
            if (newBuild.CheckValid())
              moves.add(
                newBuild,
              ); // If that is a valid move, add it to the list of moves
        }
      }
    }
    return moves;
  }

  // Make sure there are no unpaired chips on a floor with an unpaired generator
  bool CheckValid() {
    for (var floor in floors) {
      var chips = floor.listWhere(
        (element) => element.first,
      ); // Get all the chips on a floor
      var gens = floor.listWhere(
        (element) => !element.first,
      ); // Get all the generators on a floor
      var hasGens = gens.length > 0;
      for (int i = 0; i < chips.length;) {
        // For each chip
        Pair chip = chips[i];
        var gen = gens.whereFirst(
          (element) => (element as Pair).second == chip.second,
        ); // If there is a generator that matches that chip
        if (gen != null) {
          chips.remove(chip); // Remove that pair from their lists
          gens.remove(gen);
          continue;
        }
        i++;
      }
      if (hasGens && chips.length != 0)
        return false; // If the floor has generatos and there are unpaired chips, it is an invalid move
    }
    return true;
  }

  // Create a deep copy of the called on building
  Building copy() {
    var newBuild = Building();
    newBuild.floors.clear();
    for (int i = 0; i < 4; ++i) {
      var curFloor = floors[i];
      List<Pair<bool, String>> floorcpy = [];
      for (Pair p in curFloor) {
        floorcpy.add(Pair(p.first, p.second));
      }
      newBuild.floors.add(floorcpy);
    }
    newBuild.elevatorPos = elevatorPos;
    newBuild.parent = this;
    return newBuild;
  }

  // Pairs of chip and generator are interchangeable so we anonymise the
  // chip, gen pairs into which floors they are on. Then we sort the pairs
  // to make sure any equivalent states will get the same string
  String identity() {
    Map<String, Pair<int, int>> scoreMap = {};
    for (int i = 0; i < floors.length; i++) {
      var floor = floors[i];
      for (Pair<bool, String> item in floor) {
        if (item.first) {
          scoreMap.update(item.second, (pair) {
            pair.first = i;
            return pair;
          }, ifAbsent: () => Pair(i, -1));
        } else {
          scoreMap.update(item.second, (pair) {
            pair.second = i;
            return pair;
          }, ifAbsent: () => Pair(-1, i));
        }
      }
    }
    List<Pair<int, int>> scores = [...scoreMap.values];
    scores.sort(
      (p1, p2) =>
          p1.first == p2.first ? p1.second - p2.second : p1.first - p2.first,
    );
    return '$elevatorPos$scores';
  }

  // Create an exact, sorted string representation of a floor
  String lineString(int index) {
    StringBuffer str = StringBuffer();
    var floor = floors[index];
    var chips = floor.listWhere((element) => element.first);
    var gens = floor.listWhere((element) => !element.first);
    while (chips.length > 0) {
      Pair<bool, String> lowest = chips[0];
      int lowi = 0;
      for (int i = 1; i < chips.length; ++i) {
        if (chips[i].second.compareTo(lowest.second) < 0) {
          lowi = i;
          lowest = chips[i];
        }
      }
      str.write('C${lowest.second}');
      chips.removeAt(lowi);
    }
    while (gens.length > 0) {
      Pair<bool, String> lowest = gens[0];
      int lowi = 0;
      for (int i = 1; i < gens.length; ++i) {
        if (gens[i].second.compareTo(lowest.second) < 0) {
          lowi = i;
          lowest = gens[i];
        }
      }
      str.write('G${lowest.second}');
      gens.removeAt(lowi);
    }
    return str.toString();
  }

  void printPath() {
    if (this.parent != null) this.parent!.printPath();
    print(this);
  }

  // A nice easy way to print a building
  @override
  String toString() {
    var string = 'Elevator position: $elevatorPos\n';
    for (int i = 3; i >= 0; --i) {
      string += 'F$i: ${floors[i]}\n';
    }
    return string;
  }
}
