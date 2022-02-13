	li hp, 16777568
	jump min_caml_start
print_char:
    sw a0, 0(zero)
	jalr zero, ra, 0
print_int:
	li a1, 48
	li a2, 48
	li a3, 48
	li a4, 100
	li a5, 10
	li a6, 1
	li a7, 48
print_int_l1:
	blt a0, a4, print_int_l2
	addi a1, a1, 1
	addi a0, a0, -100
	jump print_int_l1
print_int_l2:
	blt a0, a5, print_int_l3
	addi a2, a2, 1
	addi a0, a0, -10
	jump print_int_l2
print_int_l3:
	blt a0, a6, print_int_l4
	addi a3, a3, 1
	addi a0, a0, -1
	jump print_int_l3
print_int_l4:
	sw a1, 0(zero)
	sw a2, 0(zero)
	sw a3, 0(zero)
	jalr zero, ra, 0
read_int:
    lw a0, 0(zero)
    lw a1, 0(zero)
    slli a1, a1, 8
    add a0, a0, a1
    lw a1, 0(zero)
    slli a1, a1, 16
    add a0, a0, a1
    lw a1 , 0(zero)
    slli a1, a1, 24
    add a0, a0, a1
    jalr zero, ra, 0
read_float:
    lw a0, 0(zero)
    lw a1, 0(zero)
    slli a1, a1, 8
    add a0, a0, a1
    lw a1, 0(zero)
    slli a1, a1, 16
    add a0, a0, a1
    lw a1 , 0(zero)
    slli a1, a1, 24
    add a0, a0, a1
    fmv.w.x f0, a0
    jalr zero, ra, 0
fiszero:
    feq a0, f0, fzero
    jalr zero, ra, 0
fispos:
    flt a0, fzero, f0
    jalr zero, ra, 0
fisneg:
    flt a0, f0, fzero
    jalr zero, ra, 0
fneg:
    fneg f0, f0
    jalr zero, ra, 0
fabs:
    flt a1, f0, fzero
    bne a1, zero, fabs_l1
    jalr zero, ra, 0
fabs_l1:
    fneg f0, f0
    jalr zero, ra, 0
fless:
    flt a0, f0, f1
    jalr zero, ra, 0
fhalf:
    fli f1, 0.5
    fmul f0, f0, f1
    jalr zero, ra, 0
floor:
    ftoi a0,f0
    itof f1,a0
    flt a1,f0,f1
    sub a0,a0,a1
    itof f0,a0
    jalr zero, ra, 0
int_of_float:
    ftoi a0, f0
    jalr zero, ra, 0
float_of_int:
    itof f0, a0
    jalr zero, ra, 0
sqrt:
    fsqrt f0, f0
    jalr zero, ra, 0
fsqr:
    fmul f0, f0, f0
    jalr zero, ra, 0
create_array: # a0-length array with value a1
    addi a3, a0, 0
create_array_loop:
    bge zero, a0, create_array_exit
create_array_cont:
    addi a0, a0, -1
    # slli a2, a0, 2
    add a2, a0, hp
    sw a1, 0(a2)
    jump create_array_loop
create_array_exit:
    add a0, hp, zero
    add hp, hp, a3
    jalr zero, ra, 0
create_float_array: # a0-length array with value f0
    addi a3, a0, 0
create_float_array_loop:
    bge zero, a0, create_float_array_exit
create_float_array_cont:
    addi a0, a0, -1
    # slli a2, a0, 2
    add a2, a0, hp
    fsw f0, 0(a2)
    jump create_float_array_loop
create_float_array_exit:
    add a0, hp, zero
    add hp, hp, a3
    jalr zero, ra, 0
create_global_array: # a1-length array with value a2 @address a0
    addi a3, a0, 0
    addi a0, a1, 0
    addi a1, a2, 0
create_global_array_loop:
    bge zero, a0, create_global_array_exit
create_global_array_cont:
    addi a0, a0, -1
    add a4, a0, a3
    sw a1, 0(a4)
    jump create_global_array_loop
create_global_array_exit:
    add a0, a3, zero
    jalr zero, ra, 0
create_global_float_array: # a1-length array with value f0 @address a0
    addi a3, a0, 0
    addi a0, a1, 0
create_global_float_array_loop:
    bge zero, a0, create_global_float_array_exit
create_global_float_array_cont:
    addi a0, a0, -1
    add a4, a0, a3
    fsw f0, 0(a4)
    jump create_global_float_array_loop
create_global_float_array_exit:
    add a0, a3, zero
    jalr zero, ra, 0
pi_div.122:
	fli f2, 0.000000
	feq a20, f2, f0
	beq a20, zero, fbe_else.313
	jalr zero, ra, 0 # ret
fbe_else.313:
	fli f2, 0.000000
	fle a20, f0, f2
	beq a20, zero, fble_else.314
	fneg f2, f0
	fle a20, f2, f1
	beq a20, zero, fble_else.315
	fadd f0, f0, f1
	fsw f0, 0(sp)
	fmv f0, f1
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, fhalf # call
	addi sp, sp, 3
	lw ra, -2(sp)
	fadd f1, f0, fzero
	flw f0, 0(sp)
	jump pi_div.122
fble_else.315:
	fli f2, 2.000000
	fmul f1, f1, f2
	jump pi_div.122
fble_else.314:
	fli f2, 3.141593
	fli f3, 2.000000
	fmul f2, f2, f3
	fle a20, f2, f0
	beq a20, zero, fble_else.316
	fle a20, f0, f1
	beq a20, zero, fble_else.317
	fsw f1, -2(sp)
	fsw f0, -4(sp)
	fmv f0, f1
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, fhalf # call
	addi sp, sp, 7
	lw ra, -6(sp)
	flw f1, -4(sp)
	fsub f0, f1, f0
	flw f1, -2(sp)
	fsw f0, -6(sp)
	fmv f0, f1
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, fhalf # call
	addi sp, sp, 9
	lw ra, -8(sp)
	fadd f1, f0, fzero
	flw f0, -6(sp)
	jump pi_div.122
fble_else.317:
	fli f2, 2.000000
	fmul f1, f1, f2
	jump pi_div.122
fble_else.316:
	jalr zero, ra, 0 # ret
pi4div.125:
	fli f1, 3.141593
	fli f2, 2.000000
	fdiv f1, f1, f2
	fle a20, f1, f0
	beq a20, zero, fble_else.318
	fli f1, 3.141593
	fle a20, f1, f0
	beq a20, zero, fble_else.319
	fli f1, 3.141593
	fli f2, 1.500000
	fmul f1, f1, f2
	fle a20, f1, f0
	beq a20, zero, fble_else.320
	fli f1, 3.141593
	fli f2, 2.000000
	fmul f1, f1, f2
	fsub f0, f1, f0
	fli f1, 1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.320:
	fli f1, 3.141593
	fsub f0, f0, f1
	fli f1, -1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.319:
	fli f1, 3.141593
	fsub f0, f1, f0
	fli f1, -1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.318:
	fli f1, 1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
pi4div2.127:
	fli f1, 3.141593
	fli f2, 2.000000
	fdiv f1, f1, f2
	fle a20, f1, f0
	beq a20, zero, fble_else.321
	fli f1, 3.141593
	fle a20, f1, f0
	beq a20, zero, fble_else.322
	fli f1, 3.141593
	fli f2, 1.500000
	fmul f1, f1, f2
	fle a20, f1, f0
	beq a20, zero, fble_else.323
	fli f1, 3.141593
	fli f2, 2.000000
	fmul f1, f1, f2
	fsub f0, f1, f0
	fli f1, -1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.323:
	fli f1, 3.141593
	fsub f0, f0, f1
	fli f1, -1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.322:
	fli f1, 3.141593
	fsub f0, f1, f0
	fli f1, 1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
fble_else.321:
	fli f1, 1.000000
	add a0, hp, zero
	addi hp, hp, 8
	fsw f1, 4(a0)
	fsw f0, 0(a0)
	jalr zero, ra, 0 # ret
tailor_cos.129:
	fmul f0, f0, f0
	fsw f0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, fhalf # call
	addi sp, sp, 3
	lw ra, -2(sp)
	flw f1, 0(sp)
	fmul f2, f1, f0
	fli f3, 0.083333
	fmul f2, f2, f3
	fmul f3, f1, f2
	fli f4, 0.033333
	fmul f3, f3, f4
	fmul f4, f1, f3
	fli f5, 0.017857
	fmul f4, f4, f5
	fmul f5, f1, f4
	fli f6, 0.011111
	fmul f5, f5, f6
	fmul f1, f1, f5
	fli f6, 0.007576
	fmul f1, f1, f6
	fli f6, 1.000000
	fsub f0, f6, f0
	fadd f0, f0, f2
	fsub f0, f0, f3
	fadd f0, f0, f4
	fsub f0, f0, f5
	fadd f0, f0, f1
	jalr zero, ra, 0 # ret
cos:
	fli f1, 3.141593
	fli f2, 2.000000
	fmul f1, f1, f2
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, pi_div.122 # call
	addi sp, sp, 1
	lw ra, 0(sp)
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, pi4div.125 # call
	addi sp, sp, 1
	lw ra, 0(sp)
	flw f0, 4(a0)
	flw f1, 0(a0)
	fsw f0, 0(sp)
	fmv f0, f1
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, tailor_cos.129 # call
	addi sp, sp, 3
	lw ra, -2(sp)
	flw f1, 0(sp)
	fmul f0, f1, f0
	jalr zero, ra, 0 # ret
sin:
	fli f1, 3.141593
	fli f2, 2.000000
	fmul f1, f1, f2
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, pi_div.122 # call
	addi sp, sp, 1
	lw ra, 0(sp)
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, pi4div2.127 # call
	addi sp, sp, 1
	lw ra, 0(sp)
	flw f0, 4(a0)
	flw f1, 0(a0)
	fli f2, 3.141593
	fli f3, 2.000000
	fdiv f2, f2, f3
	fsub f1, f2, f1
	fsw f0, 0(sp)
	fmv f0, f1
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, tailor_cos.129 # call
	addi sp, sp, 3
	lw ra, -2(sp)
	flw f1, 0(sp)
	fmul f0, f1, f0
	jalr zero, ra, 0 # ret
tailor_atan.135:
	fmul f1, f0, f0
	fmul f2, f1, f0
	fli f3, 0.333333
	fmul f2, f2, f3
	fmul f3, f1, f2
	fli f4, 0.600000
	fmul f3, f3, f4
	fmul f4, f1, f3
	fli f5, 0.714286
	fmul f4, f4, f5
	fmul f5, f1, f4
	fli f6, 0.777778
	fmul f5, f5, f6
	fmul f1, f1, f5
	fli f6, 0.818182
	fmul f1, f1, f6
	fsub f0, f0, f2
	fadd f0, f0, f3
	fsub f0, f0, f4
	fadd f0, f0, f5
	fsub f0, f0, f1
	jalr zero, ra, 0 # ret
atan:
	fli f1, 0.000000
	fle a20, f1, f0
	beq a20, zero, fble_else.324
	fli f1, 1.000000
	fle a20, f0, f1
	beq a20, zero, fble_else.325
	fli f1, 0.414214
	fle a20, f0, f1
	beq a20, zero, fble_else.326
	jump tailor_atan.135
fble_else.326:
	fli f1, 3.141593
	fli f2, 4.000000
	fdiv f1, f1, f2
	fli f2, 1.000000
	fsub f2, f0, f2
	fli f3, 1.000000
	fadd f0, f3, f0
	fdiv f0, f2, f0
	fsw f1, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, atan # call
	addi sp, sp, 3
	lw ra, -2(sp)
	flw f1, 0(sp)
	fadd f0, f1, f0
	jalr zero, ra, 0 # ret
fble_else.325:
	fli f1, 3.141593
	fli f2, 2.000000
	fdiv f1, f1, f2
	fli f2, 1.000000
	fdiv f0, f2, f0
	fsw f1, -2(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, atan # call
	addi sp, sp, 5
	lw ra, -4(sp)
	flw f1, -2(sp)
	fsub f0, f1, f0
	jalr zero, ra, 0 # ret
fble_else.324:
	fneg f0, f0
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, atan # call
	addi sp, sp, 5
	lw ra, -4(sp)
	fneg f0, f0
	jalr zero, ra, 0 # ret
vecunit_sgn.2519:
	flw f0, 0(a0)
	fmul f0, f0, f0
	flw f1, 1(a0)
	fmul f1, f1, f1
	fadd f0, f0, f1
	flw f1, 2(a0)
	fmul f1, f1, f1
	fadd f0, f0, f1
	fsqrt f0, f0
	feq a2, f0, fzero
	li a3, 0
	bne a2, a3, be_else.15628
	bne a1, a3, be_else.15630
	fli f1, 1.000000
	fdiv f0, f1, f0
	jump be_cont.15631
be_else.15630:
	fli f1, -1.000000
	fdiv f0, f1, f0
be_cont.15631:
	jump be_cont.15629
be_else.15628:
	fli f0, 1.000000
be_cont.15629:
	flw f1, 0(a0)
	fmul f1, f1, f0
	fsw f1, 0(a0)
	flw f1, 1(a0)
	fmul f1, f1, f0
	fsw f1, 1(a0)
	flw f1, 2(a0)
	fmul f0, f1, f0
	fsw f0, 2(a0)
	jalr zero, ra, 0
vecaccum.2530:
	flw f1, 0(a0)
	flw f2, 0(a1)
	fmul f2, f0, f2
	fadd f1, f1, f2
	fsw f1, 0(a0)
	flw f1, 1(a0)
	flw f2, 1(a1)
	fmul f2, f0, f2
	fadd f1, f1, f2
	fsw f1, 1(a0)
	flw f1, 2(a0)
	flw f2, 2(a1)
	fmul f0, f0, f2
	fadd f0, f1, f0
	fsw f0, 2(a0)
	jalr zero, ra, 0
vecaccumv.2543:
	flw f0, 0(a0)
	flw f1, 0(a1)
	flw f2, 0(a2)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fsw f0, 0(a0)
	flw f0, 1(a0)
	flw f1, 1(a1)
	flw f2, 1(a2)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fsw f0, 1(a0)
	flw f0, 2(a0)
	flw f1, 2(a1)
	flw f2, 2(a2)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fsw f0, 2(a0)
	jalr zero, ra, 0
read_screen_settings.2620:
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, read_float
	addi sp, sp, 1
	lw ra, 0(sp)
	li a0, 16777277
	fsw f0, 0(a0)
	li a0, 1
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_float
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 16777277
	lw a1, 0(sp)
	add a22, a0, a1
	fsw f0, 0(a22)
	li a0, 2
	sw a0, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_float
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 16777277
	lw a1, -1(sp)
	add a22, a0, a1
	fsw f0, 0(a22)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_float
	addi sp, sp, 3
	lw ra, -2(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	fsw f0, -2(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, cos
	addi sp, sp, 5
	lw ra, -4(sp)
	flw f1, -2(sp)
	fsw f0, -3(sp)
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, sin
	addi sp, sp, 5
	lw ra, -4(sp)
	fsw f0, -4(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_float
	addi sp, sp, 7
	lw ra, -6(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	fsw f0, -5(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, cos
	addi sp, sp, 7
	lw ra, -6(sp)
	flw f1, -5(sp)
	fsw f0, -6(sp)
	fmv f0, f1
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, sin
	addi sp, sp, 9
	lw ra, -8(sp)
	flw f1, -3(sp)
	fmul f2, f1, f0
	fli f3, 200.000000
	fmul f2, f2, f3
	li a0, 16777374
	fsw f2, 0(a0)
	li a0, 1
	fli f2, -200.000000
	flw f3, -4(sp)
	fmul f2, f3, f2
	li a1, 16777374
	add a22, a1, a0
	fsw f2, 0(a22)
	li a0, 2
	flw f2, -6(sp)
	fmul f4, f1, f2
	fli f5, 200.000000
	fmul f4, f4, f5
	li a1, 16777374
	add a22, a1, a0
	fsw f4, 0(a22)
	li a0, 16777368
	fsw f2, 0(a0)
	li a0, 1
	li a1, 16777368
	fli f4, 0.000000
	add a22, a1, a0
	fsw f4, 0(a22)
	li a0, 2
	fneg f4, f0
	li a1, 16777368
	add a22, a1, a0
	fsw f4, 0(a22)
	fneg f4, f3
	fmul f0, f4, f0
	li a0, 16777371
	fsw f0, 0(a0)
	li a0, 1
	fneg f0, f1
	li a1, 16777371
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	fneg f0, f3
	fmul f0, f0, f2
	li a1, 16777371
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 16777277
	flw f0, 0(a0)
	li a0, 16777374
	flw f1, 0(a0)
	fsub f0, f0, f1
	li a0, 16777280
	fsw f0, 0(a0)
	li a0, 1
	li a1, 1
	li a2, 16777277
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 1
	li a2, 16777374
	add a22, a2, a1
	flw f1, 0(a22)
	fsub f0, f0, f1
	li a1, 16777280
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 2
	li a2, 16777277
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 2
	li a2, 16777374
	add a22, a2, a1
	flw f1, 0(a22)
	fsub f0, f0, f1
	li a1, 16777280
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
read_light.2622:
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, read_int
	addi sp, sp, 1
	lw ra, 0(sp)
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, read_float
	addi sp, sp, 1
	lw ra, 0(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	fsw f0, 0(sp)
	fsw f1, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, sin
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 1
	fneg f0, f0
	li a1, 16777283
	add a22, a1, a0
	fsw f0, 0(a22)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_float
	addi sp, sp, 3
	lw ra, -2(sp)
	flw f1, -1(sp)
	fmul f0, f0, f1
	flw f1, 0(sp)
	fsw f0, -2(sp)
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, cos
	addi sp, sp, 5
	lw ra, -4(sp)
	flw f1, -2(sp)
	fsw f0, -3(sp)
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, sin
	addi sp, sp, 5
	lw ra, -4(sp)
	flw f1, -3(sp)
	fmul f0, f1, f0
	li a0, 16777283
	fsw f0, 0(a0)
	flw f0, -2(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, cos
	addi sp, sp, 5
	lw ra, -4(sp)
	li a0, 2
	flw f1, -3(sp)
	fmul f0, f1, f0
	li a1, 16777283
	add a22, a1, a0
	fsw f0, 0(a22)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_float
	addi sp, sp, 5
	lw ra, -4(sp)
	li a0, 16777286
	fsw f0, 0(a0)
	jalr zero, ra, 0
rotate_quadratic_matrix.2624:
	flw f0, 0(a1)
	sw a0, 0(sp)
	sw a1, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, cos
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a0, -1(sp)
	flw f1, 0(a0)
	fsw f0, -2(sp)
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, sin
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -1(sp)
	flw f1, 1(a0)
	fsw f0, -3(sp)
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, cos
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -1(sp)
	flw f1, 1(a0)
	fsw f0, -4(sp)
	fmv f0, f1
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, sin
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -1(sp)
	flw f1, 2(a0)
	fsw f0, -5(sp)
	fmv f0, f1
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, cos
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -1(sp)
	flw f1, 2(a0)
	fsw f0, -6(sp)
	fmv f0, f1
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, sin
	addi sp, sp, 9
	lw ra, -8(sp)
	flw f1, -6(sp)
	flw f2, -4(sp)
	fmul f3, f2, f1
	flw f4, -5(sp)
	flw f5, -3(sp)
	fmul f6, f5, f4
	fmul f6, f6, f1
	flw f7, -2(sp)
	fmul f8, f7, f0
	fsub f6, f6, f8
	fmul f8, f7, f4
	fmul f8, f8, f1
	fmul f9, f5, f0
	fadd f8, f8, f9
	fmul f9, f2, f0
	fmul f10, f5, f4
	fmul f10, f10, f0
	fmul f11, f7, f1
	fadd f10, f10, f11
	fmul f11, f7, f4
	fmul f0, f11, f0
	fmul f1, f5, f1
	fsub f0, f0, f1
	fneg f1, f4
	fmul f4, f5, f2
	fmul f2, f7, f2
	lw a0, 0(sp)
	flw f5, 0(a0)
	flw f7, 1(a0)
	flw f11, 2(a0)
	fmul f12, f3, f3
	fmul f12, f5, f12
	fsw f9, -7(sp)
	fmul f9, f9, f9
	fmul f9, f7, f9
	fadd f9, f12, f9
	fmul f12, f1, f1
	fmul f12, f11, f12
	fadd f9, f9, f12
	fsw f9, 0(a0)
	fmul f9, f6, f6
	fmul f9, f5, f9
	fmul f12, f10, f10
	fmul f12, f7, f12
	fadd f9, f9, f12
	fmul f12, f4, f4
	fmul f12, f11, f12
	fadd f9, f9, f12
	fsw f9, 1(a0)
	fmul f9, f8, f8
	fmul f9, f5, f9
	fmul f12, f0, f0
	fmul f12, f7, f12
	fadd f9, f9, f12
	fmul f12, f2, f2
	fmul f12, f11, f12
	fadd f9, f9, f12
	fsw f9, 2(a0)
	fli f9, 2.000000
	fmul f12, f5, f6
	fmul f12, f12, f8
	fsw f10, -8(sp)
	fmul f10, f7, f10
	fmul f10, f10, f0
	fadd f10, f12, f10
	fmul f12, f11, f4
	fmul f12, f12, f2
	fadd f10, f10, f12
	fmul f9, f9, f10
	lw a0, -1(sp)
	fsw f9, 0(a0)
	fli f9, 2.000000
	fmul f10, f5, f3
	fmul f8, f10, f8
	flw f10, -7(sp)
	fmul f12, f7, f10
	fmul f0, f12, f0
	fadd f0, f8, f0
	fmul f8, f11, f1
	fmul f2, f8, f2
	fadd f0, f0, f2
	fmul f0, f9, f0
	fsw f0, 1(a0)
	fli f0, 2.000000
	fmul f2, f5, f3
	fmul f2, f2, f6
	fmul f3, f7, f10
	flw f5, -8(sp)
	fmul f3, f3, f5
	fadd f2, f2, f3
	fmul f1, f11, f1
	fmul f1, f1, f4
	fadd f1, f2, f1
	fmul f0, f0, f1
	fsw f0, 2(a0)
	jalr zero, ra, 0
read_nth_object.2627:
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_int
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, -1
	bne a0, a1, be_else.15638
	li a0, 0
	jalr zero, ra, 0
be_else.15638:
	sw a0, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_int
	addi sp, sp, 3
	lw ra, -2(sp)
	sw a0, -2(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_int
	addi sp, sp, 5
	lw ra, -4(sp)
	sw a0, -3(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_int
	addi sp, sp, 5
	lw ra, -4(sp)
	li a1, 3
	fli f0, 0.000000
	sw a0, -4(sp)
	add a0, a1, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_float_array
	addi sp, sp, 7
	lw ra, -6(sp)
	sw a0, -5(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_float
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	fsw f0, 0(a0)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_float
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	fsw f0, 1(a0)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_float
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	fsw f0, 2(a0)
	li a1, 3
	fli f0, 0.000000
	add a0, a1, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_float_array
	addi sp, sp, 7
	lw ra, -6(sp)
	sw a0, -6(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, read_float
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	fsw f0, 0(a0)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, read_float
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	fsw f0, 1(a0)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, read_float
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	fsw f0, 2(a0)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, read_float
	addi sp, sp, 9
	lw ra, -8(sp)
	flt a0, f0, fzero
	li a1, 2
	fli f0, 0.000000
	sw a0, -7(sp)
	add a0, a1, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_float_array
	addi sp, sp, 9
	lw ra, -8(sp)
	sw a0, -8(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, read_float
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	fsw f0, 0(a0)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, read_float
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	fsw f0, 1(a0)
	li a1, 3
	fli f0, 0.000000
	add a0, a1, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_float_array
	addi sp, sp, 11
	lw ra, -10(sp)
	sw a0, -9(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, read_float
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -9(sp)
	fsw f0, 0(a0)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, read_float
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -9(sp)
	fsw f0, 1(a0)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, read_float
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -9(sp)
	fsw f0, 2(a0)
	li a1, 3
	fli f0, 0.000000
	add a0, a1, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_float_array
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 0
	lw a2, -4(sp)
	bne a2, a1, be_else.15639
	jump be_cont.15640
be_else.15639:
	sw a0, -10(sp)
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, read_float
	addi sp, sp, 13
	lw ra, -12(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	lw a0, -10(sp)
	fsw f0, 0(a0)
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, read_float
	addi sp, sp, 13
	lw ra, -12(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	lw a0, -10(sp)
	fsw f0, 1(a0)
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, read_float
	addi sp, sp, 13
	lw ra, -12(sp)
	fli f1, 0.017453
	fmul f0, f0, f1
	lw a0, -10(sp)
	fsw f0, 2(a0)
be_cont.15640:
	li a1, 2
	lw a2, -2(sp)
	bne a2, a1, be_else.15641
	li a1, 1
	jump be_cont.15642
be_else.15641:
	lw a1, -7(sp)
be_cont.15642:
	li a3, 4
	fli f0, 0.000000
	sw a1, -11(sp)
	sw a0, -10(sp)
	add a0, a3, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, create_float_array
	addi sp, sp, 13
	lw ra, -12(sp)
	add a1, hp, zero
	addi hp, hp, 12
	sw a0, 10(a1)
	lw a0, -10(sp)
	sw a0, 9(a1)
	lw a2, -9(sp)
	sw a2, 8(a1)
	lw a2, -8(sp)
	sw a2, 7(a1)
	lw a2, -11(sp)
	sw a2, 6(a1)
	lw a2, -6(sp)
	sw a2, 5(a1)
	lw a2, -5(sp)
	sw a2, 4(a1)
	lw a3, -4(sp)
	sw a3, 3(a1)
	lw a4, -3(sp)
	sw a4, 2(a1)
	lw a4, -2(sp)
	sw a4, 1(a1)
	lw a5, -1(sp)
	sw a5, 0(a1)
	li a5, 16777217
	lw a6, 0(sp)
	add a22, a5, a6
	sw a1, 0(a22)
	li a1, 3
	bne a4, a1, be_else.15643
	flw f0, 0(a2)
	feq a1, f0, fzero
	li a4, 0
	bne a1, a4, be_else.15645
	feq a1, f0, fzero
	bne a1, a4, be_else.15647
	flt a1, fzero, f0
	bne a1, a4, be_else.15649
	fli f1, -1.000000
	jump be_cont.15650
be_else.15649:
	fli f1, 1.000000
be_cont.15650:
	jump be_cont.15648
be_else.15647:
	fli f1, 0.000000
be_cont.15648:
	fmul f0, f0, f0
	fdiv f0, f1, f0
	jump be_cont.15646
be_else.15645:
	fli f0, 0.000000
be_cont.15646:
	fsw f0, 0(a2)
	flw f0, 1(a2)
	feq a1, f0, fzero
	bne a1, a4, be_else.15651
	feq a1, f0, fzero
	bne a1, a4, be_else.15653
	flt a1, fzero, f0
	bne a1, a4, be_else.15655
	fli f1, -1.000000
	jump be_cont.15656
be_else.15655:
	fli f1, 1.000000
be_cont.15656:
	jump be_cont.15654
be_else.15653:
	fli f1, 0.000000
be_cont.15654:
	fmul f0, f0, f0
	fdiv f0, f1, f0
	jump be_cont.15652
be_else.15651:
	fli f0, 0.000000
be_cont.15652:
	fsw f0, 1(a2)
	flw f0, 2(a2)
	feq a1, f0, fzero
	bne a1, a4, be_else.15657
	feq a1, f0, fzero
	bne a1, a4, be_else.15659
	flt a1, fzero, f0
	bne a1, a4, be_else.15661
	fli f1, -1.000000
	jump be_cont.15662
be_else.15661:
	fli f1, 1.000000
be_cont.15662:
	jump be_cont.15660
be_else.15659:
	fli f1, 0.000000
be_cont.15660:
	fmul f0, f0, f0
	fdiv f0, f1, f0
	jump be_cont.15658
be_else.15657:
	fli f0, 0.000000
be_cont.15658:
	fsw f0, 2(a2)
	jump be_cont.15644
be_else.15643:
	li a1, 2
	bne a4, a1, be_else.15663
	li a1, 0
	lw a4, -7(sp)
	bne a4, a1, be_else.15665
	li a4, 1
	jump be_cont.15666
be_else.15665:
	add a4, a1, zero
be_cont.15666:
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, vecunit_sgn.2519
	addi sp, sp, 13
	lw ra, -12(sp)
	jump be_cont.15664
be_else.15663:
be_cont.15664:
be_cont.15644:
	li a0, 0
	lw a1, -4(sp)
	bne a1, a0, be_else.15667
	jump be_cont.15668
be_else.15667:
	lw a0, -5(sp)
	lw a1, -10(sp)
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, rotate_quadratic_matrix.2624
	addi sp, sp, 13
	lw ra, -12(sp)
be_cont.15668:
	li a0, 1
	jalr zero, ra, 0
read_object.2629:
	lw a1, 1(cl)
	li a2, 60
	blt a0, a2, ble_else.15669
	jalr zero, ra, 0
ble_else.15669:
	sw cl, 0(sp)
	sw a1, -1(sp)
	sw a2, -2(sp)
	sw a0, -3(sp)
	add cl, a1, zero
	sw ra, -4(sp)
	lw swp, 0(cl)
	addi sp, sp, -5
	jalr ra, swp, 0
	addi sp, sp, 5
	lw ra, -4(sp)
	li a1, 0
	bne a0, a1, be_else.15671
	li a0, 16777216
	lw a1, -3(sp)
	sw a1, 0(a0)
	jalr zero, ra, 0
be_else.15671:
	lw a0, -3(sp)
	addi a0, a0, 1
	lw a2, -2(sp)
	blt a0, a2, ble_else.15673
	jalr zero, ra, 0
ble_else.15673:
	lw cl, -1(sp)
	sw a0, -4(sp)
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15675
	li a0, 16777216
	lw a1, -4(sp)
	sw a1, 0(a0)
	jalr zero, ra, 0
be_else.15675:
	lw a0, -4(sp)
	addi a0, a0, 1
	lw a2, -2(sp)
	blt a0, a2, ble_else.15677
	jalr zero, ra, 0
ble_else.15677:
	lw cl, -1(sp)
	sw a0, -5(sp)
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15679
	li a0, 16777216
	lw a1, -5(sp)
	sw a1, 0(a0)
	jalr zero, ra, 0
be_else.15679:
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a2, -2(sp)
	blt a0, a2, ble_else.15681
	jalr zero, ra, 0
ble_else.15681:
	lw cl, -1(sp)
	sw a0, -6(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15683
	li a0, 16777216
	lw a1, -6(sp)
	sw a1, 0(a0)
	jalr zero, ra, 0
be_else.15683:
	lw a0, -6(sp)
	addi a0, a0, 1
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
read_net_item.2633:
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_int
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, -1
	bne a0, a1, be_else.15685
	lw a0, 0(sp)
	addi a0, a0, 1
	jump create_array
be_else.15685:
	lw a2, 0(sp)
	addi a3, a2, 1
	sw a0, -1(sp)
	sw a3, -2(sp)
	sw a1, -3(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_int
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a1, -3(sp)
	bne a0, a1, be_else.15686
	lw a0, -2(sp)
	addi a0, a0, 1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_array
	addi sp, sp, 5
	lw ra, -4(sp)
	jump be_cont.15687
be_else.15686:
	lw a1, -2(sp)
	addi a2, a1, 1
	sw a0, -4(sp)
	add a0, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_net_item.2633
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -2(sp)
	lw a2, -4(sp)
	add a22, a1, a0
	sw a2, 0(a22)
be_cont.15687:
	lw a1, 0(sp)
	lw a2, -1(sp)
	add a22, a1, a0
	sw a2, 0(a22)
	jalr zero, ra, 0
read_or_network.2635:
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_int
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, -1
	bne a0, a1, be_else.15688
	li a0, 1
	li a1, -1
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_array
	addi sp, sp, 3
	lw ra, -2(sp)
	add a1, a0, zero
	jump be_cont.15689
be_else.15688:
	li a1, 1
	sw a0, -1(sp)
	add a0, a1, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_net_item.2633
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	sw a1, 0(a0)
	add a1, a0, zero
be_cont.15689:
	lw a0, 0(a1)
	li a2, -1
	bne a0, a2, be_else.15690
	lw a0, 0(sp)
	addi a0, a0, 1
	jump create_array
be_else.15690:
	lw a0, 0(sp)
	addi a2, a0, 1
	li a3, 0
	sw a1, -2(sp)
	sw a2, -3(sp)
	add a0, a3, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_net_item.2633
	addi sp, sp, 5
	lw ra, -4(sp)
	add a1, a0, zero
	lw a0, 0(a1)
	li a2, -1
	bne a0, a2, be_else.15691
	lw a0, -3(sp)
	addi a0, a0, 1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_array
	addi sp, sp, 5
	lw ra, -4(sp)
	jump be_cont.15692
be_else.15691:
	lw a0, -3(sp)
	addi a2, a0, 1
	sw a1, -4(sp)
	add a0, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_or_network.2635
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -3(sp)
	lw a2, -4(sp)
	add a22, a1, a0
	sw a2, 0(a22)
be_cont.15692:
	lw a1, 0(sp)
	lw a2, -2(sp)
	add a22, a1, a0
	sw a2, 0(a22)
	jalr zero, ra, 0
read_and_network.2637:
	sw cl, 0(sp)
	sw a0, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, read_int
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, -1
	sw a1, -2(sp)
	bne a0, a1, be_else.15693
	li a0, 1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_array
	addi sp, sp, 5
	lw ra, -4(sp)
	jump be_cont.15694
be_else.15693:
	li a2, 1
	sw a0, -3(sp)
	add a0, a2, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, read_net_item.2633
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a1, -3(sp)
	sw a1, 0(a0)
be_cont.15694:
	lw a1, 0(a0)
	lw a2, -2(sp)
	bne a1, a2, be_else.15695
	jalr zero, ra, 0
be_else.15695:
	li a1, 16777287
	lw a3, -1(sp)
	add a22, a1, a3
	sw a0, 0(a22)
	addi a0, a3, 1
	li a1, 0
	sw a0, -4(sp)
	add a0, a1, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, read_net_item.2633
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, 0(a0)
	lw a2, -2(sp)
	bne a1, a2, be_else.15697
	jalr zero, ra, 0
be_else.15697:
	li a1, 16777287
	lw a2, -4(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a2, 1
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
solver_rect_surface.2641:
	add a22, a2, a1
	flw f3, 0(a22)
	feq a5, f3, fzero
	li a6, 0
	bne a5, a6, be_else.15699
	lw a5, 4(a0)
	lw a0, 6(a0)
	add a22, a2, a1
	flw f3, 0(a22)
	flt a7, f3, fzero
	bne a0, a6, be_else.15700
	add a0, a7, zero
	jump be_cont.15701
be_else.15700:
	bne a7, a6, be_else.15702
	li a0, 1
	jump be_cont.15703
be_else.15702:
	add a0, a6, zero
be_cont.15703:
be_cont.15701:
	add a22, a2, a5
	flw f3, 0(a22)
	bne a0, a6, be_else.15704
	fneg f3, f3
	jump be_cont.15705
be_else.15704:
be_cont.15705:
	fsub f0, f3, f0
	add a22, a2, a1
	flw f3, 0(a22)
	fdiv f0, f0, f3
	add a22, a3, a1
	flw f3, 0(a22)
	fmul f3, f0, f3
	fadd f1, f3, f1
	fabs f1, f1
	add a22, a3, a5
	flw f3, 0(a22)
	flt a0, f1, f3
	bne a0, a6, be_else.15706
	add a0, a6, zero
	jalr zero, ra, 0
be_else.15706:
	add a22, a4, a1
	flw f1, 0(a22)
	fmul f1, f0, f1
	fadd f1, f1, f2
	fabs f1, f1
	add a22, a4, a5
	flw f2, 0(a22)
	flt a0, f1, f2
	bne a0, a6, be_else.15707
	add a0, a6, zero
	jalr zero, ra, 0
be_else.15707:
	li a0, 16777338
	fsw f0, 0(a0)
	li a0, 1
	jalr zero, ra, 0
be_else.15699:
	add a0, a6, zero
	jalr zero, ra, 0
quadratic.2662:
	fmul f3, f0, f0
	lw a1, 4(a0)
	flw f4, 0(a1)
	fmul f3, f3, f4
	fmul f4, f1, f1
	lw a1, 4(a0)
	flw f5, 1(a1)
	fmul f4, f4, f5
	fadd f3, f3, f4
	fmul f4, f2, f2
	lw a1, 4(a0)
	flw f5, 2(a1)
	fmul f4, f4, f5
	fadd f3, f3, f4
	lw a1, 3(a0)
	li a2, 0
	bne a1, a2, be_else.15708
	fadd f0, f3, fzero
	jalr zero, ra, 0
be_else.15708:
	fmul f4, f1, f2
	lw a1, 9(a0)
	flw f5, 0(a1)
	fmul f4, f4, f5
	fadd f3, f3, f4
	fmul f2, f2, f0
	lw a1, 9(a0)
	flw f4, 1(a1)
	fmul f2, f2, f4
	fadd f2, f3, f2
	fmul f0, f0, f1
	lw a0, 9(a0)
	flw f1, 2(a0)
	fmul f0, f0, f1
	fadd f0, f2, f0
	jalr zero, ra, 0
bilinear.2667:
	fmul f6, f0, f3
	lw a1, 4(a0)
	flw f7, 0(a1)
	fmul f6, f6, f7
	fmul f7, f1, f4
	lw a1, 4(a0)
	flw f8, 1(a1)
	fmul f7, f7, f8
	fadd f6, f6, f7
	fmul f7, f2, f5
	lw a1, 4(a0)
	flw f8, 2(a1)
	fmul f7, f7, f8
	fadd f6, f6, f7
	lw a1, 3(a0)
	li a2, 0
	bne a1, a2, be_else.15709
	fadd f0, f6, fzero
	jalr zero, ra, 0
be_else.15709:
	fmul f7, f2, f4
	fmul f8, f1, f5
	fadd f7, f7, f8
	lw a1, 9(a0)
	flw f8, 0(a1)
	fmul f7, f7, f8
	fmul f5, f0, f5
	fmul f2, f2, f3
	fadd f2, f5, f2
	lw a1, 9(a0)
	flw f5, 1(a1)
	fmul f2, f2, f5
	fadd f2, f7, f2
	fmul f0, f0, f4
	fmul f1, f1, f3
	fadd f0, f0, f1
	lw a0, 9(a0)
	flw f1, 2(a0)
	fmul f0, f0, f1
	fadd f0, f2, f0
	fli f1, 0.500000
	fmul f0, f0, f1
	fadd f0, f6, f0
	jalr zero, ra, 0
solver_second.2675:
	flw f3, 0(a1)
	flw f4, 1(a1)
	flw f5, 2(a1)
	fsw f2, 0(sp)
	fsw f1, -1(sp)
	fsw f0, -2(sp)
	sw a0, -3(sp)
	sw a1, -4(sp)
	fmv f2, f5
	fmv f1, f4
	fmv f0, f3
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, quadratic.2662
	addi sp, sp, 7
	lw ra, -6(sp)
	feq a0, f0, fzero
	li a1, 0
	bne a0, a1, be_else.15710
	lw a0, -4(sp)
	flw f1, 0(a0)
	flw f2, 1(a0)
	flw f3, 2(a0)
	flw f4, -2(sp)
	flw f5, -1(sp)
	flw f6, 0(sp)
	lw a0, -3(sp)
	fsw f0, -5(sp)
	fmv f0, f1
	fmv f1, f2
	fmv f2, f3
	fmv f3, f4
	fmv f4, f5
	fmv f5, f6
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, bilinear.2667
	addi sp, sp, 7
	lw ra, -6(sp)
	flw f1, -2(sp)
	flw f2, -1(sp)
	flw f3, 0(sp)
	lw a0, -3(sp)
	fsw f0, -6(sp)
	fmv f0, f1
	fmv f1, f2
	fmv f2, f3
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, quadratic.2662
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -3(sp)
	lw a1, 1(a0)
	li a2, 3
	bne a1, a2, be_else.15711
	fli f1, 1.000000
	fsub f0, f0, f1
	jump be_cont.15712
be_else.15711:
be_cont.15712:
	flw f1, -6(sp)
	fmul f2, f1, f1
	flw f3, -5(sp)
	fmul f0, f3, f0
	fsub f0, f2, f0
	flt a1, fzero, f0
	li a2, 0
	bne a1, a2, be_else.15713
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15713:
	fsqrt f0, f0
	lw a0, 6(a0)
	bne a0, a2, be_else.15714
	fneg f0, f0
	jump be_cont.15715
be_else.15714:
be_cont.15715:
	fsub f0, f0, f1
	fdiv f0, f0, f3
	li a0, 16777338
	fsw f0, 0(a0)
	li a0, 1
	jalr zero, ra, 0
be_else.15710:
	add a0, a1, zero
	jalr zero, ra, 0
solver.2681:
	lw a3, 6(cl)
	lw cl, 2(cl)
	li a4, 16777217
	add a22, a4, a0
	lw a0, 0(a22)
	flw f0, 0(a2)
	lw a4, 5(a0)
	flw f1, 0(a4)
	fsub f0, f0, f1
	flw f1, 1(a2)
	lw a4, 5(a0)
	flw f2, 1(a4)
	fsub f1, f1, f2
	flw f2, 2(a2)
	lw a2, 5(a0)
	flw f3, 2(a2)
	fsub f2, f2, f3
	lw a2, 1(a0)
	li a4, 1
	bne a2, a4, be_else.15716
	li a3, 1
	li a4, 2
	li a2, 0
	fsw f0, 0(sp)
	fsw f2, -1(sp)
	fsw f1, -2(sp)
	sw a4, -3(sp)
	sw a3, -4(sp)
	sw a1, -5(sp)
	sw a0, -6(sp)
	sw cl, -7(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a4, 0
	bne a0, a4, be_else.15717
	flw f0, -2(sp)
	flw f1, -1(sp)
	flw f2, 0(sp)
	lw a0, -6(sp)
	lw a1, -5(sp)
	lw a2, -4(sp)
	lw a3, -3(sp)
	lw cl, -7(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a3, 0
	bne a0, a3, be_else.15718
	flw f0, -1(sp)
	flw f1, 0(sp)
	flw f2, -2(sp)
	lw a0, -6(sp)
	lw a1, -5(sp)
	lw a2, -3(sp)
	lw a4, -4(sp)
	lw cl, -7(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15719
	add a0, a1, zero
	jalr zero, ra, 0
be_else.15719:
	li a0, 3
	jalr zero, ra, 0
be_else.15718:
	li a0, 2
	jalr zero, ra, 0
be_else.15717:
	li a0, 1
	jalr zero, ra, 0
be_else.15716:
	li a4, 2
	bne a2, a4, be_else.15720
	lw a0, 4(a0)
	flw f3, 0(a1)
	flw f4, 0(a0)
	fmul f3, f3, f4
	flw f4, 1(a1)
	flw f5, 1(a0)
	fmul f4, f4, f5
	fadd f3, f3, f4
	flw f4, 2(a1)
	flw f5, 2(a0)
	fmul f4, f4, f5
	fadd f3, f3, f4
	flt a1, fzero, f3
	li a2, 0
	bne a1, a2, be_else.15721
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15721:
	flw f4, 0(a0)
	fmul f0, f4, f0
	flw f4, 1(a0)
	fmul f1, f4, f1
	fadd f0, f0, f1
	flw f1, 2(a0)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fneg f0, f0
	fdiv f0, f0, f3
	li a0, 16777338
	fsw f0, 0(a0)
	li a0, 1
	jalr zero, ra, 0
be_else.15720:
	add cl, a3, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
solver_rect_fast.2685:
	flw f3, 0(a2)
	fsub f3, f3, f0
	flw f4, 1(a2)
	fmul f3, f3, f4
	flw f4, 1(a1)
	fmul f4, f3, f4
	fadd f4, f4, f1
	fabs f4, f4
	lw a3, 4(a0)
	flw f5, 1(a3)
	flt a3, f4, f5
	li a4, 0
	bne a3, a4, be_else.15722
	add a3, a4, zero
	jump be_cont.15723
be_else.15722:
	flw f4, 2(a1)
	fmul f4, f3, f4
	fadd f4, f4, f2
	fabs f4, f4
	lw a3, 4(a0)
	flw f5, 2(a3)
	flt a3, f4, f5
	bne a3, a4, be_else.15724
	add a3, a4, zero
	jump be_cont.15725
be_else.15724:
	flw f4, 1(a2)
	feq a3, f4, fzero
	bne a3, a4, be_else.15726
	li a3, 1
	jump be_cont.15727
be_else.15726:
	add a3, a4, zero
be_cont.15727:
be_cont.15725:
be_cont.15723:
	bne a3, a4, be_else.15728
	flw f3, 2(a2)
	fsub f3, f3, f1
	flw f4, 3(a2)
	fmul f3, f3, f4
	flw f4, 0(a1)
	fmul f4, f3, f4
	fadd f4, f4, f0
	fabs f4, f4
	lw a3, 4(a0)
	flw f5, 0(a3)
	flt a3, f4, f5
	bne a3, a4, be_else.15729
	add a3, a4, zero
	jump be_cont.15730
be_else.15729:
	flw f4, 2(a1)
	fmul f4, f3, f4
	fadd f4, f4, f2
	fabs f4, f4
	lw a3, 4(a0)
	flw f5, 2(a3)
	flt a3, f4, f5
	bne a3, a4, be_else.15731
	add a3, a4, zero
	jump be_cont.15732
be_else.15731:
	flw f4, 3(a2)
	feq a3, f4, fzero
	bne a3, a4, be_else.15733
	li a3, 1
	jump be_cont.15734
be_else.15733:
	add a3, a4, zero
be_cont.15734:
be_cont.15732:
be_cont.15730:
	bne a3, a4, be_else.15735
	flw f3, 4(a2)
	fsub f2, f3, f2
	flw f3, 5(a2)
	fmul f2, f2, f3
	flw f3, 0(a1)
	fmul f3, f2, f3
	fadd f0, f3, f0
	fabs f0, f0
	lw a3, 4(a0)
	flw f3, 0(a3)
	flt a3, f0, f3
	bne a3, a4, be_else.15736
	add a0, a4, zero
	jump be_cont.15737
be_else.15736:
	flw f0, 1(a1)
	fmul f0, f2, f0
	fadd f0, f0, f1
	fabs f0, f0
	lw a0, 4(a0)
	flw f1, 1(a0)
	flt a0, f0, f1
	bne a0, a4, be_else.15738
	add a0, a4, zero
	jump be_cont.15739
be_else.15738:
	flw f0, 5(a2)
	feq a0, f0, fzero
	bne a0, a4, be_else.15740
	li a0, 1
	jump be_cont.15741
be_else.15740:
	add a0, a4, zero
be_cont.15741:
be_cont.15739:
be_cont.15737:
	bne a0, a4, be_else.15742
	add a0, a4, zero
	jalr zero, ra, 0
be_else.15742:
	li a0, 16777338
	fsw f2, 0(a0)
	li a0, 3
	jalr zero, ra, 0
be_else.15735:
	li a0, 16777338
	fsw f3, 0(a0)
	li a0, 2
	jalr zero, ra, 0
be_else.15728:
	li a0, 16777338
	fsw f3, 0(a0)
	li a0, 1
	jalr zero, ra, 0
solver_surface_fast.2692:
	flw f3, 0(a1)
	flt a0, f3, fzero
	li a2, 0
	bne a0, a2, be_else.15743
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15743:
	li a0, 1
	flw f3, 1(a1)
	fmul f0, f3, f0
	flw f3, 2(a1)
	fmul f1, f3, f1
	fadd f0, f0, f1
	flw f1, 3(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	li a1, 16777338
	fsw f0, 0(a1)
	jalr zero, ra, 0
solver_second_fast.2698:
	flw f3, 0(a1)
	feq a2, f3, fzero
	li a3, 0
	bne a2, a3, be_else.15744
	flw f4, 1(a1)
	fmul f4, f4, f0
	flw f5, 2(a1)
	fmul f5, f5, f1
	fadd f4, f4, f5
	flw f5, 3(a1)
	fmul f5, f5, f2
	fadd f4, f4, f5
	sw a1, 0(sp)
	fsw f3, -1(sp)
	fsw f4, -2(sp)
	sw a0, -3(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, quadratic.2662
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -3(sp)
	lw a1, 1(a0)
	li a2, 3
	bne a1, a2, be_else.15745
	fli f1, 1.000000
	fsub f0, f0, f1
	jump be_cont.15746
be_else.15745:
be_cont.15746:
	flw f1, -2(sp)
	fmul f2, f1, f1
	flw f3, -1(sp)
	fmul f0, f3, f0
	fsub f0, f2, f0
	flt a1, fzero, f0
	li a2, 0
	bne a1, a2, be_else.15747
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15747:
	lw a0, 6(a0)
	bne a0, a2, be_else.15748
	fsqrt f0, f0
	fsub f0, f1, f0
	lw a0, 0(sp)
	flw f1, 4(a0)
	fmul f0, f0, f1
	li a0, 16777338
	fsw f0, 0(a0)
	jump be_cont.15749
be_else.15748:
	fsqrt f0, f0
	fadd f0, f1, f0
	lw a0, 0(sp)
	flw f1, 4(a0)
	fmul f0, f0, f1
	li a0, 16777338
	fsw f0, 0(a0)
be_cont.15749:
	li a0, 1
	jalr zero, ra, 0
be_else.15744:
	add a0, a3, zero
	jalr zero, ra, 0
solver_fast.2704:
	lw a3, 4(cl)
	lw a4, 3(cl)
	lw cl, 2(cl)
	li a5, 16777217
	add a22, a5, a0
	lw a5, 0(a22)
	flw f0, 0(a2)
	lw a6, 5(a5)
	flw f1, 0(a6)
	fsub f0, f0, f1
	li a6, 1
	flw f1, 1(a2)
	lw a7, 5(a5)
	flw f2, 1(a7)
	fsub f1, f1, f2
	li a7, 2
	flw f2, 2(a2)
	lw a2, 5(a5)
	flw f3, 2(a2)
	fsub f2, f2, f3
	lw a2, 1(a1)
	add a22, a0, a2
	lw a2, 0(a22)
	lw a0, 1(a5)
	bne a0, a6, be_else.15750
	lw a1, 0(a1)
	add a0, a5, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15750:
	bne a0, a7, be_else.15751
	add a1, a2, zero
	add a0, a5, zero
	add cl, a4, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15751:
	add a1, a2, zero
	add a0, a5, zero
	add cl, a3, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
solver_second_fast2.2715:
	flw f3, 0(a1)
	feq a3, f3, fzero
	li a4, 0
	bne a3, a4, be_else.15752
	flw f4, 1(a1)
	fmul f0, f4, f0
	flw f4, 2(a1)
	fmul f1, f4, f1
	fadd f0, f0, f1
	flw f1, 3(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	flw f1, 3(a2)
	fmul f2, f0, f0
	fmul f1, f3, f1
	fsub f1, f2, f1
	flt a2, fzero, f1
	bne a2, a4, be_else.15753
	add a0, a4, zero
	jalr zero, ra, 0
be_else.15753:
	lw a0, 6(a0)
	bne a0, a4, be_else.15754
	fsqrt f1, f1
	fsub f0, f0, f1
	flw f1, 4(a1)
	fmul f0, f0, f1
	li a0, 16777338
	fsw f0, 0(a0)
	jump be_cont.15755
be_else.15754:
	fsqrt f1, f1
	fadd f0, f0, f1
	flw f1, 4(a1)
	fmul f0, f0, f1
	li a0, 16777338
	fsw f0, 0(a0)
be_cont.15755:
	li a0, 1
	jalr zero, ra, 0
be_else.15752:
	add a0, a4, zero
	jalr zero, ra, 0
solver_fast2.2722:
	lw a2, 4(cl)
	lw cl, 2(cl)
	li a3, 16777217
	add a22, a3, a0
	lw a3, 0(a22)
	lw a4, 10(a3)
	flw f0, 0(a4)
	li a5, 1
	flw f1, 1(a4)
	li a6, 2
	flw f2, 2(a4)
	lw a7, 1(a1)
	add a22, a0, a7
	lw a0, 0(a22)
	lw a7, 1(a3)
	bne a7, a5, be_else.15756
	lw a1, 0(a1)
	add a2, a0, zero
	add a0, a3, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15756:
	bne a7, a6, be_else.15757
	flw f0, 0(a0)
	flt a1, f0, fzero
	li a2, 0
	bne a1, a2, be_else.15758
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15758:
	flw f0, 0(a0)
	flw f1, 3(a4)
	fmul f0, f0, f1
	li a0, 16777338
	fsw f0, 0(a0)
	add a0, a5, zero
	jalr zero, ra, 0
be_else.15757:
	add a1, a0, zero
	add cl, a2, zero
	add a2, a4, zero
	add a0, a3, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
setup_rect_table.2725:
	li a2, 6
	fli f0, 0.000000
	sw a1, 0(sp)
	sw a0, -1(sp)
	add a0, a2, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	flw f0, 0(a1)
	feq a2, f0, fzero
	li a3, 0
	bne a2, a3, be_else.15759
	lw a2, 0(sp)
	lw a4, 6(a2)
	flw f0, 0(a1)
	flt a5, f0, fzero
	bne a4, a3, be_else.15761
	add a4, a5, zero
	jump be_cont.15762
be_else.15761:
	bne a5, a3, be_else.15763
	li a4, 1
	jump be_cont.15764
be_else.15763:
	add a4, a3, zero
be_cont.15764:
be_cont.15762:
	lw a5, 4(a2)
	flw f0, 0(a5)
	bne a4, a3, be_else.15765
	fneg f0, f0
	jump be_cont.15766
be_else.15765:
be_cont.15766:
	fsw f0, 0(a0)
	fli f0, 1.000000
	flw f1, 0(a1)
	fdiv f0, f0, f1
	fsw f0, 1(a0)
	jump be_cont.15760
be_else.15759:
	fli f0, 0.000000
	fsw f0, 1(a0)
be_cont.15760:
	flw f0, 1(a1)
	feq a2, f0, fzero
	bne a2, a3, be_else.15767
	lw a2, 0(sp)
	lw a4, 6(a2)
	flw f0, 1(a1)
	flt a5, f0, fzero
	bne a4, a3, be_else.15769
	add a4, a5, zero
	jump be_cont.15770
be_else.15769:
	bne a5, a3, be_else.15771
	li a4, 1
	jump be_cont.15772
be_else.15771:
	add a4, a3, zero
be_cont.15772:
be_cont.15770:
	lw a5, 4(a2)
	flw f0, 1(a5)
	bne a4, a3, be_else.15773
	fneg f0, f0
	jump be_cont.15774
be_else.15773:
be_cont.15774:
	fsw f0, 2(a0)
	fli f0, 1.000000
	flw f1, 1(a1)
	fdiv f0, f0, f1
	fsw f0, 3(a0)
	jump be_cont.15768
be_else.15767:
	fli f0, 0.000000
	fsw f0, 3(a0)
be_cont.15768:
	flw f0, 2(a1)
	feq a2, f0, fzero
	bne a2, a3, be_else.15775
	lw a2, 0(sp)
	lw a4, 6(a2)
	flw f0, 2(a1)
	flt a5, f0, fzero
	bne a4, a3, be_else.15777
	add a4, a5, zero
	jump be_cont.15778
be_else.15777:
	bne a5, a3, be_else.15779
	li a4, 1
	jump be_cont.15780
be_else.15779:
	add a4, a3, zero
be_cont.15780:
be_cont.15778:
	lw a2, 4(a2)
	flw f0, 2(a2)
	bne a4, a3, be_else.15781
	fneg f0, f0
	jump be_cont.15782
be_else.15781:
be_cont.15782:
	fsw f0, 4(a0)
	fli f0, 1.000000
	flw f1, 2(a1)
	fdiv f0, f0, f1
	fsw f0, 5(a0)
	jump be_cont.15776
be_else.15775:
	fli f0, 0.000000
	fsw f0, 5(a0)
be_cont.15776:
	jalr zero, ra, 0
setup_surface_table.2728:
	li a2, 4
	fli f0, 0.000000
	sw a1, 0(sp)
	sw a0, -1(sp)
	add a0, a2, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	flw f0, 0(a1)
	lw a2, 0(sp)
	lw a3, 4(a2)
	flw f1, 0(a3)
	fmul f0, f0, f1
	flw f1, 1(a1)
	lw a3, 4(a2)
	flw f2, 1(a3)
	fmul f1, f1, f2
	fadd f0, f0, f1
	flw f1, 2(a1)
	lw a1, 4(a2)
	flw f2, 2(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	flt a1, fzero, f0
	li a3, 0
	bne a1, a3, be_else.15783
	fli f0, 0.000000
	fsw f0, 0(a0)
	jump be_cont.15784
be_else.15783:
	fli f1, -1.000000
	fdiv f1, f1, f0
	fsw f1, 0(a0)
	lw a1, 4(a2)
	flw f1, 0(a1)
	fdiv f1, f1, f0
	fneg f1, f1
	fsw f1, 1(a0)
	lw a1, 4(a2)
	flw f1, 1(a1)
	fdiv f1, f1, f0
	fneg f1, f1
	fsw f1, 2(a0)
	lw a1, 4(a2)
	flw f1, 2(a1)
	fdiv f0, f1, f0
	fneg f0, f0
	fsw f0, 3(a0)
be_cont.15784:
	jalr zero, ra, 0
setup_second_table.2731:
	li a2, 5
	fli f0, 0.000000
	sw a1, 0(sp)
	sw a0, -1(sp)
	add a0, a2, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	flw f0, 0(a1)
	flw f1, 1(a1)
	flw f2, 2(a1)
	lw a2, 0(sp)
	sw a0, -2(sp)
	add a0, a2, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, quadratic.2662
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -1(sp)
	flw f1, 0(a0)
	lw a1, 0(sp)
	lw a2, 4(a1)
	flw f2, 0(a2)
	fmul f1, f1, f2
	fneg f1, f1
	flw f2, 1(a0)
	lw a2, 4(a1)
	flw f3, 1(a2)
	fmul f2, f2, f3
	fneg f2, f2
	flw f3, 2(a0)
	lw a2, 4(a1)
	flw f4, 2(a2)
	fmul f3, f3, f4
	fneg f3, f3
	lw a2, -2(sp)
	fsw f0, 0(a2)
	lw a3, 3(a1)
	li a4, 0
	bne a3, a4, be_else.15785
	fsw f1, 1(a2)
	fsw f2, 2(a2)
	fsw f3, 3(a2)
	jump be_cont.15786
be_else.15785:
	flw f4, 2(a0)
	lw a3, 9(a1)
	flw f5, 1(a3)
	fmul f4, f4, f5
	flw f5, 1(a0)
	lw a3, 9(a1)
	flw f6, 2(a3)
	fmul f5, f5, f6
	fadd f4, f4, f5
	fli f5, 0.500000
	fmul f4, f4, f5
	fsub f1, f1, f4
	fsw f1, 1(a2)
	flw f1, 2(a0)
	lw a3, 9(a1)
	flw f4, 0(a3)
	fmul f1, f1, f4
	flw f4, 0(a0)
	lw a3, 9(a1)
	flw f5, 2(a3)
	fmul f4, f4, f5
	fadd f1, f1, f4
	fli f4, 0.500000
	fmul f1, f1, f4
	fsub f1, f2, f1
	fsw f1, 2(a2)
	flw f1, 1(a0)
	lw a3, 9(a1)
	flw f2, 0(a3)
	fmul f1, f1, f2
	flw f2, 0(a0)
	lw a0, 9(a1)
	flw f4, 1(a0)
	fmul f2, f2, f4
	fadd f1, f1, f2
	fli f2, 0.500000
	fmul f1, f1, f2
	fsub f1, f3, f1
	fsw f1, 3(a2)
be_cont.15786:
	feq a0, f0, fzero
	bne a0, a4, be_else.15787
	fli f1, 1.000000
	fdiv f0, f1, f0
	fsw f0, 4(a2)
	jump be_cont.15788
be_else.15787:
be_cont.15788:
	add a0, a2, zero
	jalr zero, ra, 0
iter_setup_dirvec_constants.2734:
	li a2, 0
	blt a1, a2, ble_else.15789
	li a3, 16777217
	add a22, a3, a1
	lw a3, 0(a22)
	lw a4, 1(a0)
	lw a5, 0(a0)
	lw a6, 1(a3)
	li a7, 1
	sw cl, 0(sp)
	sw a7, -1(sp)
	sw a0, -2(sp)
	bne a6, a7, be_else.15790
	sw a1, -3(sp)
	sw a4, -4(sp)
	add a1, a3, zero
	add a0, a5, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, setup_rect_table.2725
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -3(sp)
	lw a2, -4(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.15791
be_else.15790:
	li a8, 2
	bne a6, a8, be_else.15792
	sw a1, -3(sp)
	sw a4, -4(sp)
	add a1, a3, zero
	add a0, a5, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, setup_surface_table.2728
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -3(sp)
	lw a2, -4(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.15793
be_else.15792:
	sw a1, -3(sp)
	sw a4, -4(sp)
	add a1, a3, zero
	add a0, a5, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, setup_second_table.2731
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -3(sp)
	lw a2, -4(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.15793:
be_cont.15791:
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.15794
	li a1, 16777217
	add a22, a1, a0
	lw a1, 0(a22)
	lw a2, -2(sp)
	lw a3, 1(a2)
	lw a4, 0(a2)
	lw a5, 1(a1)
	lw a6, -1(sp)
	bne a5, a6, be_else.15795
	sw a0, -5(sp)
	sw a3, -6(sp)
	add a0, a4, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_rect_table.2725
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.15796
be_else.15795:
	li a6, 2
	bne a5, a6, be_else.15797
	sw a0, -5(sp)
	sw a3, -6(sp)
	add a0, a4, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_surface_table.2728
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.15798
be_else.15797:
	sw a0, -5(sp)
	sw a3, -6(sp)
	add a0, a4, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_second_table.2731
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.15798:
be_cont.15796:
	addi a1, a1, -1
	lw a0, -2(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.15794:
	jalr zero, ra, 0
ble_else.15789:
	jalr zero, ra, 0
setup_startp_constants.2739:
	li a2, 0
	blt a1, a2, ble_else.15801
	li a2, 16777217
	add a22, a2, a1
	lw a2, 0(a22)
	lw a3, 10(a2)
	lw a4, 1(a2)
	flw f0, 0(a0)
	lw a5, 5(a2)
	flw f1, 0(a5)
	fsub f0, f0, f1
	fsw f0, 0(a3)
	flw f0, 1(a0)
	lw a5, 5(a2)
	flw f1, 1(a5)
	fsub f0, f0, f1
	fsw f0, 1(a3)
	flw f0, 2(a0)
	lw a5, 5(a2)
	flw f1, 2(a5)
	fsub f0, f0, f1
	fsw f0, 2(a3)
	li a5, 2
	sw a0, 0(sp)
	sw cl, -1(sp)
	sw a1, -2(sp)
	bne a4, a5, be_else.15802
	lw a2, 4(a2)
	flw f0, 0(a3)
	flw f1, 1(a3)
	flw f2, 2(a3)
	flw f3, 0(a2)
	fmul f0, f3, f0
	flw f3, 1(a2)
	fmul f1, f3, f1
	fadd f0, f0, f1
	flw f1, 2(a2)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fsw f0, 3(a3)
	jump be_cont.15803
be_else.15802:
	li a5, 2
	blt a5, a4, ble_else.15804
	jump ble_cont.15805
ble_else.15804:
	flw f0, 0(a3)
	flw f1, 1(a3)
	flw f2, 2(a3)
	sw a3, -3(sp)
	sw a4, -4(sp)
	add a0, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, quadratic.2662
	addi sp, sp, 7
	lw ra, -6(sp)
	li a0, 3
	lw a1, -4(sp)
	bne a1, a0, be_else.15806
	fli f1, 1.000000
	fsub f0, f0, f1
	jump be_cont.15807
be_else.15806:
be_cont.15807:
	lw a0, -3(sp)
	fsw f0, 3(a0)
ble_cont.15805:
be_cont.15803:
	lw a0, -2(sp)
	addi a1, a0, -1
	lw a0, 0(sp)
	lw cl, -1(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.15801:
	jalr zero, ra, 0
is_rect_outside.2744:
	fabs f0, f0
	lw a1, 4(a0)
	flw f3, 0(a1)
	flt a1, f0, f3
	li a2, 0
	bne a1, a2, be_else.15809
	add a1, a2, zero
	jump be_cont.15810
be_else.15809:
	fabs f0, f1
	lw a1, 4(a0)
	flw f1, 1(a1)
	flt a1, f0, f1
	bne a1, a2, be_else.15811
	add a1, a2, zero
	jump be_cont.15812
be_else.15811:
	fabs f0, f2
	lw a1, 4(a0)
	flw f1, 2(a1)
	flt a1, f0, f1
be_cont.15812:
be_cont.15810:
	bne a1, a2, be_else.15813
	lw a0, 6(a0)
	bne a0, a2, be_else.15814
	li a0, 1
	jalr zero, ra, 0
be_else.15814:
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15813:
	lw a0, 6(a0)
	jalr zero, ra, 0
is_plane_outside.2749:
	lw a1, 4(a0)
	flw f3, 0(a1)
	fmul f0, f3, f0
	li a2, 1
	flw f3, 1(a1)
	fmul f1, f3, f1
	fadd f0, f0, f1
	flw f1, 2(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	lw a0, 6(a0)
	flt a1, f0, fzero
	li a3, 0
	bne a0, a3, be_else.15815
	add a0, a1, zero
	jump be_cont.15816
be_else.15815:
	bne a1, a3, be_else.15817
	add a0, a2, zero
	jump be_cont.15818
be_else.15817:
	add a0, a3, zero
be_cont.15818:
be_cont.15816:
	bne a0, a3, be_else.15819
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15819:
	add a0, a3, zero
	jalr zero, ra, 0
is_outside.2759:
	lw a1, 5(a0)
	flw f3, 0(a1)
	fsub f0, f0, f3
	lw a1, 5(a0)
	flw f3, 1(a1)
	fsub f1, f1, f3
	lw a1, 5(a0)
	flw f3, 2(a1)
	fsub f2, f2, f3
	lw a1, 1(a0)
	li a2, 1
	bne a1, a2, be_else.15820
	jump is_rect_outside.2744
be_else.15820:
	li a2, 2
	bne a1, a2, be_else.15821
	lw a1, 4(a0)
	flw f3, 0(a1)
	fmul f0, f3, f0
	flw f3, 1(a1)
	fmul f1, f3, f1
	fadd f0, f0, f1
	flw f1, 2(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	lw a0, 6(a0)
	flt a1, f0, fzero
	li a2, 0
	bne a0, a2, be_else.15822
	add a0, a1, zero
	jump be_cont.15823
be_else.15822:
	bne a1, a2, be_else.15824
	li a0, 1
	jump be_cont.15825
be_else.15824:
	add a0, a2, zero
be_cont.15825:
be_cont.15823:
	bne a0, a2, be_else.15826
	li a0, 1
	jalr zero, ra, 0
be_else.15826:
	add a0, a2, zero
	jalr zero, ra, 0
be_else.15821:
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, quadratic.2662
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a0, 0(sp)
	lw a1, 1(a0)
	li a2, 3
	bne a1, a2, be_else.15827
	fli f1, 1.000000
	fsub f0, f0, f1
	jump be_cont.15828
be_else.15827:
be_cont.15828:
	lw a0, 6(a0)
	flt a1, f0, fzero
	li a2, 0
	bne a0, a2, be_else.15829
	add a0, a1, zero
	jump be_cont.15830
be_else.15829:
	bne a1, a2, be_else.15831
	li a0, 1
	jump be_cont.15832
be_else.15831:
	add a0, a2, zero
be_cont.15832:
be_cont.15830:
	bne a0, a2, be_else.15833
	li a0, 1
	jalr zero, ra, 0
be_else.15833:
	add a0, a2, zero
	jalr zero, ra, 0
check_all_inside.2764:
	add a22, a0, a1
	lw a2, 0(a22)
	li a3, -1
	bne a2, a3, be_else.15834
	li a0, 1
	jalr zero, ra, 0
be_else.15834:
	li a4, 16777217
	add a22, a4, a2
	lw a2, 0(a22)
	lw a4, 5(a2)
	flw f3, 0(a4)
	fsub f3, f0, f3
	lw a4, 5(a2)
	flw f4, 1(a4)
	fsub f4, f1, f4
	lw a4, 5(a2)
	flw f5, 2(a4)
	fsub f5, f2, f5
	lw a4, 1(a2)
	li a5, 1
	sw cl, 0(sp)
	fsw f2, -1(sp)
	fsw f1, -2(sp)
	fsw f0, -3(sp)
	sw a3, -4(sp)
	sw a1, -5(sp)
	sw a0, -6(sp)
	bne a4, a5, be_else.15835
	add a0, a2, zero
	fmv f2, f5
	fmv f1, f4
	fmv f0, f3
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, is_rect_outside.2744
	addi sp, sp, 9
	lw ra, -8(sp)
	jump be_cont.15836
be_else.15835:
	li a5, 2
	bne a4, a5, be_else.15837
	add a0, a2, zero
	fmv f2, f5
	fmv f1, f4
	fmv f0, f3
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, is_plane_outside.2749
	addi sp, sp, 9
	lw ra, -8(sp)
	jump be_cont.15838
be_else.15837:
	sw a2, -7(sp)
	add a0, a2, zero
	fmv f2, f5
	fmv f1, f4
	fmv f0, f3
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, quadratic.2662
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -7(sp)
	lw a1, 1(a0)
	li a2, 3
	bne a1, a2, be_else.15839
	fli f1, 1.000000
	fsub f0, f0, f1
	jump be_cont.15840
be_else.15839:
be_cont.15840:
	lw a0, 6(a0)
	flt a1, f0, fzero
	li a2, 0
	bne a0, a2, be_else.15841
	add a0, a1, zero
	jump be_cont.15842
be_else.15841:
	bne a1, a2, be_else.15843
	li a0, 1
	jump be_cont.15844
be_else.15843:
	add a0, a2, zero
be_cont.15844:
be_cont.15842:
	bne a0, a2, be_else.15845
	li a0, 1
	jump be_cont.15846
be_else.15845:
	add a0, a2, zero
be_cont.15846:
be_cont.15838:
be_cont.15836:
	li a1, 0
	bne a0, a1, be_else.15847
	lw a0, -6(sp)
	addi a0, a0, 1
	lw a2, -5(sp)
	add a22, a0, a2
	lw a3, 0(a22)
	lw a4, -4(sp)
	bne a3, a4, be_else.15848
	li a0, 1
	jalr zero, ra, 0
be_else.15848:
	li a4, 16777217
	add a22, a4, a3
	lw a3, 0(a22)
	flw f0, -3(sp)
	flw f1, -2(sp)
	flw f2, -1(sp)
	sw a0, -8(sp)
	add a0, a3, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, is_outside.2759
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 0
	bne a0, a1, be_else.15849
	lw a0, -8(sp)
	addi a0, a0, 1
	flw f0, -3(sp)
	flw f1, -2(sp)
	flw f2, -1(sp)
	lw a1, -5(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15849:
	add a0, a1, zero
	jalr zero, ra, 0
be_else.15847:
	add a0, a1, zero
	jalr zero, ra, 0
shadow_check_and_group.2770:
	lw a2, 13(cl)
	lw a3, 3(cl)
	lw a4, 2(cl)
	lw a5, 1(cl)
	add a22, a0, a1
	lw a6, 0(a22)
	li a7, -1
	bne a6, a7, be_else.15850
	li a0, 0
	jalr zero, ra, 0
be_else.15850:
	add a22, a0, a1
	lw a6, 0(a22)
	sw a2, 0(sp)
	sw a1, -1(sp)
	sw cl, -2(sp)
	sw a0, -3(sp)
	sw a6, -4(sp)
	add a2, a3, zero
	add a1, a4, zero
	add a0, a6, zero
	add cl, a5, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 16777338
	flw f0, 0(a1)
	li a1, 0
	bne a0, a1, be_else.15851
	add a0, a1, zero
	jump be_cont.15852
be_else.15851:
	fli f1, -0.200000
	flt a0, f0, f1
be_cont.15852:
	bne a0, a1, be_else.15853
	li a0, 16777217
	lw a2, -4(sp)
	add a22, a0, a2
	lw a0, 0(a22)
	lw a0, 6(a0)
	bne a0, a1, be_else.15854
	add a0, a1, zero
	jalr zero, ra, 0
be_else.15854:
	lw a0, -3(sp)
	addi a0, a0, 1
	lw a1, -1(sp)
	lw cl, -2(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15853:
	fli f1, 0.010000
	fadd f0, f0, f1
	li a0, 16777283
	flw f1, 0(a0)
	fmul f1, f1, f0
	li a0, 16777341
	flw f2, 0(a0)
	fadd f1, f1, f2
	li a0, 1
	li a2, 16777283
	add a22, a2, a0
	flw f2, 0(a22)
	fmul f2, f2, f0
	li a0, 1
	li a2, 16777341
	add a22, a2, a0
	flw f3, 0(a22)
	fadd f2, f2, f3
	li a0, 2
	li a2, 16777283
	add a22, a2, a0
	flw f3, 0(a22)
	fmul f0, f3, f0
	li a0, 2
	li a2, 16777341
	add a22, a2, a0
	flw f3, 0(a22)
	fadd f0, f0, f3
	lw a0, -1(sp)
	lw a2, 0(a0)
	li a3, -1
	bne a2, a3, be_else.15855
	li a0, 1
	jump be_cont.15856
be_else.15855:
	li a3, 16777217
	add a22, a3, a2
	lw a2, 0(a22)
	fsw f0, -5(sp)
	fsw f2, -6(sp)
	fsw f1, -7(sp)
	add a0, a2, zero
	fmv f12, f2
	fmv f2, f0
	fmv f0, f1
	fmv f1, f12
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, is_outside.2759
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15857
	li a0, 1
	flw f0, -7(sp)
	flw f1, -6(sp)
	flw f2, -5(sp)
	lw a2, -1(sp)
	lw cl, 0(sp)
	add a1, a2, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	jump be_cont.15858
be_else.15857:
	add a0, a1, zero
be_cont.15858:
be_cont.15856:
	li a1, 0
	bne a0, a1, be_else.15859
	lw a0, -3(sp)
	addi a0, a0, 1
	lw a1, -1(sp)
	lw cl, -2(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15859:
	li a0, 1
	jalr zero, ra, 0
shadow_check_one_or_group.2773:
	lw a2, 2(cl)
	add a22, a0, a1
	lw a3, 0(a22)
	li a4, -1
	bne a3, a4, be_else.15860
	li a0, 0
	jalr zero, ra, 0
be_else.15860:
	li a5, 16777287
	add a22, a5, a3
	lw a3, 0(a22)
	li a5, 0
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a4, -2(sp)
	sw a1, -3(sp)
	sw a0, -4(sp)
	add a1, a3, zero
	add a0, a5, zero
	add cl, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15861
	li a0, 1
	lw a2, -4(sp)
	addi a2, a2, 1
	lw a3, -3(sp)
	add a22, a2, a3
	lw a4, 0(a22)
	lw a5, -2(sp)
	bne a4, a5, be_else.15862
	add a0, a1, zero
	jalr zero, ra, 0
be_else.15862:
	li a5, 16777287
	add a22, a5, a4
	lw a4, 0(a22)
	lw cl, -1(sp)
	sw a0, -5(sp)
	sw a2, -6(sp)
	add a0, a1, zero
	add a1, a4, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15863
	lw a0, -6(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15863:
	lw a0, -5(sp)
	jalr zero, ra, 0
be_else.15861:
	li a0, 1
	jalr zero, ra, 0
shadow_check_one_or_matrix.2776:
	lw a2, 7(cl)
	lw a3, 6(cl)
	lw a4, 3(cl)
	lw a5, 2(cl)
	lw a6, 1(cl)
	add a22, a0, a1
	lw a7, 0(a22)
	lw a8, 0(a7)
	li a9, -1
	bne a8, a9, be_else.15864
	li a0, 0
	jalr zero, ra, 0
be_else.15864:
	li a9, 99
	sw a2, 0(sp)
	sw a3, -1(sp)
	sw a7, -2(sp)
	sw a1, -3(sp)
	sw cl, -4(sp)
	sw a0, -5(sp)
	bne a8, a9, be_else.15865
	li a0, 1
	jump be_cont.15866
be_else.15865:
	add a2, a4, zero
	add a1, a5, zero
	add a0, a8, zero
	add cl, a6, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15867
	add a0, a1, zero
	jump be_cont.15868
be_else.15867:
	li a0, 16777338
	flw f0, 0(a0)
	fli f1, -0.100000
	flt a0, f0, f1
	bne a0, a1, be_else.15869
	add a0, a1, zero
	jump be_cont.15870
be_else.15869:
	lw a0, -2(sp)
	lw a2, 1(a0)
	li a3, -1
	bne a2, a3, be_else.15871
	add a0, a1, zero
	jump be_cont.15872
be_else.15871:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	lw cl, -1(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15873
	li a0, 2
	lw a2, -2(sp)
	lw cl, 0(sp)
	add a1, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	jump be_cont.15874
be_else.15873:
	li a0, 1
be_cont.15874:
be_cont.15872:
	li a1, 0
	bne a0, a1, be_else.15875
	add a0, a1, zero
	jump be_cont.15876
be_else.15875:
	li a0, 1
be_cont.15876:
be_cont.15870:
be_cont.15868:
be_cont.15866:
	li a1, 0
	bne a0, a1, be_else.15877
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw cl, -4(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15877:
	lw a0, -2(sp)
	lw a2, 1(a0)
	li a3, -1
	bne a2, a3, be_else.15878
	add a0, a1, zero
	jump be_cont.15879
be_else.15878:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	lw cl, -1(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15880
	li a0, 2
	lw a2, -2(sp)
	lw cl, 0(sp)
	add a1, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	jump be_cont.15881
be_else.15880:
	li a0, 1
be_cont.15881:
be_cont.15879:
	li a1, 0
	bne a0, a1, be_else.15882
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw cl, -4(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15882:
	li a0, 1
	jalr zero, ra, 0
solve_each_element.2779:
	lw a3, 10(cl)
	lw a4, 2(cl)
	lw a5, 1(cl)
	add a22, a0, a1
	lw a6, 0(a22)
	li a7, -1
	bne a6, a7, be_else.15883
	jalr zero, ra, 0
be_else.15883:
	sw a3, 0(sp)
	sw a2, -1(sp)
	sw a1, -2(sp)
	sw cl, -3(sp)
	sw a0, -4(sp)
	sw a6, -5(sp)
	add a1, a2, zero
	add a0, a6, zero
	add cl, a5, zero
	add a2, a4, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 0
	bne a0, a1, be_else.15885
	li a0, 16777217
	lw a2, -5(sp)
	add a22, a0, a2
	lw a0, 0(a22)
	lw a0, 6(a0)
	bne a0, a1, be_else.15886
	jalr zero, ra, 0
be_else.15886:
	lw a0, -4(sp)
	addi a0, a0, 1
	lw a1, -2(sp)
	lw a2, -1(sp)
	lw cl, -3(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15885:
	li a2, 16777338
	flw f0, 0(a2)
	fli f1, 0.000000
	flt a2, f1, f0
	bne a2, a1, be_else.15888
	jump be_cont.15889
be_else.15888:
	li a2, 16777340
	flw f1, 0(a2)
	flt a2, f0, f1
	bne a2, a1, be_else.15890
	jump be_cont.15891
be_else.15890:
	fli f1, 0.010000
	fadd f0, f0, f1
	lw a2, -1(sp)
	flw f1, 0(a2)
	fmul f1, f1, f0
	li a3, 16777362
	flw f2, 0(a3)
	fadd f1, f1, f2
	flw f2, 1(a2)
	fmul f2, f2, f0
	li a3, 1
	li a4, 16777362
	add a22, a4, a3
	flw f3, 0(a22)
	fadd f2, f2, f3
	flw f3, 2(a2)
	fmul f3, f3, f0
	li a3, 2
	li a4, 16777362
	add a22, a4, a3
	flw f4, 0(a22)
	fadd f3, f3, f4
	lw a3, -2(sp)
	lw a4, 0(a3)
	li a5, -1
	sw a0, -6(sp)
	fsw f3, -7(sp)
	fsw f2, -8(sp)
	fsw f1, -9(sp)
	fsw f0, -10(sp)
	bne a4, a5, be_else.15892
	li a0, 1
	jump be_cont.15893
be_else.15892:
	li a5, 16777217
	add a22, a5, a4
	lw a4, 0(a22)
	add a0, a4, zero
	fmv f0, f1
	fmv f1, f2
	fmv f2, f3
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, is_outside.2759
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 0
	bne a0, a1, be_else.15894
	li a0, 1
	flw f0, -9(sp)
	flw f1, -8(sp)
	flw f2, -7(sp)
	lw a2, -2(sp)
	lw cl, 0(sp)
	add a1, a2, zero
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	jump be_cont.15895
be_else.15894:
	add a0, a1, zero
be_cont.15895:
be_cont.15893:
	li a1, 0
	bne a0, a1, be_else.15896
	jump be_cont.15897
be_else.15896:
	li a0, 16777340
	flw f0, -10(sp)
	fsw f0, 0(a0)
	li a0, 16777341
	flw f0, -9(sp)
	fsw f0, 0(a0)
	li a0, 1
	li a1, 16777341
	flw f0, -8(sp)
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 16777341
	flw f0, -7(sp)
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 16777344
	lw a1, -5(sp)
	sw a1, 0(a0)
	li a0, 16777339
	lw a1, -6(sp)
	sw a1, 0(a0)
be_cont.15897:
be_cont.15891:
be_cont.15889:
	lw a0, -4(sp)
	addi a0, a0, 1
	lw a1, -2(sp)
	lw a2, -1(sp)
	lw cl, -3(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
solve_one_or_network.2783:
	lw a3, 2(cl)
	add a22, a0, a1
	lw a4, 0(a22)
	li a5, -1
	bne a4, a5, be_else.15898
	jalr zero, ra, 0
be_else.15898:
	li a6, 16777287
	add a22, a6, a4
	lw a4, 0(a22)
	li a6, 0
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a3, -2(sp)
	sw a5, -3(sp)
	sw a1, -4(sp)
	sw a0, -5(sp)
	add a1, a4, zero
	add a0, a6, zero
	add cl, a3, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15900
	jalr zero, ra, 0
be_else.15900:
	li a4, 16777287
	add a22, a4, a2
	lw a2, 0(a22)
	li a4, 0
	lw a5, -1(sp)
	lw cl, -2(sp)
	sw a0, -6(sp)
	add a1, a2, zero
	add a0, a4, zero
	add a2, a5, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15902
	jalr zero, ra, 0
be_else.15902:
	li a4, 16777287
	add a22, a4, a2
	lw a2, 0(a22)
	li a4, 0
	lw a5, -1(sp)
	lw cl, -2(sp)
	sw a0, -7(sp)
	add a1, a2, zero
	add a0, a4, zero
	add a2, a5, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -7(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15904
	jalr zero, ra, 0
be_else.15904:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	li a3, 0
	lw a4, -1(sp)
	lw cl, -2(sp)
	sw a0, -8(sp)
	add a1, a2, zero
	add a0, a3, zero
	add a2, a4, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	lw a2, -1(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
trace_or_matrix.2787:
	lw a3, 9(cl)
	lw a4, 8(cl)
	lw a5, 7(cl)
	lw a6, 2(cl)
	add a22, a0, a1
	lw a7, 0(a22)
	lw a8, 0(a7)
	li a9, -1
	bne a8, a9, be_else.15906
	jalr zero, ra, 0
be_else.15906:
	li a9, 99
	sw a2, 0(sp)
	sw a1, -1(sp)
	sw cl, -2(sp)
	sw a0, -3(sp)
	bne a8, a9, be_else.15908
	lw a3, 1(a7)
	li a4, -1
	bne a3, a4, be_else.15910
	jump be_cont.15911
be_else.15910:
	li a4, 16777287
	add a22, a4, a3
	lw a3, 0(a22)
	li a4, 0
	sw a5, -4(sp)
	sw a6, -5(sp)
	sw a7, -6(sp)
	add a1, a3, zero
	add a0, a4, zero
	add cl, a6, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 2(a0)
	li a2, -1
	bne a1, a2, be_else.15912
	jump be_cont.15913
be_else.15912:
	li a3, 16777287
	add a22, a3, a1
	lw a1, 0(a22)
	li a3, 0
	lw a4, 0(sp)
	lw cl, -5(sp)
	sw a2, -7(sp)
	add a2, a4, zero
	add a0, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 3(a0)
	lw a2, -7(sp)
	bne a1, a2, be_else.15914
	jump be_cont.15915
be_else.15914:
	li a2, 16777287
	add a22, a2, a1
	lw a1, 0(a22)
	li a2, 0
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 4
	lw a1, -6(sp)
	lw a2, 0(sp)
	lw cl, -4(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.15915:
be_cont.15913:
be_cont.15911:
	jump be_cont.15909
be_else.15908:
	sw a5, -4(sp)
	sw a6, -5(sp)
	sw a7, -6(sp)
	add a1, a2, zero
	add a0, a8, zero
	add cl, a4, zero
	add a2, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15916
	jump be_cont.15917
be_else.15916:
	li a0, 16777338
	flw f0, 0(a0)
	li a0, 16777340
	flw f1, 0(a0)
	flt a0, f0, f1
	bne a0, a1, be_else.15918
	jump be_cont.15919
be_else.15918:
	lw a0, -6(sp)
	lw a2, 1(a0)
	li a3, -1
	bne a2, a3, be_else.15920
	jump be_cont.15921
be_else.15920:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a1, zero
	add a1, a2, zero
	add a2, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 2(a0)
	li a2, -1
	bne a1, a2, be_else.15922
	jump be_cont.15923
be_else.15922:
	li a3, 16777287
	add a22, a3, a1
	lw a1, 0(a22)
	li a3, 0
	lw a4, 0(sp)
	lw cl, -5(sp)
	sw a2, -8(sp)
	add a2, a4, zero
	add a0, a3, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -6(sp)
	lw a1, 3(a0)
	lw a2, -8(sp)
	bne a1, a2, be_else.15924
	jump be_cont.15925
be_else.15924:
	li a2, 16777287
	add a22, a2, a1
	lw a1, 0(a22)
	li a2, 0
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a0, 4
	lw a1, -6(sp)
	lw a2, 0(sp)
	lw cl, -4(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
be_cont.15925:
be_cont.15923:
be_cont.15921:
be_cont.15919:
be_cont.15917:
be_cont.15909:
	lw a0, -3(sp)
	addi a0, a0, 1
	lw a1, -1(sp)
	lw a2, 0(sp)
	lw cl, -2(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
solve_each_element_fast.2793:
	lw a3, 9(cl)
	lw a4, 1(cl)
	lw a5, 0(a2)
	add a22, a0, a1
	lw a6, 0(a22)
	li a7, -1
	bne a6, a7, be_else.15926
	jalr zero, ra, 0
be_else.15926:
	sw a3, 0(sp)
	sw a5, -1(sp)
	sw a2, -2(sp)
	sw a1, -3(sp)
	sw cl, -4(sp)
	sw a0, -5(sp)
	sw a6, -6(sp)
	add a1, a2, zero
	add a0, a6, zero
	add cl, a4, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15928
	li a0, 16777217
	lw a2, -6(sp)
	add a22, a0, a2
	lw a0, 0(a22)
	lw a0, 6(a0)
	bne a0, a1, be_else.15929
	jalr zero, ra, 0
be_else.15929:
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw a2, -2(sp)
	lw cl, -4(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.15928:
	li a2, 16777338
	flw f0, 0(a2)
	fli f1, 0.000000
	flt a2, f1, f0
	bne a2, a1, be_else.15931
	jump be_cont.15932
be_else.15931:
	li a2, 16777340
	flw f1, 0(a2)
	flt a2, f0, f1
	bne a2, a1, be_else.15933
	jump be_cont.15934
be_else.15933:
	fli f1, 0.010000
	fadd f0, f0, f1
	lw a2, -1(sp)
	flw f1, 0(a2)
	fmul f1, f1, f0
	li a3, 16777365
	flw f2, 0(a3)
	fadd f1, f1, f2
	flw f2, 1(a2)
	fmul f2, f2, f0
	li a3, 1
	li a4, 16777365
	add a22, a4, a3
	flw f3, 0(a22)
	fadd f2, f2, f3
	flw f3, 2(a2)
	fmul f3, f3, f0
	li a2, 2
	li a3, 16777365
	add a22, a3, a2
	flw f4, 0(a22)
	fadd f3, f3, f4
	lw a2, -3(sp)
	lw a3, 0(a2)
	li a4, -1
	sw a0, -7(sp)
	fsw f3, -8(sp)
	fsw f2, -9(sp)
	fsw f1, -10(sp)
	fsw f0, -11(sp)
	bne a3, a4, be_else.15935
	li a0, 1
	jump be_cont.15936
be_else.15935:
	li a4, 16777217
	add a22, a4, a3
	lw a3, 0(a22)
	add a0, a3, zero
	fmv f0, f1
	fmv f1, f2
	fmv f2, f3
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, is_outside.2759
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 0
	bne a0, a1, be_else.15937
	li a0, 1
	flw f0, -10(sp)
	flw f1, -9(sp)
	flw f2, -8(sp)
	lw a2, -3(sp)
	lw cl, 0(sp)
	add a1, a2, zero
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	jump be_cont.15938
be_else.15937:
	add a0, a1, zero
be_cont.15938:
be_cont.15936:
	li a1, 0
	bne a0, a1, be_else.15939
	jump be_cont.15940
be_else.15939:
	li a0, 16777340
	flw f0, -11(sp)
	fsw f0, 0(a0)
	li a0, 16777341
	flw f0, -10(sp)
	fsw f0, 0(a0)
	li a0, 1
	li a1, 16777341
	flw f0, -9(sp)
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 16777341
	flw f0, -8(sp)
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 16777344
	lw a1, -6(sp)
	sw a1, 0(a0)
	li a0, 16777339
	lw a1, -7(sp)
	sw a1, 0(a0)
be_cont.15940:
be_cont.15934:
be_cont.15932:
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw a2, -2(sp)
	lw cl, -4(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
solve_one_or_network_fast.2797:
	lw a3, 2(cl)
	add a22, a0, a1
	lw a4, 0(a22)
	li a5, -1
	bne a4, a5, be_else.15941
	jalr zero, ra, 0
be_else.15941:
	li a6, 16777287
	add a22, a6, a4
	lw a4, 0(a22)
	li a6, 0
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a3, -2(sp)
	sw a5, -3(sp)
	sw a1, -4(sp)
	sw a0, -5(sp)
	add a1, a4, zero
	add a0, a6, zero
	add cl, a3, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15943
	jalr zero, ra, 0
be_else.15943:
	li a4, 16777287
	add a22, a4, a2
	lw a2, 0(a22)
	li a4, 0
	lw a5, -1(sp)
	lw cl, -2(sp)
	sw a0, -6(sp)
	add a1, a2, zero
	add a0, a4, zero
	add a2, a5, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15945
	jalr zero, ra, 0
be_else.15945:
	li a4, 16777287
	add a22, a4, a2
	lw a2, 0(a22)
	li a4, 0
	lw a5, -1(sp)
	lw cl, -2(sp)
	sw a0, -7(sp)
	add a1, a2, zero
	add a0, a4, zero
	add a2, a5, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -7(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a3, -3(sp)
	bne a2, a3, be_else.15947
	jalr zero, ra, 0
be_else.15947:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	li a3, 0
	lw a4, -1(sp)
	lw cl, -2(sp)
	sw a0, -8(sp)
	add a1, a2, zero
	add a0, a3, zero
	add a2, a4, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	addi a0, a0, 1
	lw a1, -4(sp)
	lw a2, -1(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
trace_or_matrix_fast.2801:
	lw a3, 8(cl)
	lw a4, 7(cl)
	lw a5, 2(cl)
	add a22, a0, a1
	lw a6, 0(a22)
	lw a7, 0(a6)
	li a8, -1
	bne a7, a8, be_else.15949
	jalr zero, ra, 0
be_else.15949:
	li a8, 99
	sw a2, 0(sp)
	sw a1, -1(sp)
	sw cl, -2(sp)
	sw a0, -3(sp)
	bne a7, a8, be_else.15951
	lw a3, 1(a6)
	li a7, -1
	bne a3, a7, be_else.15953
	jump be_cont.15954
be_else.15953:
	li a7, 16777287
	add a22, a7, a3
	lw a3, 0(a22)
	li a7, 0
	sw a4, -4(sp)
	sw a5, -5(sp)
	sw a6, -6(sp)
	add a1, a3, zero
	add a0, a7, zero
	add cl, a5, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 2(a0)
	li a2, -1
	bne a1, a2, be_else.15955
	jump be_cont.15956
be_else.15955:
	li a3, 16777287
	add a22, a3, a1
	lw a1, 0(a22)
	li a3, 0
	lw a4, 0(sp)
	lw cl, -5(sp)
	sw a2, -7(sp)
	add a2, a4, zero
	add a0, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 3(a0)
	lw a2, -7(sp)
	bne a1, a2, be_else.15957
	jump be_cont.15958
be_else.15957:
	li a2, 16777287
	add a22, a2, a1
	lw a1, 0(a22)
	li a2, 0
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 4
	lw a1, -6(sp)
	lw a2, 0(sp)
	lw cl, -4(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.15958:
be_cont.15956:
be_cont.15954:
	jump be_cont.15952
be_else.15951:
	sw a4, -4(sp)
	sw a5, -5(sp)
	sw a6, -6(sp)
	add a1, a2, zero
	add a0, a7, zero
	add cl, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 0
	bne a0, a1, be_else.15959
	jump be_cont.15960
be_else.15959:
	li a0, 16777338
	flw f0, 0(a0)
	li a0, 16777340
	flw f1, 0(a0)
	flt a0, f0, f1
	bne a0, a1, be_else.15961
	jump be_cont.15962
be_else.15961:
	lw a0, -6(sp)
	lw a2, 1(a0)
	li a3, -1
	bne a2, a3, be_else.15963
	jump be_cont.15964
be_else.15963:
	li a3, 16777287
	add a22, a3, a2
	lw a2, 0(a22)
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a1, zero
	add a1, a2, zero
	add a2, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -6(sp)
	lw a1, 2(a0)
	li a2, -1
	bne a1, a2, be_else.15965
	jump be_cont.15966
be_else.15965:
	li a3, 16777287
	add a22, a3, a1
	lw a1, 0(a22)
	li a3, 0
	lw a4, 0(sp)
	lw cl, -5(sp)
	sw a2, -8(sp)
	add a2, a4, zero
	add a0, a3, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -6(sp)
	lw a1, 3(a0)
	lw a2, -8(sp)
	bne a1, a2, be_else.15967
	jump be_cont.15968
be_else.15967:
	li a2, 16777287
	add a22, a2, a1
	lw a1, 0(a22)
	li a2, 0
	lw a3, 0(sp)
	lw cl, -5(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a0, 4
	lw a1, -6(sp)
	lw a2, 0(sp)
	lw cl, -4(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
be_cont.15968:
be_cont.15966:
be_cont.15964:
be_cont.15962:
be_cont.15960:
be_cont.15952:
	lw a0, -3(sp)
	addi a0, a0, 1
	lw a1, -1(sp)
	lw a2, 0(sp)
	lw cl, -2(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
get_nvector_second.2811:
	lw a1, 4(cl)
	li a2, 16777341
	flw f0, 0(a2)
	lw a2, 5(a0)
	flw f1, 0(a2)
	fsub f0, f0, f1
	li a2, 1
	li a3, 16777341
	add a22, a3, a2
	flw f1, 0(a22)
	lw a2, 5(a0)
	flw f2, 1(a2)
	fsub f1, f1, f2
	li a2, 2
	li a3, 16777341
	add a22, a3, a2
	flw f2, 0(a22)
	lw a2, 5(a0)
	flw f3, 2(a2)
	fsub f2, f2, f3
	lw a2, 4(a0)
	flw f3, 0(a2)
	fmul f3, f0, f3
	lw a2, 4(a0)
	flw f4, 1(a2)
	fmul f4, f1, f4
	lw a2, 4(a0)
	flw f5, 2(a2)
	fmul f5, f2, f5
	lw a2, 3(a0)
	li a3, 0
	bne a2, a3, be_else.15969
	li a2, 16777345
	fsw f3, 0(a2)
	li a2, 1
	li a3, 16777345
	add a22, a3, a2
	fsw f4, 0(a22)
	li a2, 2
	li a3, 16777345
	add a22, a3, a2
	fsw f5, 0(a22)
	jump be_cont.15970
be_else.15969:
	lw a2, 9(a0)
	flw f6, 2(a2)
	fmul f6, f1, f6
	lw a2, 9(a0)
	flw f7, 1(a2)
	fmul f7, f2, f7
	fadd f6, f6, f7
	fli f7, 0.500000
	fmul f6, f6, f7
	fadd f3, f3, f6
	li a2, 16777345
	fsw f3, 0(a2)
	li a2, 1
	lw a3, 9(a0)
	flw f3, 2(a3)
	fmul f3, f0, f3
	lw a3, 9(a0)
	flw f6, 0(a3)
	fmul f2, f2, f6
	fadd f2, f3, f2
	fli f3, 0.500000
	fmul f2, f2, f3
	fadd f2, f4, f2
	li a3, 16777345
	add a22, a3, a2
	fsw f2, 0(a22)
	li a2, 2
	lw a3, 9(a0)
	flw f2, 1(a3)
	fmul f0, f0, f2
	lw a3, 9(a0)
	flw f2, 0(a3)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fli f1, 0.500000
	fmul f0, f0, f1
	fadd f0, f5, f0
	li a3, 16777345
	add a22, a3, a2
	fsw f0, 0(a22)
be_cont.15970:
	lw a0, 6(a0)
	add swp, a1, zero
	add a1, a0, zero
	add a0, swp, zero
	jump vecunit_sgn.2519
utexture.2816:
	lw a2, 0(a0)
	lw a3, 8(a0)
	flw f0, 0(a3)
	li a3, 16777348
	fsw f0, 0(a3)
	li a3, 1
	lw a4, 8(a0)
	flw f0, 1(a4)
	li a4, 16777348
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 2
	lw a4, 8(a0)
	flw f0, 2(a4)
	li a4, 16777348
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 1
	bne a2, a3, be_else.15971
	flw f0, 0(a1)
	lw a2, 5(a0)
	flw f1, 0(a2)
	fsub f0, f0, f1
	fli f1, 0.050000
	fmul f1, f0, f1
	floor f1, f1
	fli f2, 20.000000
	fmul f1, f1, f2
	fsub f0, f0, f1
	fli f1, 10.000000
	flt a2, f0, f1
	flw f0, 2(a1)
	lw a0, 5(a0)
	flw f1, 2(a0)
	fsub f0, f0, f1
	fli f1, 0.050000
	fmul f1, f0, f1
	floor f1, f1
	fli f2, 20.000000
	fmul f1, f1, f2
	fsub f0, f0, f1
	fli f1, 10.000000
	flt a0, f0, f1
	li a1, 1
	li a3, 0
	bne a2, a3, be_else.15972
	bne a0, a3, be_else.15974
	fli f0, 255.000000
	jump be_cont.15975
be_else.15974:
	fli f0, 0.000000
be_cont.15975:
	jump be_cont.15973
be_else.15972:
	bne a0, a3, be_else.15976
	fli f0, 0.000000
	jump be_cont.15977
be_else.15976:
	fli f0, 255.000000
be_cont.15977:
be_cont.15973:
	li a0, 16777348
	add a22, a0, a1
	fsw f0, 0(a22)
	jalr zero, ra, 0
be_else.15971:
	li a3, 2
	bne a2, a3, be_else.15979
	flw f0, 1(a1)
	fli f1, 0.250000
	fmul f0, f0, f1
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, sin
	addi sp, sp, 1
	lw ra, 0(sp)
	fmul f0, f0, f0
	fli f1, 255.000000
	fmul f1, f1, f0
	li a0, 16777348
	fsw f1, 0(a0)
	li a0, 1
	fli f1, 255.000000
	fli f2, 1.000000
	fsub f0, f2, f0
	fmul f0, f1, f0
	li a1, 16777348
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
be_else.15979:
	li a3, 3
	bne a2, a3, be_else.15981
	flw f0, 0(a1)
	lw a2, 5(a0)
	flw f1, 0(a2)
	fsub f0, f0, f1
	flw f1, 2(a1)
	lw a0, 5(a0)
	flw f2, 2(a0)
	fsub f1, f1, f2
	fmul f0, f0, f0
	fmul f1, f1, f1
	fadd f0, f0, f1
	fsqrt f0, f0
	fli f1, 10.000000
	fdiv f0, f0, f1
	floor f1, f0
	fsub f0, f0, f1
	fli f1, 3.141593
	fmul f0, f0, f1
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, cos
	addi sp, sp, 1
	lw ra, 0(sp)
	fmul f0, f0, f0
	li a0, 1
	fli f1, 255.000000
	fmul f1, f0, f1
	li a1, 16777348
	add a22, a1, a0
	fsw f1, 0(a22)
	li a0, 2
	fli f1, 1.000000
	fsub f0, f1, f0
	fli f1, 255.000000
	fmul f0, f0, f1
	li a1, 16777348
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
be_else.15981:
	li a3, 4
	bne a2, a3, be_else.15983
	flw f0, 0(a1)
	lw a2, 5(a0)
	flw f1, 0(a2)
	fsub f0, f0, f1
	lw a2, 4(a0)
	flw f1, 0(a2)
	fsqrt f1, f1
	fmul f0, f0, f1
	flw f1, 2(a1)
	lw a2, 5(a0)
	flw f2, 2(a2)
	fsub f1, f1, f2
	lw a2, 4(a0)
	flw f2, 2(a2)
	fsqrt f2, f2
	fmul f1, f1, f2
	fmul f2, f0, f0
	fmul f3, f1, f1
	fadd f2, f2, f3
	fabs f3, f0
	fli f4, 0.000100
	flt a2, f3, f4
	li a3, 0
	fsw f2, 0(sp)
	sw a0, -1(sp)
	sw a1, -2(sp)
	bne a2, a3, be_else.15984
	fdiv f0, f1, f0
	fabs f0, f0
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, atan
	addi sp, sp, 5
	lw ra, -4(sp)
	fli f1, 30.000000
	fmul f0, f0, f1
	fli f1, 3.141593
	fdiv f0, f0, f1
	jump be_cont.15985
be_else.15984:
	fli f0, 15.000000
be_cont.15985:
	floor f1, f0
	fsub f0, f0, f1
	lw a0, -2(sp)
	flw f1, 1(a0)
	lw a0, -1(sp)
	lw a1, 5(a0)
	flw f2, 1(a1)
	fsub f1, f1, f2
	lw a0, 4(a0)
	flw f2, 1(a0)
	fsqrt f2, f2
	fmul f1, f1, f2
	flw f2, 0(sp)
	fabs f3, f2
	fli f4, 0.000100
	flt a0, f3, f4
	li a1, 0
	fsw f0, -3(sp)
	bne a0, a1, be_else.15986
	fdiv f1, f1, f2
	fabs f1, f1
	fmv f0, f1
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, atan
	addi sp, sp, 5
	lw ra, -4(sp)
	fli f1, 30.000000
	fmul f0, f0, f1
	fli f1, 3.141593
	fdiv f0, f0, f1
	jump be_cont.15987
be_else.15986:
	fli f0, 15.000000
be_cont.15987:
	floor f1, f0
	fsub f0, f0, f1
	fli f1, 0.150000
	fli f2, 0.500000
	flw f3, -3(sp)
	fsub f2, f2, f3
	fmul f2, f2, f2
	fsub f1, f1, f2
	fli f2, 0.500000
	fsub f0, f2, f0
	fmul f0, f0, f0
	fsub f0, f1, f0
	flt a0, f0, fzero
	li a1, 0
	bne a0, a1, be_else.15988
	jump be_cont.15989
be_else.15988:
	fli f0, 0.000000
be_cont.15989:
	li a0, 2
	fli f1, 255.000000
	fmul f0, f1, f0
	fli f1, 0.300000
	fdiv f0, f0, f1
	li a1, 16777348
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
be_else.15983:
	jalr zero, ra, 0
add_light.2819:
	lw a1, 2(cl)
	lw a0, 1(cl)
	flt a2, fzero, f0
	li a3, 0
	fsw f2, 0(sp)
	fsw f1, -1(sp)
	bne a2, a3, be_else.15992
	jump be_cont.15993
be_else.15992:
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, vecaccum.2530
	addi sp, sp, 3
	lw ra, -2(sp)
be_cont.15993:
	flw f0, -1(sp)
	flt a0, fzero, f0
	li a1, 0
	bne a0, a1, be_else.15994
	jalr zero, ra, 0
be_else.15994:
	fmul f0, f0, f0
	fmul f0, f0, f0
	flw f1, 0(sp)
	fmul f0, f0, f1
	li a0, 16777354
	flw f1, 0(a0)
	fadd f1, f1, f0
	li a0, 16777354
	fsw f1, 0(a0)
	li a0, 1
	li a1, 16777354
	add a22, a1, a0
	flw f1, 0(a22)
	fadd f1, f1, f0
	li a1, 16777354
	add a22, a1, a0
	fsw f1, 0(a22)
	li a0, 2
	li a1, 16777354
	add a22, a1, a0
	flw f1, 0(a22)
	fadd f0, f1, f0
	li a1, 16777354
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
trace_reflections.2823:
	lw a2, 13(cl)
	lw a3, 9(cl)
	lw a4, 4(cl)
	li a5, 0
	blt a0, a5, ble_else.15997
	li a6, 16777387
	add a22, a6, a0
	lw a6, 0(a22)
	lw a7, 1(a6)
	fli f2, 1000000000.000000
	li a8, 16777340
	fsw f2, 0(a8)
	li a8, 16777337
	lw a8, 0(a8)
	sw cl, 0(sp)
	sw a0, -1(sp)
	fsw f1, -2(sp)
	sw a2, -3(sp)
	sw a1, -4(sp)
	fsw f0, -5(sp)
	sw a7, -6(sp)
	sw a3, -7(sp)
	sw a6, -8(sp)
	add a2, a7, zero
	add a1, a8, zero
	add a0, a5, zero
	add cl, a4, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a0, 16777340
	flw f0, 0(a0)
	fli f1, -0.100000
	flt a0, f1, f0
	li a1, 0
	bne a0, a1, be_else.15998
	add a0, a1, zero
	jump be_cont.15999
be_else.15998:
	fli f1, 100000000.000000
	flt a0, f0, f1
be_cont.15999:
	bne a0, a1, be_else.16000
	jump be_cont.16001
be_else.16000:
	li a0, 16777344
	lw a0, 0(a0)
	slli a0, a0, 2
	li a2, 16777339
	lw a2, 0(a2)
	add a0, a0, a2
	lw a2, -8(sp)
	lw a3, 0(a2)
	bne a0, a3, be_else.16002
	li a0, 16777337
	lw a0, 0(a0)
	lw cl, -7(sp)
	add swp, a1, zero
	add a1, a0, zero
	add a0, swp, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 0
	bne a0, a1, be_else.16004
	lw a0, -6(sp)
	lw a1, 0(a0)
	li a2, 16777345
	flw f0, 0(a2)
	flw f1, 0(a1)
	fmul f0, f0, f1
	li a2, 1
	li a3, 16777345
	add a22, a3, a2
	flw f1, 0(a22)
	flw f2, 1(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	li a2, 2
	li a3, 16777345
	add a22, a3, a2
	flw f1, 0(a22)
	flw f2, 2(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	lw a1, -8(sp)
	flw f1, 2(a1)
	flw f2, -5(sp)
	fmul f3, f1, f2
	fmul f0, f3, f0
	lw a0, 0(a0)
	lw a1, -4(sp)
	flw f3, 0(a1)
	flw f4, 0(a0)
	fmul f3, f3, f4
	flw f4, 1(a1)
	flw f5, 1(a0)
	fmul f4, f4, f5
	fadd f3, f3, f4
	flw f4, 2(a1)
	flw f5, 2(a0)
	fmul f4, f4, f5
	fadd f3, f3, f4
	fmul f1, f1, f3
	flw f3, -2(sp)
	lw cl, -3(sp)
	fmv f2, f3
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	jump be_cont.16005
be_else.16004:
be_cont.16005:
	jump be_cont.16003
be_else.16002:
be_cont.16003:
be_cont.16001:
	lw a0, -1(sp)
	addi a0, a0, -1
	flw f0, -5(sp)
	flw f1, -2(sp)
	lw a1, -4(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.15997:
	jalr zero, ra, 0
trace_ray.2828:
	lw a3, 70(cl)
	lw a4, 67(cl)
	lw a5, 59(cl)
	lw a6, 49(cl)
	lw a7, 32(cl)
	lw a8, 26(cl)
	lw a9, 25(cl)
	lw a10, 18(cl)
	lw a11, 3(cl)
	li a12, 4
	blt a12, a0, ble_else.16007
	lw a12, 2(a2)
	fli f2, 1000000000.000000
	li a13, 16777340
	fsw f2, 0(a13)
	li a13, 16777337
	lw a13, 0(a13)
	li a14, 0
	sw cl, 0(sp)
	fsw f1, -1(sp)
	sw a3, -2(sp)
	sw a4, -3(sp)
	sw a5, -4(sp)
	sw a6, -5(sp)
	sw a10, -6(sp)
	sw a2, -7(sp)
	sw a8, -8(sp)
	sw a7, -9(sp)
	sw a9, -10(sp)
	fsw f0, -11(sp)
	sw a1, -12(sp)
	sw a0, -13(sp)
	sw a12, -14(sp)
	add a2, a1, zero
	add a0, a14, zero
	add cl, a11, zero
	add a1, a13, zero
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	li a0, 16777340
	flw f0, 0(a0)
	fli f1, -0.100000
	flt a0, f1, f0
	li a1, 0
	bne a0, a1, be_else.16008
	add a0, a1, zero
	jump be_cont.16009
be_else.16008:
	fli f1, 100000000.000000
	flt a0, f0, f1
be_cont.16009:
	bne a0, a1, be_else.16010
	li a0, -1
	lw a2, -13(sp)
	lw a3, -14(sp)
	add a22, a2, a3
	sw a0, 0(a22)
	bne a2, a1, be_else.16011
	jalr zero, ra, 0
be_else.16011:
	lw a0, -12(sp)
	flw f0, 0(a0)
	li a2, 16777283
	flw f1, 0(a2)
	fmul f0, f0, f1
	li a2, 1
	flw f1, 1(a0)
	li a3, 16777283
	add a22, a3, a2
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	li a2, 2
	flw f1, 2(a0)
	li a0, 16777283
	add a22, a0, a2
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fneg f0, f0
	flt a0, fzero, f0
	bne a0, a1, be_else.16013
	jalr zero, ra, 0
be_else.16013:
	fmul f1, f0, f0
	fmul f0, f1, f0
	flw f1, -11(sp)
	fmul f0, f0, f1
	li a0, 16777286
	flw f1, 0(a0)
	fmul f0, f0, f1
	li a0, 16777354
	flw f1, 0(a0)
	fadd f1, f1, f0
	li a0, 16777354
	fsw f1, 0(a0)
	li a0, 1
	li a1, 1
	li a2, 16777354
	add a22, a2, a1
	flw f1, 0(a22)
	fadd f1, f1, f0
	li a1, 16777354
	add a22, a1, a0
	fsw f1, 0(a22)
	li a0, 2
	li a1, 2
	li a2, 16777354
	add a22, a2, a1
	flw f1, 0(a22)
	fadd f0, f1, f0
	li a1, 16777354
	add a22, a1, a0
	fsw f0, 0(a22)
	jalr zero, ra, 0
be_else.16010:
	li a0, 16777344
	lw a0, 0(a0)
	li a2, 16777217
	add a22, a2, a0
	lw a2, 0(a22)
	lw a3, 2(a2)
	lw a4, 7(a2)
	flw f0, 0(a4)
	flw f1, -11(sp)
	fmul f0, f0, f1
	lw a4, 1(a2)
	li a5, 1
	sw a3, -15(sp)
	fsw f0, -16(sp)
	sw a0, -17(sp)
	sw a2, -18(sp)
	bne a4, a5, be_else.16016
	li a4, 16777339
	lw a4, 0(a4)
	li a5, 16777345
	fli f2, 0.000000
	fsw f2, 0(a5)
	li a5, 1
	li a6, 16777345
	add a22, a6, a5
	fsw f2, 0(a22)
	li a5, 2
	li a6, 16777345
	add a22, a6, a5
	fsw f2, 0(a22)
	addi a5, a4, -1
	addi a4, a4, -1
	lw a6, -12(sp)
	add a22, a4, a6
	flw f3, 0(a22)
	feq a4, f3, fzero
	bne a4, a1, be_else.16018
	flt a4, fzero, f3
	bne a4, a1, be_else.16020
	fli f2, -1.000000
	jump be_cont.16021
be_else.16020:
	fli f2, 1.000000
be_cont.16021:
	jump be_cont.16019
be_else.16018:
be_cont.16019:
	fneg f2, f2
	li a4, 16777345
	add a22, a4, a5
	fsw f2, 0(a22)
	jump be_cont.16017
be_else.16016:
	li a5, 2
	bne a4, a5, be_else.16022
	lw a4, 4(a2)
	flw f2, 0(a4)
	fneg f2, f2
	li a4, 16777345
	fsw f2, 0(a4)
	li a4, 1
	lw a5, 4(a2)
	flw f2, 1(a5)
	fneg f2, f2
	li a5, 16777345
	add a22, a5, a4
	fsw f2, 0(a22)
	li a4, 2
	lw a5, 4(a2)
	flw f2, 2(a5)
	fneg f2, f2
	li a5, 16777345
	add a22, a5, a4
	fsw f2, 0(a22)
	jump be_cont.16023
be_else.16022:
	lw cl, -10(sp)
	add a0, a2, zero
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
be_cont.16023:
be_cont.16017:
	li a0, 16777341
	flw f0, 0(a0)
	li a0, 16777362
	fsw f0, 0(a0)
	li a0, 1
	li a1, 1
	li a2, 16777341
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 16777362
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 2
	li a2, 16777341
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 16777362
	add a22, a1, a0
	fsw f0, 0(a22)
	lw a0, -18(sp)
	lw a1, -8(sp)
	lw cl, -9(sp)
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a0, -17(sp)
	slli a0, a0, 2
	li a1, 16777339
	lw a1, 0(a1)
	add a0, a0, a1
	lw a1, -13(sp)
	lw a2, -14(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	lw a0, -7(sp)
	lw a3, 1(a0)
	add a22, a1, a3
	lw a3, 0(a22)
	li a4, 16777341
	flw f0, 0(a4)
	fsw f0, 0(a3)
	li a4, 1
	li a5, 16777341
	add a22, a5, a4
	flw f0, 0(a22)
	fsw f0, 1(a3)
	li a4, 2
	li a5, 16777341
	add a22, a5, a4
	flw f0, 0(a22)
	fsw f0, 2(a3)
	lw a3, 3(a0)
	lw a4, -18(sp)
	lw a5, 7(a4)
	flw f0, 0(a5)
	fli f1, 0.500000
	flt a5, f0, f1
	li a6, 0
	bne a5, a6, be_else.16024
	li a5, 1
	add a22, a1, a3
	sw a5, 0(a22)
	lw a3, 4(a0)
	add a22, a1, a3
	lw a5, 0(a22)
	li a7, 16777348
	flw f0, 0(a7)
	fsw f0, 0(a5)
	li a7, 1
	li a8, 16777348
	add a22, a8, a7
	flw f0, 0(a22)
	fsw f0, 1(a5)
	li a7, 2
	li a8, 16777348
	add a22, a8, a7
	flw f0, 0(a22)
	fsw f0, 2(a5)
	add a22, a1, a3
	lw a3, 0(a22)
	fli f0, 0.003906
	flw f1, -16(sp)
	fmul f0, f0, f1
	flw f2, 0(a3)
	fmul f2, f2, f0
	fsw f2, 0(a3)
	flw f2, 1(a3)
	fmul f2, f2, f0
	fsw f2, 1(a3)
	flw f2, 2(a3)
	fmul f0, f2, f0
	fsw f0, 2(a3)
	lw a3, 7(a0)
	add a22, a1, a3
	lw a3, 0(a22)
	li a5, 16777345
	flw f0, 0(a5)
	fsw f0, 0(a3)
	li a5, 1
	li a7, 16777345
	add a22, a7, a5
	flw f0, 0(a22)
	fsw f0, 1(a3)
	li a5, 2
	li a7, 16777345
	add a22, a7, a5
	flw f0, 0(a22)
	fsw f0, 2(a3)
	jump be_cont.16025
be_else.16024:
	add a22, a1, a3
	sw a6, 0(a22)
be_cont.16025:
	fli f0, -2.000000
	lw a3, -12(sp)
	flw f1, 0(a3)
	li a5, 16777345
	flw f2, 0(a5)
	fmul f1, f1, f2
	li a5, 1
	flw f2, 1(a3)
	li a7, 16777345
	add a22, a7, a5
	flw f3, 0(a22)
	fmul f2, f2, f3
	fadd f1, f1, f2
	li a5, 2
	flw f2, 2(a3)
	li a7, 16777345
	add a22, a7, a5
	flw f3, 0(a22)
	fmul f2, f2, f3
	fadd f1, f1, f2
	fmul f0, f0, f1
	lw a5, -6(sp)
	add a1, a5, zero
	add a0, a3, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, vecaccum.2530
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a0, -18(sp)
	lw a1, 7(a0)
	flw f0, 1(a1)
	flw f1, -11(sp)
	fmul f0, f1, f0
	li a1, 16777337
	lw a1, 0(a1)
	li a2, 0
	lw cl, -5(sp)
	fsw f0, -19(sp)
	add a0, a2, zero
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	li a1, 0
	bne a0, a1, be_else.16026
	li a0, 16777345
	flw f0, 0(a0)
	li a0, 16777283
	flw f1, 0(a0)
	fmul f0, f0, f1
	li a0, 1
	li a2, 16777345
	add a22, a2, a0
	flw f1, 0(a22)
	li a2, 16777283
	add a22, a2, a0
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	li a0, 2
	li a2, 16777345
	add a22, a2, a0
	flw f1, 0(a22)
	li a2, 16777283
	add a22, a2, a0
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fneg f0, f0
	flw f1, -16(sp)
	fmul f0, f0, f1
	lw a0, -12(sp)
	flw f2, 0(a0)
	li a2, 16777283
	flw f3, 0(a2)
	fmul f2, f2, f3
	li a2, 1
	flw f3, 1(a0)
	li a3, 16777283
	add a22, a3, a2
	flw f4, 0(a22)
	fmul f3, f3, f4
	fadd f2, f2, f3
	li a2, 2
	flw f3, 2(a0)
	li a3, 16777283
	add a22, a3, a2
	flw f4, 0(a22)
	fmul f3, f3, f4
	fadd f2, f2, f3
	fneg f2, f2
	flw f3, -19(sp)
	lw cl, -4(sp)
	fmv f1, f2
	fmv f2, f3
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	jump be_cont.16027
be_else.16026:
be_cont.16027:
	li a0, 16777341
	flw f0, 0(a0)
	li a0, 16777365
	fsw f0, 0(a0)
	li a0, 1
	li a1, 16777341
	add a22, a1, a0
	flw f0, 0(a22)
	li a1, 16777365
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 16777341
	add a22, a1, a0
	flw f0, 0(a22)
	li a1, 16777365
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 16777216
	lw a0, 0(a0)
	addi a1, a0, -1
	lw a0, -8(sp)
	lw cl, -3(sp)
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	li a0, 16777567
	lw a0, 0(a0)
	addi a0, a0, -1
	flw f0, -16(sp)
	flw f1, -19(sp)
	lw a1, -12(sp)
	lw cl, -2(sp)
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	fli f0, 0.100000
	flw f1, -11(sp)
	flt a0, f0, f1
	li a1, 0
	bne a0, a1, be_else.16028
	jalr zero, ra, 0
be_else.16028:
	li a0, 4
	lw a1, -13(sp)
	blt a1, a0, ble_else.16030
	jump ble_cont.16031
ble_else.16030:
	addi a0, a1, 1
	li a2, -1
	lw a3, -14(sp)
	add a22, a0, a3
	sw a2, 0(a22)
ble_cont.16031:
	li a0, 2
	lw a2, -15(sp)
	bne a2, a0, be_else.16032
	fli f0, 1.000000
	lw a0, -18(sp)
	lw a0, 7(a0)
	flw f2, 0(a0)
	fsub f0, f0, f2
	fmul f0, f1, f0
	addi a0, a1, 1
	li a1, 16777340
	flw f1, 0(a1)
	flw f2, -1(sp)
	fadd f1, f2, f1
	lw a1, -12(sp)
	lw a2, -7(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
be_else.16032:
	jalr zero, ra, 0
ble_else.16007:
	jalr zero, ra, 0
trace_diffuse_ray.2834:
	lw a1, 27(cl)
	lw a2, 26(cl)
	lw a3, 19(cl)
	lw a4, 17(cl)
	lw a5, 16(cl)
	lw a6, 15(cl)
	lw cl, 3(cl)
	fli f1, 1000000000.000000
	li a7, 16777340
	fsw f1, 0(a7)
	li a7, 16777337
	lw a7, 0(a7)
	li a8, 0
	sw a1, 0(sp)
	sw a2, -1(sp)
	fsw f0, -2(sp)
	sw a3, -3(sp)
	sw a4, -4(sp)
	sw a5, -5(sp)
	sw a6, -6(sp)
	sw a0, -7(sp)
	add a2, a0, zero
	add a1, a7, zero
	add a0, a8, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 16777340
	flw f0, 0(a0)
	fli f1, -0.100000
	flt a0, f1, f0
	li a1, 0
	bne a0, a1, be_else.16035
	add a0, a1, zero
	jump be_cont.16036
be_else.16035:
	fli f1, 100000000.000000
	flt a0, f0, f1
be_cont.16036:
	bne a0, a1, be_else.16037
	jalr zero, ra, 0
be_else.16037:
	li a0, 16777344
	lw a0, 0(a0)
	li a2, 16777217
	add a22, a2, a0
	lw a0, 0(a22)
	lw a2, -7(sp)
	lw a2, 0(a2)
	lw a3, 1(a0)
	li a4, 1
	sw a0, -8(sp)
	bne a3, a4, be_else.16039
	li a3, 16777339
	lw a3, 0(a3)
	li a4, 16777345
	fli f0, 0.000000
	fsw f0, 0(a4)
	li a4, 1
	li a5, 16777345
	add a22, a5, a4
	fsw f0, 0(a22)
	li a4, 2
	li a5, 16777345
	add a22, a5, a4
	fsw f0, 0(a22)
	addi a4, a3, -1
	addi a3, a3, -1
	add a22, a3, a2
	flw f1, 0(a22)
	feq a2, f1, fzero
	bne a2, a1, be_else.16041
	flt a2, fzero, f1
	bne a2, a1, be_else.16043
	fli f1, -1.000000
	jump be_cont.16044
be_else.16043:
	fli f1, 1.000000
be_cont.16044:
	jump be_cont.16042
be_else.16041:
	fadd f1, f0, fzero
be_cont.16042:
	fneg f1, f1
	li a2, 16777345
	add a22, a2, a4
	fsw f1, 0(a22)
	jump be_cont.16040
be_else.16039:
	li a2, 2
	bne a3, a2, be_else.16045
	lw a2, 4(a0)
	flw f0, 0(a2)
	fneg f0, f0
	li a2, 16777345
	fsw f0, 0(a2)
	li a2, 1
	lw a3, 4(a0)
	flw f0, 1(a3)
	fneg f0, f0
	li a3, 16777345
	add a22, a3, a2
	fsw f0, 0(a22)
	li a2, 2
	lw a3, 4(a0)
	flw f0, 2(a3)
	fneg f0, f0
	li a3, 16777345
	add a22, a3, a2
	fsw f0, 0(a22)
	jump be_cont.16046
be_else.16045:
	lw cl, -6(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
be_cont.16046:
be_cont.16040:
	lw a0, -8(sp)
	lw a1, -4(sp)
	lw cl, -5(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a0, 16777337
	lw a1, 0(a0)
	li a0, 0
	lw cl, -3(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 0
	bne a0, a1, be_else.16047
	li a0, 16777345
	flw f0, 0(a0)
	li a0, 16777283
	flw f1, 0(a0)
	fmul f0, f0, f1
	li a0, 1
	li a2, 16777345
	add a22, a2, a0
	flw f1, 0(a22)
	li a2, 16777283
	add a22, a2, a0
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	li a0, 2
	li a2, 16777345
	add a22, a2, a0
	flw f1, 0(a22)
	li a2, 16777283
	add a22, a2, a0
	flw f2, 0(a22)
	fmul f1, f1, f2
	fadd f0, f0, f1
	fneg f0, f0
	flt a0, fzero, f0
	bne a0, a1, be_else.16048
	fli f0, 0.000000
	jump be_cont.16049
be_else.16048:
be_cont.16049:
	flw f1, -2(sp)
	fmul f0, f1, f0
	lw a0, -8(sp)
	lw a0, 7(a0)
	flw f1, 0(a0)
	fmul f0, f0, f1
	lw a0, -1(sp)
	lw a1, 0(sp)
	jump vecaccum.2530
be_else.16047:
	jalr zero, ra, 0
iter_trace_diffuse_rays.2837:
	lw a4, 1(cl)
	li a5, 0
	blt a3, a5, ble_else.16051
	add a22, a3, a0
	lw a6, 0(a22)
	lw a6, 0(a6)
	flw f0, 0(a6)
	flw f1, 0(a1)
	fmul f0, f0, f1
	flw f1, 1(a6)
	flw f2, 1(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	flw f1, 2(a6)
	flw f2, 2(a1)
	fmul f1, f1, f2
	fadd f0, f0, f1
	flt a6, f0, fzero
	sw a2, 0(sp)
	sw a1, -1(sp)
	sw a0, -2(sp)
	sw cl, -3(sp)
	sw a3, -4(sp)
	bne a6, a5, be_else.16052
	add a22, a3, a0
	lw a5, 0(a22)
	fli f1, 150.000000
	fdiv f0, f0, f1
	add a0, a5, zero
	add cl, a4, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	jump be_cont.16053
be_else.16052:
	addi a5, a3, 1
	add a22, a5, a0
	lw a5, 0(a22)
	fli f1, -150.000000
	fdiv f0, f0, f1
	add a0, a5, zero
	add cl, a4, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
be_cont.16053:
	lw a0, -4(sp)
	addi a3, a0, -2
	lw a0, -2(sp)
	lw a1, -1(sp)
	lw a2, 0(sp)
	lw cl, -3(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16051:
	jalr zero, ra, 0
trace_diffuse_ray_80percent.2846:
	lw a3, 7(cl)
	lw cl, 6(cl)
	li a4, 0
	sw a1, 0(sp)
	sw a3, -1(sp)
	sw cl, -2(sp)
	sw a2, -3(sp)
	sw a0, -4(sp)
	bne a0, a4, be_else.16055
	jump be_cont.16056
be_else.16055:
	li a4, 16777380
	lw a4, 0(a4)
	flw f0, 0(a2)
	li a5, 16777365
	fsw f0, 0(a5)
	li a5, 1
	flw f0, 1(a2)
	li a6, 16777365
	add a22, a6, a5
	fsw f0, 0(a22)
	li a5, 2
	flw f0, 2(a2)
	li a6, 16777365
	add a22, a6, a5
	fsw f0, 0(a22)
	li a5, 16777216
	lw a5, 0(a5)
	addi a5, a5, -1
	sw a4, -5(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	li a3, 118
	lw a0, -5(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw cl, -1(sp)
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
be_cont.16056:
	li a0, 1
	lw a1, -4(sp)
	bne a1, a0, be_else.16057
	jump be_cont.16058
be_else.16057:
	li a0, 1
	li a2, 16777380
	add a22, a2, a0
	lw a0, 0(a22)
	lw a2, -3(sp)
	flw f0, 0(a2)
	li a3, 16777365
	fsw f0, 0(a3)
	li a3, 1
	flw f0, 1(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 2
	flw f0, 2(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	lw cl, -2(sp)
	sw a0, -6(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a3, 118
	lw a0, -6(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw cl, -1(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16058:
	li a0, 2
	lw a1, -4(sp)
	bne a1, a0, be_else.16059
	jump be_cont.16060
be_else.16059:
	li a0, 2
	li a2, 16777380
	add a22, a2, a0
	lw a0, 0(a22)
	lw a2, -3(sp)
	flw f0, 0(a2)
	li a3, 16777365
	fsw f0, 0(a3)
	li a3, 1
	flw f0, 1(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 2
	flw f0, 2(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	lw cl, -2(sp)
	sw a0, -7(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a3, 118
	lw a0, -7(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw cl, -1(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16060:
	li a0, 3
	lw a1, -4(sp)
	bne a1, a0, be_else.16061
	jump be_cont.16062
be_else.16061:
	li a0, 3
	li a2, 16777380
	add a22, a2, a0
	lw a0, 0(a22)
	lw a2, -3(sp)
	flw f0, 0(a2)
	li a3, 16777365
	fsw f0, 0(a3)
	li a3, 1
	flw f0, 1(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 2
	flw f0, 2(a2)
	li a4, 16777365
	add a22, a4, a3
	fsw f0, 0(a22)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	lw cl, -2(sp)
	sw a0, -8(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a3, 118
	lw a0, -8(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw cl, -1(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
be_cont.16062:
	li a0, 4
	lw a1, -4(sp)
	bne a1, a0, be_else.16063
	jalr zero, ra, 0
be_else.16063:
	li a0, 4
	li a1, 16777380
	add a22, a1, a0
	lw a0, 0(a22)
	lw a1, -3(sp)
	flw f0, 0(a1)
	li a2, 16777365
	fsw f0, 0(a2)
	li a2, 1
	flw f0, 1(a1)
	li a3, 16777365
	add a22, a3, a2
	fsw f0, 0(a22)
	li a2, 2
	flw f0, 2(a1)
	li a3, 16777365
	add a22, a3, a2
	fsw f0, 0(a22)
	li a2, 16777216
	lw a2, 0(a2)
	addi a2, a2, -1
	lw cl, -2(sp)
	sw a0, -9(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	li a3, 118
	lw a0, -9(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw cl, -1(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
calc_diffuse_using_1point.2850:
	lw a2, 5(cl)
	lw a3, 4(cl)
	lw a4, 1(cl)
	lw a5, 5(a0)
	lw a6, 7(a0)
	lw a7, 1(a0)
	lw a8, 4(a0)
	add a22, a1, a5
	lw a5, 0(a22)
	flw f0, 0(a5)
	li a9, 16777351
	fsw f0, 0(a9)
	li a9, 1
	flw f0, 1(a5)
	li a10, 16777351
	add a22, a10, a9
	fsw f0, 0(a22)
	li a9, 2
	flw f0, 2(a5)
	li a5, 16777351
	add a22, a5, a9
	fsw f0, 0(a22)
	lw a0, 6(a0)
	lw a0, 0(a0)
	add a22, a1, a6
	lw a5, 0(a22)
	add a22, a1, a7
	lw a6, 0(a22)
	sw a4, 0(sp)
	sw a2, -1(sp)
	sw a1, -2(sp)
	sw a8, -3(sp)
	add a2, a6, zero
	add a1, a5, zero
	add cl, a3, zero
	sw ra, -4(sp)
	lw swp, 0(cl)
	addi sp, sp, -5
	jalr ra, swp, 0
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -2(sp)
	lw a1, -3(sp)
	add a22, a0, a1
	lw a1, 0(a22)
	lw a0, -1(sp)
	lw a2, 0(sp)
	jump vecaccumv.2543
calc_diffuse_using_5points.2853:
	lw a5, 28(cl)
	lw a6, 1(cl)
	add a22, a0, a1
	lw a1, 0(a22)
	lw a1, 5(a1)
	addi a7, a0, -1
	add a22, a7, a2
	lw a7, 0(a22)
	lw a7, 5(a7)
	add a22, a0, a2
	lw a8, 0(a22)
	lw a8, 5(a8)
	addi a9, a0, 1
	add a22, a9, a2
	lw a9, 0(a22)
	lw a9, 5(a9)
	add a22, a0, a3
	lw a3, 0(a22)
	lw a3, 5(a3)
	add a22, a4, a1
	lw a1, 0(a22)
	flw f0, 0(a1)
	li a10, 16777351
	fsw f0, 0(a10)
	li a10, 1
	flw f0, 1(a1)
	li a11, 16777351
	add a22, a11, a10
	fsw f0, 0(a22)
	li a10, 2
	flw f0, 2(a1)
	li a1, 16777351
	add a22, a1, a10
	fsw f0, 0(a22)
	add a22, a4, a7
	lw a1, 0(a22)
	li a7, 16777351
	flw f0, 0(a7)
	flw f1, 0(a1)
	fadd f0, f0, f1
	li a7, 16777351
	fsw f0, 0(a7)
	li a7, 1
	li a10, 16777351
	add a22, a10, a7
	flw f0, 0(a22)
	flw f1, 1(a1)
	fadd f0, f0, f1
	li a10, 16777351
	add a22, a10, a7
	fsw f0, 0(a22)
	li a7, 2
	li a10, 16777351
	add a22, a10, a7
	flw f0, 0(a22)
	flw f1, 2(a1)
	fadd f0, f0, f1
	li a1, 16777351
	add a22, a1, a7
	fsw f0, 0(a22)
	add a22, a4, a8
	lw a1, 0(a22)
	li a7, 16777351
	flw f0, 0(a7)
	flw f1, 0(a1)
	fadd f0, f0, f1
	li a7, 16777351
	fsw f0, 0(a7)
	li a7, 1
	li a8, 16777351
	add a22, a8, a7
	flw f0, 0(a22)
	flw f1, 1(a1)
	fadd f0, f0, f1
	li a8, 16777351
	add a22, a8, a7
	fsw f0, 0(a22)
	li a7, 2
	li a8, 16777351
	add a22, a8, a7
	flw f0, 0(a22)
	flw f1, 2(a1)
	fadd f0, f0, f1
	li a1, 16777351
	add a22, a1, a7
	fsw f0, 0(a22)
	add a22, a4, a9
	lw a1, 0(a22)
	li a7, 16777351
	flw f0, 0(a7)
	flw f1, 0(a1)
	fadd f0, f0, f1
	li a7, 16777351
	fsw f0, 0(a7)
	li a7, 1
	li a8, 16777351
	add a22, a8, a7
	flw f0, 0(a22)
	flw f1, 1(a1)
	fadd f0, f0, f1
	li a8, 16777351
	add a22, a8, a7
	fsw f0, 0(a22)
	li a7, 2
	li a8, 16777351
	add a22, a8, a7
	flw f0, 0(a22)
	flw f1, 2(a1)
	fadd f0, f0, f1
	li a1, 16777351
	add a22, a1, a7
	fsw f0, 0(a22)
	add a22, a4, a3
	lw a1, 0(a22)
	li a3, 16777351
	flw f0, 0(a3)
	flw f1, 0(a1)
	fadd f0, f0, f1
	li a3, 16777351
	fsw f0, 0(a3)
	li a3, 1
	li a7, 16777351
	add a22, a7, a3
	flw f0, 0(a22)
	flw f1, 1(a1)
	fadd f0, f0, f1
	li a7, 16777351
	add a22, a7, a3
	fsw f0, 0(a22)
	li a3, 2
	li a7, 16777351
	add a22, a7, a3
	flw f0, 0(a22)
	flw f1, 2(a1)
	fadd f0, f0, f1
	li a1, 16777351
	add a22, a1, a3
	fsw f0, 0(a22)
	add a22, a0, a2
	lw a0, 0(a22)
	lw a0, 4(a0)
	add a22, a4, a0
	lw a1, 0(a22)
	add a2, a6, zero
	add a0, a5, zero
	jump vecaccumv.2543
do_without_neighbors.2859:
	lw a2, 7(cl)
	lw a3, 5(cl)
	lw a4, 4(cl)
	lw a5, 1(cl)
	li a6, 4
	blt a6, a1, ble_else.16065
	lw a6, 2(a0)
	add a22, a1, a6
	lw a6, 0(a22)
	li a7, 0
	blt a6, a7, ble_else.16066
	lw a6, 3(a0)
	add a22, a1, a6
	lw a6, 0(a22)
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a0, -2(sp)
	sw a1, -3(sp)
	bne a6, a7, be_else.16067
	jump be_cont.16068
be_else.16067:
	lw a6, 5(a0)
	lw a8, 7(a0)
	lw a9, 1(a0)
	lw a10, 4(a0)
	add a22, a1, a6
	lw a6, 0(a22)
	flw f0, 0(a6)
	li a11, 16777351
	fsw f0, 0(a11)
	li a11, 1
	flw f0, 1(a6)
	li a12, 16777351
	add a22, a12, a11
	fsw f0, 0(a22)
	li a11, 2
	flw f0, 2(a6)
	li a6, 16777351
	add a22, a6, a11
	fsw f0, 0(a22)
	lw a6, 6(a0)
	lw a6, 0(a6)
	add a22, a1, a8
	lw a8, 0(a22)
	add a22, a1, a9
	lw a9, 0(a22)
	sw a5, -4(sp)
	sw a3, -5(sp)
	sw a10, -6(sp)
	add a2, a9, zero
	add a1, a8, zero
	add a0, a6, zero
	add cl, a4, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -3(sp)
	lw a1, -6(sp)
	add a22, a0, a1
	lw a1, 0(a22)
	lw a2, -5(sp)
	lw a3, -4(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, vecaccumv.2543
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16068:
	lw a0, -3(sp)
	addi a1, a0, 1
	li a0, 4
	blt a0, a1, ble_else.16069
	lw a0, -2(sp)
	lw a2, 2(a0)
	add a22, a1, a2
	lw a2, 0(a22)
	li a3, 0
	blt a2, a3, ble_else.16070
	lw a2, 3(a0)
	add a22, a1, a2
	lw a2, 0(a22)
	sw a1, -7(sp)
	bne a2, a3, be_else.16071
	jump be_cont.16072
be_else.16071:
	lw cl, -1(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16072:
	lw a0, -7(sp)
	addi a1, a0, 1
	lw a0, -2(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16070:
	jalr zero, ra, 0
ble_else.16069:
	jalr zero, ra, 0
ble_else.16066:
	jalr zero, ra, 0
ble_else.16065:
	jalr zero, ra, 0
neighbors_are_available.2869:
	add a22, a0, a2
	lw a5, 0(a22)
	lw a5, 2(a5)
	add a22, a4, a5
	lw a5, 0(a22)
	add a22, a0, a1
	lw a1, 0(a22)
	lw a1, 2(a1)
	add a22, a4, a1
	lw a1, 0(a22)
	bne a1, a5, be_else.16077
	add a22, a0, a3
	lw a1, 0(a22)
	lw a1, 2(a1)
	add a22, a4, a1
	lw a1, 0(a22)
	bne a1, a5, be_else.16078
	li a1, 1
	addi a3, a0, -1
	add a22, a3, a2
	lw a3, 0(a22)
	lw a3, 2(a3)
	add a22, a4, a3
	lw a3, 0(a22)
	bne a3, a5, be_else.16079
	addi a0, a0, 1
	add a22, a0, a2
	lw a0, 0(a22)
	lw a0, 2(a0)
	add a22, a4, a0
	lw a0, 0(a22)
	bne a0, a5, be_else.16080
	add a0, a1, zero
	jalr zero, ra, 0
be_else.16080:
	li a0, 0
	jalr zero, ra, 0
be_else.16079:
	li a0, 0
	jalr zero, ra, 0
be_else.16078:
	li a0, 0
	jalr zero, ra, 0
be_else.16077:
	li a0, 0
	jalr zero, ra, 0
try_exploit_neighbors.2875:
	lw a6, 3(cl)
	lw a7, 2(cl)
	lw a8, 1(cl)
	add a22, a0, a3
	lw a9, 0(a22)
	li a10, 4
	blt a10, a5, ble_else.16081
	lw a11, 2(a9)
	add a22, a5, a11
	lw a11, 0(a22)
	li a12, 0
	blt a11, a12, ble_else.16082
	sw a1, 0(sp)
	sw cl, -1(sp)
	sw a4, -2(sp)
	sw a2, -3(sp)
	sw a6, -4(sp)
	sw a9, -5(sp)
	sw a7, -6(sp)
	sw a8, -7(sp)
	sw a10, -8(sp)
	sw a5, -9(sp)
	sw a0, -10(sp)
	sw a3, -11(sp)
	add a1, a2, zero
	add a2, a3, zero
	add a3, a4, zero
	add a4, a5, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, neighbors_are_available.2869
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 0
	bne a0, a1, be_else.16083
	lw a0, -10(sp)
	lw a2, -11(sp)
	add a22, a0, a2
	lw a0, 0(a22)
	lw a2, -8(sp)
	lw a3, -9(sp)
	blt a2, a3, ble_else.16084
	lw a2, 2(a0)
	add a22, a3, a2
	lw a2, 0(a22)
	blt a2, a1, ble_else.16085
	lw a2, 3(a0)
	add a22, a3, a2
	lw a2, 0(a22)
	sw a0, -12(sp)
	bne a2, a1, be_else.16086
	jump be_cont.16087
be_else.16086:
	lw cl, -7(sp)
	add a1, a3, zero
	sw ra, -14(sp)
	lw swp, 0(cl)
	addi sp, sp, -15
	jalr ra, swp, 0
	addi sp, sp, 15
	lw ra, -14(sp)
be_cont.16087:
	lw a0, -9(sp)
	addi a1, a0, 1
	lw a0, -12(sp)
	lw cl, -6(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16085:
	jalr zero, ra, 0
ble_else.16084:
	jalr zero, ra, 0
be_else.16083:
	lw a0, -5(sp)
	lw a0, 3(a0)
	lw a4, -9(sp)
	add a22, a4, a0
	lw a0, 0(a22)
	bne a0, a1, be_else.16090
	jump be_cont.16091
be_else.16090:
	lw a0, -10(sp)
	lw a1, -3(sp)
	lw a2, -11(sp)
	lw a3, -2(sp)
	lw cl, -4(sp)
	sw ra, -14(sp)
	lw swp, 0(cl)
	addi sp, sp, -15
	jalr ra, swp, 0
	addi sp, sp, 15
	lw ra, -14(sp)
be_cont.16091:
	lw a0, -9(sp)
	addi a5, a0, 1
	lw a0, -10(sp)
	lw a1, 0(sp)
	lw a2, -3(sp)
	lw a3, -11(sp)
	lw a4, -2(sp)
	lw cl, -1(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16082:
	jalr zero, ra, 0
ble_else.16081:
	jalr zero, ra, 0
write_ppm_header.2882:
	li a0, 80
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, print_char
	addi sp, sp, 1
	lw ra, 0(sp)
	li a0, 51
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, print_char
	addi sp, sp, 1
	lw ra, 0(sp)
	li a0, 10
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_char
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 16777357
	lw a0, 0(a0)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_int
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 32
	sw a0, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_char
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 1
	li a1, 16777357
	add a22, a1, a0
	lw a0, 0(a22)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_int
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a0, -1(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_char
	addi sp, sp, 3
	lw ra, -2(sp)
	li a0, 255
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, print_int
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a0, 0(sp)
	jump print_char
pretrace_diffuse_rays.2888:
	lw a2, 10(cl)
	lw a3, 9(cl)
	li a4, 4
	blt a4, a1, ble_else.16094
	lw a4, 2(a0)
	add a22, a1, a4
	lw a4, 0(a22)
	li a5, 0
	blt a4, a5, ble_else.16095
	lw a4, 3(a0)
	add a22, a1, a4
	lw a4, 0(a22)
	sw cl, 0(sp)
	sw a1, -1(sp)
	bne a4, a5, be_else.16096
	jump be_cont.16097
be_else.16096:
	lw a4, 6(a0)
	lw a4, 0(a4)
	li a5, 16777351
	fli f0, 0.000000
	fsw f0, 0(a5)
	li a5, 1
	li a6, 16777351
	add a22, a6, a5
	fsw f0, 0(a22)
	li a5, 2
	li a6, 16777351
	add a22, a6, a5
	fsw f0, 0(a22)
	lw a5, 7(a0)
	lw a6, 1(a0)
	li a7, 16777380
	add a22, a7, a4
	lw a4, 0(a22)
	add a22, a1, a5
	lw a5, 0(a22)
	add a22, a1, a6
	lw a6, 0(a22)
	flw f0, 0(a6)
	li a7, 16777365
	fsw f0, 0(a7)
	li a7, 1
	flw f0, 1(a6)
	li a8, 16777365
	add a22, a8, a7
	fsw f0, 0(a22)
	li a7, 2
	flw f0, 2(a6)
	li a8, 16777365
	add a22, a8, a7
	fsw f0, 0(a22)
	li a7, 16777216
	lw a7, 0(a7)
	addi a7, a7, -1
	sw a0, -2(sp)
	sw a6, -3(sp)
	sw a5, -4(sp)
	sw a4, -5(sp)
	sw a2, -6(sp)
	add a1, a7, zero
	add a0, a6, zero
	add cl, a3, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	li a3, 118
	lw a0, -5(sp)
	lw a1, -4(sp)
	lw a2, -3(sp)
	lw cl, -6(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -2(sp)
	lw a1, 5(a0)
	lw a2, -1(sp)
	add a22, a2, a1
	lw a1, 0(a22)
	li a3, 16777351
	flw f0, 0(a3)
	fsw f0, 0(a1)
	li a3, 1
	li a4, 16777351
	add a22, a4, a3
	flw f0, 0(a22)
	fsw f0, 1(a1)
	li a3, 2
	li a4, 16777351
	add a22, a4, a3
	flw f0, 0(a22)
	fsw f0, 2(a1)
be_cont.16097:
	lw a1, -1(sp)
	addi a1, a1, 1
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16095:
	jalr zero, ra, 0
ble_else.16094:
	jalr zero, ra, 0
pretrace_pixels.2891:
	lw a3, 24(cl)
	lw a4, 19(cl)
	lw a5, 4(cl)
	li a6, 0
	blt a1, a6, ble_else.16100
	li a7, 16777361
	flw f3, 0(a7)
	li a7, 16777359
	lw a7, 0(a7)
	sub a7, a1, a7
	itof f4, a7
	fmul f3, f3, f4
	li a7, 16777368
	flw f4, 0(a7)
	fmul f4, f3, f4
	fadd f4, f4, f0
	li a7, 16777377
	fsw f4, 0(a7)
	li a7, 1
	li a8, 1
	li a9, 16777368
	add a22, a9, a8
	flw f4, 0(a22)
	fmul f4, f3, f4
	fadd f4, f4, f1
	li a8, 16777377
	add a22, a8, a7
	fsw f4, 0(a22)
	li a7, 2
	li a8, 2
	li a9, 16777368
	add a22, a9, a8
	flw f4, 0(a22)
	fmul f3, f3, f4
	fadd f3, f3, f2
	li a8, 16777377
	add a22, a8, a7
	fsw f3, 0(a22)
	fsw f2, 0(sp)
	fsw f1, -1(sp)
	fsw f0, -2(sp)
	sw cl, -3(sp)
	sw a3, -4(sp)
	sw a2, -5(sp)
	sw a5, -6(sp)
	sw a4, -7(sp)
	sw a1, -8(sp)
	sw a0, -9(sp)
	add a1, a6, zero
	add a0, a5, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, vecunit_sgn.2519
	addi sp, sp, 11
	lw ra, -10(sp)
	li a0, 16777354
	fli f1, 0.000000
	fsw f1, 0(a0)
	li a0, 1
	li a1, 16777354
	add a22, a1, a0
	fsw f1, 0(a22)
	li a0, 2
	li a1, 16777354
	add a22, a1, a0
	fsw f1, 0(a22)
	li a0, 16777280
	flw f0, 0(a0)
	li a0, 16777362
	fsw f0, 0(a0)
	li a0, 1
	li a1, 1
	li a2, 16777280
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 16777362
	add a22, a1, a0
	fsw f0, 0(a22)
	li a0, 2
	li a1, 2
	li a2, 16777280
	add a22, a2, a1
	flw f0, 0(a22)
	li a1, 16777362
	add a22, a1, a0
	fsw f0, 0(a22)
	fli f0, 1.000000
	lw a0, -8(sp)
	lw a1, -9(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	li a3, 0
	lw a4, -6(sp)
	lw cl, -7(sp)
	add a1, a4, zero
	add a0, a3, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	lw a1, -9(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a2, 0(a2)
	li a3, 16777354
	flw f0, 0(a3)
	fsw f0, 0(a2)
	li a3, 1
	li a4, 16777354
	add a22, a4, a3
	flw f0, 0(a22)
	fsw f0, 1(a2)
	li a3, 2
	li a4, 16777354
	add a22, a4, a3
	flw f0, 0(a22)
	fsw f0, 2(a2)
	add a22, a0, a1
	lw a2, 0(a22)
	lw a2, 6(a2)
	lw a3, -5(sp)
	sw a3, 0(a2)
	add a22, a0, a1
	lw a2, 0(a22)
	li a4, 0
	lw cl, -4(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -8(sp)
	addi a1, a0, -1
	lw a0, -5(sp)
	addi a0, a0, 1
	li a2, 5
	blt a0, a2, ble_else.16101
	addi a2, a0, -5
	jump ble_cont.16102
ble_else.16101:
	add a2, a0, zero
ble_cont.16102:
	flw f0, -2(sp)
	flw f1, -1(sp)
	flw f2, 0(sp)
	lw a0, -9(sp)
	lw cl, -3(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16100:
	jalr zero, ra, 0
pretrace_line.2898:
	lw cl, 10(cl)
	li a3, 16777361
	flw f0, 0(a3)
	li a3, 1
	li a4, 16777359
	add a22, a4, a3
	lw a4, 0(a22)
	sub a1, a1, a4
	itof f1, a1
	fmul f0, f0, f1
	li a1, 16777371
	flw f1, 0(a1)
	fmul f1, f0, f1
	li a1, 16777374
	flw f2, 0(a1)
	fadd f1, f1, f2
	li a1, 16777371
	add a22, a1, a3
	flw f2, 0(a22)
	fmul f2, f0, f2
	li a1, 16777374
	add a22, a1, a3
	flw f3, 0(a22)
	fadd f2, f2, f3
	li a1, 2
	li a3, 16777371
	add a22, a3, a1
	flw f3, 0(a22)
	fmul f0, f0, f3
	li a3, 16777374
	add a22, a3, a1
	flw f3, 0(a22)
	fadd f0, f0, f3
	li a1, 16777357
	lw a1, 0(a1)
	addi a1, a1, -1
	fmv f12, f2
	fmv f2, f0
	fmv f0, f1
	fmv f1, f12
	lw swp, 0(cl)
	jalr zero, swp, 0
scan_pixel.2902:
	lw a5, 9(cl)
	lw a6, 8(cl)
	lw a7, 7(cl)
	li a8, 16777357
	lw a8, 0(a8)
	blt a0, a8, ble_else.16104
	jalr zero, ra, 0
ble_else.16104:
	add a22, a0, a3
	lw a8, 0(a22)
	lw a8, 0(a8)
	flw f0, 0(a8)
	li a9, 16777354
	fsw f0, 0(a9)
	li a9, 1
	flw f0, 1(a8)
	li a10, 16777354
	add a22, a10, a9
	fsw f0, 0(a22)
	li a9, 2
	flw f0, 2(a8)
	li a8, 16777354
	add a22, a8, a9
	fsw f0, 0(a22)
	li a8, 1
	li a9, 16777357
	add a22, a9, a8
	lw a8, 0(a22)
	addi a9, a1, 1
	blt a9, a8, ble_else.16106
	li a8, 0
	add a9, a8, zero
	jump ble_cont.16107
ble_else.16106:
	li a8, 0
	blt a8, a1, ble_else.16108
	add a9, a8, zero
	jump ble_cont.16109
ble_else.16108:
	li a9, 16777357
	lw a9, 0(a9)
	addi a10, a0, 1
	blt a10, a9, ble_else.16110
	add a9, a8, zero
	jump ble_cont.16111
ble_else.16110:
	blt a8, a0, ble_else.16112
	add a9, a8, zero
	jump ble_cont.16113
ble_else.16112:
	li a9, 1
ble_cont.16113:
ble_cont.16111:
ble_cont.16109:
ble_cont.16107:
	sw a4, 0(sp)
	sw a3, -1(sp)
	sw a2, -2(sp)
	sw a1, -3(sp)
	sw cl, -4(sp)
	sw a0, -5(sp)
	bne a9, a8, be_else.16114
	add a22, a0, a3
	lw a5, 0(a22)
	lw a9, 2(a5)
	lw a9, 0(a9)
	blt a9, a8, ble_else.16116
	lw a9, 3(a5)
	lw a9, 0(a9)
	sw a5, -6(sp)
	sw a6, -7(sp)
	bne a9, a8, be_else.16118
	jump be_cont.16119
be_else.16118:
	add a1, a8, zero
	add a0, a5, zero
	add cl, a7, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16119:
	li a1, 1
	lw a0, -6(sp)
	lw cl, -7(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	jump ble_cont.16117
ble_else.16116:
ble_cont.16117:
	jump be_cont.16115
be_else.16114:
	add cl, a5, zero
	add a5, a8, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
be_cont.16115:
	li a0, 16777354
	flw f0, 0(a0)
	ftoi a0, f0
	li a1, 255
	blt a1, a0, ble_else.16120
	li a1, 0
	blt a0, a1, ble_else.16122
	jump ble_cont.16123
ble_else.16122:
	add a0, a1, zero
ble_cont.16123:
	jump ble_cont.16121
ble_else.16120:
	li a0, 255
ble_cont.16121:
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_int
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 32
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_char
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 1
	li a1, 16777354
	add a22, a1, a0
	flw f0, 0(a22)
	ftoi a0, f0
	li a1, 255
	blt a1, a0, ble_else.16124
	li a1, 0
	blt a0, a1, ble_else.16126
	jump ble_cont.16127
ble_else.16126:
	add a0, a1, zero
ble_cont.16127:
	jump ble_cont.16125
ble_else.16124:
	li a0, 255
ble_cont.16125:
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_int
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 32
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_char
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 2
	li a1, 16777354
	add a22, a1, a0
	flw f0, 0(a22)
	ftoi a0, f0
	li a1, 255
	blt a1, a0, ble_else.16128
	li a1, 0
	blt a0, a1, ble_else.16130
	jump ble_cont.16131
ble_else.16130:
	add a0, a1, zero
ble_cont.16131:
	jump ble_cont.16129
ble_else.16128:
	li a0, 255
ble_cont.16129:
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_int
	addi sp, sp, 9
	lw ra, -8(sp)
	li a0, 10
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, print_char
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -3(sp)
	lw a2, -2(sp)
	lw a3, -1(sp)
	lw a4, 0(sp)
	lw cl, -4(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
scan_line.2908:
	lw a5, 4(cl)
	lw a6, 3(cl)
	li a7, 1
	li a8, 16777357
	add a22, a8, a7
	lw a8, 0(a22)
	blt a0, a8, ble_else.16132
	jalr zero, ra, 0
ble_else.16132:
	li a8, 16777357
	add a22, a8, a7
	lw a7, 0(a22)
	addi a7, a7, -1
	sw cl, 0(sp)
	sw a4, -1(sp)
	sw a3, -2(sp)
	sw a2, -3(sp)
	sw a1, -4(sp)
	sw a0, -5(sp)
	sw a5, -6(sp)
	blt a0, a7, ble_else.16134
	jump ble_cont.16135
ble_else.16134:
	addi a7, a0, 1
	add a2, a4, zero
	add a1, a7, zero
	add a0, a3, zero
	add cl, a6, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
ble_cont.16135:
	li a0, 0
	lw a1, -5(sp)
	lw a2, -4(sp)
	lw a3, -3(sp)
	lw a4, -2(sp)
	lw cl, -6(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -5(sp)
	addi a0, a0, 1
	lw a1, -1(sp)
	addi a1, a1, 2
	li a2, 5
	blt a1, a2, ble_else.16136
	addi a4, a1, -5
	jump ble_cont.16137
ble_else.16136:
	add a4, a1, zero
ble_cont.16137:
	lw a1, -3(sp)
	lw a2, -2(sp)
	lw a3, -4(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
create_float5x3array.2914:
	li a0, 3
	fli f0, 0.000000
	sw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	add a1, a0, zero
	li a0, 5
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_array
	addi sp, sp, 3
	lw ra, -2(sp)
	fli f0, 0.000000
	lw a1, 0(sp)
	sw a0, -1(sp)
	add a0, a1, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	sw a0, 1(a1)
	fli f0, 0.000000
	lw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	sw a0, 2(a1)
	fli f0, 0.000000
	lw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	sw a0, 3(a1)
	fli f0, 0.000000
	lw a0, 0(sp)
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	lw a1, -1(sp)
	sw a0, 4(a1)
	add a0, a1, zero
	jalr zero, ra, 0
init_line_elements.2918:
	li a2, 0
	blt a1, a2, ble_else.16138
	li a3, 3
	fli f0, 0.000000
	sw a1, 0(sp)
	sw a0, -1(sp)
	add a0, a3, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	sw a0, -2(sp)
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_float5x3array.2914
	addi sp, sp, 5
	lw ra, -4(sp)
	li a1, 5
	li a2, 0
	sw a0, -3(sp)
	sw a1, -4(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_array
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a1, -4(sp)
	li a2, 0
	sw a0, -5(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_array
	addi sp, sp, 7
	lw ra, -6(sp)
	sw a0, -6(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_float5x3array.2914
	addi sp, sp, 9
	lw ra, -8(sp)
	sw a0, -7(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_float5x3array.2914
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 1
	li a2, 0
	sw a0, -8(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_array
	addi sp, sp, 11
	lw ra, -10(sp)
	sw a0, -9(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_float5x3array.2914
	addi sp, sp, 11
	lw ra, -10(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -9(sp)
	sw a0, 6(a1)
	lw a0, -8(sp)
	sw a0, 5(a1)
	lw a0, -7(sp)
	sw a0, 4(a1)
	lw a0, -6(sp)
	sw a0, 3(a1)
	lw a0, -5(sp)
	sw a0, 2(a1)
	lw a0, -3(sp)
	sw a0, 1(a1)
	lw a0, -2(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, 0(sp)
	lw a2, -1(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16139
	li a3, 3
	fli f0, 0.000000
	sw a0, -10(sp)
	add a0, a3, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, create_float_array
	addi sp, sp, 13
	lw ra, -12(sp)
	sw a0, -11(sp)
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, create_float5x3array.2914
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 5
	li a2, 0
	sw a0, -12(sp)
	sw a1, -13(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, create_array
	addi sp, sp, 15
	lw ra, -14(sp)
	lw a1, -13(sp)
	li a2, 0
	sw a0, -14(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, create_array
	addi sp, sp, 17
	lw ra, -16(sp)
	sw a0, -15(sp)
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, create_float5x3array.2914
	addi sp, sp, 17
	lw ra, -16(sp)
	sw a0, -16(sp)
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_float5x3array.2914
	addi sp, sp, 19
	lw ra, -18(sp)
	li a1, 1
	li a2, 0
	sw a0, -17(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_array
	addi sp, sp, 19
	lw ra, -18(sp)
	sw a0, -18(sp)
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, create_float5x3array.2914
	addi sp, sp, 21
	lw ra, -20(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -18(sp)
	sw a0, 6(a1)
	lw a0, -17(sp)
	sw a0, 5(a1)
	lw a0, -16(sp)
	sw a0, 4(a1)
	lw a0, -15(sp)
	sw a0, 3(a1)
	lw a0, -14(sp)
	sw a0, 2(a1)
	lw a0, -12(sp)
	sw a0, 1(a1)
	lw a0, -11(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -10(sp)
	lw a2, -1(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16140
	li a3, 3
	fli f0, 0.000000
	sw a0, -19(sp)
	add a0, a3, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, create_float_array
	addi sp, sp, 21
	lw ra, -20(sp)
	sw a0, -20(sp)
	sw ra, -22(sp)
	addi sp, sp, -23
	jal ra, create_float5x3array.2914
	addi sp, sp, 23
	lw ra, -22(sp)
	li a1, 5
	li a2, 0
	sw a0, -21(sp)
	sw a1, -22(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_array
	addi sp, sp, 25
	lw ra, -24(sp)
	lw a1, -22(sp)
	li a2, 0
	sw a0, -23(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_array
	addi sp, sp, 25
	lw ra, -24(sp)
	sw a0, -24(sp)
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_float5x3array.2914
	addi sp, sp, 27
	lw ra, -26(sp)
	sw a0, -25(sp)
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_float5x3array.2914
	addi sp, sp, 27
	lw ra, -26(sp)
	li a1, 1
	li a2, 0
	sw a0, -26(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_array
	addi sp, sp, 29
	lw ra, -28(sp)
	sw a0, -27(sp)
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_float5x3array.2914
	addi sp, sp, 29
	lw ra, -28(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -27(sp)
	sw a0, 6(a1)
	lw a0, -26(sp)
	sw a0, 5(a1)
	lw a0, -25(sp)
	sw a0, 4(a1)
	lw a0, -24(sp)
	sw a0, 3(a1)
	lw a0, -23(sp)
	sw a0, 2(a1)
	lw a0, -21(sp)
	sw a0, 1(a1)
	lw a0, -20(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -19(sp)
	lw a2, -1(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16141
	li a3, 3
	fli f0, 0.000000
	sw a0, -28(sp)
	add a0, a3, zero
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_float_array
	addi sp, sp, 31
	lw ra, -30(sp)
	sw a0, -29(sp)
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_float5x3array.2914
	addi sp, sp, 31
	lw ra, -30(sp)
	li a1, 5
	li a2, 0
	sw a0, -30(sp)
	sw a1, -31(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -32(sp)
	addi sp, sp, -33
	jal ra, create_array
	addi sp, sp, 33
	lw ra, -32(sp)
	lw a1, -31(sp)
	li a2, 0
	sw a0, -32(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_array
	addi sp, sp, 35
	lw ra, -34(sp)
	sw a0, -33(sp)
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_float5x3array.2914
	addi sp, sp, 35
	lw ra, -34(sp)
	sw a0, -34(sp)
	sw ra, -36(sp)
	addi sp, sp, -37
	jal ra, create_float5x3array.2914
	addi sp, sp, 37
	lw ra, -36(sp)
	li a1, 1
	li a2, 0
	sw a0, -35(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -36(sp)
	addi sp, sp, -37
	jal ra, create_array
	addi sp, sp, 37
	lw ra, -36(sp)
	sw a0, -36(sp)
	sw ra, -38(sp)
	addi sp, sp, -39
	jal ra, create_float5x3array.2914
	addi sp, sp, 39
	lw ra, -38(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -36(sp)
	sw a0, 6(a1)
	lw a0, -35(sp)
	sw a0, 5(a1)
	lw a0, -34(sp)
	sw a0, 4(a1)
	lw a0, -33(sp)
	sw a0, 3(a1)
	lw a0, -32(sp)
	sw a0, 2(a1)
	lw a0, -30(sp)
	sw a0, 1(a1)
	lw a0, -29(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -28(sp)
	lw a2, -1(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a1, a1, -1
	add a0, a2, zero
	jump init_line_elements.2918
ble_else.16141:
	add a0, a2, zero
	jalr zero, ra, 0
ble_else.16140:
	add a0, a2, zero
	jalr zero, ra, 0
ble_else.16139:
	add a0, a2, zero
	jalr zero, ra, 0
ble_else.16138:
	jalr zero, ra, 0
calc_dirvec.2928:
	li a3, 5
	blt a0, a3, ble_else.16142
	fmul f2, f0, f0
	fmul f3, f1, f1
	fadd f2, f2, f3
	fli f3, 1.000000
	fadd f2, f2, f3
	fsqrt f2, f2
	fdiv f0, f0, f2
	fdiv f1, f1, f2
	fli f3, 1.000000
	fdiv f2, f3, f2
	li a0, 16777380
	add a22, a0, a1
	lw a0, 0(a22)
	add a22, a2, a0
	lw a1, 0(a22)
	lw a1, 0(a1)
	fsw f0, 0(a1)
	fsw f1, 1(a1)
	fsw f2, 2(a1)
	addi a1, a2, 40
	add a22, a1, a0
	lw a1, 0(a22)
	lw a1, 0(a1)
	fneg f3, f1
	fsw f0, 0(a1)
	fsw f2, 1(a1)
	fsw f3, 2(a1)
	addi a1, a2, 80
	add a22, a1, a0
	lw a1, 0(a22)
	lw a1, 0(a1)
	fneg f3, f0
	fneg f4, f1
	fsw f2, 0(a1)
	fsw f3, 1(a1)
	fsw f4, 2(a1)
	addi a1, a2, 1
	add a22, a1, a0
	lw a1, 0(a22)
	lw a1, 0(a1)
	fneg f3, f0
	fneg f4, f1
	fneg f5, f2
	fsw f3, 0(a1)
	fsw f4, 1(a1)
	fsw f5, 2(a1)
	addi a1, a2, 41
	add a22, a1, a0
	lw a1, 0(a22)
	lw a1, 0(a1)
	fneg f3, f0
	fneg f4, f2
	fsw f3, 0(a1)
	fsw f4, 1(a1)
	fsw f1, 2(a1)
	addi a1, a2, 81
	add a22, a1, a0
	lw a0, 0(a22)
	lw a0, 0(a0)
	fneg f2, f2
	fsw f2, 0(a0)
	fsw f0, 1(a0)
	fsw f1, 2(a0)
	jalr zero, ra, 0
ble_else.16142:
	fmul f0, f1, f1
	fli f1, 0.100000
	fadd f0, f0, f1
	fsqrt f0, f0
	fli f1, 1.000000
	fdiv f1, f1, f0
	sw a2, 0(sp)
	sw a1, -1(sp)
	sw cl, -2(sp)
	fsw f3, -3(sp)
	sw a0, -4(sp)
	fsw f0, -5(sp)
	fsw f2, -6(sp)
	fmv f0, f1
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, atan
	addi sp, sp, 9
	lw ra, -8(sp)
	flw f1, -6(sp)
	fmul f0, f0, f1
	fsw f0, -7(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, sin
	addi sp, sp, 9
	lw ra, -8(sp)
	flw f1, -7(sp)
	fsw f0, -8(sp)
	fmv f0, f1
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, cos
	addi sp, sp, 11
	lw ra, -10(sp)
	flw f1, -8(sp)
	fdiv f0, f1, f0
	flw f1, -5(sp)
	fmul f0, f0, f1
	lw a0, -4(sp)
	addi a0, a0, 1
	fmul f1, f0, f0
	fli f2, 0.100000
	fadd f1, f1, f2
	fsqrt f1, f1
	fli f2, 1.000000
	fdiv f2, f2, f1
	fsw f0, -9(sp)
	sw a0, -10(sp)
	fsw f1, -11(sp)
	fmv f0, f2
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, atan
	addi sp, sp, 13
	lw ra, -12(sp)
	flw f1, -3(sp)
	fmul f0, f0, f1
	fsw f0, -12(sp)
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, sin
	addi sp, sp, 15
	lw ra, -14(sp)
	flw f1, -12(sp)
	fsw f0, -13(sp)
	fmv f0, f1
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, cos
	addi sp, sp, 15
	lw ra, -14(sp)
	flw f1, -13(sp)
	fdiv f0, f1, f0
	flw f1, -11(sp)
	fmul f1, f0, f1
	flw f0, -9(sp)
	flw f2, -6(sp)
	flw f3, -3(sp)
	lw a0, -10(sp)
	lw a1, -1(sp)
	lw a2, 0(sp)
	lw cl, -2(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
calc_dirvecs.2936:
	lw a3, 1(cl)
	li a4, 0
	blt a0, a4, ble_else.16144
	itof f1, a0
	fli f2, 0.200000
	fmul f1, f1, f2
	fli f2, 0.900000
	fsub f2, f1, f2
	fli f1, 0.000000
	sw cl, 0(sp)
	fsw f0, -1(sp)
	sw a1, -2(sp)
	sw a3, -3(sp)
	sw a2, -4(sp)
	sw a0, -5(sp)
	add a0, a4, zero
	add cl, a3, zero
	fmv f3, f0
	fmv f0, f1
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	itof f0, a0
	fli f1, 0.200000
	fmul f0, f0, f1
	fli f1, 0.100000
	fadd f2, f0, f1
	lw a1, -4(sp)
	addi a2, a1, 2
	fli f0, 0.000000
	flw f3, -1(sp)
	li a3, 0
	lw a4, -2(sp)
	lw cl, -3(sp)
	add a1, a4, zero
	add a0, a3, zero
	fmv f1, f0
	sw ra, -6(sp)
	lw swp, 0(cl)
	addi sp, sp, -7
	jalr ra, swp, 0
	addi sp, sp, 7
	lw ra, -6(sp)
	lw a0, -5(sp)
	addi a0, a0, -1
	lw a1, -2(sp)
	addi a1, a1, 1
	li a2, 5
	blt a1, a2, ble_else.16145
	addi a1, a1, -5
	jump ble_cont.16146
ble_else.16145:
ble_cont.16146:
	flw f0, -1(sp)
	lw a2, -4(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16144:
	jalr zero, ra, 0
calc_dirvec_rows.2941:
	lw a3, 1(cl)
	li a4, 0
	blt a0, a4, ble_else.16148
	itof f0, a0
	fli f1, 0.200000
	fmul f0, f0, f1
	fli f1, 0.900000
	fsub f0, f0, f1
	li a4, 4
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a1, -2(sp)
	sw a0, -3(sp)
	add a0, a4, zero
	add cl, a3, zero
	sw ra, -4(sp)
	lw swp, 0(cl)
	addi sp, sp, -5
	jalr ra, swp, 0
	addi sp, sp, 5
	lw ra, -4(sp)
	lw a0, -3(sp)
	addi a0, a0, -1
	lw a1, -2(sp)
	addi a1, a1, 2
	li a2, 5
	blt a1, a2, ble_else.16149
	addi a1, a1, -5
	jump ble_cont.16150
ble_else.16149:
ble_cont.16150:
	lw a2, -1(sp)
	addi a2, a2, 4
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16148:
	jalr zero, ra, 0
create_dirvec_elements.2947:
	li a2, 0
	blt a1, a2, ble_else.16152
	li a3, 3
	fli f0, 0.000000
	sw cl, 0(sp)
	sw a3, -1(sp)
	sw a1, -2(sp)
	sw a0, -3(sp)
	add a0, a3, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_float_array
	addi sp, sp, 5
	lw ra, -4(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -4(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_array
	addi sp, sp, 7
	lw ra, -6(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -4(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -2(sp)
	lw a2, -3(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16153
	fli f0, 0.000000
	lw a1, -1(sp)
	sw a0, -5(sp)
	add a0, a1, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_float_array
	addi sp, sp, 7
	lw ra, -6(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -6(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_array
	addi sp, sp, 9
	lw ra, -8(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -6(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -5(sp)
	lw a2, -3(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a1, a1, -1
	lw cl, 0(sp)
	add a0, a2, zero
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16153:
	jalr zero, ra, 0
ble_else.16152:
	jalr zero, ra, 0
create_dirvecs.2950:
	lw a1, 5(cl)
	li a2, 0
	blt a0, a2, ble_else.16156
	li a3, 120
	li a4, 3
	fli f0, 0.000000
	sw cl, 0(sp)
	sw a1, -1(sp)
	sw a0, -2(sp)
	sw a3, -3(sp)
	add a0, a4, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_float_array
	addi sp, sp, 5
	lw ra, -4(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -4(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_array
	addi sp, sp, 7
	lw ra, -6(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -4(sp)
	sw a0, 0(a1)
	lw a0, -3(sp)
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_array
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 16777380
	lw a2, -2(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	li a0, 16777380
	add a22, a0, a2
	lw a0, 0(a22)
	li a1, 3
	fli f0, 0.000000
	sw a0, -5(sp)
	add a0, a1, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_float_array
	addi sp, sp, 7
	lw ra, -6(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -6(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_array
	addi sp, sp, 9
	lw ra, -8(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -6(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -5(sp)
	sw a0, 118(a1)
	li a0, 117
	lw cl, -1(sp)
	add swp, a1, zero
	add a1, a0, zero
	add a0, swp, zero
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a0, -2(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16157
	li a1, 120
	li a2, 3
	fli f0, 0.000000
	sw a0, -7(sp)
	sw a1, -8(sp)
	add a0, a2, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_float_array
	addi sp, sp, 11
	lw ra, -10(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -9(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_array
	addi sp, sp, 11
	lw ra, -10(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -9(sp)
	sw a0, 0(a1)
	lw a0, -8(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_array
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 16777380
	lw a2, -7(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	li a0, 16777380
	add a22, a0, a2
	lw a0, 0(a22)
	li a1, 118
	lw cl, -1(sp)
	sw ra, -10(sp)
	lw swp, 0(cl)
	addi sp, sp, -11
	jalr ra, swp, 0
	addi sp, sp, 11
	lw ra, -10(sp)
	lw a0, -7(sp)
	addi a0, a0, -1
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16157:
	jalr zero, ra, 0
ble_else.16156:
	jalr zero, ra, 0
init_dirvec_constants.2952:
	lw a2, 3(cl)
	li a3, 0
	blt a1, a3, ble_else.16160
	add a22, a1, a0
	lw a4, 0(a22)
	li a5, 16777216
	lw a5, 0(a5)
	addi a5, a5, -1
	sw cl, 0(sp)
	sw a2, -1(sp)
	sw a0, -2(sp)
	sw a1, -3(sp)
	blt a5, a3, ble_else.16161
	li a6, 16777217
	add a22, a6, a5
	lw a6, 0(a22)
	lw a7, 1(a4)
	lw a8, 0(a4)
	lw a9, 1(a6)
	li a10, 1
	sw a4, -4(sp)
	bne a9, a10, be_else.16163
	sw a5, -5(sp)
	sw a7, -6(sp)
	add a1, a6, zero
	add a0, a8, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_rect_table.2725
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16164
be_else.16163:
	li a10, 2
	bne a9, a10, be_else.16165
	sw a5, -5(sp)
	sw a7, -6(sp)
	add a1, a6, zero
	add a0, a8, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_surface_table.2728
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16166
be_else.16165:
	sw a5, -5(sp)
	sw a7, -6(sp)
	add a1, a6, zero
	add a0, a8, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_second_table.2731
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -5(sp)
	lw a2, -6(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16166:
be_cont.16164:
	addi a1, a1, -1
	lw a0, -4(sp)
	lw cl, -1(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	jump ble_cont.16162
ble_else.16161:
ble_cont.16162:
	lw a0, -3(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16167
	lw a2, -2(sp)
	add a22, a0, a2
	lw a3, 0(a22)
	li a4, 16777216
	lw a4, 0(a4)
	addi a4, a4, -1
	sw a0, -7(sp)
	blt a4, a1, ble_else.16168
	li a5, 16777217
	add a22, a5, a4
	lw a5, 0(a22)
	lw a6, 1(a3)
	lw a7, 0(a3)
	lw a8, 1(a5)
	li a9, 1
	sw a3, -8(sp)
	bne a8, a9, be_else.16170
	sw a4, -9(sp)
	sw a6, -10(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_rect_table.2725
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16171
be_else.16170:
	li a9, 2
	bne a8, a9, be_else.16172
	sw a4, -9(sp)
	sw a6, -10(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_surface_table.2728
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16173
be_else.16172:
	sw a4, -9(sp)
	sw a6, -10(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_second_table.2731
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16173:
be_cont.16171:
	addi a1, a1, -1
	lw a0, -8(sp)
	lw cl, -1(sp)
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	jump ble_cont.16169
ble_else.16168:
ble_cont.16169:
	lw a0, -7(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16174
	lw a2, -2(sp)
	add a22, a0, a2
	lw a3, 0(a22)
	li a4, 16777216
	lw a4, 0(a4)
	addi a4, a4, -1
	sw a0, -11(sp)
	blt a4, a1, ble_else.16175
	li a5, 16777217
	add a22, a5, a4
	lw a5, 0(a22)
	lw a6, 1(a3)
	lw a7, 0(a3)
	lw a8, 1(a5)
	li a9, 1
	sw a3, -12(sp)
	bne a8, a9, be_else.16177
	sw a4, -13(sp)
	sw a6, -14(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_rect_table.2725
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -13(sp)
	lw a2, -14(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16178
be_else.16177:
	li a9, 2
	bne a8, a9, be_else.16179
	sw a4, -13(sp)
	sw a6, -14(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_surface_table.2728
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -13(sp)
	lw a2, -14(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16180
be_else.16179:
	sw a4, -13(sp)
	sw a6, -14(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_second_table.2731
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -13(sp)
	lw a2, -14(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16180:
be_cont.16178:
	addi a1, a1, -1
	lw a0, -12(sp)
	lw cl, -1(sp)
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	jump ble_cont.16176
ble_else.16175:
ble_cont.16176:
	lw a0, -11(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16181
	lw a1, -2(sp)
	add a22, a0, a1
	lw a2, 0(a22)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	lw cl, -1(sp)
	sw a0, -15(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a0, -15(sp)
	addi a1, a0, -1
	lw a0, -2(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16181:
	jalr zero, ra, 0
ble_else.16174:
	jalr zero, ra, 0
ble_else.16167:
	jalr zero, ra, 0
ble_else.16160:
	jalr zero, ra, 0
init_vecset_constants.2955:
	lw a1, 10(cl)
	lw a2, 4(cl)
	li a3, 0
	blt a0, a3, ble_else.16186
	li a4, 16777380
	add a22, a4, a0
	lw a4, 0(a22)
	lw a5, 119(a4)
	li a6, 16777216
	lw a6, 0(a6)
	addi a6, a6, -1
	sw cl, 0(sp)
	sw a0, -1(sp)
	sw a1, -2(sp)
	sw a2, -3(sp)
	sw a4, -4(sp)
	blt a6, a3, ble_else.16187
	li a7, 16777217
	add a22, a7, a6
	lw a7, 0(a22)
	lw a8, 1(a5)
	lw a9, 0(a5)
	lw a10, 1(a7)
	li a11, 1
	sw a5, -5(sp)
	bne a10, a11, be_else.16189
	sw a6, -6(sp)
	sw a8, -7(sp)
	add a1, a7, zero
	add a0, a9, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_rect_table.2725
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -6(sp)
	lw a2, -7(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16190
be_else.16189:
	li a11, 2
	bne a10, a11, be_else.16191
	sw a6, -6(sp)
	sw a8, -7(sp)
	add a1, a7, zero
	add a0, a9, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_surface_table.2728
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -6(sp)
	lw a2, -7(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16192
be_else.16191:
	sw a6, -6(sp)
	sw a8, -7(sp)
	add a1, a7, zero
	add a0, a9, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, setup_second_table.2731
	addi sp, sp, 9
	lw ra, -8(sp)
	lw a1, -6(sp)
	lw a2, -7(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16192:
be_cont.16190:
	addi a1, a1, -1
	lw a0, -5(sp)
	lw cl, -3(sp)
	sw ra, -8(sp)
	lw swp, 0(cl)
	addi sp, sp, -9
	jalr ra, swp, 0
	addi sp, sp, 9
	lw ra, -8(sp)
	jump ble_cont.16188
ble_else.16187:
ble_cont.16188:
	lw a0, -4(sp)
	lw a1, 118(a0)
	li a2, 16777216
	lw a2, 0(a2)
	addi a2, a2, -1
	li a3, 0
	blt a2, a3, ble_else.16193
	li a4, 16777217
	add a22, a4, a2
	lw a4, 0(a22)
	lw a5, 1(a1)
	lw a6, 0(a1)
	lw a7, 1(a4)
	li a8, 1
	sw a1, -8(sp)
	bne a7, a8, be_else.16195
	sw a2, -9(sp)
	sw a5, -10(sp)
	add a1, a4, zero
	add a0, a6, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_rect_table.2725
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16196
be_else.16195:
	li a8, 2
	bne a7, a8, be_else.16197
	sw a2, -9(sp)
	sw a5, -10(sp)
	add a1, a4, zero
	add a0, a6, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_surface_table.2728
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16198
be_else.16197:
	sw a2, -9(sp)
	sw a5, -10(sp)
	add a1, a4, zero
	add a0, a6, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_second_table.2731
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16198:
be_cont.16196:
	addi a1, a1, -1
	lw a0, -8(sp)
	lw cl, -3(sp)
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	jump ble_cont.16194
ble_else.16193:
ble_cont.16194:
	lw a0, -4(sp)
	lw a1, 117(a0)
	li a2, 16777216
	lw a2, 0(a2)
	addi a2, a2, -1
	lw cl, -3(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 116
	lw a0, -4(sp)
	lw cl, -2(sp)
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a0, -1(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16199
	li a2, 16777380
	add a22, a2, a0
	lw a2, 0(a22)
	lw a3, 119(a2)
	li a4, 16777216
	lw a4, 0(a4)
	addi a4, a4, -1
	sw a0, -11(sp)
	sw a2, -12(sp)
	blt a4, a1, ble_else.16200
	li a5, 16777217
	add a22, a5, a4
	lw a5, 0(a22)
	lw a6, 1(a3)
	lw a7, 0(a3)
	lw a8, 1(a5)
	li a9, 1
	sw a3, -13(sp)
	bne a8, a9, be_else.16202
	sw a4, -14(sp)
	sw a6, -15(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_rect_table.2725
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -14(sp)
	lw a2, -15(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16203
be_else.16202:
	li a9, 2
	bne a8, a9, be_else.16204
	sw a4, -14(sp)
	sw a6, -15(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_surface_table.2728
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -14(sp)
	lw a2, -15(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16205
be_else.16204:
	sw a4, -14(sp)
	sw a6, -15(sp)
	add a1, a5, zero
	add a0, a7, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, setup_second_table.2731
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a1, -14(sp)
	lw a2, -15(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16205:
be_cont.16203:
	addi a1, a1, -1
	lw a0, -13(sp)
	lw cl, -3(sp)
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	jump ble_cont.16201
ble_else.16200:
ble_cont.16201:
	lw a0, -12(sp)
	lw a1, 118(a0)
	li a2, 16777216
	lw a2, 0(a2)
	addi a2, a2, -1
	lw cl, -3(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	li a1, 117
	lw a0, -12(sp)
	lw cl, -2(sp)
	sw ra, -16(sp)
	lw swp, 0(cl)
	addi sp, sp, -17
	jalr ra, swp, 0
	addi sp, sp, 17
	lw ra, -16(sp)
	lw a0, -11(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16206
	li a2, 16777380
	add a22, a2, a0
	lw a2, 0(a22)
	li a3, 119
	lw a4, 119(a2)
	li a5, 16777216
	lw a5, 0(a5)
	addi a5, a5, -1
	lw cl, -3(sp)
	sw a3, -16(sp)
	sw a0, -17(sp)
	sw a2, -18(sp)
	add a1, a5, zero
	add a0, a4, zero
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	li a1, 118
	lw a0, -18(sp)
	lw cl, -2(sp)
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a0, -17(sp)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16207
	li a1, 16777380
	add a22, a1, a0
	lw a1, 0(a22)
	lw a2, -16(sp)
	lw cl, -2(sp)
	sw a0, -19(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a0, -19(sp)
	addi a0, a0, -1
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
ble_else.16207:
	jalr zero, ra, 0
ble_else.16206:
	jalr zero, ra, 0
ble_else.16199:
	jalr zero, ra, 0
ble_else.16186:
	jalr zero, ra, 0
setup_rect_reflection.2966:
	lw a2, 9(cl)
	slli a0, a0, 2
	li a3, 16777567
	lw a3, 0(a3)
	fli f0, 1.000000
	lw a1, 7(a1)
	flw f1, 0(a1)
	fsub f0, f0, f1
	li a1, 16777283
	flw f1, 0(a1)
	fneg f1, f1
	li a1, 1
	li a4, 16777283
	add a22, a4, a1
	flw f2, 0(a22)
	fneg f2, f2
	li a1, 2
	li a4, 16777283
	add a22, a4, a1
	flw f3, 0(a22)
	fneg f3, f3
	addi a1, a0, 1
	li a4, 16777283
	flw f4, 0(a4)
	li a4, 3
	fli f5, 0.000000
	fsw f1, 0(sp)
	sw a0, -1(sp)
	sw a3, -2(sp)
	sw a1, -3(sp)
	fsw f0, -4(sp)
	sw a2, -5(sp)
	fsw f3, -6(sp)
	fsw f2, -7(sp)
	fsw f4, -8(sp)
	add a0, a4, zero
	fmv f0, f5
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_float_array
	addi sp, sp, 11
	lw ra, -10(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -9(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_array
	addi sp, sp, 11
	lw ra, -10(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a2, -9(sp)
	sw a2, 0(a1)
	flw f0, -8(sp)
	fsw f0, 0(a2)
	flw f0, -7(sp)
	fsw f0, 1(a2)
	flw f1, -6(sp)
	fsw f1, 2(a2)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	li a4, 0
	sw a1, -10(sp)
	blt a3, a4, ble_else.16212
	li a5, 16777217
	add a22, a5, a3
	lw a5, 0(a22)
	lw a6, 1(a5)
	li a7, 1
	bne a6, a7, be_else.16214
	sw a3, -11(sp)
	sw a0, -12(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, setup_rect_table.2725
	addi sp, sp, 15
	lw ra, -14(sp)
	lw a1, -11(sp)
	lw a2, -12(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16215
be_else.16214:
	li a7, 2
	bne a6, a7, be_else.16216
	sw a3, -11(sp)
	sw a0, -12(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, setup_surface_table.2728
	addi sp, sp, 15
	lw ra, -14(sp)
	lw a1, -11(sp)
	lw a2, -12(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16217
be_else.16216:
	sw a3, -11(sp)
	sw a0, -12(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, setup_second_table.2731
	addi sp, sp, 15
	lw ra, -14(sp)
	lw a1, -11(sp)
	lw a2, -12(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16217:
be_cont.16215:
	addi a1, a1, -1
	lw a0, -10(sp)
	lw cl, -5(sp)
	sw ra, -14(sp)
	lw swp, 0(cl)
	addi sp, sp, -15
	jalr ra, swp, 0
	addi sp, sp, 15
	lw ra, -14(sp)
	jump ble_cont.16213
ble_else.16212:
ble_cont.16213:
	add a0, hp, zero
	addi hp, hp, 6
	flw f0, -4(sp)
	fsw f0, 2(a0)
	lw a1, -10(sp)
	sw a1, 1(a0)
	lw a1, -3(sp)
	sw a1, 0(a0)
	li a1, 16777387
	lw a2, -2(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a2, 1
	lw a1, -1(sp)
	addi a3, a1, 2
	li a4, 1
	li a5, 16777283
	add a22, a5, a4
	flw f1, 0(a22)
	li a4, 3
	fli f2, 0.000000
	sw a0, -13(sp)
	sw a3, -14(sp)
	fsw f1, -15(sp)
	add a0, a4, zero
	fmv f0, f2
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, create_float_array
	addi sp, sp, 17
	lw ra, -16(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -16(sp)
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_array
	addi sp, sp, 19
	lw ra, -18(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a2, -16(sp)
	sw a2, 0(a1)
	flw f0, 0(sp)
	fsw f0, 0(a2)
	flw f1, -15(sp)
	fsw f1, 1(a2)
	flw f1, -6(sp)
	fsw f1, 2(a2)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	li a4, 0
	sw a1, -17(sp)
	blt a3, a4, ble_else.16218
	li a5, 16777217
	add a22, a5, a3
	lw a5, 0(a22)
	lw a6, 1(a5)
	li a7, 1
	bne a6, a7, be_else.16220
	sw a3, -18(sp)
	sw a0, -19(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, setup_rect_table.2725
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a1, -18(sp)
	lw a2, -19(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16221
be_else.16220:
	li a7, 2
	bne a6, a7, be_else.16222
	sw a3, -18(sp)
	sw a0, -19(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, setup_surface_table.2728
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a1, -18(sp)
	lw a2, -19(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16223
be_else.16222:
	sw a3, -18(sp)
	sw a0, -19(sp)
	add a1, a5, zero
	add a0, a2, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, setup_second_table.2731
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a1, -18(sp)
	lw a2, -19(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16223:
be_cont.16221:
	addi a1, a1, -1
	lw a0, -17(sp)
	lw cl, -5(sp)
	sw ra, -20(sp)
	lw swp, 0(cl)
	addi sp, sp, -21
	jalr ra, swp, 0
	addi sp, sp, 21
	lw ra, -20(sp)
	jump ble_cont.16219
ble_else.16218:
ble_cont.16219:
	add a0, hp, zero
	addi hp, hp, 6
	flw f0, -4(sp)
	fsw f0, 2(a0)
	lw a1, -17(sp)
	sw a1, 1(a0)
	lw a1, -14(sp)
	sw a1, 0(a0)
	li a1, 16777387
	lw a2, -13(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	lw a0, -2(sp)
	addi a1, a0, 2
	lw a2, -1(sp)
	addi a2, a2, 3
	li a3, 2
	li a4, 16777283
	add a22, a4, a3
	flw f1, 0(a22)
	li a3, 3
	fli f2, 0.000000
	sw a1, -20(sp)
	sw a2, -21(sp)
	fsw f1, -22(sp)
	add a0, a3, zero
	fmv f0, f2
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_float_array
	addi sp, sp, 25
	lw ra, -24(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -23(sp)
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_array
	addi sp, sp, 25
	lw ra, -24(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a2, -23(sp)
	sw a2, 0(a1)
	flw f0, 0(sp)
	fsw f0, 0(a2)
	flw f0, -7(sp)
	fsw f0, 1(a2)
	flw f0, -22(sp)
	fsw f0, 2(a2)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	li a4, 0
	sw a1, -24(sp)
	blt a3, a4, ble_else.16224
	li a4, 16777217
	add a22, a4, a3
	lw a4, 0(a22)
	lw a5, 1(a4)
	li a6, 1
	bne a5, a6, be_else.16226
	sw a3, -25(sp)
	sw a0, -26(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, setup_rect_table.2725
	addi sp, sp, 29
	lw ra, -28(sp)
	lw a1, -25(sp)
	lw a2, -26(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16227
be_else.16226:
	li a6, 2
	bne a5, a6, be_else.16228
	sw a3, -25(sp)
	sw a0, -26(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, setup_surface_table.2728
	addi sp, sp, 29
	lw ra, -28(sp)
	lw a1, -25(sp)
	lw a2, -26(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16229
be_else.16228:
	sw a3, -25(sp)
	sw a0, -26(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, setup_second_table.2731
	addi sp, sp, 29
	lw ra, -28(sp)
	lw a1, -25(sp)
	lw a2, -26(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16229:
be_cont.16227:
	addi a1, a1, -1
	lw a0, -24(sp)
	lw cl, -5(sp)
	sw ra, -28(sp)
	lw swp, 0(cl)
	addi sp, sp, -29
	jalr ra, swp, 0
	addi sp, sp, 29
	lw ra, -28(sp)
	jump ble_cont.16225
ble_else.16224:
ble_cont.16225:
	add a0, hp, zero
	addi hp, hp, 6
	flw f0, -4(sp)
	fsw f0, 2(a0)
	lw a1, -24(sp)
	sw a1, 1(a0)
	lw a1, -21(sp)
	sw a1, 0(a0)
	li a1, 16777387
	lw a2, -20(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	lw a0, -2(sp)
	addi a0, a0, 3
	li a1, 16777567
	sw a0, 0(a1)
	jalr zero, ra, 0
setup_surface_reflection.2969:
	lw a2, 11(cl)
	slli a0, a0, 2
	addi a0, a0, 1
	li a3, 16777567
	lw a3, 0(a3)
	fli f0, 1.000000
	lw a4, 7(a1)
	flw f1, 0(a4)
	fsub f0, f0, f1
	lw a4, 4(a1)
	li a5, 16777283
	flw f1, 0(a5)
	flw f2, 0(a4)
	fmul f1, f1, f2
	li a5, 1
	li a6, 16777283
	add a22, a6, a5
	flw f2, 0(a22)
	flw f3, 1(a4)
	fmul f2, f2, f3
	fadd f1, f1, f2
	li a5, 2
	li a6, 16777283
	add a22, a6, a5
	flw f2, 0(a22)
	flw f3, 2(a4)
	fmul f2, f2, f3
	fadd f1, f1, f2
	fli f2, 2.000000
	lw a4, 4(a1)
	flw f3, 0(a4)
	fmul f2, f2, f3
	fmul f2, f2, f1
	li a4, 16777283
	flw f3, 0(a4)
	fsub f2, f2, f3
	fli f3, 2.000000
	lw a4, 4(a1)
	flw f4, 1(a4)
	fmul f3, f3, f4
	fmul f3, f3, f1
	li a4, 1
	li a5, 16777283
	add a22, a5, a4
	flw f4, 0(a22)
	fsub f3, f3, f4
	fli f4, 2.000000
	lw a1, 4(a1)
	flw f5, 2(a1)
	fmul f4, f4, f5
	fmul f1, f4, f1
	li a1, 2
	li a4, 16777283
	add a22, a4, a1
	flw f4, 0(a22)
	fsub f1, f1, f4
	li a1, 3
	fli f4, 0.000000
	sw a3, 0(sp)
	sw a0, -1(sp)
	fsw f0, -2(sp)
	sw a2, -3(sp)
	fsw f1, -4(sp)
	fsw f3, -5(sp)
	fsw f2, -6(sp)
	add a0, a1, zero
	fmv f0, f4
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_float_array
	addi sp, sp, 9
	lw ra, -8(sp)
	add a1, a0, zero
	li a0, 16777216
	lw a0, 0(a0)
	sw a1, -7(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_array
	addi sp, sp, 9
	lw ra, -8(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a2, -7(sp)
	sw a2, 0(a1)
	flw f0, -6(sp)
	fsw f0, 0(a2)
	flw f0, -5(sp)
	fsw f0, 1(a2)
	flw f0, -4(sp)
	fsw f0, 2(a2)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	li a4, 0
	sw a1, -8(sp)
	blt a3, a4, ble_else.16231
	li a4, 16777217
	add a22, a4, a3
	lw a4, 0(a22)
	lw a5, 1(a4)
	li a6, 1
	bne a5, a6, be_else.16233
	sw a3, -9(sp)
	sw a0, -10(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_rect_table.2725
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16234
be_else.16233:
	li a6, 2
	bne a5, a6, be_else.16235
	sw a3, -9(sp)
	sw a0, -10(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_surface_table.2728
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16236
be_else.16235:
	sw a3, -9(sp)
	sw a0, -10(sp)
	add a1, a4, zero
	add a0, a2, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, setup_second_table.2731
	addi sp, sp, 13
	lw ra, -12(sp)
	lw a1, -9(sp)
	lw a2, -10(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16236:
be_cont.16234:
	addi a1, a1, -1
	lw a0, -8(sp)
	lw cl, -3(sp)
	sw ra, -12(sp)
	lw swp, 0(cl)
	addi sp, sp, -13
	jalr ra, swp, 0
	addi sp, sp, 13
	lw ra, -12(sp)
	jump ble_cont.16232
ble_else.16231:
ble_cont.16232:
	add a0, hp, zero
	addi hp, hp, 6
	flw f0, -2(sp)
	fsw f0, 2(a0)
	lw a1, -8(sp)
	sw a1, 1(a0)
	lw a1, -1(sp)
	sw a1, 0(a0)
	li a1, 16777387
	lw a2, 0(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a2, 1
	li a1, 16777567
	sw a0, 0(a1)
	jalr zero, ra, 0
rt.2974:
	lw a2, 41(cl)
	lw a3, 40(cl)
	lw a4, 39(cl)
	lw a5, 38(cl)
	lw a6, 35(cl)
	lw a7, 28(cl)
	lw a8, 25(cl)
	lw a9, 24(cl)
	lw a10, 21(cl)
	lw a11, 20(cl)
	lw a12, 19(cl)
	lw a13, 17(cl)
	lw a14, 16(cl)
	lw a15, 14(cl)
	lw a16, 13(cl)
	lw a17, 12(cl)
	li a18, 16777357
	sw a0, 0(a18)
	li a18, 1
	li a19, 16777357
	add a22, a19, a18
	sw a1, 0(a22)
	srli a18, a0, 1
	li a19, 16777359
	sw a18, 0(a19)
	li a18, 1
	srli a1, a1, 1
	li a19, 16777359
	add a22, a19, a18
	sw a1, 0(a22)
	fli f0, 128.000000
	itof f1, a0
	fdiv f0, f0, f1
	li a0, 16777361
	fsw f0, 0(a0)
	li a0, 16777357
	lw a0, 0(a0)
	li a1, 3
	fli f0, 0.000000
	sw a2, 0(sp)
	sw a3, -1(sp)
	sw a4, -2(sp)
	sw a5, -3(sp)
	sw a6, -4(sp)
	sw a7, -5(sp)
	sw a8, -6(sp)
	sw a9, -7(sp)
	sw a10, -8(sp)
	sw a11, -9(sp)
	sw a12, -10(sp)
	sw a13, -11(sp)
	sw a14, -12(sp)
	sw a15, -13(sp)
	sw a16, -14(sp)
	sw a17, -15(sp)
	sw a0, -16(sp)
	add a0, a1, zero
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_float_array
	addi sp, sp, 19
	lw ra, -18(sp)
	sw a0, -17(sp)
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_float5x3array.2914
	addi sp, sp, 19
	lw ra, -18(sp)
	li a1, 5
	li a2, 0
	sw a0, -18(sp)
	sw a1, -19(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, create_array
	addi sp, sp, 21
	lw ra, -20(sp)
	lw a1, -19(sp)
	li a2, 0
	sw a0, -20(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -22(sp)
	addi sp, sp, -23
	jal ra, create_array
	addi sp, sp, 23
	lw ra, -22(sp)
	sw a0, -21(sp)
	sw ra, -22(sp)
	addi sp, sp, -23
	jal ra, create_float5x3array.2914
	addi sp, sp, 23
	lw ra, -22(sp)
	sw a0, -22(sp)
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_float5x3array.2914
	addi sp, sp, 25
	lw ra, -24(sp)
	li a1, 1
	li a2, 0
	sw a0, -23(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_array
	addi sp, sp, 25
	lw ra, -24(sp)
	sw a0, -24(sp)
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_float5x3array.2914
	addi sp, sp, 27
	lw ra, -26(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -24(sp)
	sw a0, 6(a1)
	lw a0, -23(sp)
	sw a0, 5(a1)
	lw a0, -22(sp)
	sw a0, 4(a1)
	lw a0, -21(sp)
	sw a0, 3(a1)
	lw a0, -20(sp)
	sw a0, 2(a1)
	lw a0, -18(sp)
	sw a0, 1(a1)
	lw a0, -17(sp)
	sw a0, 0(a1)
	lw a0, -16(sp)
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_array
	addi sp, sp, 27
	lw ra, -26(sp)
	li a1, 16777357
	lw a1, 0(a1)
	addi a1, a1, -2
	li a2, 0
	blt a1, a2, ble_else.16238
	li a3, 3
	fli f0, 0.000000
	sw a1, -25(sp)
	sw a0, -26(sp)
	add a0, a3, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_float_array
	addi sp, sp, 29
	lw ra, -28(sp)
	sw a0, -27(sp)
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_float5x3array.2914
	addi sp, sp, 29
	lw ra, -28(sp)
	li a1, 5
	li a2, 0
	sw a0, -28(sp)
	sw a1, -29(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_array
	addi sp, sp, 31
	lw ra, -30(sp)
	lw a1, -29(sp)
	li a2, 0
	sw a0, -30(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -32(sp)
	addi sp, sp, -33
	jal ra, create_array
	addi sp, sp, 33
	lw ra, -32(sp)
	sw a0, -31(sp)
	sw ra, -32(sp)
	addi sp, sp, -33
	jal ra, create_float5x3array.2914
	addi sp, sp, 33
	lw ra, -32(sp)
	sw a0, -32(sp)
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_float5x3array.2914
	addi sp, sp, 35
	lw ra, -34(sp)
	li a1, 1
	li a2, 0
	sw a0, -33(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_array
	addi sp, sp, 35
	lw ra, -34(sp)
	sw a0, -34(sp)
	sw ra, -36(sp)
	addi sp, sp, -37
	jal ra, create_float5x3array.2914
	addi sp, sp, 37
	lw ra, -36(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -34(sp)
	sw a0, 6(a1)
	lw a0, -33(sp)
	sw a0, 5(a1)
	lw a0, -32(sp)
	sw a0, 4(a1)
	lw a0, -31(sp)
	sw a0, 3(a1)
	lw a0, -30(sp)
	sw a0, 2(a1)
	lw a0, -28(sp)
	sw a0, 1(a1)
	lw a0, -27(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -25(sp)
	lw a2, -26(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16240
	li a3, 3
	fli f0, 0.000000
	sw a0, -35(sp)
	add a0, a3, zero
	sw ra, -36(sp)
	addi sp, sp, -37
	jal ra, create_float_array
	addi sp, sp, 37
	lw ra, -36(sp)
	sw a0, -36(sp)
	sw ra, -38(sp)
	addi sp, sp, -39
	jal ra, create_float5x3array.2914
	addi sp, sp, 39
	lw ra, -38(sp)
	li a1, 5
	li a2, 0
	sw a0, -37(sp)
	sw a1, -38(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -40(sp)
	addi sp, sp, -41
	jal ra, create_array
	addi sp, sp, 41
	lw ra, -40(sp)
	lw a1, -38(sp)
	li a2, 0
	sw a0, -39(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -40(sp)
	addi sp, sp, -41
	jal ra, create_array
	addi sp, sp, 41
	lw ra, -40(sp)
	sw a0, -40(sp)
	sw ra, -42(sp)
	addi sp, sp, -43
	jal ra, create_float5x3array.2914
	addi sp, sp, 43
	lw ra, -42(sp)
	sw a0, -41(sp)
	sw ra, -42(sp)
	addi sp, sp, -43
	jal ra, create_float5x3array.2914
	addi sp, sp, 43
	lw ra, -42(sp)
	li a1, 1
	li a2, 0
	sw a0, -42(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -44(sp)
	addi sp, sp, -45
	jal ra, create_array
	addi sp, sp, 45
	lw ra, -44(sp)
	sw a0, -43(sp)
	sw ra, -44(sp)
	addi sp, sp, -45
	jal ra, create_float5x3array.2914
	addi sp, sp, 45
	lw ra, -44(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -43(sp)
	sw a0, 6(a1)
	lw a0, -42(sp)
	sw a0, 5(a1)
	lw a0, -41(sp)
	sw a0, 4(a1)
	lw a0, -40(sp)
	sw a0, 3(a1)
	lw a0, -39(sp)
	sw a0, 2(a1)
	lw a0, -37(sp)
	sw a0, 1(a1)
	lw a0, -36(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -35(sp)
	lw a2, -26(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a1, a1, -1
	add a0, a2, zero
	sw ra, -44(sp)
	addi sp, sp, -45
	jal ra, init_line_elements.2918
	addi sp, sp, 45
	lw ra, -44(sp)
	jump ble_cont.16241
ble_else.16240:
	add a0, a2, zero
ble_cont.16241:
	jump ble_cont.16239
ble_else.16238:
ble_cont.16239:
	li a1, 16777357
	lw a1, 0(a1)
	li a2, 3
	fli f0, 0.000000
	sw a0, -44(sp)
	sw a1, -45(sp)
	add a0, a2, zero
	sw ra, -46(sp)
	addi sp, sp, -47
	jal ra, create_float_array
	addi sp, sp, 47
	lw ra, -46(sp)
	sw a0, -46(sp)
	sw ra, -48(sp)
	addi sp, sp, -49
	jal ra, create_float5x3array.2914
	addi sp, sp, 49
	lw ra, -48(sp)
	li a1, 5
	li a2, 0
	sw a0, -47(sp)
	sw a1, -48(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -50(sp)
	addi sp, sp, -51
	jal ra, create_array
	addi sp, sp, 51
	lw ra, -50(sp)
	lw a1, -48(sp)
	li a2, 0
	sw a0, -49(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -50(sp)
	addi sp, sp, -51
	jal ra, create_array
	addi sp, sp, 51
	lw ra, -50(sp)
	sw a0, -50(sp)
	sw ra, -52(sp)
	addi sp, sp, -53
	jal ra, create_float5x3array.2914
	addi sp, sp, 53
	lw ra, -52(sp)
	sw a0, -51(sp)
	sw ra, -52(sp)
	addi sp, sp, -53
	jal ra, create_float5x3array.2914
	addi sp, sp, 53
	lw ra, -52(sp)
	li a1, 1
	li a2, 0
	sw a0, -52(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -54(sp)
	addi sp, sp, -55
	jal ra, create_array
	addi sp, sp, 55
	lw ra, -54(sp)
	sw a0, -53(sp)
	sw ra, -54(sp)
	addi sp, sp, -55
	jal ra, create_float5x3array.2914
	addi sp, sp, 55
	lw ra, -54(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -53(sp)
	sw a0, 6(a1)
	lw a0, -52(sp)
	sw a0, 5(a1)
	lw a0, -51(sp)
	sw a0, 4(a1)
	lw a0, -50(sp)
	sw a0, 3(a1)
	lw a0, -49(sp)
	sw a0, 2(a1)
	lw a0, -47(sp)
	sw a0, 1(a1)
	lw a0, -46(sp)
	sw a0, 0(a1)
	lw a0, -45(sp)
	sw ra, -54(sp)
	addi sp, sp, -55
	jal ra, create_array
	addi sp, sp, 55
	lw ra, -54(sp)
	li a1, 16777357
	lw a1, 0(a1)
	addi a1, a1, -2
	li a2, 0
	blt a1, a2, ble_else.16242
	li a3, 3
	fli f0, 0.000000
	sw a1, -54(sp)
	sw a0, -55(sp)
	add a0, a3, zero
	sw ra, -56(sp)
	addi sp, sp, -57
	jal ra, create_float_array
	addi sp, sp, 57
	lw ra, -56(sp)
	sw a0, -56(sp)
	sw ra, -58(sp)
	addi sp, sp, -59
	jal ra, create_float5x3array.2914
	addi sp, sp, 59
	lw ra, -58(sp)
	li a1, 5
	li a2, 0
	sw a0, -57(sp)
	sw a1, -58(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -60(sp)
	addi sp, sp, -61
	jal ra, create_array
	addi sp, sp, 61
	lw ra, -60(sp)
	lw a1, -58(sp)
	li a2, 0
	sw a0, -59(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -60(sp)
	addi sp, sp, -61
	jal ra, create_array
	addi sp, sp, 61
	lw ra, -60(sp)
	sw a0, -60(sp)
	sw ra, -62(sp)
	addi sp, sp, -63
	jal ra, create_float5x3array.2914
	addi sp, sp, 63
	lw ra, -62(sp)
	sw a0, -61(sp)
	sw ra, -62(sp)
	addi sp, sp, -63
	jal ra, create_float5x3array.2914
	addi sp, sp, 63
	lw ra, -62(sp)
	li a1, 1
	li a2, 0
	sw a0, -62(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -64(sp)
	addi sp, sp, -65
	jal ra, create_array
	addi sp, sp, 65
	lw ra, -64(sp)
	sw a0, -63(sp)
	sw ra, -64(sp)
	addi sp, sp, -65
	jal ra, create_float5x3array.2914
	addi sp, sp, 65
	lw ra, -64(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -63(sp)
	sw a0, 6(a1)
	lw a0, -62(sp)
	sw a0, 5(a1)
	lw a0, -61(sp)
	sw a0, 4(a1)
	lw a0, -60(sp)
	sw a0, 3(a1)
	lw a0, -59(sp)
	sw a0, 2(a1)
	lw a0, -57(sp)
	sw a0, 1(a1)
	lw a0, -56(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -54(sp)
	lw a2, -55(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16244
	li a3, 3
	fli f0, 0.000000
	sw a0, -64(sp)
	add a0, a3, zero
	sw ra, -66(sp)
	addi sp, sp, -67
	jal ra, create_float_array
	addi sp, sp, 67
	lw ra, -66(sp)
	sw a0, -65(sp)
	sw ra, -66(sp)
	addi sp, sp, -67
	jal ra, create_float5x3array.2914
	addi sp, sp, 67
	lw ra, -66(sp)
	li a1, 5
	li a2, 0
	sw a0, -66(sp)
	sw a1, -67(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -68(sp)
	addi sp, sp, -69
	jal ra, create_array
	addi sp, sp, 69
	lw ra, -68(sp)
	lw a1, -67(sp)
	li a2, 0
	sw a0, -68(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -70(sp)
	addi sp, sp, -71
	jal ra, create_array
	addi sp, sp, 71
	lw ra, -70(sp)
	sw a0, -69(sp)
	sw ra, -70(sp)
	addi sp, sp, -71
	jal ra, create_float5x3array.2914
	addi sp, sp, 71
	lw ra, -70(sp)
	sw a0, -70(sp)
	sw ra, -72(sp)
	addi sp, sp, -73
	jal ra, create_float5x3array.2914
	addi sp, sp, 73
	lw ra, -72(sp)
	li a1, 1
	li a2, 0
	sw a0, -71(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -72(sp)
	addi sp, sp, -73
	jal ra, create_array
	addi sp, sp, 73
	lw ra, -72(sp)
	sw a0, -72(sp)
	sw ra, -74(sp)
	addi sp, sp, -75
	jal ra, create_float5x3array.2914
	addi sp, sp, 75
	lw ra, -74(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -72(sp)
	sw a0, 6(a1)
	lw a0, -71(sp)
	sw a0, 5(a1)
	lw a0, -70(sp)
	sw a0, 4(a1)
	lw a0, -69(sp)
	sw a0, 3(a1)
	lw a0, -68(sp)
	sw a0, 2(a1)
	lw a0, -66(sp)
	sw a0, 1(a1)
	lw a0, -65(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -64(sp)
	lw a2, -55(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a1, a1, -1
	add a0, a2, zero
	sw ra, -74(sp)
	addi sp, sp, -75
	jal ra, init_line_elements.2918
	addi sp, sp, 75
	lw ra, -74(sp)
	jump ble_cont.16245
ble_else.16244:
	add a0, a2, zero
ble_cont.16245:
	jump ble_cont.16243
ble_else.16242:
ble_cont.16243:
	li a1, 16777357
	lw a1, 0(a1)
	li a2, 3
	fli f0, 0.000000
	sw a0, -73(sp)
	sw a1, -74(sp)
	add a0, a2, zero
	sw ra, -76(sp)
	addi sp, sp, -77
	jal ra, create_float_array
	addi sp, sp, 77
	lw ra, -76(sp)
	sw a0, -75(sp)
	sw ra, -76(sp)
	addi sp, sp, -77
	jal ra, create_float5x3array.2914
	addi sp, sp, 77
	lw ra, -76(sp)
	li a1, 5
	li a2, 0
	sw a0, -76(sp)
	sw a1, -77(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -78(sp)
	addi sp, sp, -79
	jal ra, create_array
	addi sp, sp, 79
	lw ra, -78(sp)
	lw a1, -77(sp)
	li a2, 0
	sw a0, -78(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -80(sp)
	addi sp, sp, -81
	jal ra, create_array
	addi sp, sp, 81
	lw ra, -80(sp)
	sw a0, -79(sp)
	sw ra, -80(sp)
	addi sp, sp, -81
	jal ra, create_float5x3array.2914
	addi sp, sp, 81
	lw ra, -80(sp)
	sw a0, -80(sp)
	sw ra, -82(sp)
	addi sp, sp, -83
	jal ra, create_float5x3array.2914
	addi sp, sp, 83
	lw ra, -82(sp)
	li a1, 1
	li a2, 0
	sw a0, -81(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -82(sp)
	addi sp, sp, -83
	jal ra, create_array
	addi sp, sp, 83
	lw ra, -82(sp)
	sw a0, -82(sp)
	sw ra, -84(sp)
	addi sp, sp, -85
	jal ra, create_float5x3array.2914
	addi sp, sp, 85
	lw ra, -84(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -82(sp)
	sw a0, 6(a1)
	lw a0, -81(sp)
	sw a0, 5(a1)
	lw a0, -80(sp)
	sw a0, 4(a1)
	lw a0, -79(sp)
	sw a0, 3(a1)
	lw a0, -78(sp)
	sw a0, 2(a1)
	lw a0, -76(sp)
	sw a0, 1(a1)
	lw a0, -75(sp)
	sw a0, 0(a1)
	lw a0, -74(sp)
	sw ra, -84(sp)
	addi sp, sp, -85
	jal ra, create_array
	addi sp, sp, 85
	lw ra, -84(sp)
	li a1, 16777357
	lw a1, 0(a1)
	addi a1, a1, -2
	li a2, 0
	blt a1, a2, ble_else.16246
	li a3, 3
	fli f0, 0.000000
	sw a1, -83(sp)
	sw a0, -84(sp)
	add a0, a3, zero
	sw ra, -86(sp)
	addi sp, sp, -87
	jal ra, create_float_array
	addi sp, sp, 87
	lw ra, -86(sp)
	sw a0, -85(sp)
	sw ra, -86(sp)
	addi sp, sp, -87
	jal ra, create_float5x3array.2914
	addi sp, sp, 87
	lw ra, -86(sp)
	li a1, 5
	li a2, 0
	sw a0, -86(sp)
	sw a1, -87(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -88(sp)
	addi sp, sp, -89
	jal ra, create_array
	addi sp, sp, 89
	lw ra, -88(sp)
	lw a1, -87(sp)
	li a2, 0
	sw a0, -88(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -90(sp)
	addi sp, sp, -91
	jal ra, create_array
	addi sp, sp, 91
	lw ra, -90(sp)
	sw a0, -89(sp)
	sw ra, -90(sp)
	addi sp, sp, -91
	jal ra, create_float5x3array.2914
	addi sp, sp, 91
	lw ra, -90(sp)
	sw a0, -90(sp)
	sw ra, -92(sp)
	addi sp, sp, -93
	jal ra, create_float5x3array.2914
	addi sp, sp, 93
	lw ra, -92(sp)
	li a1, 1
	li a2, 0
	sw a0, -91(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -92(sp)
	addi sp, sp, -93
	jal ra, create_array
	addi sp, sp, 93
	lw ra, -92(sp)
	sw a0, -92(sp)
	sw ra, -94(sp)
	addi sp, sp, -95
	jal ra, create_float5x3array.2914
	addi sp, sp, 95
	lw ra, -94(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -92(sp)
	sw a0, 6(a1)
	lw a0, -91(sp)
	sw a0, 5(a1)
	lw a0, -90(sp)
	sw a0, 4(a1)
	lw a0, -89(sp)
	sw a0, 3(a1)
	lw a0, -88(sp)
	sw a0, 2(a1)
	lw a0, -86(sp)
	sw a0, 1(a1)
	lw a0, -85(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -83(sp)
	lw a2, -84(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a0, a1, -1
	li a1, 0
	blt a0, a1, ble_else.16248
	li a3, 3
	fli f0, 0.000000
	sw a0, -93(sp)
	add a0, a3, zero
	sw ra, -94(sp)
	addi sp, sp, -95
	jal ra, create_float_array
	addi sp, sp, 95
	lw ra, -94(sp)
	sw a0, -94(sp)
	sw ra, -96(sp)
	addi sp, sp, -97
	jal ra, create_float5x3array.2914
	addi sp, sp, 97
	lw ra, -96(sp)
	li a1, 5
	li a2, 0
	sw a0, -95(sp)
	sw a1, -96(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -98(sp)
	addi sp, sp, -99
	jal ra, create_array
	addi sp, sp, 99
	lw ra, -98(sp)
	lw a1, -96(sp)
	li a2, 0
	sw a0, -97(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -98(sp)
	addi sp, sp, -99
	jal ra, create_array
	addi sp, sp, 99
	lw ra, -98(sp)
	sw a0, -98(sp)
	sw ra, -100(sp)
	addi sp, sp, -101
	jal ra, create_float5x3array.2914
	addi sp, sp, 101
	lw ra, -100(sp)
	sw a0, -99(sp)
	sw ra, -100(sp)
	addi sp, sp, -101
	jal ra, create_float5x3array.2914
	addi sp, sp, 101
	lw ra, -100(sp)
	li a1, 1
	li a2, 0
	sw a0, -100(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -102(sp)
	addi sp, sp, -103
	jal ra, create_array
	addi sp, sp, 103
	lw ra, -102(sp)
	sw a0, -101(sp)
	sw ra, -102(sp)
	addi sp, sp, -103
	jal ra, create_float5x3array.2914
	addi sp, sp, 103
	lw ra, -102(sp)
	add a1, hp, zero
	addi hp, hp, 8
	sw a0, 7(a1)
	lw a0, -101(sp)
	sw a0, 6(a1)
	lw a0, -100(sp)
	sw a0, 5(a1)
	lw a0, -99(sp)
	sw a0, 4(a1)
	lw a0, -98(sp)
	sw a0, 3(a1)
	lw a0, -97(sp)
	sw a0, 2(a1)
	lw a0, -95(sp)
	sw a0, 1(a1)
	lw a0, -94(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	lw a1, -93(sp)
	lw a2, -84(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	addi a1, a1, -1
	add a0, a2, zero
	sw ra, -102(sp)
	addi sp, sp, -103
	jal ra, init_line_elements.2918
	addi sp, sp, 103
	lw ra, -102(sp)
	jump ble_cont.16249
ble_else.16248:
	add a0, a2, zero
ble_cont.16249:
	jump ble_cont.16247
ble_else.16246:
ble_cont.16247:
	lw cl, -15(sp)
	sw a0, -102(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	lw cl, -14(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a0, 0
	lw cl, -13(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a1, 0
	bne a0, a1, be_else.16250
	li a0, 16777216
	sw a1, 0(a0)
	jump be_cont.16251
be_else.16250:
	li a0, 1
	lw cl, -12(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
be_cont.16251:
	li a0, 0
	lw cl, -11(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a0, 0
	sw ra, -104(sp)
	addi sp, sp, -105
	jal ra, read_or_network.2635
	addi sp, sp, 105
	lw ra, -104(sp)
	li a1, 16777337
	sw a0, 0(a1)
	lw cl, -10(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a0, 4
	lw cl, -9(sp)
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a0, 9
	li a1, 0
	lw cl, -8(sp)
	add a2, a1, zero
	sw ra, -104(sp)
	lw swp, 0(cl)
	addi sp, sp, -105
	jalr ra, swp, 0
	addi sp, sp, 105
	lw ra, -104(sp)
	li a0, 4
	li a1, 16777380
	add a22, a1, a0
	lw a0, 0(a22)
	li a1, 119
	lw a2, 119(a0)
	li a3, 16777216
	lw a3, 0(a3)
	addi a3, a3, -1
	lw cl, -7(sp)
	sw a1, -103(sp)
	sw a0, -104(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -106(sp)
	lw swp, 0(cl)
	addi sp, sp, -107
	jalr ra, swp, 0
	addi sp, sp, 107
	lw ra, -106(sp)
	li a1, 118
	lw a0, -104(sp)
	lw cl, -6(sp)
	sw ra, -106(sp)
	lw swp, 0(cl)
	addi sp, sp, -107
	jalr ra, swp, 0
	addi sp, sp, 107
	lw ra, -106(sp)
	li a0, 3
	li a1, 16777380
	add a22, a1, a0
	lw a0, 0(a22)
	lw a1, -103(sp)
	lw cl, -6(sp)
	sw ra, -106(sp)
	lw swp, 0(cl)
	addi sp, sp, -107
	jalr ra, swp, 0
	addi sp, sp, 107
	lw ra, -106(sp)
	li a0, 2
	lw cl, -5(sp)
	sw ra, -106(sp)
	lw swp, 0(cl)
	addi sp, sp, -107
	jalr ra, swp, 0
	addi sp, sp, 107
	lw ra, -106(sp)
	li a0, 16777385
	lw a0, 0(a0)
	li a1, 16777283
	flw f0, 0(a1)
	fsw f0, 0(a0)
	li a1, 1
	li a2, 16777283
	add a22, a2, a1
	flw f0, 0(a22)
	fsw f0, 1(a0)
	li a1, 2
	li a2, 16777283
	add a22, a2, a1
	flw f0, 0(a22)
	fsw f0, 2(a0)
	li a0, 16777216
	lw a0, 0(a0)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16252
	li a2, 16777217
	add a22, a2, a0
	lw a2, 0(a22)
	li a3, 16777385
	lw a3, 1(a3)
	li a4, 16777385
	lw a4, 0(a4)
	lw a5, 1(a2)
	li a6, 1
	bne a5, a6, be_else.16254
	sw a0, -105(sp)
	sw a3, -106(sp)
	add a1, a2, zero
	add a0, a4, zero
	sw ra, -108(sp)
	addi sp, sp, -109
	jal ra, setup_rect_table.2725
	addi sp, sp, 109
	lw ra, -108(sp)
	lw a1, -105(sp)
	lw a2, -106(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16255
be_else.16254:
	li a6, 2
	bne a5, a6, be_else.16256
	sw a0, -105(sp)
	sw a3, -106(sp)
	add a1, a2, zero
	add a0, a4, zero
	sw ra, -108(sp)
	addi sp, sp, -109
	jal ra, setup_surface_table.2728
	addi sp, sp, 109
	lw ra, -108(sp)
	lw a1, -105(sp)
	lw a2, -106(sp)
	add a22, a1, a2
	sw a0, 0(a22)
	jump be_cont.16257
be_else.16256:
	sw a0, -105(sp)
	sw a3, -106(sp)
	add a1, a2, zero
	add a0, a4, zero
	sw ra, -108(sp)
	addi sp, sp, -109
	jal ra, setup_second_table.2731
	addi sp, sp, 109
	lw ra, -108(sp)
	lw a1, -105(sp)
	lw a2, -106(sp)
	add a22, a1, a2
	sw a0, 0(a22)
be_cont.16257:
be_cont.16255:
	addi a1, a1, -1
	lw a0, -4(sp)
	lw cl, -7(sp)
	sw ra, -108(sp)
	lw swp, 0(cl)
	addi sp, sp, -109
	jalr ra, swp, 0
	addi sp, sp, 109
	lw ra, -108(sp)
	jump ble_cont.16253
ble_else.16252:
ble_cont.16253:
	li a0, 16777216
	lw a0, 0(a0)
	addi a0, a0, -1
	li a1, 0
	blt a0, a1, ble_else.16258
	li a2, 16777217
	add a22, a2, a0
	lw a2, 0(a22)
	lw a3, 2(a2)
	li a4, 2
	bne a3, a4, be_else.16260
	lw a3, 7(a2)
	flw f0, 0(a3)
	fli f1, 1.000000
	flt a3, f0, f1
	bne a3, a1, be_else.16262
	jump be_cont.16263
be_else.16262:
	lw a3, 1(a2)
	li a5, 1
	bne a3, a5, be_else.16264
	lw cl, -3(sp)
	add a1, a2, zero
	sw ra, -108(sp)
	lw swp, 0(cl)
	addi sp, sp, -109
	jalr ra, swp, 0
	addi sp, sp, 109
	lw ra, -108(sp)
	jump be_cont.16265
be_else.16264:
	bne a3, a4, be_else.16266
	lw cl, -2(sp)
	add a1, a2, zero
	sw ra, -108(sp)
	lw swp, 0(cl)
	addi sp, sp, -109
	jalr ra, swp, 0
	addi sp, sp, 109
	lw ra, -108(sp)
	jump be_cont.16267
be_else.16266:
be_cont.16267:
be_cont.16265:
be_cont.16263:
	jump be_cont.16261
be_else.16260:
be_cont.16261:
	jump ble_cont.16259
ble_else.16258:
ble_cont.16259:
	lw a0, -73(sp)
	li a1, 0
	lw cl, -1(sp)
	add a2, a1, zero
	sw ra, -108(sp)
	lw swp, 0(cl)
	addi sp, sp, -109
	jalr ra, swp, 0
	addi sp, sp, 109
	lw ra, -108(sp)
	li a4, 2
	li a0, 0
	lw a1, -44(sp)
	lw a2, -73(sp)
	lw a3, -102(sp)
	lw cl, 0(sp)
	lw swp, 0(cl)
	jalr zero, swp, 0
min_caml_start:
	addi sp, sp, -28
	li a1, 1
	li a0, 16777216
	li a2, 0
	sw ra, 0(sp)
	addi sp, sp, -1
	jal ra, create_global_array
	addi sp, sp, 1
	lw ra, 0(sp)
	fli f0, 0.000000
	li a1, 0
	sw a0, 0(sp)
	add a0, a1, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, 60
	add a2, hp, zero
	addi hp, hp, 12
	sw a0, 10(a2)
	sw a0, 9(a2)
	sw a0, 8(a2)
	sw a0, 7(a2)
	li a3, 0
	sw a3, 6(a2)
	sw a0, 5(a2)
	sw a0, 4(a2)
	sw a3, 3(a2)
	sw a3, 2(a2)
	sw a3, 1(a2)
	sw a3, 0(a2)
	li a0, 16777217
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_global_array
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, 3
	li a2, 16777277
	fli f0, 0.000000
	sw a0, -1(sp)
	add a0, a2, zero
	sw ra, -2(sp)
	addi sp, sp, -3
	jal ra, create_global_float_array
	addi sp, sp, 3
	lw ra, -2(sp)
	li a1, 3
	li a2, 16777280
	fli f0, 0.000000
	sw a0, -2(sp)
	add a0, a2, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_global_float_array
	addi sp, sp, 5
	lw ra, -4(sp)
	li a1, 3
	li a2, 16777283
	fli f0, 0.000000
	sw a0, -3(sp)
	add a0, a2, zero
	sw ra, -4(sp)
	addi sp, sp, -5
	jal ra, create_global_float_array
	addi sp, sp, 5
	lw ra, -4(sp)
	li a1, 1
	fli f0, 255.000000
	li a2, 16777286
	sw a0, -4(sp)
	add a0, a2, zero
	sw ra, -6(sp)
	addi sp, sp, -7
	jal ra, create_global_float_array
	addi sp, sp, 7
	lw ra, -6(sp)
	li a1, 50
	li a2, 1
	li a3, -1
	sw a0, -5(sp)
	sw a1, -6(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_array
	addi sp, sp, 9
	lw ra, -8(sp)
	add a2, a0, zero
	li a0, 16777287
	lw a1, -6(sp)
	sw ra, -8(sp)
	addi sp, sp, -9
	jal ra, create_global_array
	addi sp, sp, 9
	lw ra, -8(sp)
	li a1, 1
	li a2, 1
	li a3, 16777287
	lw a3, 0(a3)
	sw a0, -7(sp)
	sw a1, -8(sp)
	add a1, a3, zero
	add a0, a2, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_array
	addi sp, sp, 11
	lw ra, -10(sp)
	add a2, a0, zero
	li a0, 16777337
	lw a1, -8(sp)
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_global_array
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 1
	li a2, 16777338
	fli f0, 0.000000
	sw a0, -9(sp)
	add a0, a2, zero
	sw ra, -10(sp)
	addi sp, sp, -11
	jal ra, create_global_float_array
	addi sp, sp, 11
	lw ra, -10(sp)
	li a1, 1
	li a2, 16777339
	li a3, 0
	sw a0, -10(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, create_global_array
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 1
	fli f0, 1000000000.000000
	li a2, 16777340
	sw a0, -11(sp)
	add a0, a2, zero
	sw ra, -12(sp)
	addi sp, sp, -13
	jal ra, create_global_float_array
	addi sp, sp, 13
	lw ra, -12(sp)
	li a1, 3
	li a2, 16777341
	fli f0, 0.000000
	sw a0, -12(sp)
	add a0, a2, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, create_global_float_array
	addi sp, sp, 15
	lw ra, -14(sp)
	li a1, 1
	li a2, 16777344
	li a3, 0
	sw a0, -13(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -14(sp)
	addi sp, sp, -15
	jal ra, create_global_array
	addi sp, sp, 15
	lw ra, -14(sp)
	li a1, 3
	li a2, 16777345
	fli f0, 0.000000
	sw a0, -14(sp)
	add a0, a2, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, create_global_float_array
	addi sp, sp, 17
	lw ra, -16(sp)
	li a1, 3
	li a2, 16777348
	fli f0, 0.000000
	sw a0, -15(sp)
	add a0, a2, zero
	sw ra, -16(sp)
	addi sp, sp, -17
	jal ra, create_global_float_array
	addi sp, sp, 17
	lw ra, -16(sp)
	li a1, 3
	li a2, 16777351
	fli f0, 0.000000
	sw a0, -16(sp)
	add a0, a2, zero
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_global_float_array
	addi sp, sp, 19
	lw ra, -18(sp)
	li a1, 3
	li a2, 16777354
	fli f0, 0.000000
	sw a0, -17(sp)
	add a0, a2, zero
	sw ra, -18(sp)
	addi sp, sp, -19
	jal ra, create_global_float_array
	addi sp, sp, 19
	lw ra, -18(sp)
	li a1, 2
	li a2, 16777357
	li a3, 0
	sw a0, -18(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, create_global_array
	addi sp, sp, 21
	lw ra, -20(sp)
	li a1, 2
	li a2, 16777359
	li a3, 0
	sw a0, -19(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -20(sp)
	addi sp, sp, -21
	jal ra, create_global_array
	addi sp, sp, 21
	lw ra, -20(sp)
	li a1, 1
	li a2, 16777361
	fli f0, 0.000000
	sw a0, -20(sp)
	add a0, a2, zero
	sw ra, -22(sp)
	addi sp, sp, -23
	jal ra, create_global_float_array
	addi sp, sp, 23
	lw ra, -22(sp)
	li a1, 3
	li a2, 16777362
	fli f0, 0.000000
	sw a0, -21(sp)
	add a0, a2, zero
	sw ra, -22(sp)
	addi sp, sp, -23
	jal ra, create_global_float_array
	addi sp, sp, 23
	lw ra, -22(sp)
	li a1, 3
	li a2, 16777365
	fli f0, 0.000000
	sw a0, -22(sp)
	add a0, a2, zero
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_global_float_array
	addi sp, sp, 25
	lw ra, -24(sp)
	li a1, 3
	li a2, 16777368
	fli f0, 0.000000
	sw a0, -23(sp)
	add a0, a2, zero
	sw ra, -24(sp)
	addi sp, sp, -25
	jal ra, create_global_float_array
	addi sp, sp, 25
	lw ra, -24(sp)
	li a1, 3
	li a2, 16777371
	fli f0, 0.000000
	sw a0, -24(sp)
	add a0, a2, zero
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_global_float_array
	addi sp, sp, 27
	lw ra, -26(sp)
	li a1, 3
	li a2, 16777374
	fli f0, 0.000000
	sw a0, -25(sp)
	add a0, a2, zero
	sw ra, -26(sp)
	addi sp, sp, -27
	jal ra, create_global_float_array
	addi sp, sp, 27
	lw ra, -26(sp)
	li a1, 3
	li a2, 16777377
	fli f0, 0.000000
	sw a0, -26(sp)
	add a0, a2, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_global_float_array
	addi sp, sp, 29
	lw ra, -28(sp)
	fli f0, 0.000000
	li a1, 0
	sw a0, -27(sp)
	add a0, a1, zero
	sw ra, -28(sp)
	addi sp, sp, -29
	jal ra, create_float_array
	addi sp, sp, 29
	lw ra, -28(sp)
	add a1, a0, zero
	li a0, 0
	sw a1, -28(sp)
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_array
	addi sp, sp, 31
	lw ra, -30(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -28(sp)
	sw a0, 0(a1)
	li a0, 0
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_array
	addi sp, sp, 31
	lw ra, -30(sp)
	add a2, a0, zero
	li a1, 5
	li a0, 16777380
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_global_array
	addi sp, sp, 31
	lw ra, -30(sp)
	fli f0, 0.000000
	li a1, 0
	sw a0, -29(sp)
	add a0, a1, zero
	sw ra, -30(sp)
	addi sp, sp, -31
	jal ra, create_float_array
	addi sp, sp, 31
	lw ra, -30(sp)
	li a1, 3
	fli f0, 0.000000
	sw a0, -30(sp)
	add a0, a1, zero
	sw ra, -32(sp)
	addi sp, sp, -33
	jal ra, create_float_array
	addi sp, sp, 33
	lw ra, -32(sp)
	li a1, 60
	lw a2, -30(sp)
	sw a0, -31(sp)
	add a0, a1, zero
	add a1, a2, zero
	sw ra, -32(sp)
	addi sp, sp, -33
	jal ra, create_array
	addi sp, sp, 33
	lw ra, -32(sp)
	li a1, 16777385
	sw a0, 1(a1)
	lw a0, -31(sp)
	sw a0, 0(a1)
	li a0, 16777385
	fli f0, 0.000000
	li a1, 0
	sw a0, -32(sp)
	add a0, a1, zero
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_float_array
	addi sp, sp, 35
	lw ra, -34(sp)
	add a1, a0, zero
	li a0, 0
	sw a1, -33(sp)
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_array
	addi sp, sp, 35
	lw ra, -34(sp)
	add a1, hp, zero
	addi hp, hp, 2
	sw a0, 1(a1)
	lw a0, -33(sp)
	sw a0, 0(a1)
	add a0, a1, zero
	li a1, 180
	add a2, hp, zero
	addi hp, hp, 6
	fli f0, 0.000000
	fsw f0, 2(a2)
	sw a0, 1(a2)
	li a0, 0
	sw a0, 0(a2)
	li a3, 16777387
	add a0, a3, zero
	sw ra, -34(sp)
	addi sp, sp, -35
	jal ra, create_global_array
	addi sp, sp, 35
	lw ra, -34(sp)
	li a1, 1
	li a2, 16777567
	li a3, 0
	sw a0, -34(sp)
	add a0, a2, zero
	add a2, a3, zero
	sw ra, -36(sp)
	addi sp, sp, -37
	jal ra, create_global_array
	addi sp, sp, 37
	lw ra, -36(sp)
	add a1, hp, zero
	addi hp, hp, 22
	la a2, read_screen_settings.2620
	sw a2, 0(a1)
	lw a2, -3(sp)
	sw a2, 21(a1)
	lw a3, -26(sp)
	sw a3, 20(a1)
	lw a4, -2(sp)
	sw a4, 19(a1)
	sw a2, 18(a1)
	sw a3, 17(a1)
	sw a4, 16(a1)
	sw a2, 15(a1)
	sw a3, 14(a1)
	sw a4, 13(a1)
	lw a5, -25(sp)
	sw a5, 12(a1)
	sw a5, 11(a1)
	sw a5, 10(a1)
	lw a6, -24(sp)
	sw a6, 9(a1)
	sw a6, 8(a1)
	sw a6, 7(a1)
	sw a3, 6(a1)
	sw a3, 5(a1)
	sw a3, 4(a1)
	sw a4, 3(a1)
	sw a4, 2(a1)
	sw a4, 1(a1)
	add a4, hp, zero
	addi hp, hp, 6
	la a7, read_light.2622
	sw a7, 0(a4)
	lw a7, -5(sp)
	sw a7, 4(a4)
	lw a8, -4(sp)
	sw a8, 3(a4)
	sw a8, 2(a4)
	sw a8, 1(a4)
	add a9, hp, zero
	addi hp, hp, 2
	la a10, read_nth_object.2627
	sw a10, 0(a9)
	lw a10, -1(sp)
	sw a10, 1(a9)
	add a11, hp, zero
	addi hp, hp, 10
	la a12, read_object.2629
	sw a12, 0(a11)
	lw a12, 0(sp)
	sw a12, 8(a11)
	sw a9, 7(a11)
	sw a12, 6(a11)
	sw a9, 5(a11)
	sw a12, 4(a11)
	sw a9, 3(a11)
	sw a12, 2(a11)
	sw a9, 1(a11)
	add a13, hp, zero
	addi hp, hp, 4
	la a14, read_and_network.2637
	sw a14, 0(a13)
	lw a14, -7(sp)
	sw a14, 2(a13)
	sw a14, 1(a13)
	add a15, hp, zero
	addi hp, hp, 2
	la a16, solver_rect_surface.2641
	sw a16, 0(a15)
	lw a16, -10(sp)
	sw a16, 1(a15)
	add a17, hp, zero
	addi hp, hp, 2
	la a18, solver_second.2675
	sw a18, 0(a17)
	sw a16, 1(a17)
	add a18, hp, zero
	addi hp, hp, 8
	la a19, solver.2681
	sw a19, 0(a18)
	sw a17, 6(a18)
	sw a16, 5(a18)
	sw a15, 4(a18)
	sw a15, 3(a18)
	sw a15, 2(a18)
	sw a10, 1(a18)
	add a15, hp, zero
	addi hp, hp, 4
	la a17, solver_rect_fast.2685
	sw a17, 0(a15)
	sw a16, 3(a15)
	sw a16, 2(a15)
	sw a16, 1(a15)
	add a17, hp, zero
	addi hp, hp, 2
	la a19, solver_surface_fast.2692
	sw a19, 0(a17)
	sw a16, 1(a17)
	add a19, hp, zero
	addi hp, hp, 4
	la a20, solver_second_fast.2698
	sw a20, 0(a19)
	sw a16, 2(a19)
	sw a16, 1(a19)
	add a20, hp, zero
	addi hp, hp, 6
	la cl, solver_fast.2704
	sw cl, 0(a20)
	sw a19, 4(a20)
	sw a17, 3(a20)
	sw a15, 2(a20)
	sw a10, 1(a20)
	add a17, hp, zero
	addi hp, hp, 4
	la a19, solver_second_fast2.2715
	sw a19, 0(a17)
	sw a16, 2(a17)
	sw a16, 1(a17)
	add a19, hp, zero
	addi hp, hp, 6
	la cl, solver_fast2.2722
	sw cl, 0(a19)
	sw a17, 4(a19)
	sw a16, 3(a19)
	sw a15, 2(a19)
	sw a10, 1(a19)
	add a15, hp, zero
	addi hp, hp, 4
	la a17, iter_setup_dirvec_constants.2734
	sw a17, 0(a15)
	sw a10, 2(a15)
	sw a10, 1(a15)
	add a17, hp, zero
	addi hp, hp, 2
	la cl, setup_startp_constants.2739
	sw cl, 0(a17)
	sw a10, 1(a17)
	add cl, hp, zero
	addi hp, hp, 4
	la swp, check_all_inside.2764
	sw swp, 0(cl)
	sw a10, 2(cl)
	sw a10, 1(cl)
	add swp, hp, zero
	addi hp, hp, 14
	sw a1, -35(sp)
	la a1, shadow_check_and_group.2770
	sw a1, 0(swp)
	sw cl, 13(swp)
	sw a10, 12(swp)
	lw a1, -13(sp)
	sw a1, 11(swp)
	sw a8, 10(swp)
	sw a1, 9(swp)
	sw a8, 8(swp)
	sw a1, 7(swp)
	sw a8, 6(swp)
	sw a10, 5(swp)
	sw a16, 4(swp)
	sw a1, 3(swp)
	sw a4, -36(sp)
	lw a4, -32(sp)
	sw a4, 2(swp)
	sw a20, 1(swp)
	sw a9, -37(sp)
	add a9, hp, zero
	addi hp, hp, 6
	sw a11, -38(sp)
	la a11, shadow_check_one_or_group.2773
	sw a11, 0(a9)
	sw swp, 4(a9)
	sw a14, 3(a9)
	sw swp, 2(a9)
	sw a14, 1(a9)
	add a11, hp, zero
	addi hp, hp, 12
	sw a13, -39(sp)
	la a13, shadow_check_one_or_matrix.2776
	sw a13, 0(a11)
	sw a9, 10(a11)
	sw swp, 9(a11)
	sw a14, 8(a11)
	sw a9, 7(a11)
	sw swp, 6(a11)
	sw a14, 5(a11)
	sw a16, 4(a11)
	sw a1, 3(a11)
	sw a4, 2(a11)
	sw a20, 1(a11)
	add a9, hp, zero
	addi hp, hp, 18
	la a13, solve_each_element.2779
	sw a13, 0(a9)
	lw a13, -11(sp)
	sw a13, 16(a9)
	lw a20, -14(sp)
	sw a20, 15(a9)
	sw a1, 14(a9)
	sw a1, 13(a9)
	sw a1, 12(a9)
	lw swp, -12(sp)
	sw swp, 11(a9)
	sw cl, 10(a9)
	sw a10, 9(a9)
	lw a4, -22(sp)
	sw a4, 8(a9)
	sw a4, 7(a9)
	sw a4, 6(a9)
	sw swp, 5(a9)
	sw a16, 4(a9)
	sw a10, 3(a9)
	sw a4, 2(a9)
	sw a18, 1(a9)
	sw a15, -40(sp)
	add a15, hp, zero
	addi hp, hp, 10
	la a5, solve_one_or_network.2783
	sw a5, 0(a15)
	sw a9, 8(a15)
	sw a14, 7(a15)
	sw a9, 6(a15)
	sw a14, 5(a15)
	sw a9, 4(a15)
	sw a14, 3(a15)
	sw a9, 2(a15)
	sw a14, 1(a15)
	add a5, hp, zero
	addi hp, hp, 20
	la a3, trace_or_matrix.2787
	sw a3, 0(a5)
	sw a15, 18(a5)
	sw a9, 17(a5)
	sw a14, 16(a5)
	sw a9, 15(a5)
	sw a14, 14(a5)
	sw a9, 13(a5)
	sw a14, 12(a5)
	sw swp, 11(a5)
	sw a16, 10(a5)
	sw a4, 9(a5)
	sw a18, 8(a5)
	sw a15, 7(a5)
	sw a9, 6(a5)
	sw a14, 5(a5)
	sw a9, 4(a5)
	sw a14, 3(a5)
	sw a9, 2(a5)
	sw a14, 1(a5)
	add a3, hp, zero
	addi hp, hp, 16
	la a9, solve_each_element_fast.2793
	sw a9, 0(a3)
	sw a13, 15(a3)
	sw a20, 14(a3)
	sw a1, 13(a3)
	sw a1, 12(a3)
	sw a1, 11(a3)
	sw swp, 10(a3)
	sw cl, 9(a3)
	sw a10, 8(a3)
	lw a9, -23(sp)
	sw a9, 7(a3)
	sw a9, 6(a3)
	sw a9, 5(a3)
	sw swp, 4(a3)
	sw a16, 3(a3)
	sw a10, 2(a3)
	sw a19, 1(a3)
	add a15, hp, zero
	addi hp, hp, 10
	la a18, solve_one_or_network_fast.2797
	sw a18, 0(a15)
	sw a3, 8(a15)
	sw a14, 7(a15)
	sw a3, 6(a15)
	sw a14, 5(a15)
	sw a3, 4(a15)
	sw a14, 3(a15)
	sw a3, 2(a15)
	sw a14, 1(a15)
	add a18, hp, zero
	addi hp, hp, 18
	la cl, trace_or_matrix_fast.2801
	sw cl, 0(a18)
	sw a15, 17(a18)
	sw a3, 16(a18)
	sw a14, 15(a18)
	sw a3, 14(a18)
	sw a14, 13(a18)
	sw a3, 12(a18)
	sw a14, 11(a18)
	sw swp, 10(a18)
	sw a16, 9(a18)
	sw a19, 8(a18)
	sw a15, 7(a18)
	sw a3, 6(a18)
	sw a14, 5(a18)
	sw a3, 4(a18)
	sw a14, 3(a18)
	sw a3, 2(a18)
	sw a14, 1(a18)
	add a3, hp, zero
	addi hp, hp, 12
	la a14, get_nvector_second.2811
	sw a14, 0(a3)
	lw a14, -15(sp)
	sw a14, 10(a3)
	sw a14, 9(a3)
	sw a14, 8(a3)
	sw a14, 7(a3)
	sw a14, 6(a3)
	sw a14, 5(a3)
	sw a14, 4(a3)
	sw a1, 3(a3)
	sw a1, 2(a3)
	sw a1, 1(a3)
	add a15, hp, zero
	addi hp, hp, 10
	la a16, utexture.2816
	sw a16, 0(a15)
	lw a16, -16(sp)
	sw a16, 9(a15)
	sw a16, 8(a15)
	sw a16, 7(a15)
	sw a16, 6(a15)
	sw a16, 5(a15)
	sw a16, 4(a15)
	sw a16, 3(a15)
	sw a16, 2(a15)
	sw a16, 1(a15)
	add a19, hp, zero
	addi hp, hp, 10
	la cl, add_light.2819
	sw cl, 0(a19)
	lw cl, -18(sp)
	sw cl, 8(a19)
	sw cl, 7(a19)
	sw cl, 6(a19)
	sw cl, 5(a19)
	sw cl, 4(a19)
	sw cl, 3(a19)
	sw a16, 2(a19)
	sw cl, 1(a19)
	add a6, hp, zero
	addi hp, hp, 14
	la a2, trace_reflections.2823
	sw a2, 0(a6)
	sw a19, 13(a6)
	sw a14, 12(a6)
	sw a14, 11(a6)
	sw a14, 10(a6)
	sw a11, 9(a6)
	lw a2, -9(sp)
	sw a2, 8(a6)
	sw a13, 7(a6)
	sw a20, 6(a6)
	sw swp, 5(a6)
	sw a18, 4(a6)
	sw a2, 3(a6)
	sw swp, 2(a6)
	sw a18, -41(sp)
	lw a18, -34(sp)
	sw a18, 1(a6)
	add a18, hp, zero
	addi hp, hp, 72
	sw a5, -42(sp)
	la a5, trace_ray.2828
	sw a5, 0(a18)
	sw swp, 71(a18)
	sw a6, 70(a18)
	sw a0, 69(a18)
	sw a1, 68(a18)
	sw a17, 67(a18)
	sw a12, 66(a18)
	sw a9, 65(a18)
	sw a1, 64(a18)
	sw a9, 63(a18)
	sw a1, 62(a18)
	sw a9, 61(a18)
	sw a1, 60(a18)
	sw a19, 59(a18)
	sw a8, 58(a18)
	sw a8, 57(a18)
	sw a8, 56(a18)
	sw a8, 55(a18)
	sw a14, 54(a18)
	sw a8, 53(a18)
	sw a14, 52(a18)
	sw a8, 51(a18)
	sw a14, 50(a18)
	sw a11, 49(a18)
	sw a2, 48(a18)
	sw a14, 47(a18)
	sw a14, 46(a18)
	sw a14, 45(a18)
	sw a14, 44(a18)
	sw a14, 43(a18)
	sw a14, 42(a18)
	sw a14, 41(a18)
	sw a16, 40(a18)
	sw a16, 39(a18)
	sw a16, 38(a18)
	sw a1, 37(a18)
	sw a1, 36(a18)
	sw a1, 35(a18)
	sw a13, 34(a18)
	sw a1, 33(a18)
	sw a15, 32(a18)
	sw a4, 31(a18)
	sw a1, 30(a18)
	sw a4, 29(a18)
	sw a1, 28(a18)
	sw a4, 27(a18)
	sw a1, 26(a18)
	sw a3, 25(a18)
	sw a14, 24(a18)
	sw a14, 23(a18)
	sw a14, 22(a18)
	sw a14, 21(a18)
	sw a14, 20(a18)
	sw a14, 19(a18)
	sw a14, 18(a18)
	sw a13, 17(a18)
	sw a10, 16(a18)
	sw a20, 15(a18)
	sw cl, 14(a18)
	sw cl, 13(a18)
	sw cl, 12(a18)
	sw cl, 11(a18)
	sw cl, 10(a18)
	sw cl, 9(a18)
	sw a7, 8(a18)
	sw a8, 7(a18)
	sw a8, 6(a18)
	sw a8, 5(a18)
	sw swp, 4(a18)
	lw a5, -42(sp)
	sw a5, 3(a18)
	sw a2, 2(a18)
	sw swp, 1(a18)
	add a5, hp, zero
	addi hp, hp, 28
	la a6, trace_diffuse_ray.2834
	sw a6, 0(a5)
	sw a16, 27(a5)
	lw a6, -17(sp)
	sw a6, 26(a5)
	sw a8, 25(a5)
	sw a14, 24(a5)
	sw a8, 23(a5)
	sw a14, 22(a5)
	sw a8, 21(a5)
	sw a14, 20(a5)
	sw a11, 19(a5)
	sw a2, 18(a5)
	sw a1, 17(a5)
	sw a15, 16(a5)
	sw a3, 15(a5)
	sw a14, 14(a5)
	sw a14, 13(a5)
	sw a14, 12(a5)
	sw a14, 11(a5)
	sw a14, 10(a5)
	sw a14, 9(a5)
	sw a14, 8(a5)
	sw a13, 7(a5)
	sw a10, 6(a5)
	sw a20, 5(a5)
	sw swp, 4(a5)
	lw a1, -41(sp)
	sw a1, 3(a5)
	sw a2, 2(a5)
	sw swp, 1(a5)
	add a1, hp, zero
	addi hp, hp, 4
	la a3, iter_trace_diffuse_rays.2837
	sw a3, 0(a1)
	sw a5, 2(a1)
	sw a5, 1(a1)
	add a3, hp, zero
	addi hp, hp, 36
	la a5, trace_diffuse_ray_80percent.2846
	sw a5, 0(a3)
	sw a1, 35(a3)
	sw a17, 34(a3)
	sw a12, 33(a3)
	sw a9, 32(a3)
	sw a9, 31(a3)
	sw a9, 30(a3)
	lw a5, -29(sp)
	sw a5, 29(a3)
	sw a1, 28(a3)
	sw a17, 27(a3)
	sw a12, 26(a3)
	sw a9, 25(a3)
	sw a9, 24(a3)
	sw a9, 23(a3)
	sw a5, 22(a3)
	sw a1, 21(a3)
	sw a17, 20(a3)
	sw a12, 19(a3)
	sw a9, 18(a3)
	sw a9, 17(a3)
	sw a9, 16(a3)
	sw a5, 15(a3)
	sw a1, 14(a3)
	sw a17, 13(a3)
	sw a12, 12(a3)
	sw a9, 11(a3)
	sw a9, 10(a3)
	sw a9, 9(a3)
	sw a5, 8(a3)
	sw a1, 7(a3)
	sw a17, 6(a3)
	sw a12, 5(a3)
	sw a9, 4(a3)
	sw a9, 3(a3)
	sw a9, 2(a3)
	sw a5, 1(a3)
	add a7, hp, zero
	addi hp, hp, 8
	la a11, calc_diffuse_using_1point.2850
	sw a11, 0(a7)
	sw a6, 6(a7)
	sw cl, 5(a7)
	sw a3, 4(a7)
	sw a6, 3(a7)
	sw a6, 2(a7)
	sw a6, 1(a7)
	add a11, hp, zero
	addi hp, hp, 30
	la a13, calc_diffuse_using_5points.2853
	sw a13, 0(a11)
	sw a6, 29(a11)
	sw cl, 28(a11)
	sw a6, 27(a11)
	sw a6, 26(a11)
	sw a6, 25(a11)
	sw a6, 24(a11)
	sw a6, 23(a11)
	sw a6, 22(a11)
	sw a6, 21(a11)
	sw a6, 20(a11)
	sw a6, 19(a11)
	sw a6, 18(a11)
	sw a6, 17(a11)
	sw a6, 16(a11)
	sw a6, 15(a11)
	sw a6, 14(a11)
	sw a6, 13(a11)
	sw a6, 12(a11)
	sw a6, 11(a11)
	sw a6, 10(a11)
	sw a6, 9(a11)
	sw a6, 8(a11)
	sw a6, 7(a11)
	sw a6, 6(a11)
	sw a6, 5(a11)
	sw a6, 4(a11)
	sw a6, 3(a11)
	sw a6, 2(a11)
	sw a6, 1(a11)
	add a13, hp, zero
	addi hp, hp, 8
	la a14, do_without_neighbors.2859
	sw a14, 0(a13)
	sw a7, 7(a13)
	sw a6, 6(a13)
	sw cl, 5(a13)
	sw a3, 4(a13)
	sw a6, 3(a13)
	sw a6, 2(a13)
	sw a6, 1(a13)
	add a3, hp, zero
	addi hp, hp, 4
	la a14, try_exploit_neighbors.2875
	sw a14, 0(a3)
	sw a11, 3(a3)
	sw a13, 2(a3)
	sw a7, 1(a3)
	add a11, hp, zero
	addi hp, hp, 4
	la a14, write_ppm_header.2882
	sw a14, 0(a11)
	lw a14, -19(sp)
	sw a14, 2(a11)
	sw a14, 1(a11)
	add a15, hp, zero
	addi hp, hp, 14
	la a16, pretrace_diffuse_rays.2888
	sw a16, 0(a15)
	sw a6, 13(a15)
	sw a6, 12(a15)
	sw a6, 11(a15)
	sw a1, 10(a15)
	sw a17, 9(a15)
	sw a12, 8(a15)
	sw a9, 7(a15)
	sw a9, 6(a15)
	sw a9, 5(a15)
	sw a5, 4(a15)
	sw a6, 3(a15)
	sw a6, 2(a15)
	sw a6, 1(a15)
	add a1, hp, zero
	addi hp, hp, 26
	la a6, pretrace_pixels.2891
	sw a6, 0(a1)
	sw a15, 24(a1)
	sw cl, 23(a1)
	sw cl, 22(a1)
	sw cl, 21(a1)
	lw a6, -27(sp)
	sw a6, 20(a1)
	sw a18, 19(a1)
	sw a4, 18(a1)
	lw a9, -3(sp)
	sw a9, 17(a1)
	sw a4, 16(a1)
	sw a9, 15(a1)
	sw a4, 14(a1)
	sw a9, 13(a1)
	sw cl, 12(a1)
	sw cl, 11(a1)
	sw cl, 10(a1)
	sw a6, 9(a1)
	sw a6, 8(a1)
	lw a4, -24(sp)
	sw a4, 7(a1)
	sw a6, 6(a1)
	sw a4, 5(a1)
	sw a6, 4(a1)
	sw a4, 3(a1)
	lw a4, -20(sp)
	sw a4, 2(a1)
	lw a6, -21(sp)
	sw a6, 1(a1)
	add a9, hp, zero
	addi hp, hp, 12
	la a15, pretrace_line.2898
	sw a15, 0(a9)
	sw a1, 10(a9)
	sw a14, 9(a9)
	lw a1, -26(sp)
	sw a1, 8(a9)
	lw a15, -25(sp)
	sw a15, 7(a9)
	sw a1, 6(a9)
	sw a15, 5(a9)
	sw a1, 4(a9)
	sw a15, 3(a9)
	sw a4, 2(a9)
	sw a6, 1(a9)
	add a1, hp, zero
	addi hp, hp, 14
	la a15, scan_pixel.2902
	sw a15, 0(a1)
	sw cl, 12(a1)
	sw cl, 11(a1)
	sw cl, 10(a1)
	sw a3, 9(a1)
	sw a13, 8(a1)
	sw a7, 7(a1)
	sw a14, 6(a1)
	sw a14, 5(a1)
	sw cl, 4(a1)
	sw cl, 3(a1)
	sw cl, 2(a1)
	sw a14, 1(a1)
	add a3, hp, zero
	addi hp, hp, 6
	la a7, scan_line.2908
	sw a7, 0(a3)
	sw a1, 4(a3)
	sw a9, 3(a3)
	sw a14, 2(a3)
	sw a14, 1(a3)
	add a1, hp, zero
	addi hp, hp, 2
	la a7, calc_dirvec.2928
	sw a7, 0(a1)
	sw a5, 1(a1)
	add a7, hp, zero
	addi hp, hp, 4
	la a13, calc_dirvecs.2936
	sw a13, 0(a7)
	sw a1, 2(a7)
	sw a1, 1(a7)
	add a1, hp, zero
	addi hp, hp, 2
	la a13, calc_dirvec_rows.2941
	sw a13, 0(a1)
	sw a7, 1(a1)
	add a7, hp, zero
	addi hp, hp, 4
	la a13, create_dirvec_elements.2947
	sw a13, 0(a7)
	sw a12, 2(a7)
	sw a12, 1(a7)
	add a13, hp, zero
	addi hp, hp, 10
	la a15, create_dirvecs.2950
	sw a15, 0(a13)
	sw a7, 9(a13)
	sw a5, 8(a13)
	sw a5, 7(a13)
	sw a12, 6(a13)
	sw a7, 5(a13)
	sw a12, 4(a13)
	sw a5, 3(a13)
	sw a5, 2(a13)
	sw a12, 1(a13)
	add a7, hp, zero
	addi hp, hp, 12
	la a15, init_dirvec_constants.2952
	sw a15, 0(a7)
	lw a15, -40(sp)
	sw a15, 11(a7)
	sw a12, 10(a7)
	sw a15, 9(a7)
	sw a10, 8(a7)
	sw a12, 7(a7)
	sw a15, 6(a7)
	sw a10, 5(a7)
	sw a12, 4(a7)
	sw a15, 3(a7)
	sw a10, 2(a7)
	sw a12, 1(a7)
	add a16, hp, zero
	addi hp, hp, 24
	la a17, init_vecset_constants.2955
	sw a17, 0(a16)
	sw a7, 23(a16)
	sw a5, 22(a16)
	sw a7, 21(a16)
	sw a15, 20(a16)
	sw a12, 19(a16)
	sw a5, 18(a16)
	sw a7, 17(a16)
	sw a15, 16(a16)
	sw a12, 15(a16)
	sw a15, 14(a16)
	sw a10, 13(a16)
	sw a12, 12(a16)
	sw a5, 11(a16)
	sw a7, 10(a16)
	sw a15, 9(a16)
	sw a12, 8(a16)
	sw a15, 7(a16)
	sw a10, 6(a16)
	sw a12, 5(a16)
	sw a15, 4(a16)
	sw a10, 3(a16)
	sw a12, 2(a16)
	sw a5, 1(a16)
	add a17, hp, zero
	addi hp, hp, 24
	la a18, setup_rect_reflection.2966
	sw a18, 0(a17)
	sw a0, 23(a17)
	lw a18, -34(sp)
	sw a18, 22(a17)
	sw a15, 21(a17)
	sw a10, 20(a17)
	sw a12, 19(a17)
	sw a12, 18(a17)
	sw a8, 17(a17)
	sw a18, 16(a17)
	sw a15, 15(a17)
	sw a10, 14(a17)
	sw a12, 13(a17)
	sw a12, 12(a17)
	sw a8, 11(a17)
	sw a18, 10(a17)
	sw a15, 9(a17)
	sw a10, 8(a17)
	sw a12, 7(a17)
	sw a12, 6(a17)
	sw a8, 5(a17)
	sw a8, 4(a17)
	sw a8, 3(a17)
	sw a8, 2(a17)
	sw a0, 1(a17)
	add a19, hp, zero
	addi hp, hp, 14
	la a20, setup_surface_reflection.2969
	sw a20, 0(a19)
	sw a0, 13(a19)
	sw a18, 12(a19)
	sw a15, 11(a19)
	sw a10, 10(a19)
	sw a12, 9(a19)
	sw a12, 8(a19)
	sw a8, 7(a19)
	sw a8, 6(a19)
	sw a8, 5(a19)
	sw a8, 4(a19)
	sw a8, 3(a19)
	sw a8, 2(a19)
	sw a0, 1(a19)
	add cl, hp, zero
	addi hp, hp, 42
	la a0, rt.2974
	sw a0, 0(cl)
	sw a3, 41(cl)
	sw a9, 40(cl)
	sw a19, 39(cl)
	sw a17, 38(cl)
	sw a10, 37(cl)
	sw a12, 36(cl)
	lw a0, -32(sp)
	sw a0, 35(cl)
	sw a15, 34(cl)
	sw a10, 33(cl)
	sw a12, 32(cl)
	sw a8, 31(cl)
	sw a8, 30(cl)
	sw a8, 29(cl)
	sw a16, 28(cl)
	sw a7, 27(cl)
	sw a5, 26(cl)
	sw a7, 25(cl)
	sw a15, 24(cl)
	sw a12, 23(cl)
	sw a5, 22(cl)
	sw a1, 21(cl)
	sw a13, 20(cl)
	sw a11, 19(cl)
	sw a2, 18(cl)
	lw a0, -39(sp)
	sw a0, 17(cl)
	lw a0, -38(sp)
	sw a0, 16(cl)
	sw a12, 15(cl)
	lw a0, -37(sp)
	sw a0, 14(cl)
	lw a0, -36(sp)
	sw a0, 13(cl)
	lw a0, -35(sp)
	sw a0, 12(cl)
	sw a14, 11(cl)
	sw a14, 10(cl)
	sw a14, 9(cl)
	sw a14, 8(cl)
	sw a14, 7(cl)
	sw a14, 6(cl)
	sw a6, 5(cl)
	sw a4, 4(cl)
	sw a4, 3(cl)
	sw a14, 2(cl)
	sw a14, 1(cl)
	li a0, 128
	li a1, 128
	sw ra, -44(sp)
	lw swp, 0(cl)
	addi sp, sp, -45
	jalr ra, swp, 0
	addi sp, sp, 45
	lw ra, -44(sp)
	li a0, 0
	jalr zero, ra, 0
