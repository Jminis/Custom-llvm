// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs
// RUN: %clang_cc1 -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -emit-llvm %s -o - | FileCheck %s
// expected-no-diagnostics

#ifndef HEADER
#define HEADER

void foo() { }

#pragma omp begin declare variant match( \
    device = {arch(ppc64le, ppc64)},     \
    implementation = {extension(match_any, bind_to_declaration)})

void foo();

#pragma omp end declare variant

int main() {
  foo();
}

#endif
// CHECK-LABEL: define {{[^@]+}}@_Z3foov
// CHECK-SAME: () #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define {{[^@]+}}@main
// CHECK-SAME: () #[[ATTR1:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    call void @"_Z74foo$ompvariant$S2$s7$Pppc64le$Pppc64$S3$s9$Pmatch_any$Pbind_to_declarationv"()
// CHECK-NEXT:    ret i32 0
//