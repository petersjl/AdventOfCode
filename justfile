default:
    just --list

setup year day:
    dart run ./utils/bin/setup.dart {{year}} {{day}}

fetch year day:
    dart run ./utils/bin/fetch.dart {{year}} {{day}}

runc year day:
    just compile {{year}} {{day}}
    ./{{year}}/exe/Day{{day}}.exe

run year day: 
    dart run {{year}}/bin/Day{{day}}.dart

test year day:
    dart run {{year}}/test/Day{{day}}_test.dart

compile year day:
    mkdir -p ./{{year}}/exe
    dart compile exe {{year}}/bin/Day{{day}}.dart -o {{year}}/exe/Day{{day}}.exe

install:
    dart pub get --no-example