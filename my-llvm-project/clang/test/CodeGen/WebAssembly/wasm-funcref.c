// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple wasm32 -target-feature +reference-types -o - -emit-llvm %s | FileCheck %s

typedef void (*__funcref funcref_t)();
typedef int (*__funcref fn_funcref_t)(int);
typedef int (*fn_t)(int);

// Null funcref builtin call
// CHECK-LABEL: @get_null(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call ptr addrspace(20) @llvm.wasm.ref.null.func()
// CHECK-NEXT:    ret ptr addrspace(20) [[TMP0]]
//
funcref_t get_null() {
  return __builtin_wasm_ref_null_func();
}

// Call to null funcref builtin but requires cast since
// default return value for builtin is a funcref with function type () -> ().
// CHECK-LABEL: @get_null_ii(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call ptr addrspace(20) @llvm.wasm.ref.null.func()
// CHECK-NEXT:    ret ptr addrspace(20) [[TMP0]]
//
fn_funcref_t get_null_ii() {
  return (fn_funcref_t) __builtin_wasm_ref_null_func();
}

// Identity function for funcref.
// CHECK-LABEL: @identity(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[FN_ADDR:%.*]] = alloca ptr addrspace(20), align 4
// CHECK-NEXT:    store ptr addrspace(20) [[FN:%.*]], ptr [[FN_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr addrspace(20), ptr [[FN_ADDR]], align 4
// CHECK-NEXT:    ret ptr addrspace(20) [[TMP0]]
//
funcref_t identity(funcref_t fn) {
  return fn;
}

void helper(funcref_t);

// Pass funcref ref as an argument to a helper function.
// CHECK-LABEL: @handle(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[FN_ADDR:%.*]] = alloca ptr addrspace(20), align 4
// CHECK-NEXT:    store ptr addrspace(20) [[FN:%.*]], ptr [[FN_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr addrspace(20), ptr [[FN_ADDR]], align 4
// CHECK-NEXT:    call void @helper(ptr addrspace(20) noundef [[TMP0]])
// CHECK-NEXT:    ret i32 0
//
int handle(funcref_t fn) {
  helper(fn);
  return 0;
}

// Return funcref from function pointer.
// CHECK-LABEL: @get_ref(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[FNPTR_ADDR:%.*]] = alloca ptr, align 4
// CHECK-NEXT:    store ptr [[FNPTR:%.*]], ptr [[FNPTR_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[FNPTR_ADDR]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = addrspacecast ptr [[TMP0]] to ptr addrspace(20)
// CHECK-NEXT:    ret ptr addrspace(20) [[TMP1]]
//
fn_funcref_t get_ref(fn_t fnptr) {
  return (fn_funcref_t) fnptr;
}

// Call funcref
// CHECK-LABEL: @call_fn(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[REF_ADDR:%.*]] = alloca ptr addrspace(20), align 4
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr addrspace(20) [[REF:%.*]], ptr [[REF_ADDR]], align 4
// CHECK-NEXT:    store i32 [[X:%.*]], ptr [[X_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr addrspace(20), ptr [[REF_ADDR]], align 4
// CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[X_ADDR]], align 4
// CHECK-NEXT:    [[CALL:%.*]] = call addrspace(20) i32 [[TMP0]](i32 noundef [[TMP1]])
// CHECK-NEXT:    ret i32 [[CALL]]
//
int call_fn(fn_funcref_t ref, int x) {
  return ref(x);
}

typedef fn_funcref_t (*builtin_refnull_t)();

// Calling ref.null through a function pointer.
// CHECK-LABEL: @get_null_fptr(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[REFNULL_ADDR:%.*]] = alloca ptr, align 4
// CHECK-NEXT:    store ptr [[REFNULL:%.*]], ptr [[REFNULL_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[REFNULL_ADDR]], align 4
// CHECK-NEXT:    [[CALL:%.*]] = call ptr addrspace(20) [[TMP0]]()
// CHECK-NEXT:    ret ptr addrspace(20) [[CALL]]
//
fn_funcref_t get_null_fptr(builtin_refnull_t refnull) {
  return refnull();
}