// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day07.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Round>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.splitWhitespace();
    return Round(Hand(parts[0]), int.parse(parts[1]));
  }).toList();
}

String solvePart1(InputType input) {
  input.sort();
  int totalBid = 0;
  for (int i = 0; i < input.length; i++) {
    totalBid += input[i].bid * (i + 1);
  }
  return totalBid.toString();
}

String solvePart2(InputType input) {
  return "";
}

class Round implements Comparable<Round> {
  final Hand hand;
  final int bid;

  Round(this.hand, this.bid);

  @override
  int compareTo(Round other) {
    return hand.compareTo(other.hand);
  }
}

enum HandType implements Comparable<HandType> {
  highCard(1),
  onePair(2),
  twoPair(3),
  threeOfAKind(4),
  fullHouse(5),
  fourOfAKind(6),
  fiveOfAKind(7);

  final int rank;
  const HandType(this.rank);

  @override
  int compareTo(HandType other) {
    return rank.compareTo(other.rank);
  }
}

class Hand implements Comparable<Hand> {
  final List<int> cards;
  HandType? _type;
  HandType get type => _type ??= determineHandType();

  Hand(String cardStr)
    : this.cards = cardStr.split('').map((c) {
        switch (c) {
          case 'A':
            return 14;
          case 'T':
            return 10;
          case 'J':
            return 11;
          case 'Q':
            return 12;
          case 'K':
            return 13;
          default:
            return int.parse(c);
        }
      }).toList();

  @override
  int compareTo(Hand other) {
    final typeCompare = type.compareTo(other.type);
    if (typeCompare != 0) return typeCompare;
    // Compare individual card values if hand types are the same
    for (int i = 0; i < cards.length; i++) {
      final cardCompare = cards[i].compareTo(other.cards[i]);
      if (cardCompare != 0) return cardCompare;
    }
    return 0;
  }

  HandType determineHandType() {
    var counts = <int, int>{};
    for (var card in cards) {
      counts.increment(card);
    }
    var countValues = counts.values.toList();
    if (countValues.contains(5)) return HandType.fiveOfAKind;
    if (countValues.contains(4)) return HandType.fourOfAKind;
    if (countValues.contains(3) && countValues.contains(2)) {
      return HandType.fullHouse;
    }
    if (countValues.contains(3)) return HandType.threeOfAKind;
    if (countValues.where((c) => c == 2).length == 2) {
      return HandType.twoPair;
    }
    if (countValues.contains(2)) return HandType.onePair;
    return HandType.highCard;
  }
}
