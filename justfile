default:
    just --list

setup year day:
    dart run ./utils/bin/setup.dart {{year}} {{day}}

fetch-all year:
    dart run ./utils/bin/fetch.dart {{year}}

fetch year day:
    dart run ./utils/bin/fetch.dart {{year}} {{day}}

runc year day:
    just compile {{year}} {{day}}
    ./{{year}}/exe/day{{day}}.exe

run year day: 
    dart run {{year}}/bin/day{{day}}.dart

test year day:
    dart run {{year}}/test/day{{day}}_test.dart

compile year day:
    mkdir -p ./{{year}}/exe
    dart compile exe {{year}}/bin/day{{day}}.dart -o {{year}}/exe/day{{day}}.exe

install:
    dart pub get --no-example