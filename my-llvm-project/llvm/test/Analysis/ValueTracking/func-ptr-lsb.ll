; RUN: opt -passes=instcombine -S < %s | FileCheck %s

target datalayout = "e-p:32:32-n32-S64"

; CHECK-LABEL: @foo_ptr
; CHECK: and
define i32 @foo_ptr() {
entry:
  ; Even though the address of @foo is aligned, we cannot assume that the
  ; pointer has the same alignment. This is not true for e.g. ARM targets
  ; which store ARM/Thumb state in the LSB
  %and = and i32 ptrtoint (ptr @foo to i32), -4
  ret i32 %and
}

define internal void @foo() align 16 {
entry:
  ret void
}
