; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s
target triple = "arm64-apple-ios7.0"

define i64 @foo(ptr nocapture readonly %ptr, i64 %a, i64 %b, i64 %c) local_unnamed_addr #0 {
; CHECK-LABEL: foo:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    lsr x8, x1, #32
; CHECK-NEXT:    ldr w9, [x0, #4]
; CHECK-NEXT:    cmn x3, x2
; CHECK-NEXT:    umull x8, w9, w8
; CHECK-NEXT:    cinc x0, x8, hs
; CHECK-NEXT:    ret
entry:
  %0 = lshr i64 %a, 32
  %1 = load i64, ptr %ptr, align 8
  %2 = lshr i64 %1, 32
  %3 = mul nuw i64 %2, %0
  %4 = add i64 %c, %b
  %5 = icmp ult i64 %4, %c
  %6 = zext i1 %5 to i64
  %7 = add i64 %3, %6
  ret i64 %7
}

attributes #0 = { norecurse nounwind readonly }
