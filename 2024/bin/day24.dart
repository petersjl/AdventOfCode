// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day24.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (Map<String, Wire>, List<GateTemplate>);

class Wire {
  String name;
  int? value;
  Wire(this.name, [this.value]);
  Wire clone() => Wire(this.name, this.value);
}

typedef int Operation(int a, int b);

int AND(int a, int b) {
  return a & b;
}

int OR(int a, int b) {
  return a | b;
}

int XOR(int a, int b) {
  return a ^ b;
}

class Gate {
  Wire input_a, input_b, output;
  Operation op;
  Gate(this.input_a, this.input_b, this.output, this.op);

  bool get ready => input_a.value != null && input_b.value != null;

  void compute() {
    output.value = op(input_a.value!, input_b.value!);
  }
}

class GateTemplate {
  String input_a, input_b, output;
  Operation op;
  GateTemplate(this.input_a, this.input_b, this.output, this.op);
}

InputType parseInput(String input) {
  var parts = input.splitDoubleNewLine();
  Map<String, Wire> wires = {};
  parts[0].splitNewLine().forEach((line) {
    var p = line.split(': ');
    wires[p[0]] = Wire(p[0], int.parse(p[1]));
  });
  List<GateTemplate> templates = [];
  parts[1].splitNewLine().forEach((line) {
    var p = line.split(' ');
    if (!wires.containsKey(p[0])) wires[p[0]] = Wire(p[0]);
    if (!wires.containsKey(p[2])) wires[p[2]] = Wire(p[2]);
    if (!wires.containsKey(p[4])) wires[p[4]] = Wire(p[4]);
    Operation op = switch (p[1]) {
      "AND" => AND,
      "OR" => OR,
      "XOR" => XOR,
      _ => throw Exception("Unknown operation found"),
    };
    templates.add(GateTemplate(p[0], p[2], p[4], op));
  });

  return (wires, templates);
}

List<Gate> hookUpGates(Map<String, Wire> wires, List<GateTemplate> templates) {
  return templates.listMap(
    (template) => Gate(
      wires[template.input_a]!,
      wires[template.input_b]!,
      wires[template.output]!,
      template.op,
    ),
  );
}

void simulateGates(List<Gate> gates) {
  while (gates.length > 0) {
    for (int i = 0; i < gates.length; i++) {
      if (gates[i].ready) {
        gates[i].compute();
        gates.removeAt(i);
        i--;
      }
    }
  }
}

String solvePart1(InputType input) {
  var (templateWires, templates) = input;
  Map<String, Wire> wires = {};
  templateWires.forEach((key, value) => wires[key] = value.clone());
  List<Gate> gates = hookUpGates(wires, templates);
  simulateGates(gates);
  List<Wire> outputs = [];
  wires.keys.forEach((wire) {
    if (wire[0] == "z") outputs.add(wires[wire]!);
  });
  outputs.sort((a, b) => b.name.compareTo(a.name));
  int total = 0;
  outputs.forEach((output) {
    total = total + output.value!;
    total = total << 1;
  });
  total = total >> 1;
  return total.toString();
}

String solvePart2(InputType input) {
  return "";
}
