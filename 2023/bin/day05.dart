// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day05.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({Map<String, Mapping> mappings, List<int> seeds});

InputType parseInput(String input) {
  var sections = input.splitDoubleNewLine();
  final seedString = sections.removeAt(0);
  var seeds = Utils.ParseIntList(seedString.substring(7));
  var mappings = sections.map((section) => Mapping(section)).fold(
    <String, Mapping>{},
    (map, mapping) {
      map[mapping.from] = mapping;
      return map;
    },
  );
  return (mappings: mappings, seeds: seeds);
}

String solvePart1(InputType input) {
  final mappings = input.mappings;
  final seeds = input.seeds;
  final combined = combineMappings(mappings, 'seed');
  if (!(combined.to == 'location')) {
    throw Exception(
      'Expected combined mapping to map to location, but got ${combined.to}',
    );
  }
  var seedIter = seeds.iterator;
  seedIter.moveNext();
  var lowest = combined.targetAtSource(seedIter.current);
  while (seedIter.moveNext()) {
    var location = combined.targetAtSource(seedIter.current);
    if (location < lowest) lowest = location;
  }
  return lowest.toString();
}

String solvePart2(InputType input) {
  final mappings = input.mappings;
  final seeds = input.seeds;
  final combined = combineMappings(mappings, 'seed');
  if (!(combined.to == 'location')) {
    throw Exception(
      'Expected combined mapping to map to location, but got ${combined.to}',
    );
  }
  var seedIndex = 0;
  var lowest = combined.targetAtSource(seeds[seedIndex]);
  while (seedIndex < seeds.length - 1) {
    var seedStart = seeds[seedIndex];
    var seedEnd = seedStart + seeds[seedIndex + 1] - 1;
    lowest = min(lowest, combined.targetAtSource(seedStart));
    for (var range in combined.ranges) {
      if (seedStart <= range.source && range.source <= seedEnd) {
        lowest = min(lowest, range.target);
      }
    }
    seedIndex += 2;
  }
  return lowest.toString();
}

Mapping combineMappings(Map<String, Mapping> mappings, String first) {
  var combined = mappings[first];
  if (combined == null) {
    throw ArgumentError('No mapping found for $first');
  }
  // Ensure the first mapping is sorted by target for the merge logic to work correctly.
  combined.ranges = combined.ranges..sort((a, b) => a.target - b.target);
  var next = combined.to;
  while (mappings.containsKey(next)) {
    combined.mergeRanges(mappings[next]!);
    next = combined.to;
  }
  // Return to source-sorted
  combined.ranges.sort((a, b) => a.source - b.source);
  return combined;
}

class Range {
  final int source, sourceEnd;
  final int target, targetEnd;
  final int length;
  Range(this.target, this.source, this.length)
    : sourceEnd = source + length - 1,
      targetEnd = target + length - 1;

  int sourceAtTarget(int targetValue) => source + (targetValue - target);
  int targetAtSource(int sourceValue) => target + (sourceValue - source);

  List<Range> merge(Range other) {
    final overlapStart = target > other.source ? target : other.source;
    final overlapEnd = targetEnd < other.sourceEnd
        ? targetEnd
        : other.sourceEnd;
    if (overlapStart > overlapEnd) {
      throw ArgumentError('Cannot merge non-overlapping ranges');
    }

    final merged = <Range>[];

    if (target < overlapStart) {
      // Left segment from this range that does not overlap other.
      merged.add(Range(this.target, this.source, overlapStart - this.target));
    }

    if (other.source < overlapStart) {
      // Left segment from other range that does not overlap this range.
      merged.add(
        Range(other.target, other.source, overlapStart - other.source),
      );
    }

    // Overlapping segment: compose this(source->target) with other(source->target).
    merged.add(
      Range(
        other.targetAtSource(overlapStart),
        sourceAtTarget(overlapStart),
        overlapEnd - overlapStart + 1,
      ),
    );

    if (this.targetEnd > overlapEnd) {
      // Right segment from this range that does not overlap other.
      merged.add(
        Range(
          overlapEnd + 1,
          sourceAtTarget(overlapEnd + 1),
          this.targetEnd - overlapEnd,
        ),
      );
    }

    if (other.sourceEnd > overlapEnd) {
      // Right segment from other range that does not overlap this range.
      merged.add(
        Range(
          other.targetAtSource(overlapEnd + 1),
          overlapEnd + 1,
          other.sourceEnd - overlapEnd,
        ),
      );
    }

    return merged;
  }
}

class Mapping {
  late final String from;
  late String to;
  var ranges = <Range>[];

  Mapping(String stringRep) {
    var lines = stringRep.splitNewLine();
    var header = lines.removeAt(0);
    var headerParts = header.split(new RegExp(r'[- ]'));
    this.from = headerParts[0];
    this.to = headerParts[2];
    for (var line in lines) {
      var parts = line.splitWhitespace();
      var target = int.parse(parts[0]);
      var source = int.parse(parts[1]);
      var length = int.parse(parts[2]);
      ranges.add(Range(target, source, length));
    }
    ranges.sort((a, b) => a.source - b.source);
  }

  int targetAtSource(int sourceValue) {
    for (var range in ranges) {
      if (sourceValue < range.source) {
        // Since ranges are sorted by source, we can stop searching once we've passed the source value.
        return sourceValue;
      }
      if (sourceValue <= range.sourceEnd) {
        return range.targetAtSource(sourceValue);
      }
    }
    // source value is above all ranges, so it maps to itself.
    return sourceValue;
  }

  /// Compose this mapping with [other], where this maps source->middle and
  /// [other] maps middle->destination.
  ///
  /// Assumes this mapping is already sorted by target and [other] is sorted
  /// by source.
  ///
  /// Length is treated as a count: (start, length) covers
  /// [start, start + length - 1].
  void mergeRanges(Mapping other) {
    this.to = other.to;
    // Compare this mapping's destination windows against other's source windows.
    var byTarget = ranges;
    var bySource = other.ranges;
    var composed = <Range>[];
    var i = 0;
    var j = 0;
    Range? currentA;
    Range? currentB;

    while (currentA != null ||
        i < byTarget.length ||
        currentB != null ||
        j < bySource.length) {
      // Pull next range only when there is no carry-over tail from a prior split.
      currentA ??= i < byTarget.length ? byTarget[i++] : null;
      currentB ??= j < bySource.length ? bySource[j++] : null;

      final a = currentA;
      final b = currentB;

      if (a == null) {
        // Only B remains.
        composed.add(currentB!);
        currentB = null;
        continue;
      }

      if (b == null) {
        // Only A remains.
        composed.add(currentA!);
        currentA = null;
        continue;
      }

      if (a.targetEnd < b.source) {
        composed.add(a);
        currentA = null;
        continue;
      }

      if (b.sourceEnd < a.target) {
        composed.add(b);
        currentB = null;
        continue;
      }

      final merged = a.merge(b);
      var index = 0;

      if (a.target < b.source || b.source < a.target) {
        // Non-overlap prefix from whichever range starts earlier.
        composed.add(merged[index]);
        index++;
      }

      // The composed overlap segment is always next.
      composed.add(merged[index]);
      index++;

      currentA = null;
      currentB = null;
      if (a.targetEnd > b.sourceEnd) {
        // A had a right-side tail; carry it to compare with the next B.
        currentA = merged[index];
      } else if (b.sourceEnd > a.targetEnd) {
        // B had a right-side tail; carry it to compare with the next A.
        currentB = merged[index];
      }
    }

    ranges = _normalizeRanges(composed);
    // Keep this invariant for the next merge call.
    ranges.sort((a, b) => a.target - b.target);
  }

  List<Range> _normalizeRanges(List<Range> input) {
    if (input.isEmpty) return input;

    var sorted = [...input]..sort((a, b) => a.source - b.source);
    var merged = <Range>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final prev = merged.last;
      final cur = sorted[i];
      final prevOffset = prev.target - prev.source;
      final curOffset = cur.target - cur.source;
      final contiguousSource = prev.sourceEnd + 1 == cur.source;
      final contiguousTarget = prev.targetEnd + 1 == cur.target;

      if (contiguousSource && contiguousTarget && prevOffset == curOffset) {
        merged[merged.length - 1] = Range(
          prev.target,
          prev.source,
          prev.length + cur.length,
        );
      } else {
        merged.add(cur);
      }
    }
    return merged;
  }
}
