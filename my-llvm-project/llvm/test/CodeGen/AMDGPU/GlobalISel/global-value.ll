; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii -stop-after=legalizer < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -stop-after=legalizer < %s | FileCheck -check-prefix=GCN-PAL %s

@external_constant = external addrspace(4) constant i32, align 4
@external_constant32 = external addrspace(6) constant i32, align 4
@external_global = external addrspace(1) global i32, align 4
@external_other = external addrspace(999) global i32, align 4

@internal_constant = internal addrspace(4) constant i32 9, align 4
@internal_constant32 = internal addrspace(6) constant i32 9, align 4
@internal_global = internal addrspace(1) global i32 9, align 4
@internal_other = internal addrspace(999) global i32 9, align 4


define ptr addrspace(4) @external_constant_got() {

  ; GCN-LABEL: name: external_constant_got
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-gotprel32-lo) @external_constant + 4, target-flags(amdgpu-gotprel32-hi) @external_constant + 12, implicit-def $scc
  ; GCN-NEXT:   [[LOAD:%[0-9]+]]:_(p4) = G_LOAD [[SI_PC_ADD_REL_OFFSET]](p4) :: (dereferenceable invariant load (p4) from got, addrspace 4)
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[LOAD]](p4)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: external_constant_got
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @external_constant
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @external_constant
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(4) @external_constant
}

define ptr addrspace(1) @external_global_got() {

  ; GCN-LABEL: name: external_global_got
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-gotprel32-lo) @external_global + 4, target-flags(amdgpu-gotprel32-hi) @external_global + 12, implicit-def $scc
  ; GCN-NEXT:   [[LOAD:%[0-9]+]]:_(p1) = G_LOAD [[SI_PC_ADD_REL_OFFSET]](p4) :: (dereferenceable invariant load (p1) from got, addrspace 4)
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[LOAD]](p1)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: external_global_got
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @external_global
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @external_global
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(1) @external_global
}

define ptr addrspace(999) @external_other_got() {

  ; GCN-LABEL: name: external_other_got
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-gotprel32-lo) @external_other + 4, target-flags(amdgpu-gotprel32-hi) @external_other + 12, implicit-def $scc
  ; GCN-NEXT:   [[LOAD:%[0-9]+]]:_(p999) = G_LOAD [[SI_PC_ADD_REL_OFFSET]](p4) :: (dereferenceable invariant load (p999) from got, addrspace 4)
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[LOAD]](p999)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: external_other_got
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @external_other
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @external_other
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(999) @external_other
}

define ptr addrspace(4) @internal_constant_pcrel() {

  ; GCN-LABEL: name: internal_constant_pcrel
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-rel32-lo) @internal_constant + 4, target-flags(amdgpu-rel32-hi) @internal_constant + 12, implicit-def $scc
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SI_PC_ADD_REL_OFFSET]](p4)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: internal_constant_pcrel
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @internal_constant
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @internal_constant
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(4) @internal_constant
}

define ptr addrspace(1) @internal_global_pcrel() {

  ; GCN-LABEL: name: internal_global_pcrel
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p1) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-rel32-lo) @internal_global + 4, target-flags(amdgpu-rel32-hi) @internal_global + 12, implicit-def $scc
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SI_PC_ADD_REL_OFFSET]](p1)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: internal_global_pcrel
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @internal_global
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @internal_global
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(1) @internal_global
}

define ptr addrspace(999) @internal_other_pcrel() {

  ; GCN-LABEL: name: internal_other_pcrel
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p999) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-rel32-lo) @internal_other + 4, target-flags(amdgpu-rel32-hi) @internal_other + 12, implicit-def $scc
  ; GCN-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SI_PC_ADD_REL_OFFSET]](p999)
  ; GCN-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; GCN-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ;
  ; GCN-PAL-LABEL: name: internal_other_pcrel
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @internal_other
  ; GCN-PAL-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32(s32) = S_MOV_B32 target-flags(amdgpu-abs32-hi) @internal_other
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](s32)
  ; GCN-PAL-NEXT:   $vgpr1 = COPY [[S_MOV_B32_1]](s32)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1
  ret ptr addrspace(999) @internal_other
}

define ptr addrspace(6) @external_constant32_got() {

  ; GCN-LABEL: name: external_constant32_got
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-gotprel32-lo) @external_constant32 + 4, target-flags(amdgpu-gotprel32-hi) @external_constant32 + 12, implicit-def $scc
  ; GCN-NEXT:   [[LOAD:%[0-9]+]]:_(p4) = G_LOAD [[SI_PC_ADD_REL_OFFSET]](p4) :: (dereferenceable invariant load (p4) from got, addrspace 4)
  ; GCN-NEXT:   [[EXTRACT:%[0-9]+]]:_(p6) = G_EXTRACT [[LOAD]](p4), 0
  ; GCN-NEXT:   $vgpr0 = COPY [[EXTRACT]](p6)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
  ;
  ; GCN-PAL-LABEL: name: external_constant32_got
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(p6) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @external_constant32
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](p6)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0
  ret ptr addrspace(6) @external_constant32
}

define ptr addrspace(6) @internal_constant32_pcrel() {

  ; GCN-LABEL: name: internal_constant32_pcrel
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   [[SI_PC_ADD_REL_OFFSET:%[0-9]+]]:sreg_64(p4) = SI_PC_ADD_REL_OFFSET target-flags(amdgpu-rel32-lo) @internal_constant32 + 4, target-flags(amdgpu-rel32-hi) @internal_constant32 + 12, implicit-def $scc
  ; GCN-NEXT:   [[EXTRACT:%[0-9]+]]:_(p6) = G_EXTRACT [[SI_PC_ADD_REL_OFFSET]](p4), 0
  ; GCN-NEXT:   $vgpr0 = COPY [[EXTRACT]](p6)
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
  ;
  ; GCN-PAL-LABEL: name: internal_constant32_pcrel
  ; GCN-PAL: bb.1 (%ir-block.0):
  ; GCN-PAL-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32(p6) = S_MOV_B32 target-flags(amdgpu-abs32-lo) @internal_constant32
  ; GCN-PAL-NEXT:   $vgpr0 = COPY [[S_MOV_B32_]](p6)
  ; GCN-PAL-NEXT:   SI_RETURN implicit $vgpr0
  ret ptr addrspace(6) @internal_constant32
}