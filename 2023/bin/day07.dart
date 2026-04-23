// ignore_for_file: dead_code

import 'dart:math';
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
  for (final round in input) round.hand.setHandWithJokers();
  input.sort();
  int totalBid = 0;
  for (int i = 0; i < input.length; i++) {
    totalBid += input[i].bid * (i + 1);
  }
  return totalBid.toString();
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

  void setHandWithJokers() {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i] == 11) cards[i] = 1; // Treat Joker as lowest card
    }

    var counts = <int, int>{};
    for (var card in cards) {
      counts.increment(card);
    }
    final jokers = counts.remove(1) ?? 0; // Count of Jokers
    if (jokers == 5) {
      this._type = HandType.fiveOfAKind; // All Jokers
      return;
    }
    var countValues = counts.values.toList()..sort((a, b) => b.compareTo(a));

    if (countValues.isEmpty) {
      this._type = HandType.fiveOfAKind; // Edge case: all jokers
      return;
    }

    if (countValues.contains(5 - jokers)) {
      this._type = HandType.fiveOfAKind;
      return;
    }
    if (countValues.contains(4 - jokers)) {
      this._type = HandType.fourOfAKind;
      return;
    }

    // Full house: need 3 of one kind and 2 of another
    if (countValues.length >= 2) {
      int jokersNeededForTriple = max(0, 3 - countValues[0]);
      int jokersNeededForPair = max(0, 2 - countValues[1]);
      if (jokersNeededForTriple + jokersNeededForPair <= jokers) {
        this._type = HandType.fullHouse;
        return;
      }
    }

    if (countValues.contains(3 - jokers)) {
      this._type = HandType.threeOfAKind;
      return;
    }
    if (countValues.where((c) => c == 2 - jokers).length == 2) {
      this._type = HandType.twoPair;
      return;
    }
    if (countValues.contains(2 - jokers)) {
      this._type = HandType.onePair;
      return;
    }
    this._type ??= HandType.highCard;
  }
}
