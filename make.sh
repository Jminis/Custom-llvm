#!/bin/bash
NPROC=$(($(nproc) - 2))
echo using $NPROC cores...

mkdir build
cd build
cmake -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE="RELEASE" \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" \
    ../my-llvm-project/llvm

make -j$NPROC
