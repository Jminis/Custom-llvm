; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+amx-int8 -mattr=+avx512f -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+amx-int8 -mattr=+avx512f -verify-machineinstrs -enable-ipra | FileCheck -check-prefix=IPRA %s
; RUN: llc < %s -O0 -mtriple=x86_64-unknown-unknown -mattr=+amx-int8 -mattr=+avx512f -verify-machineinstrs | FileCheck -check-prefix=O0 %s

@buf = dso_local global [3072 x i8] zeroinitializer, align 64

define internal void @foo() {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    retq
;
; IPRA-LABEL: foo:
; IPRA:       # %bb.0: # %entry
; IPRA-NEXT:    retq
;
; O0-LABEL: foo:
; O0:       # %bb.0: # %entry
; O0-NEXT:    retq
entry:
  ret void
}

define dso_local void @test_api(i16 signext %0, i16 signext %1) nounwind {
; CHECK-LABEL: test_api:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    subq $2120, %rsp # imm = 0x848
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vmovups %zmm0, (%rsp)
; CHECK-NEXT:    movb $1, (%rsp)
; CHECK-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw %bx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %bpl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw %bx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %bpl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    movl $buf, %eax
; CHECK-NEXT:    movl $32, %r14d
; CHECK-NEXT:    movw $8, %r15w
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm1
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm1, 1088(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    movl $buf+1024, %eax
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm2
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm2, 64(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    movl $buf+2048, %eax
; CHECK-NEXT:    tileloadd (%rax,%r14), %tmm0
; CHECK-NEXT:    movabsq $64, %rcx
; CHECK-NEXT:    tileloadd 1088(%rsp,%rcx), %tmm1 # 1024-byte Folded Reload
; CHECK-NEXT:    tileloadd 64(%rsp,%rcx), %tmm2 # 1024-byte Folded Reload
; CHECK-NEXT:    tdpbssd %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tilestored %tmm0, (%rax,%r14)
; CHECK-NEXT:    addq $2120, %rsp # imm = 0x848
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    tilerelease
; CHECK-NEXT:    retq
;
; IPRA-LABEL: test_api:
; IPRA:       # %bb.0:
; IPRA-NEXT:    subq $72, %rsp
; IPRA-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; IPRA-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movw %si, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb %dil, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movw %si, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb %dil, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movl $buf, %eax
; IPRA-NEXT:    movl $32, %ecx
; IPRA-NEXT:    movw $8, %dx
; IPRA-NEXT:    tileloadd (%rax,%rcx), %tmm0
; IPRA-NEXT:    movl $buf+1024, %eax
; IPRA-NEXT:    tileloadd (%rax,%rcx), %tmm1
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    movl $buf+2048, %eax
; IPRA-NEXT:    tileloadd (%rax,%rcx), %tmm2
; IPRA-NEXT:    tdpbssd %tmm1, %tmm0, %tmm2
; IPRA-NEXT:    tilestored %tmm2, (%rax,%rcx)
; IPRA-NEXT:    addq $72, %rsp
; IPRA-NEXT:    tilerelease
; IPRA-NEXT:    vzeroupper
; IPRA-NEXT:    retq
;
; O0-LABEL: test_api:
; O0:       # %bb.0:
; O0-NEXT:    pushq %rbp
; O0-NEXT:    movq %rsp, %rbp
; O0-NEXT:    andq $-1024, %rsp # imm = 0xFC00
; O0-NEXT:    subq $8192, %rsp # imm = 0x2000
; O0-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; O0-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; O0-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %si, %cx
; O0-NEXT:    movw %cx, {{[-0-9]+}}(%r{{[sb]}}p) # 2-byte Spill
; O0-NEXT:    movw %di, %ax
; O0-NEXT:    movw %ax, {{[-0-9]+}}(%r{{[sb]}}p) # 2-byte Spill
; O0-NEXT:    movl $buf, %esi
; O0-NEXT:    movl $32, %edi
; O0-NEXT:    movw $8, %dx
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %dx, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rsi,%rdi), %tmm0
; O0-NEXT:    movl $64, %edi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rsi
; O0-NEXT:    movw $8, %dx
; O0-NEXT:    tilestored %tmm0, (%rsi,%rdi)
; O0-NEXT:    movl $32, %esi
; O0-NEXT:    movl $buf+1024, %edx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rdx,%rsi), %tmm0
; O0-NEXT:    movl $64, %esi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rdx,%rsi)
; O0-NEXT:    vzeroupper
; O0-NEXT:    callq foo
; O0-NEXT:    movw {{[-0-9]+}}(%r{{[sb]}}p), %cx # 2-byte Reload
; O0-NEXT:    movw {{[-0-9]+}}(%r{{[sb]}}p), %ax # 2-byte Reload
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    movl $32, %esi
; O0-NEXT:    movl $buf+2048, %edx
; O0-NEXT:    tileloadd (%rdx,%rsi), %tmm0
; O0-NEXT:    movl $64, %esi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    tilestored %tmm0, (%rdx,%rsi)
; O0-NEXT:    movl $64, %edi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    movw $8, %si
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %si, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rdx,%rdi), %tmm0
; O0-NEXT:    movabsq $64, %rdx
; O0-NEXT:    tilestored %tmm0, 1024(%rsp,%rdx) # 1024-byte Folded Spill
; O0-NEXT:    movl $64, %r8d
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdi
; O0-NEXT:    movw $8, %dx
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %si, {{[0-9]+}}(%rsp)
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    # implicit-def: $dl
; O0-NEXT:    movb %dl, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %cx, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rdi,%r8), %tmm2
; O0-NEXT:    movl $64, %edi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    tileloadd (%rdx,%rdi), %tmm0
; O0-NEXT:    movw $8, %dx
; O0-NEXT:    movabsq $64, %rdi
; O0-NEXT:    tileloadd 1024(%rsp,%rdi), %tmm1 # 1024-byte Folded Reload
; O0-NEXT:    tdpbssd %tmm2, %tmm1, %tmm0
; O0-NEXT:    movl $64, %esi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    tilestored %tmm0, (%rdx,%rsi)
; O0-NEXT:    movl $64, %esi
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; O0-NEXT:    tileloadd (%rdx,%rsi), %tmm0
; O0-NEXT:    movl $32, %esi
; O0-NEXT:    movl $buf+2048, %edx
; O0-NEXT:    tilestored %tmm0, (%rdx,%rsi)
; O0-NEXT:    movq %rbp, %rsp
; O0-NEXT:    popq %rbp
; O0-NEXT:    tilerelease
; O0-NEXT:    retq
  %3 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %0, i16 8, ptr @buf, i64 32)
  %4 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 %1, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 1024), i64 32)
  call void @foo()
  %5 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %0, i16 %1, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 2048), i64 32)
  %6 = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 %0, i16 %1, i16 8, x86_amx %5, x86_amx %3, x86_amx %4)
  tail call void @llvm.x86.tilestored64.internal(i16 %0, i16 %1, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 2048), i64 32, x86_amx %6)
  ret void
}

define dso_local i32 @test_loop(i32 %0) nounwind {
; CHECK-LABEL: test_loop:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    subq $1096, %rsp # imm = 0x448
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vmovups %zmm0, (%rsp)
; CHECK-NEXT:    movb $1, (%rsp)
; CHECK-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    testl %ebx, %ebx
; CHECK-NEXT:    jg .LBB2_4
; CHECK-NEXT:  # %bb.1: # %.preheader
; CHECK-NEXT:    movl $7, %ebp
; CHECK-NEXT:    movl $buf, %r14d
; CHECK-NEXT:    movl $32, %r15d
; CHECK-NEXT:    movw $8, %r12w
; CHECK-NEXT:    movl $buf+2048, %r13d
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB2_2: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    tileloadd (%r14,%r15), %tmm0
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm0, 64(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tileloadd 64(%rsp,%rax), %tmm0 # 1024-byte Folded Reload
; CHECK-NEXT:    tilestored %tmm0, (%r13,%r15)
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    decl %ebp
; CHECK-NEXT:    cmpl $7, %ebp
; CHECK-NEXT:    jne .LBB2_2
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    cmpl $3, %ebx
; CHECK-NEXT:    jne .LBB2_4
; CHECK-NEXT:  # %bb.6:
; CHECK-NEXT:    testl %ebp, %ebp
; CHECK-NEXT:    jne .LBB2_5
; CHECK-NEXT:  # %bb.7:
; CHECK-NEXT:    incl %ebx
; CHECK-NEXT:    jmp .LBB2_8
; CHECK-NEXT:  .LBB2_4:
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    movl $32, %eax
; CHECK-NEXT:    movl $buf+1024, %ecx
; CHECK-NEXT:    movw $8, %dx
; CHECK-NEXT:    tileloadd (%rcx,%rax), %tmm0
; CHECK-NEXT:    tilestored %tmm0, (%rcx,%rax)
; CHECK-NEXT:  .LBB2_5:
; CHECK-NEXT:    decl %ebx
; CHECK-NEXT:  .LBB2_8:
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    addq $1096, %rsp # imm = 0x448
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    tilerelease
; CHECK-NEXT:    retq
;
; IPRA-LABEL: test_loop:
; IPRA:       # %bb.0:
; IPRA-NEXT:    subq $72, %rsp
; IPRA-NEXT:    movl %edi, %eax
; IPRA-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; IPRA-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    testl %edi, %edi
; IPRA-NEXT:    jg .LBB2_4
; IPRA-NEXT:  # %bb.1: # %.preheader
; IPRA-NEXT:    movl $7, %ecx
; IPRA-NEXT:    movl $buf, %edx
; IPRA-NEXT:    movl $32, %esi
; IPRA-NEXT:    movw $8, %di
; IPRA-NEXT:    movl $buf+2048, %r8d
; IPRA-NEXT:    .p2align 4, 0x90
; IPRA-NEXT:  .LBB2_2: # =>This Inner Loop Header: Depth=1
; IPRA-NEXT:    tileloadd (%rdx,%rsi), %tmm0
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    tilestored %tmm0, (%r8,%rsi)
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    decl %ecx
; IPRA-NEXT:    cmpl $7, %ecx
; IPRA-NEXT:    jne .LBB2_2
; IPRA-NEXT:  # %bb.3:
; IPRA-NEXT:    cmpl $3, %eax
; IPRA-NEXT:    jne .LBB2_4
; IPRA-NEXT:  # %bb.6:
; IPRA-NEXT:    testl %ecx, %ecx
; IPRA-NEXT:    jne .LBB2_5
; IPRA-NEXT:  # %bb.7:
; IPRA-NEXT:    incl %eax
; IPRA-NEXT:    jmp .LBB2_8
; IPRA-NEXT:  .LBB2_4:
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    movl $32, %ecx
; IPRA-NEXT:    movl $buf+1024, %edx
; IPRA-NEXT:    movw $8, %si
; IPRA-NEXT:    tileloadd (%rdx,%rcx), %tmm0
; IPRA-NEXT:    tilestored %tmm0, (%rdx,%rcx)
; IPRA-NEXT:  .LBB2_5:
; IPRA-NEXT:    decl %eax
; IPRA-NEXT:  .LBB2_8:
; IPRA-NEXT:    addq $72, %rsp
; IPRA-NEXT:    tilerelease
; IPRA-NEXT:    vzeroupper
; IPRA-NEXT:    retq
;
; O0-LABEL: test_loop:
; O0:       # %bb.0:
; O0-NEXT:    pushq %rbp
; O0-NEXT:    movq %rsp, %rbp
; O0-NEXT:    andq $-1024, %rsp # imm = 0xFC00
; O0-NEXT:    subq $4096, %rsp # imm = 0x1000
; O0-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; O0-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; O0-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; O0-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    vzeroupper
; O0-NEXT:    callq foo
; O0-NEXT:  # %bb.1:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %ecx # 4-byte Reload
; O0-NEXT:    xorl %eax, %eax
; O0-NEXT:    cmpl $0, %ecx
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    jg .LBB2_4
; O0-NEXT:    jmp .LBB2_3
; O0-NEXT:  .LBB2_2:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    cmpl $3, %eax
; O0-NEXT:    je .LBB2_5
; O0-NEXT:    jmp .LBB2_4
; O0-NEXT:  .LBB2_3: # =>This Inner Loop Header: Depth=1
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    movl $buf, %ecx
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    callq foo
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movl $buf+2048, %ecx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    callq foo
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    addl $1, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    cmpl $0, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    je .LBB2_2
; O0-NEXT:    jmp .LBB2_3
; O0-NEXT:  .LBB2_4:
; O0-NEXT:    callq foo
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movl $buf+1024, %ecx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movl $buf+1024, %ecx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    jmp .LBB2_7
; O0-NEXT:  .LBB2_5:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    cmpl $7, %eax
; O0-NEXT:    jne .LBB2_7
; O0-NEXT:  # %bb.6:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    addl $1, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    jmp .LBB2_8
; O0-NEXT:  .LBB2_7:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    subl $1, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:  .LBB2_8:
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    movq %rbp, %rsp
; O0-NEXT:    popq %rbp
; O0-NEXT:    tilerelease
; O0-NEXT:    retq
  call void @foo()
  br label %2
2:
  %3 = icmp sgt i32 %0, 0
  br i1 %3, label %11, label %6
4:
  %5 = icmp eq i32 %0, 3
  br i1 %5, label %13, label %11
6:
  %7 = phi i32 [ %9, %6 ], [ 0, %2 ]
  %8 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 8, ptr @buf, i64 32)
  call void @foo()
  tail call void @llvm.x86.tilestored64.internal(i16 8, i16 8, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 2048), i64 32, x86_amx %8)
  call void @foo()
  %9 = add i32 %7, 1
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %4, label %6
11:
  call void @foo()
  %12 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 8, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 1024), i64 32)
  tail call void @llvm.x86.tilestored64.internal(i16 8, i16 8, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 1024), i64 32, x86_amx %12)
  br label %17
13:
  %14 = icmp eq i32 %9, 7
  br i1 %14, label %15, label %17
15:
  %16 = add i32 %0, 1
  br label %19
17:
  %18 = sub i32 %0, 1
  br label %19
19:
  %20 = phi i32 [ %16, %15 ], [ %18, %17 ]
  ret i32 %20
}

define dso_local void @test_loop2(i32 %0) nounwind {
; CHECK-LABEL: test_loop2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    subq $1088, %rsp # imm = 0x440
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vmovups %zmm0, (%rsp)
; CHECK-NEXT:    movb $1, (%rsp)
; CHECK-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl $buf, %r14d
; CHECK-NEXT:    movl $32, %r15d
; CHECK-NEXT:    movw $8, %bp
; CHECK-NEXT:    movl $buf+2048, %r12d
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB3_1: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    testl %ebx, %ebx
; CHECK-NEXT:    jle .LBB3_3
; CHECK-NEXT:  # %bb.2: # in Loop: Header=BB3_1 Depth=1
; CHECK-NEXT:    tileloadd (%r14,%r15), %tmm0
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tilestored %tmm0, 64(%rsp,%rax) # 1024-byte Folded Spill
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    ldtilecfg (%rsp)
; CHECK-NEXT:    movabsq $64, %rax
; CHECK-NEXT:    tileloadd 64(%rsp,%rax), %tmm0 # 1024-byte Folded Reload
; CHECK-NEXT:    tilestored %tmm0, (%r12,%r15)
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    jmp .LBB3_1
; CHECK-NEXT:  .LBB3_3:
; CHECK-NEXT:    addq $1088, %rsp # imm = 0x440
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    tilerelease
; CHECK-NEXT:    retq
;
; IPRA-LABEL: test_loop2:
; IPRA:       # %bb.0:
; IPRA-NEXT:    subq $72, %rsp
; IPRA-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; IPRA-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movb $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movw $8, {{[0-9]+}}(%rsp)
; IPRA-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; IPRA-NEXT:    movl $buf, %eax
; IPRA-NEXT:    movl $32, %ecx
; IPRA-NEXT:    movw $8, %dx
; IPRA-NEXT:    movl $buf+2048, %esi
; IPRA-NEXT:    .p2align 4, 0x90
; IPRA-NEXT:  .LBB3_1: # =>This Inner Loop Header: Depth=1
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    testl %edi, %edi
; IPRA-NEXT:    jle .LBB3_3
; IPRA-NEXT:  # %bb.2: # in Loop: Header=BB3_1 Depth=1
; IPRA-NEXT:    tileloadd (%rax,%rcx), %tmm0
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    tilestored %tmm0, (%rsi,%rcx)
; IPRA-NEXT:    callq foo
; IPRA-NEXT:    jmp .LBB3_1
; IPRA-NEXT:  .LBB3_3:
; IPRA-NEXT:    addq $72, %rsp
; IPRA-NEXT:    tilerelease
; IPRA-NEXT:    vzeroupper
; IPRA-NEXT:    retq
;
; O0-LABEL: test_loop2:
; O0:       # %bb.0:
; O0-NEXT:    pushq %rbp
; O0-NEXT:    movq %rsp, %rbp
; O0-NEXT:    andq $-1024, %rsp # imm = 0xFC00
; O0-NEXT:    subq $3072, %rsp # imm = 0xC00
; O0-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; O0-NEXT:    vmovups %zmm0, {{[0-9]+}}(%rsp)
; O0-NEXT:    movb $1, {{[0-9]+}}(%rsp)
; O0-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    xorl %eax, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:  .LBB3_1: # =>This Inner Loop Header: Depth=1
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    vzeroupper
; O0-NEXT:    callq foo
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    cmpl $0, %eax
; O0-NEXT:    jle .LBB3_3
; O0-NEXT:  # %bb.2: # in Loop: Header=BB3_1 Depth=1
; O0-NEXT:    movl $buf, %ecx
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    callq foo
; O0-NEXT:    movl $64, %edx
; O0-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    # implicit-def: $al
; O0-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; O0-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; O0-NEXT:    ldtilecfg {{[0-9]+}}(%rsp)
; O0-NEXT:    tileloadd (%rcx,%rdx), %tmm0
; O0-NEXT:    movl $32, %edx
; O0-NEXT:    movl $buf+2048, %ecx
; O0-NEXT:    movw $8, %ax
; O0-NEXT:    tilestored %tmm0, (%rcx,%rdx)
; O0-NEXT:    callq foo
; O0-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; O0-NEXT:    addl $1, %eax
; O0-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; O0-NEXT:    jmp .LBB3_1
; O0-NEXT:  .LBB3_3:
; O0-NEXT:    movq %rbp, %rsp
; O0-NEXT:    popq %rbp
; O0-NEXT:    tilerelease
; O0-NEXT:    retq
  br label %2
2:
  %3 = phi i32 [ 0, %1 ], [ %7, %5 ]
  call void @foo()
  %4 = icmp sgt i32 %0, 0
  br i1 %4, label %5, label %8
5:
  %6 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 8, ptr @buf, i64 32)
  call void @foo()
  tail call void @llvm.x86.tilestored64.internal(i16 8, i16 8, ptr getelementptr inbounds ([3072 x i8], ptr @buf, i64 0, i64 2048), i64 32, x86_amx %6)
  call void @foo()
  %7 = add i32 %3, 1
  br label %2
8:
  ret void
}

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, ptr, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, ptr, i64, x86_amx)