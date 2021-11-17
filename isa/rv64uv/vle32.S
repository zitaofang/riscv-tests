# See LICENSE for license details.

#*****************************************************************************
# lw.S
#-----------------------------------------------------------------------------
#
# Test lw instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

# vsetvli a2,zero,0
  la a5,src
  la a6,dest
  
  li a4, 128
  vsetvli a4,a4,e32,mf2
  csrwi vstart,0

  vle32.v v2,0(a5)
  vse32.v v2,0(a6)

  li a2,0
loop:
  lw a0,0(a6)
  lw a1,0(a5)
  addi TESTNUM,a2,2
  bne a0,a1,fail
  addi a6,a6,4
  addi a5,a5,4
  addi a2,a2,1
  bne a2,a4,loop
  j pass

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
#include "data_w.h"

dest:
  .skip 16384

RVTEST_DATA_END
