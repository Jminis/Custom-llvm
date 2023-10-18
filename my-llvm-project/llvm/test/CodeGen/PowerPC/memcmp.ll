; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le-unknown-gnu-linux  < %s | FileCheck %s -check-prefix=CHECK

define signext i32 @memcmp8(ptr nocapture readonly %buffer1, ptr nocapture readonly %buffer2) {
; CHECK-LABEL: memcmp8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldbrx 3, 0, 3
; CHECK-NEXT:    ldbrx 4, 0, 4
; CHECK-NEXT:    subc 5, 4, 3
; CHECK-NEXT:    subfe 5, 4, 4
; CHECK-NEXT:    subc 4, 3, 4
; CHECK-NEXT:    subfe 3, 3, 3
; CHECK-NEXT:    neg 5, 5
; CHECK-NEXT:    neg 3, 3
; CHECK-NEXT:    sub 3, 5, 3
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(ptr %buffer1, ptr %buffer2, i64 8)
  ret i32 %call
}

define signext i32 @memcmp4(ptr nocapture readonly %buffer1, ptr nocapture readonly %buffer2) {
; CHECK-LABEL: memcmp4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lwbrx 3, 0, 3
; CHECK-NEXT:    lwbrx 4, 0, 4
; CHECK-NEXT:    sub 5, 4, 3
; CHECK-NEXT:    sub 3, 3, 4
; CHECK-NEXT:    rldicl 5, 5, 1, 63
; CHECK-NEXT:    rldicl 3, 3, 1, 63
; CHECK-NEXT:    sub 3, 5, 3
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(ptr %buffer1, ptr %buffer2, i64 4)
  ret i32 %call
}

define signext i32 @memcmp2(ptr nocapture readonly %buffer1, ptr nocapture readonly %buffer2) {
; CHECK-LABEL: memcmp2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lhbrx 3, 0, 3
; CHECK-NEXT:    lhbrx 4, 0, 4
; CHECK-NEXT:    sub 3, 3, 4
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(ptr %buffer1, ptr %buffer2, i64 2)
  ret i32 %call
}

define signext i32 @memcmp1(ptr nocapture readonly %buffer1, ptr nocapture readonly %buffer2) {
; CHECK-LABEL: memcmp1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lbz 3, 0(3)
; CHECK-NEXT:    lbz 4, 0(4)
; CHECK-NEXT:    sub 3, 3, 4
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(ptr %buffer1, ptr %buffer2, i64 1) #2
  ret i32 %call
}

declare signext i32 @memcmp(ptr, ptr, i64)