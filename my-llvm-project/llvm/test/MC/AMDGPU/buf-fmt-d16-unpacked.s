// RUN: llvm-mc -triple=amdgcn -mcpu=fiji -show-encoding %s | FileCheck -check-prefix=UNPACKED %s
// RUN: not llvm-mc -triple=amdgcn -mcpu=gfx810 2>&1 %s | FileCheck -check-prefix=PACKED-ERR --implicit-check-not=error: %s
// RUN: not llvm-mc -triple=amdgcn -mcpu=gfx900 2>&1 %s | FileCheck -check-prefix=PACKED-ERR --implicit-check-not=error: %s


//===----------------------------------------------------------------------===//
// Buffer Format Instructions.
//===----------------------------------------------------------------------===//

buffer_load_format_d16_x v1, off, s[4:7], s1
// UNPACKED: buffer_load_format_d16_x v1, off, s[4:7], s1 ; encoding: [0x00,0x00,0x20,0xe0,0x00,0x01,0x01,0x01]

buffer_load_format_d16_xy v[1:2], off, s[4:7], s1
// UNPACKED: buffer_load_format_d16_xy v[1:2], off, s[4:7], s1 ; encoding: [0x00,0x00,0x24,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

buffer_load_format_d16_xyz v[1:3], off, s[4:7], s1
// UNPACKED: buffer_load_format_d16_xyz v[1:3], off, s[4:7], s1 ; encoding: [0x00,0x00,0x28,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

buffer_load_format_d16_xyzw v[1:4], off, s[4:7], s1
// UNPACKED: buffer_load_format_d16_xyzw v[1:4], off, s[4:7], s1 ; encoding: [0x00,0x00,0x2c,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

buffer_store_format_d16_x v1, off, s[4:7], s1
// UNPACKED: buffer_store_format_d16_x v1, off, s[4:7], s1 ; encoding: [0x00,0x00,0x30,0xe0,0x00,0x01,0x01,0x01]

buffer_store_format_d16_xy v[1:2], off, s[4:7], s1
// UNPACKED: buffer_store_format_d16_xy v[1:2], off, s[4:7], s1 ; encoding: [0x00,0x00,0x34,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

buffer_store_format_d16_xyz v[1:3], off, s[4:7], s1
// UNPACKED: buffer_store_format_d16_xyz v[1:3], off, s[4:7], s1 ; encoding: [0x00,0x00,0x38,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

buffer_store_format_d16_xyzw v[1:4], off, s[4:7], s1
// UNPACKED: buffer_store_format_d16_xyzw v[1:4], off, s[4:7], s1 ; encoding: [0x00,0x00,0x3c,0xe0,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode


//===----------------------------------------------------------------------===//
// TBuffer Format Instructions.
//===----------------------------------------------------------------------===//

tbuffer_load_format_d16_x v1, off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_load_format_d16_x v1, off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x00,0x7c,0xe9,0x00,0x01,0x01,0x01]

tbuffer_load_format_d16_xy v[1:2], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_load_format_d16_xy v[1:2], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x80,0x7c,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

tbuffer_load_format_d16_xyz v[1:3], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_load_format_d16_xyz v[1:3], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x00,0x7d,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

tbuffer_load_format_d16_xyzw v[1:4], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_load_format_d16_xyzw v[1:4], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x80,0x7d,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

tbuffer_store_format_d16_x v1, off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_store_format_d16_x v1, off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x00,0x7e,0xe9,0x00,0x01,0x01,0x01]

tbuffer_store_format_d16_xy v[1:2], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_store_format_d16_xy v[1:2], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x80,0x7e,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

tbuffer_store_format_d16_xyz v[1:3], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_store_format_d16_xyz v[1:3], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x00,0x7f,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode

tbuffer_store_format_d16_xyzw v[1:4], off, s[4:7], dfmt:15, nfmt:2, s1
// UNPACKED: tbuffer_store_format_d16_xyzw v[1:4], off, s[4:7], s1 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_USCALED] ; encoding: [0x00,0x80,0x7f,0xe9,0x00,0x01,0x01,0x01]
// PACKED-ERR: :[[@LINE-2]]:{{[0-9]+}}: error: operands are not valid for this GPU or mode
