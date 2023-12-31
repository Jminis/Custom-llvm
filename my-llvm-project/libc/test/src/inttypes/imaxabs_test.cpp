//===-- Unittests for imaxabs ---------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/inttypes/imaxabs.h"
#include "test/UnitTest/Test.h"

TEST(LlvmLibcImaxAbsTest, Zero) {
  EXPECT_EQ(LIBC_NAMESPACE::imaxabs(0), intmax_t(0));
}

TEST(LlvmLibcImaxAbsTest, Positive) {
  EXPECT_EQ(LIBC_NAMESPACE::imaxabs(1), intmax_t(1));
}

TEST(LlvmLibcImaxAbsTest, Negative) {
  EXPECT_EQ(LIBC_NAMESPACE::imaxabs(-1), intmax_t(1));
}
