mkdir corpus
rm corpus/*
mkdir coverages
rm coverages/*
./clang -fsanitize-coverage=edge -fsanitize=address,fuzzer -o fuzzme fuzzme.c
ASAN_OPTIONS=coverage=1 ./fuzzme -runs=100 -seed=1234 ./corpus
