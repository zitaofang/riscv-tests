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

  la a5,src
  la a6,dest
  
  li a4,128
  vsetvli a4,a4,e32,m2
  csrwi vstart,0

  li a0,0
  slli t0,a4,2
  la a3,index
index_loop:
  addi a0,a0,4
  sub a1,t0,a0
  sb a1,0(a3)
  addi a3,a3,1
  bne a0,t0,index_loop

  la a3,index
  vle8.v v2,0(a3)

  vluxseg2ei8.v v4,(a5),v2
  vs1r.v v7,(a6)

  li a2,0
  slli t0,a4,1
  srli a4,a4,1
  add a6,a6,t0
  addi a6,a6,-4
  addi a5,a5,4
loop:
  lw a0,0(a6)
  lw a1,0(a5)
  addi TESTNUM,a2,2
  bne a0,a1,fail
  addi a6,a6,-4
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

index:
  .skip 1024

RVTEST_DATA_END
