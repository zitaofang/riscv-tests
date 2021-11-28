# See LICENSE for license details.

#*****************************************************************************
# lb.S
#-----------------------------------------------------------------------------
#
# Test lb instruction in a vf block.
# Be careful with your bootrom config setting: This test assume the bootrom 
#   end at 0x20000, which is the default setting.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

# vsetvli a2,zero,0
  la a5,0x20000
  la a6,dest

  li t0,5
  sub a5,a5,t0

  # We are doing seg2 fault-only-first, so vl will end up be 2 with 4 elements written
  li t0,4
  add t2,a6,t0
  li t3,0xce
  sb t3,0(t2)
  
  li a4, 128
  vsetvli a4,a4,e8,m1
  csrwi vstart,0

  vlseg2e8ff.v v2,0(a5)
  vsseg2e8.v v2,0(a6)

  li t4,2
  csrr t1,vl
  bne t4,t1,fail

  li a2,0
loop:
  lb a0,0(a6)
  lb a1,0(a5)
  addi TESTNUM,a2,2
  bne a0,a1,fail
  addi a6,a6,1
  addi a5,a5,1
  addi a2,a2,1
  bne a2,t0,loop
  lb a0,0(t2)
  bne t3,a0,fail
  j pass

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
