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

  la a7,mask
  li t0,0xaaaaaaaa
  li t1,16
  li t2,0
mask_loop:
  sw t0,0(a7)
  addi a7,a7,4
  addi t2,t2,1
  bne t1,t2,mask_loop
  
  li a4, 128
  vsetvli a4,a4,e8,m1
  csrwi vstart,0
  li t0,3

  la a7,mask
  #vlm.v v0,(a7)
  vle1.v v0,(a7)

  vlse8.v v1,(a5),t0,v0.t
  vsse8.v v1,(a6),t0,v0.t

  slli t0,t0,1
  srli a4,a4,1
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

mask:
  .skip 1024

RVTEST_DATA_END
