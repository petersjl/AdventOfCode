default:
    just --list

run year day:
    dart run {{year}}/bin/Day{{day}}.dart

test year day:
    dart test {{year}}/test/Day{{day}}_test.dart