; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; Verifies that LICM is disabled for loops that contains coro.suspend.
; RUN: opt -S < %s -passes=licm | FileCheck %s

define i64 @licm(i64 %n) #0 {
; CHECK-LABEL: define i64 @licm
; CHECK-SAME: (i64 [[N:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = alloca i64, align 8
; CHECK-NEXT:    br label [[BB0:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[BB0]] ], [ [[T5:%.*]], [[AWAIT_READY:%.*]] ]
; CHECK-NEXT:    [[T5]] = add i64 [[I]], 1
; CHECK-NEXT:    [[SUSPEND:%.*]] = call i8 @llvm.coro.suspend(token none, i1 false)
; CHECK-NEXT:    switch i8 [[SUSPEND]], label [[BB2:%.*]] [
; CHECK-NEXT:    i8 0, label [[AWAIT_READY]]
; CHECK-NEXT:    ]
; CHECK:       await.ready:
; CHECK-NEXT:    store i64 1, ptr [[P]], align 4
; CHECK-NEXT:    [[T6:%.*]] = icmp ult i64 [[T5]], [[N]]
; CHECK-NEXT:    br i1 [[T6]], label [[LOOP]], label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[RES:%.*]] = call i1 @llvm.coro.end(ptr null, i1 false, token none)
; CHECK-NEXT:    ret i64 0
;
entry:
  %p = alloca i64
  br label %bb0

bb0:
  br label %loop

loop:
  %i = phi i64 [ 0, %bb0 ], [ %t5, %await.ready ]
  %t5 = add i64 %i, 1
  %suspend = call i8 @llvm.coro.suspend(token none, i1 false)
  switch i8 %suspend, label %bb2 [
  i8 0, label %await.ready
  ]

await.ready:
  store i64 1, ptr %p
  %t6 = icmp ult i64 %t5, %n
  br i1 %t6, label %loop, label %bb2

bb2:
  %res = call i1 @llvm.coro.end(ptr null, i1 false, token none)
  ret i64 0
}

@tls = thread_local global i32 0

define i64 @hoist_threadlocal() presplitcoroutine {
; CHECK-LABEL: define i64 @hoist_threadlocal
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = alloca i64, align 8
; CHECK-NEXT:    br label [[LOOP_PREHEADER:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[LOOP_PREHEADER]] ], [ [[I_NEXT:%.*]], [[LOOP_END:%.*]] ]
; CHECK-NEXT:    [[I_NEXT]] = add i64 [[I]], 1
; CHECK-NEXT:    [[THREAD_LOCAL_0:%.*]] = call ptr @llvm.threadlocal.address.p0(ptr @tls)
; CHECK-NEXT:    [[READONLY_0:%.*]] = call ptr @readonly_funcs()
; CHECK-NEXT:    [[SUSPEND:%.*]] = call i8 @llvm.coro.suspend(token none, i1 false)
; CHECK-NEXT:    switch i8 [[SUSPEND]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i8 0, label [[AWAIT_READY:%.*]]
; CHECK-NEXT:    ]
; CHECK:       await.ready:
; CHECK-NEXT:    [[THREAD_LOCAL_1:%.*]] = call ptr @llvm.threadlocal.address.p0(ptr @tls)
; CHECK-NEXT:    [[READONLY_1:%.*]] = call ptr @readonly_funcs()
; CHECK-NEXT:    [[CMP_0:%.*]] = icmp eq ptr [[THREAD_LOCAL_0]], [[THREAD_LOCAL_1]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp eq ptr [[READONLY_0]], [[READONLY_1]]
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP_0]], [[CMP_1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[NOT_REACHABLE:%.*]], label [[LOOP_END]]
; CHECK:       not.reachable:
; CHECK-NEXT:    call void @not.reachable()
; CHECK-NEXT:    br label [[LOOP_END]]
; CHECK:       loop.end:
; CHECK-NEXT:    br i1 [[CMP]], label [[EXIT]], label [[FOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = call i1 @llvm.coro.end(ptr null, i1 false, token none)
; CHECK-NEXT:    ret i64 0
;
entry:
  %p = alloca i64
  br label %loop.preheader

loop.preheader:
  br label %for.body

for.body:
  %i = phi i64 [ 0, %loop.preheader ], [ %i.next, %loop.end ]
  %i.next = add i64 %i, 1
  %thread_local.0 = call ptr @llvm.threadlocal.address(ptr @tls)
  %readonly.0 = call ptr @readonly_funcs()
  %suspend = call i8 @llvm.coro.suspend(token none, i1 false)
  switch i8 %suspend, label %exit [
  i8 0, label %await.ready
  ]

await.ready:
  %thread_local.1 = call ptr @llvm.threadlocal.address(ptr @tls)
  %readonly.1 = call ptr @readonly_funcs()
  %cmp.0 = icmp eq ptr %thread_local.0, %thread_local.1
  %cmp.1 = icmp eq ptr %readonly.0, %readonly.1
  %cmp = and i1 %cmp.0, %cmp.1
  br i1 %cmp, label %not.reachable, label %loop.end

not.reachable:
  call void @not.reachable()
  br label %loop.end

loop.end:
  %loop.end.cond = icmp ugt i64 %i.next, 5
  br i1 %cmp, label %exit, label %for.body

exit:
  %res = call i1 @llvm.coro.end(ptr null, i1 false, token none)
  ret i64 0
}

declare i8  @llvm.coro.suspend(token, i1)
declare i1  @llvm.coro.end(ptr, i1, token)
declare nonnull ptr @readonly_funcs() readonly
declare nonnull ptr @llvm.threadlocal.address(ptr nonnull) nounwind readnone willreturn
declare void @not.reachable()
