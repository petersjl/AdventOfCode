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
  int? _handValue;
  int get handValue =>
      _handValue ??= hand.getOrderValue() + hand.type.rank * 1000000000000000;

  Round(this.hand, this.bid);

  @override
  int compareTo(Round other) {
    return handValue.compareTo(other.handValue);
  }
}

enum HandType {
  highCard(1),
  onePair(2),
  twoPair(3),
  threeOfAKind(4),
  fullHouse(5),
  fourOfAKind(6),
  fiveOfAKind(7);

  final int rank;
  const HandType(this.rank);
}

class Hand {
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

  int getOrderValue() {
    int val = 0;
    for (final card in cards) {
      val = val * 100 + card;
    }
    return val;
  }

  HandType determineHandType() {
    final counts = List<int>.filled(15, 0);
    for (final card in cards) {
      counts[card]++;
    }

    bool hasThree = false;
    int pairCount = 0;
    for (final count in counts) {
      if (count == 5) return HandType.fiveOfAKind;
      if (count == 4) return HandType.fourOfAKind;
      if (count == 3) hasThree = true;
      if (count == 2) pairCount++;
    }

    if (hasThree && pairCount == 1) return HandType.fullHouse;
    if (hasThree) return HandType.threeOfAKind;
    if (pairCount == 2) return HandType.twoPair;
    if (pairCount == 1) return HandType.onePair;
    return HandType.highCard;
  }

  void setHandWithJokers() {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i] == 11) cards[i] = 1; // Treat Joker as lowest card
    }

    final counts = List<int>.filled(15, 0);
    int jokers = 0;
    for (final card in cards) {
      if (card == 1) {
        jokers++;
      } else {
        counts[card]++;
      }
    }

    if (jokers == 5) {
      this._type = HandType.fiveOfAKind;
      return;
    }

    int maxCount = 0;
    for (final count in counts) {
      if (count > maxCount) maxCount = count;
    }

    if (maxCount + jokers >= 5) {
      this._type = HandType.fiveOfAKind;
      return;
    }
    if (maxCount + jokers >= 4) {
      this._type = HandType.fourOfAKind;
      return;
    }
    if (_canMakeGroups(counts, jokers, 3, 2)) {
      this._type = HandType.fullHouse;
      return;
    }
    if (maxCount + jokers >= 3) {
      this._type = HandType.threeOfAKind;
      return;
    }
    if (_canMakeGroups(counts, jokers, 2, 2)) {
      this._type = HandType.twoPair;
      return;
    }
    if (maxCount + jokers >= 2) {
      this._type = HandType.onePair;
      return;
    }
    this._type = HandType.highCard;
  }

  bool _canMakeGroups(
    List<int> counts,
    int jokers,
    int firstSize,
    int secondSize,
  ) {
    for (int firstRank = 2; firstRank <= 14; firstRank++) {
      final jokersForFirst = max(0, firstSize - counts[firstRank]);
      if (jokersForFirst > jokers) continue;

      for (int secondRank = 2; secondRank <= 14; secondRank++) {
        if (secondRank == firstRank) continue;

        final jokersForSecond = max(0, secondSize - counts[secondRank]);
        if (jokersForFirst + jokersForSecond <= jokers) {
          return true;
        }
      }
    }

    return false;
  }
}
