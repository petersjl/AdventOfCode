default:
    just --list

setup year day:
    dart run ./utils/bin/setup.dart {{year}} {{day}}

setup-year year:
    dart run ./utils/bin/setup_year.dart {{year}}

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

time year:
    dart run ./utils/bin/benchmark_year.dart {{year}}

timed year day:
    dart run ./utils/bin/benchmark_day.dart {{year}} {{day}} --write

install:
    dart pub get --no-example