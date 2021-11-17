# See LICENSE for license details.

#*****************************************************************************
# lb.S
#-----------------------------------------------------------------------------
#
# Test lb instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

# vsetvli a2,zero,0
  la a5,src
  la a6,dest
  
  li a4, 128
  vsetvli a4,a4,e8,m1
  csrwi vstart,0
  li t0,3

  vlse8.v v1,(a5),t0
  vsse8.v v1,(a6),t0

  li a2,0
loop:
  lb a0,0(a6)
  lb a1,0(a5)
  addi TESTNUM,a2,2
  bne a0,a1,fail
  li t1,1
inner_loop:
  addi a6,a6,1
  lb t2,0(a6)
  bnez t2,fail
  addi t1,t1,1
  bne t1,t0,inner_loop
  addi a6,a6,1
  add a5,a5,t0
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
