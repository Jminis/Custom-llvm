; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+vpu | FileCheck %s

define fastcc <256 x i1> @brd_v256i1_s(i1 %s) {
; CHECK-LABEL: brd_v256i1_s:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0, %s0
; CHECK-NEXT:    vbrd %v1, 0
; CHECK-NEXT:    vcmpu.w %v0, %v0, %v1
; CHECK-NEXT:    vfmk.w.ne %vm1, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %val = insertelement <256 x i1> undef, i1 %s, i32 0
  %ret = shufflevector <256 x i1> %val, <256 x i1> undef, <256 x i32> zeroinitializer
  ret <256 x i1> %ret
}

define fastcc <256 x i1> @brd_v256i1_zero() {
; CHECK-LABEL: brd_v256i1_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorm %vm1, %vm0, %vm0
; CHECK-NEXT:    b.l.t (, %s10)
  %val = insertelement <256 x i1> undef, i1 0, i32 0
  %ret = shufflevector <256 x i1> %val, <256 x i1> undef, <256 x i32> zeroinitializer
  ret <256 x i1> %ret
}

define fastcc <256 x i1> @brd_v256i1_one() {
; CHECK-LABEL: brd_v256i1_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andm %vm1, %vm0, %vm0
; CHECK-NEXT:    b.l.t (, %s10)
  %val = insertelement <256 x i1> undef, i1 1, i32 0
  %ret = shufflevector <256 x i1> %val, <256 x i1> undef, <256 x i32> zeroinitializer
  ret <256 x i1> %ret
}