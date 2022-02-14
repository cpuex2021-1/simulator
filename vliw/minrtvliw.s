nop; 	lui hp, 4096; nop; nop; 
	jump min_caml_start; 	addi hp, hp, 352; nop; nop; 
nop; nop; nop; nop; 
print_char:
	ret; nop;     sw a0, 0(zero); nop; 
print_int:
	addi a2, zero, 48; 	addi a1, zero, 48; nop; nop; 
	addi a4, zero, 100; 	addi a3, zero, 48; nop; nop; 
	addi a6, zero, 1; 	addi a5, zero, 10; nop; nop; 
nop; 	addi a7, zero, 48; nop; nop; 
print_int_l1:
	blt a0, a4, print_int_l2; nop; nop; nop; 
	addi a0, a0, -100; 	addi a1, a1, 1; nop; nop; 
	jump print_int_l1; nop; nop; nop; 
print_int_l2:
	blt a0, a5, print_int_l3; nop; nop; nop; 
	addi a0, a0, -10; 	addi a2, a2, 1; nop; nop; 
	jump print_int_l2; nop; nop; nop; 
print_int_l3:
	blt a0, a6, print_int_l4; nop; nop; nop; 
	addi a0, a0, -1; 	addi a3, a3, 1; nop; nop; 
	jump print_int_l3; nop; nop; nop; 
print_int_l4:
nop; nop; 	sw a1, 0(zero); nop; 
nop; nop; 	sw a2, 0(zero); nop; 
	ret; nop; 	sw a3, 0(zero); nop; 
read_int:
nop; nop;     lw a0, 0(zero); nop; 
nop; nop;     lw a1, 0(zero); nop; 
nop;     slli a1, a1, 8; nop; nop; 
nop;     add a0, a0, a1;     lw a1, 0(zero); nop; 
nop;     slli a1, a1, 16; nop; nop; 
nop;     add a0, a0, a1;     lw a1 , 0(zero); nop; 
nop;     slli a1, a1, 24; nop; nop; 
	ret;     add a0, a0, a1; nop; nop; 
nop; nop; nop; nop; 
read_float:
nop; nop;     lw a0, 0(zero); nop; 
nop; nop;     lw a1, 0(zero); nop; 
nop;     slli a1, a1, 8; nop; nop; 
nop;     add a0, a0, a1;     lw a1, 0(zero); nop; 
nop;     slli a1, a1, 16; nop; nop; 
nop;     add a0, a0, a1;     lw a1 , 0(zero); nop; 
nop;     slli a1, a1, 24; nop; nop; 
nop;     add a0, a0, a1; nop; nop; 
	ret; 	addi f0, a0, 0; nop; nop; 
nop; nop; nop; nop; 
fiszero:
	ret;     feq a0, f0, fzero; nop; nop; 
fispos:
	ret;     flt a0, fzero, f0; nop; nop; 
fisneg:
	ret;     flt a0, f0, fzero; nop; nop; 
fneg:
	ret;     fneg f0, f0; nop; nop; 
fabs:
nop;     flt a1, f0, fzero; nop; nop; 
    bne a1, zero, fabs_l1; nop; nop; nop; 
	ret; nop; nop; nop; 
fabs_l1:
	ret;     fneg f0, f0; nop; nop; 
fless:
	ret;     flt a0, f0, f1; nop; nop; 
fhalf:
nop; 	lui.float f1, 0.5; nop; nop; 
nop; 	addi.float f1, f1, 0.5; nop; nop; 
	ret;     fmul f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
floor:
nop;     ftoi a0,f0; nop; nop; 
nop;     itof f1,a0; nop; nop; 
nop;     flt a1,f0,f1; nop; nop; 
nop;     sub a0,a0,a1; nop; nop; 
	ret;     itof f0,a0; nop; nop; 
nop; nop; nop; nop; 
int_of_float:
	ret;     ftoi a0, f0; nop; nop; 
float_of_int:
	ret;     itof f0, a0; nop; nop; 
sqrt:
	ret;     fsqrt f0, f0; nop; nop; 
fsqr:
	ret;     fmul f0, f0, f0; nop; nop; 
create_array:
nop;     addi a3, a0, 0; nop; nop; 
create_array_loop:
    bge zero, a0, create_array_exit; nop; nop; nop; 
create_array_cont:
nop;     addi a0, a0, -1; nop; nop; 
nop;     add a2, a0, hp; nop; nop; 
    jump create_array_loop; nop; nop;     sw a1, 0(a2); 
nop; nop; nop; nop; 
create_array_exit:
    add hp, hp, a3;     add a0, hp, zero; nop; nop; 
	ret; nop; nop; nop; 
create_float_array:
nop;     addi a3, a0, 0; nop; nop; 
create_float_array_loop:
    bge zero, a0, create_float_array_exit; nop; nop; nop; 
create_float_array_cont:
nop;     addi a0, a0, -1; nop; nop; 
nop;     add a2, a0, hp; nop; nop; 
    jump create_float_array_loop; nop; nop; 	sw f0, 0(a2); 
nop; nop; nop; nop; 
create_float_array_exit:
    add hp, hp, a3;     add a0, hp, zero; nop; nop; 
	ret; nop; nop; nop; 
create_global_array:
    addi a0, a1, 0;     addi a3, a0, 0; nop; nop; 
nop;     addi a1, a2, 0; nop; nop; 
create_global_array_loop:
    bge zero, a0, create_global_array_exit; nop; nop; nop; 
create_global_array_cont:
nop;     addi a0, a0, -1; nop; nop; 
nop;     add a4, a0, a3; nop; nop; 
    jump create_global_array_loop; nop; nop;     sw a1, 0(a4); 
nop; nop; nop; nop; 
create_global_array_exit:
	ret;     add a0, a3, zero; nop; nop; 
create_global_float_array:
    addi a0, a1, 0;     addi a3, a0, 0; nop; nop; 
create_global_float_array_loop:
    bge zero, a0, create_global_float_array_exit; nop; nop; nop; 
create_global_float_array_cont:
nop;     addi a0, a0, -1; nop; nop; 
nop;     add a4, a0, a3; nop; nop; 
    jump create_global_float_array_loop; nop; nop; 	sw f0, 0(a4); 
nop; nop; nop; nop; 
create_global_float_array_exit:
	ret;     add a0, a3, zero; nop; nop; 
pi_div.122:
nop; 	lui.float f2, 0.000000; nop; nop; 
nop; 	addi.float f2, f2, 0.000000; nop; nop; 
nop; 	feq a20, f2, f0; nop; nop; 
	beq a20, zero, fbe_else.313; nop; nop; nop; 
	ret; nop; nop; nop; 
fbe_else.313:
nop; 	lui.float f2, 0.000000; nop; nop; 
nop; 	addi.float f2, f2, 0.000000; nop; nop; 
nop; 	fle a20, f0, f2; nop; nop; 
	beq a20, zero, fble_else.314; nop; nop; nop; 
nop; 	fneg f2, f0; nop; nop; 
nop; 	fle a20, f2, f1; nop; nop; 
	beq a20, zero, fble_else.315; nop; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
	addi sp, sp, -3; 	addi f0, f1, 0; nop; 	sw f0, 0(sp); 
	call fhalf; nop; nop; nop; 
	fadd f1, f0, fzero; 	addi sp, sp, 3; nop; nop; 
	jump pi_div.122; nop; nop; 	lw f0, 0(sp); 
nop; nop; nop; nop; 
fble_else.315:
nop; 	lui.float f2, 2.000000; nop; nop; 
nop; 	addi.float f2, f2, 2.000000; nop; nop; 
	jump pi_div.122; 	fmul f1, f1, f2; nop; nop; 
nop; nop; nop; nop; 
fble_else.314:
	lui.float f3, 2.000000; 	lui.float f2, 3.141593; nop; nop; 
	addi.float f3, f3, 2.000000; 	addi.float f2, f2, 3.141593; nop; nop; 
nop; 	fmul f2, f2, f3; nop; nop; 
nop; 	fle a20, f2, f0; nop; nop; 
	beq a20, zero, fble_else.316; nop; nop; nop; 
nop; 	fle a20, f0, f1; nop; nop; 
	beq a20, zero, fble_else.317; nop; nop; nop; 
	addi sp, sp, -7; 	addi f0, f1, 0; 	sw f0, -4(sp); 	sw f1, -2(sp); 
	call fhalf; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; nop; 	lw f1, -4(sp); 
nop; 	fsub f0, f1, f0; nop; 	lw f1, -2(sp); 
	addi sp, sp, -9; 	addi f0, f1, 0; nop; 	sw f0, -6(sp); 
	call fhalf; nop; nop; nop; 
	fadd f1, f0, fzero; 	addi sp, sp, 9; nop; nop; 
	jump pi_div.122; nop; nop; 	lw f0, -6(sp); 
nop; nop; nop; nop; 
fble_else.317:
nop; 	lui.float f2, 2.000000; nop; nop; 
nop; 	addi.float f2, f2, 2.000000; nop; nop; 
	jump pi_div.122; 	fmul f1, f1, f2; nop; nop; 
nop; nop; nop; nop; 
fble_else.316:
	ret; nop; nop; nop; 
pi4div.125:
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f2, f2, 2.000000; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fdiv f1, f1, f2; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.318; nop; nop; nop; 
nop; 	lui.float f1, 3.141593; nop; nop; 
nop; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.319; nop; nop; nop; 
	lui.float f2, 1.500000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f2, f2, 1.500000; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.320; nop; nop; nop; 
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	add a0, hp, zero; nop; nop; 
	addi hp, hp, 8; 	addi.float f2, f2, 2.000000; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
	lui.float f1, 1.000000; 	fsub f0, f1, f0; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.320:
	add a0, hp, zero; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi hp, hp, 8; nop; nop; 
	lui.float f1, -1.000000; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, -1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.319:
	add a0, hp, zero; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi hp, hp, 8; nop; nop; 
	lui.float f1, -1.000000; 	fsub f0, f1, f0; nop; nop; 
nop; 	addi.float f1, f1, -1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.318:
	add a0, hp, zero; 	lui.float f1, 1.000000; nop; nop; 
	addi.float f1, f1, 1.000000; 	addi hp, hp, 8; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
pi4div2.127:
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f2, f2, 2.000000; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fdiv f1, f1, f2; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.321; nop; nop; nop; 
nop; 	lui.float f1, 3.141593; nop; nop; 
nop; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.322; nop; nop; nop; 
	lui.float f2, 1.500000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f2, f2, 1.500000; 	addi.float f1, f1, 3.141593; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.323; nop; nop; nop; 
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	add a0, hp, zero; nop; nop; 
	addi hp, hp, 8; 	addi.float f2, f2, 2.000000; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
	lui.float f1, -1.000000; 	fsub f0, f1, f0; nop; nop; 
nop; 	addi.float f1, f1, -1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.323:
	add a0, hp, zero; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi hp, hp, 8; nop; nop; 
	lui.float f1, -1.000000; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, -1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.322:
	add a0, hp, zero; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi hp, hp, 8; nop; nop; 
	lui.float f1, 1.000000; 	fsub f0, f1, f0; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
fble_else.321:
	add a0, hp, zero; 	lui.float f1, 1.000000; nop; nop; 
	addi.float f1, f1, 1.000000; 	addi hp, hp, 8; nop; 	sw f0, 0(a0); 
	ret; nop; nop; 	sw f1, 4(a0); 
nop; nop; nop; nop; 
tailor_cos.129:
nop; 	fmul f0, f0, f0; nop; nop; 
nop; 	addi sp, sp, -3; nop; 	sw f0, 0(sp); 
	call fhalf; nop; nop; nop; 
	lui.float f3, 0.083333; 	addi sp, sp, 3; nop; nop; 
	lui.float f5, 0.017857; 	lui.float f4, 0.033333; nop; 	lw f1, 0(sp); 
	addi.float f3, f3, 0.083333; 	lui.float f6, 0.011111; nop; nop; 
	addi.float f4, f4, 0.033333; 	fmul f2, f1, f0; nop; nop; 
	addi.float f6, f6, 0.011111; 	addi.float f5, f5, 0.017857; nop; nop; 
nop; 	fmul f2, f2, f3; nop; nop; 
nop; 	fmul f3, f1, f2; nop; nop; 
nop; 	fmul f3, f3, f4; nop; nop; 
nop; 	fmul f4, f1, f3; nop; nop; 
nop; 	fmul f4, f4, f5; nop; nop; 
nop; 	fmul f5, f1, f4; nop; nop; 
	lui.float f6, 0.007576; 	fmul f5, f5, f6; nop; nop; 
	addi.float f6, f6, 0.007576; 	fmul f1, f1, f5; nop; nop; 
	lui.float f6, 1.000000; 	fmul f1, f1, f6; nop; nop; 
nop; 	addi.float f6, f6, 1.000000; nop; nop; 
nop; 	fsub f0, f6, f0; nop; nop; 
nop; 	fadd f0, f0, f2; nop; nop; 
nop; 	fsub f0, f0, f3; nop; nop; 
nop; 	fadd f0, f0, f4; nop; nop; 
nop; 	fsub f0, f0, f5; nop; nop; 
	ret; 	fadd f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
cos:
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi sp, sp, -1; nop; nop; 
nop; 	addi.float f2, f2, 2.000000; nop; nop; 
	call pi_div.122; 	fmul f1, f1, f2; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 1; nop; nop; 
	call pi4div.125; 	addi sp, sp, -1; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 1; 	lw f1, 0(a0); 	lw f0, 4(a0); 
	addi sp, sp, -3; 	addi f0, f1, 0; nop; 	sw f0, 0(sp); 
	call tailor_cos.129; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw f1, 0(sp); 
	ret; 	fmul f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
sin:
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	addi sp, sp, -1; nop; nop; 
nop; 	addi.float f2, f2, 2.000000; nop; nop; 
	call pi_div.122; 	fmul f1, f1, f2; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 1; nop; nop; 
	call pi4div2.127; 	addi sp, sp, -1; nop; nop; 
nop; nop; nop; nop; 
	lui.float f2, 3.141593; 	addi sp, sp, 1; 	lw f1, 0(a0); 	lw f0, 4(a0); 
	addi.float f2, f2, 3.141593; 	lui.float f3, 2.000000; nop; 	sw f0, 0(sp); 
	addi.float f3, f3, 2.000000; 	addi sp, sp, -3; nop; nop; 
nop; 	fdiv f2, f2, f3; nop; nop; 
nop; 	fsub f1, f2, f1; nop; nop; 
	call tailor_cos.129; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw f1, 0(sp); 
	ret; 	fmul f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
tailor_atan.135:
	lui.float f3, 0.333333; 	fmul f1, f0, f0; nop; nop; 
	lui.float f5, 0.714286; 	lui.float f4, 0.600000; nop; nop; 
	fmul f2, f1, f0; 	lui.float f6, 0.777778; nop; nop; 
	addi.float f4, f4, 0.600000; 	addi.float f3, f3, 0.333333; nop; nop; 
	addi.float f6, f6, 0.777778; 	addi.float f5, f5, 0.714286; nop; nop; 
nop; 	fmul f2, f2, f3; nop; nop; 
	fsub f0, f0, f2; 	fmul f3, f1, f2; nop; nop; 
nop; 	fmul f3, f3, f4; nop; nop; 
	fadd f0, f0, f3; 	fmul f4, f1, f3; nop; nop; 
nop; 	fmul f4, f4, f5; nop; nop; 
	fsub f0, f0, f4; 	fmul f5, f1, f4; nop; nop; 
	lui.float f6, 0.818182; 	fmul f5, f5, f6; nop; nop; 
	addi.float f6, f6, 0.818182; 	fmul f1, f1, f5; nop; nop; 
	fmul f1, f1, f6; 	fadd f0, f0, f5; nop; nop; 
	ret; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
atan:
nop; 	lui.float f1, 0.000000; nop; nop; 
nop; 	addi.float f1, f1, 0.000000; nop; nop; 
nop; 	fle a20, f1, f0; nop; nop; 
	beq a20, zero, fble_else.324; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
nop; 	fle a20, f0, f1; nop; nop; 
	beq a20, zero, fble_else.325; nop; nop; nop; 
nop; 	lui.float f1, 0.414214; nop; nop; 
nop; 	addi.float f1, f1, 0.414214; nop; nop; 
nop; 	fle a20, f0, f1; nop; nop; 
	beq a20, zero, fble_else.326; nop; nop; nop; 
	jump tailor_atan.135; nop; nop; nop; 
fble_else.326:
	lui.float f2, 4.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f1, f1, 3.141593; 	lui.float f3, 1.000000; nop; nop; 
	addi.float f3, f3, 1.000000; 	addi.float f2, f2, 4.000000; nop; nop; 
	lui.float f2, 1.000000; 	fdiv f1, f1, f2; nop; nop; 
	addi sp, sp, -3; 	addi.float f2, f2, 1.000000; nop; 	sw f1, 0(sp); 
	fadd f0, f3, f0; 	fsub f2, f0, f2; nop; nop; 
	call atan; 	fdiv f0, f2, f0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw f1, 0(sp); 
	ret; 	fadd f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
fble_else.325:
	lui.float f2, 2.000000; 	lui.float f1, 3.141593; nop; nop; 
	addi.float f2, f2, 2.000000; 	addi.float f1, f1, 3.141593; nop; nop; 
	lui.float f2, 1.000000; 	fdiv f1, f1, f2; nop; nop; 
	addi sp, sp, -5; 	addi.float f2, f2, 1.000000; nop; 	sw f1, -2(sp); 
	call atan; 	fdiv f0, f2, f0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; nop; nop; 	lw f1, -2(sp); 
	ret; 	fsub f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
fble_else.324:
	addi sp, sp, -5; 	fneg f0, f0; nop; nop; 
	call atan; nop; nop; nop; 
	fneg f0, f0; 	addi sp, sp, 5; nop; nop; 
	ret; nop; nop; nop; 
vecunit_sgn.2519:
nop; 	addi a3, zero, 0; 	lw f1, 1(a0); 	lw f0, 0(a0); 
	fmul f1, f1, f1; 	fmul f0, f0, f0; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 2(a0); 
nop; 	fmul f1, f1, f1; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	fsqrt f0, f0; nop; nop; 
nop; 	feq a2, f0, fzero; nop; nop; 
	bne a2, a3, be_else.15628; nop; nop; nop; 
	bne a1, a3, be_else.15630; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15631; 	fdiv f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
be_else.15630:
nop; 	lui.float f1, -1.000000; nop; nop; 
nop; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; 	fdiv f0, f1, f0; nop; nop; 
be_cont.15631:
	jump be_cont.15629; nop; nop; nop; 
be_else.15628:
nop; 	lui.float f0, 1.000000; nop; nop; 
nop; 	addi.float f0, f0, 1.000000; nop; nop; 
be_cont.15629:
nop; nop; nop; 	lw f1, 0(a0); 
nop; 	fmul f1, f1, f0; nop; nop; 
nop; nop; 	lw f1, 1(a0); 	sw f1, 0(a0); 
nop; 	fmul f1, f1, f0; nop; nop; 
nop; nop; 	lw f1, 2(a0); 	sw f1, 1(a0); 
nop; 	fmul f0, f1, f0; nop; nop; 
	ret; nop; nop; 	sw f0, 2(a0); 
nop; nop; nop; nop; 
vecaccum.2530:
nop; nop; 	lw f2, 0(a1); 	lw f1, 0(a0); 
nop; 	fmul f2, f0, f2; nop; nop; 
nop; 	fadd f1, f1, f2; nop; 	lw f2, 1(a1); 
nop; 	fmul f2, f0, f2; 	lw f1, 1(a0); 	sw f1, 0(a0); 
nop; 	fadd f1, f1, f2; nop; 	lw f2, 2(a1); 
nop; 	fmul f0, f0, f2; 	lw f1, 2(a0); 	sw f1, 1(a0); 
nop; 	fadd f0, f1, f0; nop; nop; 
	ret; nop; nop; 	sw f0, 2(a0); 
nop; nop; nop; nop; 
vecaccumv.2543:
nop; nop; 	lw f1, 0(a1); 	lw f0, 0(a0); 
nop; nop; nop; 	lw f2, 0(a2); 
nop; 	fmul f1, f1, f2; nop; 	lw f2, 1(a2); 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 1(a1); 
nop; 	fmul f1, f1, f2; 	lw f0, 1(a0); 	sw f0, 0(a0); 
nop; 	fadd f0, f0, f1; 	lw f1, 2(a1); 	lw f2, 2(a2); 
nop; 	fmul f1, f1, f2; 	lw f0, 2(a0); 	sw f0, 1(a0); 
nop; 	fadd f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 2(a0); 
nop; nop; nop; nop; 
read_screen_settings.2620:
	call read_float; 	addi sp, sp, -1; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 1; nop; nop; 
nop; 	addi a0, a0, 61; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call read_float; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 3; nop; nop; 
nop; 	addi a0, a0, 61; nop; 	lw a1, 0(sp); 
	addi a0, zero, 2; 	add a22, a0, a1; nop; nop; 
nop; 	addi sp, sp, -3; 	sw a0, -1(sp); 	sw f0, 0(a22); 
	call read_float; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 3; nop; nop; 
	addi sp, sp, -3; 	addi a0, a0, 61; nop; 	lw a1, -1(sp); 
nop; 	add a22, a0, a1; nop; nop; 
	call read_float; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 3; nop; nop; 
nop; 	addi.float f1, f1, 0.017453; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw f0, -2(sp); 
	call cos; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -5; 	sw f0, -3(sp); 	lw f1, -2(sp); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	sw f0, -4(sp); 
	call read_float; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 7; nop; nop; 
nop; 	addi.float f1, f1, 0.017453; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	sw f0, -5(sp); 
	call cos; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -9; 	sw f0, -6(sp); 	lw f1, -5(sp); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
	lui.float f3, 200.000000; 	addi sp, sp, 9; nop; nop; 
	lui a1, 4096; 	lui a0, 4096; nop; 	lw f1, -3(sp); 
	lui a2, 4096; 	lui.float f5, 200.000000; nop; nop; 
	fmul f2, f1, f0; 	addi.float f3, f3, 200.000000; nop; nop; 
	addi a1, a1, 158; 	addi a0, a0, 158; nop; nop; 
	addi a2, a2, 61; 	addi.float f5, f5, 200.000000; nop; nop; 
nop; 	fmul f2, f2, f3; nop; 	lw f3, -4(sp); 
	lui.float f2, -200.000000; 	addi a0, zero, 1; nop; 	sw f2, 0(a0); 
	add a22, a1, a0; 	addi.float f2, f2, -200.000000; nop; nop; 
	lui a1, 4096; 	addi a0, zero, 2; nop; nop; 
	addi a1, a1, 158; 	fmul f2, f3, f2; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; 	lw f2, -6(sp); 	sw f2, 0(a22); 
	fmul f4, f1, f2; 	lui a1, 4096; nop; nop; 
	fmul f4, f4, f5; 	addi a0, a0, 152; nop; nop; 
	lui.float f4, 0.000000; 	addi a1, a1, 152; 	sw f2, 0(a0); 	sw f4, 0(a22); 
	addi.float f4, f4, 0.000000; 	addi a0, zero, 1; nop; nop; 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
	fneg f4, f0; 	lui a1, 4096; nop; 	sw f4, 0(a22); 
nop; 	addi a1, a1, 152; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; nop; nop; 
	addi a0, a0, 155; 	lui a1, 4096; nop; 	sw f4, 0(a22); 
	addi a1, a1, 155; 	fneg f4, f3; nop; nop; 
nop; 	fmul f0, f4, f0; nop; nop; 
	fneg f0, f1; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
	fneg f0, f3; 	lui a1, 4096; nop; 	sw f0, 0(a22); 
	addi a1, a1, 155; 	fmul f0, f0, f2; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; nop; nop; 
	addi a0, a0, 61; 	addi a1, zero, 1; nop; 	sw f0, 0(a22); 
	lui a0, 4096; 	add a22, a2, a1; nop; 	lw f0, 0(a0); 
	lui a2, 4096; 	addi a1, zero, 1; nop; nop; 
	addi a2, a2, 158; 	addi a0, a0, 158; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw f1, 0(a0); 
	addi a0, a0, 64; 	fsub f0, f0, f1; nop; nop; 
	add a22, a2, a1; 	addi a0, zero, 1; 	lw f0, 0(a22); 	sw f0, 0(a0); 
	lui a2, 4096; 	lui a1, 4096; nop; 	lw f1, 0(a22); 
	addi a1, a1, 64; 	fsub f0, f0, f1; nop; nop; 
	add a22, a1, a0; 	addi a2, a2, 61; nop; nop; 
	addi a1, zero, 2; 	addi a0, zero, 2; nop; 	sw f0, 0(a22); 
	addi a1, zero, 2; 	add a22, a2, a1; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f0, 0(a22); 
nop; 	addi a2, a2, 158; nop; nop; 
	lui a1, 4096; 	add a22, a2, a1; nop; nop; 
nop; 	addi a1, a1, 64; nop; 	lw f1, 0(a22); 
	add a22, a1, a0; 	fsub f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
read_light.2622:
	call read_int; 	addi sp, sp, -1; nop; nop; 
nop; 	addi sp, sp, 1; nop; nop; 
	call read_float; 	addi sp, sp, -1; nop; nop; 
nop; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 1; nop; nop; 
nop; 	addi.float f1, f1, 0.017453; nop; nop; 
nop; 	fmul f0, f0, f1; nop; 	sw f1, -1(sp); 
nop; 	addi sp, sp, -3; nop; 	sw f0, 0(sp); 
	call sin; nop; nop; nop; 
	addi a0, zero, 1; 	addi sp, sp, 3; nop; nop; 
	lui a1, 4096; 	fneg f0, f0; nop; nop; 
	addi a1, a1, 67; 	addi sp, sp, -3; nop; nop; 
nop; 	add a22, a1, a0; nop; nop; 
	call read_float; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw f1, -1(sp); 
nop; 	fmul f0, f0, f1; nop; 	lw f1, 0(sp); 
	addi sp, sp, -5; 	addi f0, f1, 0; nop; 	sw f0, -2(sp); 
	call cos; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -5; 	sw f0, -3(sp); 	lw f1, -2(sp); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 5; nop; nop; 
nop; 	addi a0, a0, 67; nop; 	lw f1, -3(sp); 
nop; 	fmul f0, f1, f0; nop; nop; 
nop; 	addi sp, sp, -5; 	lw f0, -2(sp); 	sw f0, 0(a0); 
	call cos; nop; nop; nop; 
	addi a0, zero, 2; 	addi sp, sp, 5; nop; nop; 
	addi sp, sp, -5; 	lui a1, 4096; nop; 	lw f1, -3(sp); 
	addi a1, a1, 67; 	fmul f0, f1, f0; nop; nop; 
nop; 	add a22, a1, a0; nop; nop; 
	call read_float; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 5; nop; nop; 
nop; 	addi a0, a0, 70; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
rotate_quadratic_matrix.2624:
nop; nop; 	sw a0, 0(sp); 	lw f0, 0(a1); 
nop; 	addi sp, sp, -3; nop; 	sw a1, -1(sp); 
	call cos; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; 	addi sp, sp, -5; 	sw f0, -2(sp); 	lw a0, -1(sp); 
nop; nop; nop; 	lw f1, 0(a0); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -5; 	sw f0, -3(sp); 	lw a0, -1(sp); 
nop; nop; nop; 	lw f1, 1(a0); 
	call cos; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -7; 	sw f0, -4(sp); 	lw a0, -1(sp); 
nop; nop; nop; 	lw f1, 1(a0); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; 	sw f0, -5(sp); 	lw a0, -1(sp); 
nop; nop; nop; 	lw f1, 2(a0); 
	call cos; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -9; 	sw f0, -6(sp); 	lw a0, -1(sp); 
nop; nop; nop; 	lw f1, 2(a0); 
	call sin; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw f2, -4(sp); 	lw f1, -6(sp); 
nop; 	fmul f3, f2, f1; 	lw f5, -3(sp); 	lw f4, -5(sp); 
	fmul f9, f5, f0; 	fmul f6, f5, f4; 	lw a0, 0(sp); 	lw f7, -2(sp); 
	fmul f12, f3, f3; 	fmul f10, f5, f4; nop; nop; 
	fmul f8, f7, f0; 	fmul f6, f6, f1; nop; nop; 
	fmul f10, f10, f0; 	fmul f11, f7, f1; nop; nop; 
	fadd f10, f10, f11; 	fsub f6, f6, f8; nop; nop; 
	fmul f11, f7, f4; 	fmul f8, f7, f4; nop; 	sw f10, -8(sp); 
	fmul f1, f5, f1; 	fmul f8, f8, f1; nop; nop; 
	fmul f9, f2, f0; 	fadd f8, f8, f9; nop; nop; 
	fmul f9, f9, f9; 	fmul f0, f11, f0; 	lw f11, 2(a0); 	sw f9, -7(sp); 
	fneg f1, f4; 	fsub f0, f0, f1; nop; nop; 
	fmul f2, f7, f2; 	fmul f4, f5, f2; 	lw f7, 1(a0); 	lw f5, 0(a0); 
	fmul f9, f7, f9; 	fmul f12, f5, f12; nop; nop; 
	fmul f12, f1, f1; 	fadd f9, f12, f9; nop; nop; 
nop; 	fmul f12, f11, f12; nop; nop; 
	fmul f12, f10, f10; 	fadd f9, f9, f12; nop; nop; 
	fmul f12, f7, f12; 	fmul f10, f7, f10; nop; 	sw f9, 0(a0); 
	fmul f10, f10, f0; 	fmul f9, f6, f6; nop; nop; 
nop; 	fmul f9, f5, f9; nop; nop; 
	fmul f12, f4, f4; 	fadd f9, f9, f12; nop; nop; 
nop; 	fmul f12, f11, f12; nop; nop; 
	fmul f12, f0, f0; 	fadd f9, f9, f12; nop; nop; 
	fmul f9, f8, f8; 	fmul f12, f7, f12; nop; 	sw f9, 1(a0); 
nop; 	fmul f9, f5, f9; nop; nop; 
	fmul f12, f2, f2; 	fadd f9, f9, f12; nop; nop; 
nop; 	fmul f12, f11, f12; nop; nop; 
	fmul f12, f5, f6; 	fadd f9, f9, f12; nop; nop; 
	lui.float f9, 2.000000; 	fmul f12, f12, f8; 	lw a0, -1(sp); 	sw f9, 2(a0); 
	fadd f10, f12, f10; 	addi.float f9, f9, 2.000000; nop; nop; 
nop; 	fmul f12, f11, f4; nop; nop; 
nop; 	fmul f12, f12, f2; nop; nop; 
nop; 	fadd f10, f10, f12; nop; nop; 
	fmul f10, f5, f3; 	fmul f9, f9, f10; nop; nop; 
	lui.float f9, 2.000000; 	fmul f8, f10, f8; 	lw f10, -7(sp); 	sw f9, 0(a0); 
	fmul f12, f7, f10; 	addi.float f9, f9, 2.000000; nop; nop; 
nop; 	fmul f0, f12, f0; nop; nop; 
	fmul f8, f11, f1; 	fadd f0, f8, f0; nop; nop; 
	fmul f2, f8, f2; 	fmul f1, f11, f1; nop; nop; 
	fmul f1, f1, f4; 	fadd f0, f0, f2; nop; nop; 
	fmul f0, f9, f0; 	fmul f2, f5, f3; nop; 	lw f5, -8(sp); 
	fmul f2, f2, f6; 	fmul f3, f7, f10; nop; 	sw f0, 1(a0); 
	fmul f3, f3, f5; 	lui.float f0, 2.000000; nop; nop; 
	fadd f2, f2, f3; 	addi.float f0, f0, 2.000000; nop; nop; 
nop; 	fadd f1, f2, f1; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 2(a0); 
nop; nop; nop; nop; 
read_nth_object.2627:
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call read_int; nop; nop; nop; 
	lui a1, 1048575; 	addi sp, sp, 3; nop; nop; 
nop; 	addi a1, a1, 4095; nop; nop; 
	bne a0, a1, be_else.15638; nop; nop; nop; 
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.15638:
nop; 	addi sp, sp, -3; nop; 	sw a0, -1(sp); 
	call read_int; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw a0, -2(sp); 
	call read_int; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw a0, -3(sp); 
	call read_int; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 5; nop; nop; 
	add a0, a1, zero; 	lui.float f0, 0.000000; nop; 	sw a0, -4(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -7; nop; nop; 
	call create_float_array; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	sw a0, -5(sp); 
	call read_float; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	lw a0, -5(sp); 
	call read_float; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	lw a0, -5(sp); 
	call read_float; nop; nop; 	sw f0, 1(a0); 
nop; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	lw a0, -5(sp); 
	add a0, a1, zero; 	lui.float f0, 0.000000; nop; 	sw f0, 2(a0); 
	call create_float_array; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	sw a0, -6(sp); 
	call read_float; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	lw a0, -6(sp); 
	call read_float; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	lw a0, -6(sp); 
	call read_float; nop; nop; 	sw f0, 1(a0); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	lw a0, -6(sp); 
	call read_float; nop; nop; 	sw f0, 2(a0); 
nop; nop; nop; nop; 
	flt a0, f0, fzero; 	addi sp, sp, 9; nop; nop; 
	lui.float f0, 0.000000; 	addi a1, zero, 2; nop; 	sw a0, -7(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -9; nop; nop; 
	call create_float_array; 	add a0, a1, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	sw a0, -8(sp); 
	call read_float; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	lw a0, -8(sp); 
	call read_float; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	lw a0, -8(sp); 
	add a0, a1, zero; 	lui.float f0, 0.000000; nop; 	sw f0, 1(a0); 
	call create_float_array; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	sw a0, -9(sp); 
	call read_float; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	lw a0, -9(sp); 
	call read_float; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	lw a0, -9(sp); 
	call read_float; nop; nop; 	sw f0, 1(a0); 
nop; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	lw a0, -9(sp); 
	add a0, a1, zero; 	lui.float f0, 0.000000; nop; 	sw f0, 2(a0); 
	call create_float_array; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 11; nop; nop; 
nop; nop; nop; 	lw a2, -4(sp); 
	bne a2, a1, be_else.15639; nop; nop; nop; 
	jump be_cont.15640; nop; nop; nop; 
be_else.15639:
nop; 	addi sp, sp, -13; nop; 	sw a0, -10(sp); 
	call read_float; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 13; nop; nop; 
	addi sp, sp, -13; 	addi.float f1, f1, 0.017453; nop; 	lw a0, -10(sp); 
nop; 	fmul f0, f0, f1; nop; nop; 
	call read_float; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 13; nop; nop; 
	addi sp, sp, -13; 	addi.float f1, f1, 0.017453; nop; 	lw a0, -10(sp); 
nop; 	fmul f0, f0, f1; nop; nop; 
	call read_float; nop; nop; 	sw f0, 1(a0); 
nop; nop; nop; nop; 
	lui.float f1, 0.017453; 	addi sp, sp, 13; nop; nop; 
nop; 	addi.float f1, f1, 0.017453; nop; 	lw a0, -10(sp); 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; 	sw f0, 2(a0); 
be_cont.15640:
nop; 	addi a1, zero, 2; nop; 	lw a2, -2(sp); 
	bne a2, a1, be_else.15641; nop; nop; nop; 
	jump be_cont.15642; 	addi a1, zero, 1; nop; nop; 
be_else.15641:
nop; nop; nop; 	lw a1, -7(sp); 
be_cont.15642:
	lui.float f0, 0.000000; 	addi a3, zero, 4; 	sw a0, -10(sp); 	sw a1, -11(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -13; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 13; nop; nop; 
nop; 	addi hp, hp, 12; 	lw a2, -9(sp); 	sw a0, 10(a1); 
nop; nop; 	lw a4, -3(sp); 	lw a3, -4(sp); 
nop; nop; 	lw a6, 0(sp); 	lw a5, -1(sp); 
nop; nop; 	sw a2, 8(a1); 	lw a0, -10(sp); 
nop; nop; 	sw a4, 2(a1); 	sw a3, 3(a1); 
nop; 	lui a5, 4096; 	lw a2, -8(sp); 	sw a5, 0(a1); 
nop; 	addi a5, a5, 1; 	lw a4, -2(sp); 	sw a0, 9(a1); 
nop; 	add a22, a5, a6; 	sw a4, 1(a1); 	sw a2, 7(a1); 
nop; nop; 	sw a1, 0(a22); 	lw a2, -11(sp); 
nop; nop; 	lw a2, -6(sp); 	sw a2, 6(a1); 
nop; nop; 	lw a2, -5(sp); 	sw a2, 5(a1); 
nop; 	addi a1, zero, 3; nop; 	sw a2, 4(a1); 
	bne a4, a1, be_else.15643; nop; nop; nop; 
nop; 	addi a4, zero, 0; nop; 	lw f0, 0(a2); 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15645; nop; nop; nop; 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15647; nop; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a4, be_else.15649; nop; nop; nop; 
nop; 	lui.float f1, -1.000000; nop; nop; 
	jump be_cont.15650; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.15649:
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
be_cont.15650:
	jump be_cont.15648; nop; nop; nop; 
be_else.15647:
nop; 	lui.float f1, 0.000000; nop; nop; 
nop; 	addi.float f1, f1, 0.000000; nop; nop; 
be_cont.15648:
nop; 	fmul f0, f0, f0; nop; nop; 
	jump be_cont.15646; 	fdiv f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
be_else.15645:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
be_cont.15646:
nop; nop; 	lw f0, 1(a2); 	sw f0, 0(a2); 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15651; nop; nop; nop; 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15653; nop; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a4, be_else.15655; nop; nop; nop; 
nop; 	lui.float f1, -1.000000; nop; nop; 
	jump be_cont.15656; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.15655:
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
be_cont.15656:
	jump be_cont.15654; nop; nop; nop; 
be_else.15653:
nop; 	lui.float f1, 0.000000; nop; nop; 
nop; 	addi.float f1, f1, 0.000000; nop; nop; 
be_cont.15654:
nop; 	fmul f0, f0, f0; nop; nop; 
	jump be_cont.15652; 	fdiv f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
be_else.15651:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
be_cont.15652:
nop; nop; 	lw f0, 2(a2); 	sw f0, 1(a2); 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15657; nop; nop; nop; 
nop; 	feq a1, f0, fzero; nop; nop; 
	bne a1, a4, be_else.15659; nop; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a4, be_else.15661; nop; nop; nop; 
nop; 	lui.float f1, -1.000000; nop; nop; 
	jump be_cont.15662; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.15661:
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
be_cont.15662:
	jump be_cont.15660; nop; nop; nop; 
be_else.15659:
nop; 	lui.float f1, 0.000000; nop; nop; 
nop; 	addi.float f1, f1, 0.000000; nop; nop; 
be_cont.15660:
nop; 	fmul f0, f0, f0; nop; nop; 
	jump be_cont.15658; 	fdiv f0, f1, f0; nop; nop; 
nop; nop; nop; nop; 
be_else.15657:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
be_cont.15658:
	jump be_cont.15644; nop; nop; 	sw f0, 2(a2); 
be_else.15643:
nop; 	addi a1, zero, 2; nop; nop; 
	bne a4, a1, be_else.15663; nop; nop; nop; 
nop; 	addi a1, zero, 0; nop; 	lw a4, -7(sp); 
	bne a4, a1, be_else.15665; nop; nop; nop; 
	jump be_cont.15666; 	addi a4, zero, 1; nop; nop; 
be_else.15665:
nop; 	add a4, a1, zero; nop; nop; 
be_cont.15666:
	add a0, a2, zero; 	add a1, a4, zero; nop; nop; 
	call vecunit_sgn.2519; 	addi sp, sp, -13; nop; nop; 
	jump be_cont.15664; 	addi sp, sp, 13; nop; nop; 
be_else.15663:
be_cont.15664:
be_cont.15644:
nop; 	addi a0, zero, 0; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.15667; nop; nop; nop; 
	jump be_cont.15668; nop; nop; nop; 
be_else.15667:
nop; 	addi sp, sp, -13; 	lw a1, -10(sp); 	lw a0, -5(sp); 
	call rotate_quadratic_matrix.2624; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
be_cont.15668:
	ret; 	addi a0, zero, 1; nop; nop; 
read_object.2629:
nop; 	addi a2, zero, 60; nop; 	lw a1, 1(cl); 
	blt a0, a2, ble_else.15669; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.15669:
nop; 	add cl, a1, zero; 	sw a1, -1(sp); 	sw cl, 0(sp); 
nop; 	addi sp, sp, -5; 	sw a0, -3(sp); 	sw a2, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 5; nop; nop; 
	bne a0, a1, be_else.15671; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a1, -3(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	ret; nop; nop; 	sw a1, 0(a0); 
nop; nop; nop; nop; 
be_else.15671:
nop; nop; 	lw a2, -2(sp); 	lw a0, -3(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
	blt a0, a2, ble_else.15673; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.15673:
nop; 	addi sp, sp, -7; 	sw a0, -4(sp); 	lw cl, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15675; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a1, -4(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	ret; nop; nop; 	sw a1, 0(a0); 
nop; nop; nop; nop; 
be_else.15675:
nop; nop; 	lw a2, -2(sp); 	lw a0, -4(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
	blt a0, a2, ble_else.15677; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.15677:
nop; 	addi sp, sp, -7; 	sw a0, -5(sp); 	lw cl, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15679; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a1, -5(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	ret; nop; nop; 	sw a1, 0(a0); 
nop; nop; nop; nop; 
be_else.15679:
nop; nop; 	lw a2, -2(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
	blt a0, a2, ble_else.15681; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.15681:
nop; 	addi sp, sp, -9; 	sw a0, -6(sp); 	lw cl, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15683; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a1, -6(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	ret; nop; nop; 	sw a1, 0(a0); 
nop; nop; nop; nop; 
be_else.15683:
nop; nop; 	lw cl, 0(sp); 	lw a0, -6(sp); 
nop; 	addi a0, a0, 1; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
read_net_item.2633:
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call read_int; nop; nop; nop; 
	lui a1, 1048575; 	addi sp, sp, 3; nop; nop; 
nop; 	addi a1, a1, 4095; nop; nop; 
	bne a0, a1, be_else.15685; nop; nop; nop; 
nop; nop; nop; 	lw a0, 0(sp); 
	jump create_array; 	addi a0, a0, 1; nop; nop; 
nop; nop; nop; nop; 
be_else.15685:
nop; nop; 	sw a0, -1(sp); 	lw a2, 0(sp); 
nop; 	addi a3, a2, 1; nop; 	sw a1, -3(sp); 
nop; 	addi sp, sp, -5; nop; 	sw a3, -2(sp); 
	call read_int; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; nop; nop; 	lw a1, -3(sp); 
	bne a0, a1, be_else.15686; nop; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	lw a0, -2(sp); 
	call create_array; 	addi a0, a0, 1; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.15687; 	addi sp, sp, 5; nop; nop; 
be_else.15686:
nop; 	addi sp, sp, -7; 	sw a0, -4(sp); 	lw a1, -2(sp); 
nop; 	addi a2, a1, 1; nop; nop; 
	call read_net_item.2633; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a2, -4(sp); 	lw a1, -2(sp); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	sw a2, 0(a22); 
be_cont.15687:
nop; nop; 	lw a2, -1(sp); 	lw a1, 0(sp); 
nop; 	add a22, a1, a0; nop; nop; 
	ret; nop; nop; 	sw a2, 0(a22); 
nop; nop; nop; nop; 
read_or_network.2635:
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call read_int; nop; nop; nop; 
	lui a1, 1048575; 	addi sp, sp, 3; nop; nop; 
nop; 	addi a1, a1, 4095; nop; nop; 
	bne a0, a1, be_else.15688; nop; nop; nop; 
	lui a1, 1048575; 	addi a0, zero, 1; nop; nop; 
	addi a1, a1, 4095; 	addi sp, sp, -3; nop; nop; 
	call create_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 3; nop; nop; 
	jump be_cont.15689; nop; nop; nop; 
be_else.15688:
	addi sp, sp, -3; 	addi a1, zero, 1; nop; 	sw a0, -1(sp); 
	call read_net_item.2633; 	add a0, a1, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw a1, -1(sp); 
nop; 	add a1, a0, zero; nop; 	sw a1, 0(a0); 
be_cont.15689:
nop; 	lui a2, 1048575; nop; 	lw a0, 0(a1); 
nop; 	addi a2, a2, 4095; nop; nop; 
	bne a0, a2, be_else.15690; nop; nop; nop; 
nop; nop; nop; 	lw a0, 0(sp); 
	jump create_array; 	addi a0, a0, 1; nop; nop; 
nop; nop; nop; nop; 
be_else.15690:
nop; 	addi a3, zero, 0; 	sw a1, -2(sp); 	lw a0, 0(sp); 
	add a0, a3, zero; 	addi a2, a0, 1; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw a2, -3(sp); 
	call read_net_item.2633; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 5; nop; nop; 
nop; 	lui a2, 1048575; nop; 	lw a0, 0(a1); 
nop; 	addi a2, a2, 4095; nop; nop; 
	bne a0, a2, be_else.15691; nop; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	lw a0, -3(sp); 
	call create_array; 	addi a0, a0, 1; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.15692; 	addi sp, sp, 5; nop; nop; 
be_else.15691:
nop; 	addi sp, sp, -7; 	sw a1, -4(sp); 	lw a0, -3(sp); 
nop; 	addi a2, a0, 1; nop; nop; 
	call read_or_network.2635; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a2, -4(sp); 	lw a1, -3(sp); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	sw a2, 0(a22); 
be_cont.15692:
nop; nop; 	lw a2, -2(sp); 	lw a1, 0(sp); 
nop; 	add a22, a1, a0; nop; nop; 
	ret; nop; nop; 	sw a2, 0(a22); 
nop; nop; nop; nop; 
read_and_network.2637:
nop; 	addi sp, sp, -3; 	sw a0, -1(sp); 	sw cl, 0(sp); 
	call read_int; nop; nop; nop; 
	lui a1, 1048575; 	addi sp, sp, 3; nop; nop; 
nop; 	addi a1, a1, 4095; nop; nop; 
	bne a0, a1, be_else.15693; nop; nop; 	sw a1, -2(sp); 
	addi sp, sp, -5; 	addi a0, zero, 1; nop; nop; 
	call create_array; nop; nop; nop; 
	jump be_cont.15694; 	addi sp, sp, 5; nop; nop; 
be_else.15693:
	addi sp, sp, -5; 	addi a2, zero, 1; nop; 	sw a0, -3(sp); 
	call read_net_item.2633; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; nop; nop; 	lw a1, -3(sp); 
nop; nop; nop; 	sw a1, 0(a0); 
be_cont.15694:
nop; nop; 	lw a2, -2(sp); 	lw a1, 0(a0); 
	bne a1, a2, be_else.15695; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15695:
nop; 	lui a1, 4096; nop; 	lw a3, -1(sp); 
nop; 	addi a1, a1, 71; nop; nop; 
	addi a1, zero, 0; 	add a22, a1, a3; nop; nop; 
nop; 	addi a0, a3, 1; nop; 	sw a0, 0(a22); 
	addi sp, sp, -7; 	add a0, a1, zero; nop; 	sw a0, -4(sp); 
	call read_net_item.2633; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; 	lw a1, 0(a0); 
nop; nop; nop; 	lw a2, -2(sp); 
	bne a1, a2, be_else.15697; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15697:
nop; 	lui a1, 4096; 	lw cl, 0(sp); 	lw a2, -4(sp); 
nop; 	addi a1, a1, 71; nop; 	lw swp, 0(cl); 
nop; 	add a22, a1, a2; nop; nop; 
nop; 	addi a0, a2, 1; nop; 	sw a0, 0(a22); 
	jumpr swp; nop; nop; nop; 
solver_rect_surface.2641:
	addi a6, zero, 0; 	add a22, a2, a1; nop; nop; 
nop; nop; nop; 	lw f3, 0(a22); 
nop; 	feq a5, f3, fzero; nop; nop; 
	bne a5, a6, be_else.15699; nop; nop; nop; 
nop; 	add a22, a2, a1; 	lw a0, 6(a0); 	lw a5, 4(a0); 
nop; nop; nop; 	lw f3, 0(a22); 
	bne a0, a6, be_else.15700; 	flt a7, f3, fzero; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.15701; 	add a0, a7, zero; nop; nop; 
be_else.15700:
	bne a7, a6, be_else.15702; nop; nop; nop; 
	jump be_cont.15703; 	addi a0, zero, 1; nop; nop; 
be_else.15702:
nop; 	add a0, a6, zero; nop; nop; 
be_cont.15703:
be_cont.15701:
nop; 	add a22, a2, a5; nop; nop; 
	bne a0, a6, be_else.15704; nop; nop; 	lw f3, 0(a22); 
nop; nop; nop; nop; 
	jump be_cont.15705; 	fneg f3, f3; nop; nop; 
be_else.15704:
be_cont.15705:
	add a22, a2, a1; 	fsub f0, f3, f0; nop; nop; 
nop; 	add a22, a3, a1; nop; 	lw f3, 0(a22); 
	add a22, a3, a5; 	fdiv f0, f0, f3; nop; 	lw f3, 0(a22); 
nop; 	fmul f3, f0, f3; nop; nop; 
nop; 	fadd f1, f3, f1; nop; 	lw f3, 0(a22); 
nop; 	fabs f1, f1; nop; nop; 
nop; 	flt a0, f1, f3; nop; nop; 
	bne a0, a6, be_else.15706; nop; nop; nop; 
	ret; 	add a0, a6, zero; nop; nop; 
be_else.15706:
nop; 	add a22, a4, a1; nop; nop; 
nop; 	add a22, a4, a5; nop; 	lw f1, 0(a22); 
nop; 	fmul f1, f0, f1; nop; nop; 
nop; 	fadd f1, f1, f2; nop; 	lw f2, 0(a22); 
nop; 	fabs f1, f1; nop; nop; 
nop; 	flt a0, f1, f2; nop; nop; 
	bne a0, a6, be_else.15707; nop; nop; nop; 
	ret; 	add a0, a6, zero; nop; nop; 
be_else.15707:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
	ret; nop; nop; nop; 
be_else.15699:
	ret; 	add a0, a6, zero; nop; nop; 
quadratic.2662:
	addi a2, zero, 0; 	fmul f3, f0, f0; nop; 	lw a1, 4(a0); 
nop; nop; 	lw a1, 4(a0); 	lw f4, 0(a1); 
	fmul f4, f1, f1; 	fmul f3, f3, f4; 	lw a1, 4(a0); 	lw f5, 1(a1); 
nop; 	fmul f4, f4, f5; 	lw a1, 3(a0); 	lw f5, 2(a1); 
	fmul f4, f2, f2; 	fadd f3, f3, f4; nop; nop; 
nop; 	fmul f4, f4, f5; nop; nop; 
	bne a1, a2, be_else.15708; 	fadd f3, f3, f4; nop; nop; 
nop; nop; nop; nop; 
	ret; 	fadd f0, f3, fzero; nop; nop; 
be_else.15708:
	fmul f2, f2, f0; 	fmul f4, f1, f2; nop; 	lw a1, 9(a0); 
nop; 	fmul f0, f0, f1; 	lw a1, 9(a0); 	lw f5, 0(a1); 
nop; 	fmul f4, f4, f5; nop; 	lw a0, 9(a0); 
nop; 	fadd f3, f3, f4; 	lw f4, 1(a1); 	lw f1, 2(a0); 
	fmul f0, f0, f1; 	fmul f2, f2, f4; nop; nop; 
nop; 	fadd f2, f3, f2; nop; nop; 
	ret; 	fadd f0, f2, f0; nop; nop; 
nop; nop; nop; nop; 
bilinear.2667:
	addi a2, zero, 0; 	fmul f6, f0, f3; nop; 	lw a1, 4(a0); 
nop; nop; 	lw a1, 4(a0); 	lw f7, 0(a1); 
	fmul f7, f1, f4; 	fmul f6, f6, f7; 	lw a1, 4(a0); 	lw f8, 1(a1); 
nop; 	fmul f7, f7, f8; 	lw a1, 3(a0); 	lw f8, 2(a1); 
	fmul f7, f2, f5; 	fadd f6, f6, f7; nop; nop; 
nop; 	fmul f7, f7, f8; nop; nop; 
	bne a1, a2, be_else.15709; 	fadd f6, f6, f7; nop; nop; 
nop; nop; nop; nop; 
	ret; 	fadd f0, f6, fzero; nop; nop; 
be_else.15709:
	fmul f8, f1, f5; 	fmul f7, f2, f4; nop; 	lw a1, 9(a0); 
	fmul f5, f0, f5; 	fmul f2, f2, f3; nop; nop; 
	fadd f7, f7, f8; 	fmul f1, f1, f3; 	lw a1, 9(a0); 	lw f8, 0(a1); 
	fadd f2, f5, f2; 	fmul f0, f0, f4; 	lw f5, 1(a1); 	lw a0, 9(a0); 
	fmul f2, f2, f5; 	fmul f7, f7, f8; nop; nop; 
	fadd f2, f7, f2; 	fadd f0, f0, f1; nop; 	lw f1, 2(a0); 
	lui.float f1, 0.500000; 	fmul f0, f0, f1; nop; nop; 
	addi.float f1, f1, 0.500000; 	fadd f0, f2, f0; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
	ret; 	fadd f0, f6, f0; nop; nop; 
nop; nop; nop; nop; 
solver_second.2675:
nop; nop; 	lw f4, 1(a1); 	lw f3, 0(a1); 
nop; nop; 	sw f2, 0(sp); 	lw f5, 2(a1); 
	addi f1, f4, 0; 	addi f2, f5, 0; 	sw f0, -2(sp); 	sw f1, -1(sp); 
	addi sp, sp, -7; 	addi f0, f3, 0; 	sw a1, -4(sp); 	sw a0, -3(sp); 
	call quadratic.2662; nop; nop; nop; 
	feq a0, f0, fzero; 	addi sp, sp, 7; nop; nop; 
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15710; nop; nop; nop; 
nop; nop; 	lw f4, -2(sp); 	lw a0, -4(sp); 
nop; nop; 	lw f6, 0(sp); 	lw f5, -1(sp); 
nop; nop; 	lw f1, 0(a0); 	sw f0, -5(sp); 
nop; 	addi f0, f1, 0; 	lw f3, 2(a0); 	lw f2, 1(a0); 
	addi sp, sp, -7; 	addi f1, f2, 0; nop; 	lw a0, -3(sp); 
	addi f3, f4, 0; 	addi f2, f3, 0; nop; nop; 
	addi f5, f6, 0; 	addi f4, f5, 0; nop; nop; 
	call bilinear.2667; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw f2, -1(sp); 	lw f1, -2(sp); 
nop; nop; 	lw a0, -3(sp); 	lw f3, 0(sp); 
	addi sp, sp, -9; 	addi f0, f1, 0; nop; 	sw f0, -6(sp); 
	addi f2, f3, 0; 	addi f1, f2, 0; nop; nop; 
	call quadratic.2662; nop; nop; nop; 
	addi a2, zero, 3; 	addi sp, sp, 9; nop; nop; 
nop; nop; nop; 	lw a0, -3(sp); 
nop; nop; nop; 	lw a1, 1(a0); 
	bne a1, a2, be_else.15711; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15712; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15711:
be_cont.15712:
nop; 	addi a2, zero, 0; 	lw f3, -5(sp); 	lw f1, -6(sp); 
	fmul f0, f3, f0; 	fmul f2, f1, f1; nop; nop; 
nop; 	fsub f0, f2, f0; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a2, be_else.15713; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15713:
nop; 	fsqrt f0, f0; nop; 	lw a0, 6(a0); 
	bne a0, a2, be_else.15714; nop; nop; nop; 
	jump be_cont.15715; 	fneg f0, f0; nop; nop; 
be_else.15714:
be_cont.15715:
	lui a0, 4096; 	fsub f0, f0, f1; nop; nop; 
	addi a0, a0, 122; 	fdiv f0, f0, f3; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
	ret; nop; nop; nop; 
be_else.15710:
	ret; 	add a0, a1, zero; nop; nop; 
solver.2681:
nop; 	lui a4, 4096; 	lw f0, 0(a2); 	lw a3, 6(cl); 
nop; 	addi a4, a4, 1; nop; 	lw cl, 2(cl); 
nop; 	add a22, a4, a0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a4, 5(a0); 
nop; nop; 	lw a4, 5(a0); 	lw f1, 0(a4); 
	addi a4, zero, 1; 	fsub f0, f0, f1; 	lw f1, 1(a2); 	lw f2, 1(a4); 
nop; 	fsub f1, f1, f2; 	lw a2, 5(a0); 	lw f2, 2(a2); 
nop; nop; 	lw a2, 1(a0); 	lw f3, 2(a2); 
	bne a2, a4, be_else.15716; 	fsub f2, f2, f3; nop; nop; 
	addi a4, zero, 2; 	addi a3, zero, 1; 	sw f2, -1(sp); 	sw f0, 0(sp); 
nop; 	addi a2, zero, 0; 	sw a1, -5(sp); 	sw f1, -2(sp); 
nop; nop; 	sw cl, -7(sp); 	sw a0, -6(sp); 
nop; nop; 	sw a4, -3(sp); 	lw swp, 0(cl); 
nop; 	addi sp, sp, -9; nop; 	sw a3, -4(sp); 
	callr swp; nop; nop; nop; 
	addi a4, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a4, be_else.15717; nop; nop; nop; 
nop; nop; 	lw f1, -1(sp); 	lw f0, -2(sp); 
nop; nop; 	lw a0, -6(sp); 	lw f2, 0(sp); 
nop; nop; 	lw a2, -4(sp); 	lw a1, -5(sp); 
nop; 	addi sp, sp, -9; 	lw cl, -7(sp); 	lw a3, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a3, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a3, be_else.15718; nop; nop; nop; 
nop; nop; 	lw f1, 0(sp); 	lw f0, -1(sp); 
nop; nop; 	lw a0, -6(sp); 	lw f2, -2(sp); 
nop; nop; 	lw a2, -3(sp); 	lw a1, -5(sp); 
nop; 	addi sp, sp, -9; 	lw cl, -7(sp); 	lw a4, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15719; nop; nop; nop; 
	ret; 	add a0, a1, zero; nop; nop; 
be_else.15719:
	ret; 	addi a0, zero, 3; nop; nop; 
be_else.15718:
	ret; 	addi a0, zero, 2; nop; nop; 
be_else.15717:
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15716:
nop; 	addi a4, zero, 2; nop; nop; 
	bne a2, a4, be_else.15720; nop; nop; nop; 
nop; 	addi a2, zero, 0; 	lw f3, 0(a1); 	lw a0, 4(a0); 
nop; nop; 	lw f5, 1(a0); 	lw f4, 0(a0); 
nop; 	fmul f3, f3, f4; nop; 	lw f4, 1(a1); 
nop; 	fmul f4, f4, f5; nop; 	lw f5, 2(a0); 
nop; 	fadd f3, f3, f4; nop; 	lw f4, 2(a1); 
nop; 	fmul f4, f4, f5; nop; nop; 
nop; 	fadd f3, f3, f4; nop; nop; 
nop; 	flt a1, fzero, f3; nop; nop; 
	bne a1, a2, be_else.15721; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15721:
nop; nop; nop; 	lw f4, 0(a0); 
nop; 	fmul f0, f4, f0; nop; 	lw f4, 1(a0); 
nop; 	fmul f1, f4, f1; nop; nop; 
	lui a0, 4096; 	fadd f0, f0, f1; nop; 	lw f1, 2(a0); 
	addi a0, a0, 122; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	fneg f0, f0; nop; nop; 
nop; 	fdiv f0, f0, f3; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
	ret; nop; nop; nop; 
be_else.15720:
nop; 	add cl, a3, zero; nop; nop; 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
solver_rect_fast.2685:
nop; 	addi a4, zero, 0; 	lw f4, 1(a2); 	lw f3, 0(a2); 
nop; 	fsub f3, f3, f0; nop; 	lw a3, 4(a0); 
nop; 	fmul f3, f3, f4; 	lw f4, 1(a1); 	lw f5, 1(a3); 
nop; 	fmul f4, f3, f4; nop; nop; 
nop; 	fadd f4, f4, f1; nop; nop; 
nop; 	fabs f4, f4; nop; nop; 
nop; 	flt a3, f4, f5; nop; nop; 
	bne a3, a4, be_else.15722; nop; nop; nop; 
	jump be_cont.15723; 	add a3, a4, zero; nop; nop; 
be_else.15722:
nop; nop; 	lw a3, 4(a0); 	lw f4, 2(a1); 
nop; 	fmul f4, f3, f4; nop; 	lw f5, 2(a3); 
nop; 	fadd f4, f4, f2; nop; nop; 
nop; 	fabs f4, f4; nop; nop; 
nop; 	flt a3, f4, f5; nop; nop; 
	bne a3, a4, be_else.15724; nop; nop; nop; 
	jump be_cont.15725; 	add a3, a4, zero; nop; nop; 
be_else.15724:
nop; nop; nop; 	lw f4, 1(a2); 
nop; 	feq a3, f4, fzero; nop; nop; 
	bne a3, a4, be_else.15726; nop; nop; nop; 
	jump be_cont.15727; 	addi a3, zero, 1; nop; nop; 
be_else.15726:
nop; 	add a3, a4, zero; nop; nop; 
be_cont.15727:
be_cont.15725:
be_cont.15723:
	bne a3, a4, be_else.15728; nop; nop; nop; 
nop; nop; 	lw f4, 3(a2); 	lw f3, 2(a2); 
nop; 	fsub f3, f3, f1; nop; 	lw a3, 4(a0); 
nop; 	fmul f3, f3, f4; 	lw f4, 0(a1); 	lw f5, 0(a3); 
nop; 	fmul f4, f3, f4; nop; nop; 
nop; 	fadd f4, f4, f0; nop; nop; 
nop; 	fabs f4, f4; nop; nop; 
nop; 	flt a3, f4, f5; nop; nop; 
	bne a3, a4, be_else.15729; nop; nop; nop; 
	jump be_cont.15730; 	add a3, a4, zero; nop; nop; 
be_else.15729:
nop; nop; 	lw a3, 4(a0); 	lw f4, 2(a1); 
nop; 	fmul f4, f3, f4; nop; 	lw f5, 2(a3); 
nop; 	fadd f4, f4, f2; nop; nop; 
nop; 	fabs f4, f4; nop; nop; 
nop; 	flt a3, f4, f5; nop; nop; 
	bne a3, a4, be_else.15731; nop; nop; nop; 
	jump be_cont.15732; 	add a3, a4, zero; nop; nop; 
be_else.15731:
nop; nop; nop; 	lw f4, 3(a2); 
nop; 	feq a3, f4, fzero; nop; nop; 
	bne a3, a4, be_else.15733; nop; nop; nop; 
	jump be_cont.15734; 	addi a3, zero, 1; nop; nop; 
be_else.15733:
nop; 	add a3, a4, zero; nop; nop; 
be_cont.15734:
be_cont.15732:
be_cont.15730:
	bne a3, a4, be_else.15735; nop; nop; nop; 
nop; nop; 	lw a3, 4(a0); 	lw f3, 4(a2); 
nop; 	fsub f2, f3, f2; nop; 	lw f3, 5(a2); 
nop; 	fmul f2, f2, f3; nop; 	lw f3, 0(a1); 
nop; 	fmul f3, f2, f3; nop; nop; 
nop; 	fadd f0, f3, f0; nop; 	lw f3, 0(a3); 
nop; 	fabs f0, f0; nop; nop; 
nop; 	flt a3, f0, f3; nop; nop; 
	bne a3, a4, be_else.15736; nop; nop; nop; 
	jump be_cont.15737; 	add a0, a4, zero; nop; nop; 
be_else.15736:
nop; nop; 	lw a0, 4(a0); 	lw f0, 1(a1); 
nop; 	fmul f0, f2, f0; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 1(a0); 
nop; 	fabs f0, f0; nop; nop; 
nop; 	flt a0, f0, f1; nop; nop; 
	bne a0, a4, be_else.15738; nop; nop; nop; 
	jump be_cont.15739; 	add a0, a4, zero; nop; nop; 
be_else.15738:
nop; nop; nop; 	lw f0, 5(a2); 
nop; 	feq a0, f0, fzero; nop; nop; 
	bne a0, a4, be_else.15740; nop; nop; nop; 
	jump be_cont.15741; 	addi a0, zero, 1; nop; nop; 
be_else.15740:
nop; 	add a0, a4, zero; nop; nop; 
be_cont.15741:
be_cont.15739:
be_cont.15737:
	bne a0, a4, be_else.15742; nop; nop; nop; 
	ret; 	add a0, a4, zero; nop; nop; 
be_else.15742:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	addi a0, zero, 3; nop; 	sw f2, 0(a0); 
	ret; nop; nop; nop; 
be_else.15735:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	addi a0, zero, 2; nop; 	sw f3, 0(a0); 
	ret; nop; nop; nop; 
be_else.15728:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f3, 0(a0); 
	ret; nop; nop; nop; 
solver_surface_fast.2692:
nop; 	addi a2, zero, 0; nop; 	lw f3, 0(a1); 
nop; 	flt a0, f3, fzero; nop; nop; 
	bne a0, a2, be_else.15743; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15743:
nop; 	addi a0, zero, 1; nop; 	lw f3, 1(a1); 
nop; 	fmul f0, f3, f0; nop; 	lw f3, 2(a1); 
nop; 	fmul f1, f3, f1; nop; nop; 
	lui a1, 4096; 	fadd f0, f0, f1; nop; 	lw f1, 3(a1); 
	addi a1, a1, 122; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a1); 
nop; nop; nop; nop; 
solver_second_fast.2698:
nop; 	addi a3, zero, 0; nop; 	lw f3, 0(a1); 
nop; 	feq a2, f3, fzero; nop; nop; 
	bne a2, a3, be_else.15744; nop; nop; nop; 
nop; nop; 	lw f5, 2(a1); 	lw f4, 1(a1); 
	fmul f5, f5, f1; 	fmul f4, f4, f0; 	sw f3, -1(sp); 	sw a1, 0(sp); 
nop; 	fadd f4, f4, f5; 	lw f5, 3(a1); 	sw a0, -3(sp); 
nop; 	fmul f5, f5, f2; nop; nop; 
nop; 	fadd f4, f4, f5; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw f4, -2(sp); 
	call quadratic.2662; nop; nop; nop; 
	addi a2, zero, 3; 	addi sp, sp, 5; nop; nop; 
nop; nop; nop; 	lw a0, -3(sp); 
nop; nop; nop; 	lw a1, 1(a0); 
	bne a1, a2, be_else.15745; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15746; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15745:
be_cont.15746:
nop; 	addi a2, zero, 0; 	lw f3, -1(sp); 	lw f1, -2(sp); 
	fmul f0, f3, f0; 	fmul f2, f1, f1; nop; nop; 
nop; 	fsub f0, f2, f0; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a2, be_else.15747; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15747:
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a2, be_else.15748; nop; nop; nop; 
nop; 	fsqrt f0, f0; nop; 	lw a0, 0(sp); 
	lui a0, 4096; 	fsub f0, f1, f0; nop; 	lw f1, 4(a0); 
	addi a0, a0, 122; 	fmul f0, f0, f1; nop; nop; 
	jump be_cont.15749; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
be_else.15748:
nop; 	fsqrt f0, f0; nop; 	lw a0, 0(sp); 
	lui a0, 4096; 	fadd f0, f1, f0; nop; 	lw f1, 4(a0); 
	addi a0, a0, 122; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; 	sw f0, 0(a0); 
be_cont.15749:
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15744:
	ret; 	add a0, a3, zero; nop; nop; 
solver_fast.2704:
nop; 	lui a5, 4096; 	lw a4, 3(cl); 	lw a3, 4(cl); 
nop; 	addi a5, a5, 1; 	lw cl, 2(cl); 	lw f0, 0(a2); 
nop; 	add a22, a5, a0; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; 	lw a7, 5(a5); 	lw a6, 5(a5); 
	addi a7, zero, 2; 	addi a6, zero, 1; 	lw f2, 1(a7); 	lw f1, 0(a6); 
nop; 	fsub f0, f0, f1; nop; 	lw f1, 1(a2); 
nop; 	fsub f1, f1, f2; 	lw a2, 5(a5); 	lw f2, 2(a2); 
nop; nop; 	lw a2, 1(a1); 	lw f3, 2(a2); 
	add a22, a0, a2; 	fsub f2, f2, f3; nop; 	lw a0, 1(a5); 
	bne a0, a6, be_else.15750; nop; nop; 	lw a2, 0(a22); 
nop; 	add a0, a5, zero; 	lw swp, 0(cl); 	lw a1, 0(a1); 
	jumpr swp; nop; nop; nop; 
be_else.15750:
	bne a0, a7, be_else.15751; nop; nop; nop; 
	add a0, a5, zero; 	add a1, a2, zero; nop; nop; 
nop; 	add cl, a4, zero; nop; nop; 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15751:
	add a0, a5, zero; 	add a1, a2, zero; nop; nop; 
nop; 	add cl, a3, zero; nop; nop; 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
solver_second_fast2.2715:
nop; 	addi a4, zero, 0; nop; 	lw f3, 0(a1); 
nop; 	feq a3, f3, fzero; nop; nop; 
	bne a3, a4, be_else.15752; nop; nop; nop; 
nop; nop; nop; 	lw f4, 1(a1); 
nop; 	fmul f0, f4, f0; nop; 	lw f4, 2(a1); 
nop; 	fmul f1, f4, f1; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 3(a1); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 3(a2); 
	fmul f1, f3, f1; 	fmul f2, f0, f0; nop; nop; 
nop; 	fsub f1, f2, f1; nop; nop; 
nop; 	flt a2, fzero, f1; nop; nop; 
	bne a2, a4, be_else.15753; nop; nop; nop; 
	ret; 	add a0, a4, zero; nop; nop; 
be_else.15753:
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a4, be_else.15754; nop; nop; nop; 
	lui a0, 4096; 	fsqrt f1, f1; nop; nop; 
	addi a0, a0, 122; 	fsub f0, f0, f1; nop; 	lw f1, 4(a1); 
nop; 	fmul f0, f0, f1; nop; nop; 
	jump be_cont.15755; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
be_else.15754:
	lui a0, 4096; 	fsqrt f1, f1; nop; nop; 
	addi a0, a0, 122; 	fadd f0, f0, f1; nop; 	lw f1, 4(a1); 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; 	sw f0, 0(a0); 
be_cont.15755:
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15752:
	ret; 	add a0, a4, zero; nop; nop; 
solver_fast2.2722:
	addi a5, zero, 1; 	lui a3, 4096; 	lw a7, 1(a1); 	lw a2, 4(cl); 
	addi a3, a3, 1; 	addi a6, zero, 2; nop; 	lw cl, 2(cl); 
nop; 	add a22, a3, a0; nop; nop; 
nop; 	add a22, a0, a7; nop; 	lw a3, 0(a22); 
nop; nop; 	lw a0, 0(a22); 	lw a4, 10(a3); 
nop; nop; 	lw f0, 0(a4); 	lw a7, 1(a3); 
	bne a7, a5, be_else.15756; nop; 	lw f2, 2(a4); 	lw f1, 1(a4); 
	add a0, a3, zero; 	add a2, a0, zero; 	lw swp, 0(cl); 	lw a1, 0(a1); 
	jumpr swp; nop; nop; nop; 
be_else.15756:
	bne a7, a6, be_else.15757; nop; nop; nop; 
nop; 	addi a2, zero, 0; nop; 	lw f0, 0(a0); 
nop; 	flt a1, f0, fzero; nop; nop; 
	bne a1, a2, be_else.15758; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15758:
nop; 	lui a0, 4096; 	lw f1, 3(a4); 	lw f0, 0(a0); 
	addi a0, a0, 122; 	fmul f0, f0, f1; nop; nop; 
nop; 	add a0, a5, zero; nop; 	sw f0, 0(a0); 
	ret; nop; nop; nop; 
be_else.15757:
	add cl, a2, zero; 	add a1, a0, zero; nop; nop; 
	add a2, a4, zero; 	add a0, a3, zero; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
setup_rect_table.2725:
	lui.float f0, 0.000000; 	addi a2, zero, 6; 	sw a0, -1(sp); 	sw a1, 0(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -3; nop; nop; 
	call create_float_array; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 0; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw a1, -1(sp); 
nop; nop; nop; 	lw f0, 0(a1); 
nop; 	feq a2, f0, fzero; nop; nop; 
	bne a2, a3, be_else.15759; nop; nop; nop; 
nop; nop; 	lw f0, 0(a1); 	lw a2, 0(sp); 
nop; 	flt a5, f0, fzero; nop; 	lw a4, 6(a2); 
	bne a4, a3, be_else.15761; nop; nop; nop; 
	jump be_cont.15762; 	add a4, a5, zero; nop; nop; 
be_else.15761:
	bne a5, a3, be_else.15763; nop; nop; nop; 
	jump be_cont.15764; 	addi a4, zero, 1; nop; nop; 
be_else.15763:
nop; 	add a4, a3, zero; nop; nop; 
be_cont.15764:
be_cont.15762:
nop; nop; nop; 	lw a5, 4(a2); 
	bne a4, a3, be_else.15765; nop; nop; 	lw f0, 0(a5); 
nop; nop; nop; nop; 
	jump be_cont.15766; 	fneg f0, f0; nop; nop; 
be_else.15765:
be_cont.15766:
nop; 	lui.float f0, 1.000000; 	lw f1, 0(a1); 	sw f0, 0(a0); 
nop; 	addi.float f0, f0, 1.000000; nop; nop; 
nop; 	fdiv f0, f0, f1; nop; nop; 
	jump be_cont.15760; nop; nop; 	sw f0, 1(a0); 
nop; nop; nop; nop; 
be_else.15759:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; 	sw f0, 1(a0); 
be_cont.15760:
nop; nop; nop; 	lw f0, 1(a1); 
nop; 	feq a2, f0, fzero; nop; nop; 
	bne a2, a3, be_else.15767; nop; nop; nop; 
nop; nop; 	lw f0, 1(a1); 	lw a2, 0(sp); 
nop; 	flt a5, f0, fzero; nop; 	lw a4, 6(a2); 
	bne a4, a3, be_else.15769; nop; nop; nop; 
	jump be_cont.15770; 	add a4, a5, zero; nop; nop; 
be_else.15769:
	bne a5, a3, be_else.15771; nop; nop; nop; 
	jump be_cont.15772; 	addi a4, zero, 1; nop; nop; 
be_else.15771:
nop; 	add a4, a3, zero; nop; nop; 
be_cont.15772:
be_cont.15770:
nop; nop; nop; 	lw a5, 4(a2); 
	bne a4, a3, be_else.15773; nop; nop; 	lw f0, 1(a5); 
nop; nop; nop; nop; 
	jump be_cont.15774; 	fneg f0, f0; nop; nop; 
be_else.15773:
be_cont.15774:
nop; 	lui.float f0, 1.000000; 	lw f1, 1(a1); 	sw f0, 2(a0); 
nop; 	addi.float f0, f0, 1.000000; nop; nop; 
nop; 	fdiv f0, f0, f1; nop; nop; 
	jump be_cont.15768; nop; nop; 	sw f0, 3(a0); 
nop; nop; nop; nop; 
be_else.15767:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; 	sw f0, 3(a0); 
be_cont.15768:
nop; nop; nop; 	lw f0, 2(a1); 
nop; 	feq a2, f0, fzero; nop; nop; 
	bne a2, a3, be_else.15775; nop; nop; nop; 
nop; nop; 	lw f0, 2(a1); 	lw a2, 0(sp); 
nop; 	flt a5, f0, fzero; nop; 	lw a4, 6(a2); 
	bne a4, a3, be_else.15777; nop; nop; nop; 
	jump be_cont.15778; 	add a4, a5, zero; nop; nop; 
be_else.15777:
	bne a5, a3, be_else.15779; nop; nop; nop; 
	jump be_cont.15780; 	addi a4, zero, 1; nop; nop; 
be_else.15779:
nop; 	add a4, a3, zero; nop; nop; 
be_cont.15780:
be_cont.15778:
nop; nop; nop; 	lw a2, 4(a2); 
	bne a4, a3, be_else.15781; nop; nop; 	lw f0, 2(a2); 
nop; nop; nop; nop; 
	jump be_cont.15782; 	fneg f0, f0; nop; nop; 
be_else.15781:
be_cont.15782:
nop; 	lui.float f0, 1.000000; 	lw f1, 2(a1); 	sw f0, 4(a0); 
nop; 	addi.float f0, f0, 1.000000; nop; nop; 
nop; 	fdiv f0, f0, f1; nop; nop; 
	jump be_cont.15776; nop; nop; 	sw f0, 5(a0); 
nop; nop; nop; nop; 
be_else.15775:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; 	sw f0, 5(a0); 
be_cont.15776:
	ret; nop; nop; nop; 
setup_surface_table.2728:
	lui.float f0, 0.000000; 	addi a2, zero, 4; 	sw a0, -1(sp); 	sw a1, 0(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -3; nop; nop; 
	call create_float_array; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -1(sp); 
nop; nop; 	lw a3, 4(a2); 	lw f0, 0(a1); 
nop; nop; 	lw a3, 4(a2); 	lw f1, 0(a3); 
	addi a3, zero, 0; 	fmul f0, f0, f1; 	lw f1, 1(a1); 	lw f2, 1(a3); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; 	lw a1, 4(a2); 	lw f1, 2(a1); 
nop; nop; nop; 	lw f2, 2(a1); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	flt a1, fzero, f0; nop; nop; 
	bne a1, a3, be_else.15783; nop; nop; nop; 
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
	jump be_cont.15784; nop; nop; 	sw f0, 0(a0); 
nop; nop; nop; nop; 
be_else.15783:
nop; 	lui.float f1, -1.000000; nop; 	lw a1, 4(a2); 
nop; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; 	fdiv f1, f1, f0; nop; nop; 
nop; nop; 	lw f1, 0(a1); 	sw f1, 0(a0); 
nop; 	fdiv f1, f1, f0; nop; 	lw a1, 4(a2); 
nop; 	fneg f1, f1; nop; nop; 
nop; nop; 	lw f1, 1(a1); 	sw f1, 1(a0); 
nop; 	fdiv f1, f1, f0; nop; 	lw a1, 4(a2); 
nop; 	fneg f1, f1; nop; nop; 
nop; nop; 	lw f1, 2(a1); 	sw f1, 2(a0); 
nop; 	fdiv f0, f1, f0; nop; nop; 
nop; 	fneg f0, f0; nop; nop; 
nop; nop; nop; 	sw f0, 3(a0); 
be_cont.15784:
	ret; nop; nop; nop; 
setup_second_table.2731:
	lui.float f0, 0.000000; 	addi a2, zero, 5; 	sw a0, -1(sp); 	sw a1, 0(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -3; nop; nop; 
	call create_float_array; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -1(sp); 
	addi sp, sp, -5; 	add a0, a2, zero; 	lw f0, 0(a1); 	sw a0, -2(sp); 
	call quadratic.2662; nop; 	lw f2, 2(a1); 	lw f1, 1(a1); 
nop; nop; nop; nop; 
	addi a4, zero, 0; 	addi sp, sp, 5; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -1(sp); 
nop; nop; 	lw a2, 4(a1); 	lw f1, 0(a0); 
nop; nop; 	lw f2, 0(a2); 	lw a3, 3(a1); 
nop; 	fmul f1, f1, f2; 	lw f2, 1(a0); 	lw a2, 4(a1); 
nop; 	fneg f1, f1; 	lw a2, 4(a1); 	lw f3, 1(a2); 
nop; 	fmul f2, f2, f3; 	lw f3, 2(a0); 	lw f4, 2(a2); 
	fmul f3, f3, f4; 	fneg f2, f2; nop; 	lw a2, -2(sp); 
	bne a3, a4, be_else.15785; 	fneg f3, f3; nop; 	sw f0, 0(a2); 
nop; nop; nop; nop; 
nop; nop; 	sw f2, 2(a2); 	sw f1, 1(a2); 
	jump be_cont.15786; nop; nop; 	sw f3, 3(a2); 
be_else.15785:
nop; nop; 	lw a3, 9(a1); 	lw f4, 2(a0); 
nop; nop; 	lw a3, 9(a1); 	lw f5, 1(a3); 
nop; 	fmul f4, f4, f5; 	lw f5, 1(a0); 	lw f6, 2(a3); 
nop; 	fmul f5, f5, f6; nop; 	lw a3, 9(a1); 
	lui.float f5, 0.500000; 	fadd f4, f4, f5; nop; nop; 
nop; 	addi.float f5, f5, 0.500000; nop; nop; 
nop; 	fmul f4, f4, f5; nop; nop; 
nop; 	fsub f1, f1, f4; 	lw a3, 9(a1); 	lw f4, 0(a3); 
nop; nop; 	lw f5, 2(a3); 	sw f1, 1(a2); 
nop; nop; 	lw a3, 9(a1); 	lw f1, 2(a0); 
nop; 	fmul f1, f1, f4; nop; 	lw f4, 0(a0); 
nop; 	fmul f4, f4, f5; nop; nop; 
	lui.float f4, 0.500000; 	fadd f1, f1, f4; nop; nop; 
nop; 	addi.float f4, f4, 0.500000; nop; nop; 
nop; 	fmul f1, f1, f4; nop; nop; 
nop; 	fsub f1, f2, f1; nop; 	lw f2, 0(a3); 
nop; nop; 	lw f1, 1(a0); 	sw f1, 2(a2); 
nop; 	fmul f1, f1, f2; 	lw a0, 9(a1); 	lw f2, 0(a0); 
nop; nop; nop; 	lw f4, 1(a0); 
nop; 	fmul f2, f2, f4; nop; nop; 
	lui.float f2, 0.500000; 	fadd f1, f1, f2; nop; nop; 
nop; 	addi.float f2, f2, 0.500000; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fsub f1, f3, f1; nop; nop; 
nop; nop; nop; 	sw f1, 3(a2); 
be_cont.15786:
nop; 	feq a0, f0, fzero; nop; nop; 
	bne a0, a4, be_else.15787; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
nop; 	fdiv f0, f1, f0; nop; nop; 
	jump be_cont.15788; nop; nop; 	sw f0, 4(a2); 
nop; nop; nop; nop; 
be_else.15787:
be_cont.15788:
	ret; 	add a0, a2, zero; nop; nop; 
iter_setup_dirvec_constants.2734:
nop; 	addi a2, zero, 0; nop; nop; 
	blt a1, a2, ble_else.15789; nop; nop; nop; 
	addi a7, zero, 1; 	lui a3, 4096; 	lw a5, 0(a0); 	lw a4, 1(a0); 
nop; 	addi a3, a3, 1; 	sw a0, -2(sp); 	sw cl, 0(sp); 
nop; 	add a22, a3, a1; nop; 	sw a7, -1(sp); 
nop; nop; nop; 	lw a3, 0(a22); 
nop; nop; nop; 	lw a6, 1(a3); 
	bne a6, a7, be_else.15790; nop; nop; nop; 
	add a1, a3, zero; 	add a0, a5, zero; 	sw a4, -4(sp); 	sw a1, -3(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -7; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a2, -4(sp); 	lw a1, -3(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.15791; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.15790:
nop; 	addi a8, zero, 2; nop; nop; 
	bne a6, a8, be_else.15792; nop; nop; nop; 
	add a1, a3, zero; 	add a0, a5, zero; 	sw a4, -4(sp); 	sw a1, -3(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -7; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a2, -4(sp); 	lw a1, -3(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.15793; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.15792:
	add a1, a3, zero; 	add a0, a5, zero; 	sw a4, -4(sp); 	sw a1, -3(sp); 
	call setup_second_table.2731; 	addi sp, sp, -7; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a2, -4(sp); 	lw a1, -3(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.15793:
be_cont.15791:
	addi a1, zero, 0; 	addi a0, a1, -1; nop; nop; 
	blt a0, a1, ble_else.15794; nop; nop; nop; 
nop; 	lui a1, 4096; 	lw a6, -1(sp); 	lw a2, -2(sp); 
nop; 	addi a1, a1, 1; 	lw a4, 0(a2); 	lw a3, 1(a2); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a5, 1(a1); 
	bne a5, a6, be_else.15795; nop; nop; nop; 
	addi sp, sp, -9; 	add a0, a4, zero; 	sw a3, -6(sp); 	sw a0, -5(sp); 
	call setup_rect_table.2725; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.15796; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.15795:
nop; 	addi a6, zero, 2; nop; nop; 
	bne a5, a6, be_else.15797; nop; nop; nop; 
	addi sp, sp, -9; 	add a0, a4, zero; 	sw a3, -6(sp); 	sw a0, -5(sp); 
	call setup_surface_table.2728; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.15798; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.15797:
	addi sp, sp, -9; 	add a0, a4, zero; 	sw a3, -6(sp); 	sw a0, -5(sp); 
	call setup_second_table.2731; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.15798:
be_cont.15796:
nop; 	addi a1, a1, -1; 	lw cl, 0(sp); 	lw a0, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.15794:
	ret; nop; nop; nop; 
ble_else.15789:
	ret; nop; nop; nop; 
setup_startp_constants.2739:
nop; 	addi a2, zero, 0; nop; nop; 
	blt a1, a2, ble_else.15801; nop; nop; nop; 
nop; 	lui a2, 4096; 	sw a0, 0(sp); 	lw f0, 0(a0); 
nop; 	addi a2, a2, 1; 	sw a1, -2(sp); 	sw cl, -1(sp); 
nop; 	add a22, a2, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
nop; nop; 	lw a4, 1(a2); 	lw a3, 10(a2); 
nop; nop; nop; 	lw a5, 5(a2); 
nop; nop; 	lw a5, 5(a2); 	lw f1, 0(a5); 
nop; 	fsub f0, f0, f1; 	lw a5, 5(a2); 	lw f1, 1(a5); 
nop; nop; 	lw f0, 1(a0); 	sw f0, 0(a3); 
	addi a5, zero, 2; 	fsub f0, f0, f1; nop; 	lw f1, 2(a5); 
nop; nop; 	lw f0, 2(a0); 	sw f0, 1(a3); 
nop; 	fsub f0, f0, f1; nop; nop; 
	bne a4, a5, be_else.15802; nop; nop; 	sw f0, 2(a3); 
nop; nop; nop; nop; 
nop; nop; 	lw f0, 0(a3); 	lw a2, 4(a2); 
nop; nop; 	lw f2, 2(a3); 	lw f1, 1(a3); 
nop; nop; nop; 	lw f3, 0(a2); 
nop; 	fmul f0, f3, f0; nop; 	lw f3, 1(a2); 
nop; 	fmul f1, f3, f1; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 2(a2); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
	jump be_cont.15803; nop; nop; 	sw f0, 3(a3); 
nop; nop; nop; nop; 
be_else.15802:
nop; 	addi a5, zero, 2; nop; nop; 
	blt a5, a4, ble_else.15804; nop; nop; nop; 
	jump ble_cont.15805; nop; nop; nop; 
ble_else.15804:
nop; 	add a0, a2, zero; 	lw f1, 1(a3); 	lw f0, 0(a3); 
nop; nop; 	sw a3, -3(sp); 	lw f2, 2(a3); 
nop; 	addi sp, sp, -7; nop; 	sw a4, -4(sp); 
	call quadratic.2662; nop; nop; nop; 
	addi a0, zero, 3; 	addi sp, sp, 7; nop; nop; 
nop; nop; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.15806; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15807; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15806:
be_cont.15807:
nop; nop; nop; 	lw a0, -3(sp); 
nop; nop; nop; 	sw f0, 3(a0); 
ble_cont.15805:
be_cont.15803:
nop; nop; 	lw cl, -1(sp); 	lw a0, -2(sp); 
nop; 	addi a1, a0, -1; 	lw a0, 0(sp); 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.15801:
	ret; nop; nop; nop; 
is_rect_outside.2744:
	addi a2, zero, 0; 	fabs f0, f0; nop; 	lw a1, 4(a0); 
nop; nop; nop; 	lw f3, 0(a1); 
nop; 	flt a1, f0, f3; nop; nop; 
	bne a1, a2, be_else.15809; nop; nop; nop; 
	jump be_cont.15810; 	add a1, a2, zero; nop; nop; 
be_else.15809:
nop; 	fabs f0, f1; nop; 	lw a1, 4(a0); 
nop; nop; nop; 	lw f1, 1(a1); 
nop; 	flt a1, f0, f1; nop; nop; 
	bne a1, a2, be_else.15811; nop; nop; nop; 
	jump be_cont.15812; 	add a1, a2, zero; nop; nop; 
be_else.15811:
nop; 	fabs f0, f2; nop; 	lw a1, 4(a0); 
nop; nop; nop; 	lw f1, 2(a1); 
nop; 	flt a1, f0, f1; nop; nop; 
be_cont.15812:
be_cont.15810:
	bne a1, a2, be_else.15813; nop; nop; nop; 
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a2, be_else.15814; nop; nop; nop; 
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15814:
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15813:
	ret; nop; nop; 	lw a0, 6(a0); 
is_plane_outside.2749:
	addi a3, zero, 0; 	addi a2, zero, 1; 	lw a0, 6(a0); 	lw a1, 4(a0); 
nop; nop; nop; 	lw f3, 0(a1); 
nop; 	fmul f0, f3, f0; nop; 	lw f3, 1(a1); 
nop; 	fmul f1, f3, f1; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
	bne a0, a3, be_else.15815; 	flt a1, f0, fzero; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.15816; 	add a0, a1, zero; nop; nop; 
be_else.15815:
	bne a1, a3, be_else.15817; nop; nop; nop; 
	jump be_cont.15818; 	add a0, a2, zero; nop; nop; 
be_else.15817:
nop; 	add a0, a3, zero; nop; nop; 
be_cont.15818:
be_cont.15816:
	bne a0, a3, be_else.15819; nop; nop; nop; 
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15819:
	ret; 	add a0, a3, zero; nop; nop; 
is_outside.2759:
nop; 	addi a2, zero, 1; nop; 	lw a1, 5(a0); 
nop; nop; 	lw a1, 5(a0); 	lw f3, 0(a1); 
nop; 	fsub f0, f0, f3; 	lw a1, 5(a0); 	lw f3, 1(a1); 
nop; 	fsub f1, f1, f3; 	lw a1, 1(a0); 	lw f3, 2(a1); 
	bne a1, a2, be_else.15820; 	fsub f2, f2, f3; nop; nop; 
	jump is_rect_outside.2744; nop; nop; nop; 
be_else.15820:
nop; 	addi a2, zero, 2; nop; nop; 
	bne a1, a2, be_else.15821; nop; nop; nop; 
nop; 	addi a2, zero, 0; 	lw a0, 6(a0); 	lw a1, 4(a0); 
nop; nop; nop; 	lw f3, 0(a1); 
nop; 	fmul f0, f3, f0; nop; 	lw f3, 1(a1); 
nop; 	fmul f1, f3, f1; nop; nop; 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
	bne a0, a2, be_else.15822; 	flt a1, f0, fzero; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.15823; 	add a0, a1, zero; nop; nop; 
be_else.15822:
	bne a1, a2, be_else.15824; nop; nop; nop; 
	jump be_cont.15825; 	addi a0, zero, 1; nop; nop; 
be_else.15824:
nop; 	add a0, a2, zero; nop; nop; 
be_cont.15825:
be_cont.15823:
	bne a0, a2, be_else.15826; nop; nop; nop; 
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15826:
	ret; 	add a0, a2, zero; nop; nop; 
be_else.15821:
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call quadratic.2662; nop; nop; nop; 
	addi a2, zero, 3; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw a0, 0(sp); 
nop; nop; nop; 	lw a1, 1(a0); 
	bne a1, a2, be_else.15827; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15828; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15827:
be_cont.15828:
	addi a2, zero, 0; 	flt a1, f0, fzero; nop; 	lw a0, 6(a0); 
	bne a0, a2, be_else.15829; nop; nop; nop; 
	jump be_cont.15830; 	add a0, a1, zero; nop; nop; 
be_else.15829:
	bne a1, a2, be_else.15831; nop; nop; nop; 
	jump be_cont.15832; 	addi a0, zero, 1; nop; nop; 
be_else.15831:
nop; 	add a0, a2, zero; nop; nop; 
be_cont.15832:
be_cont.15830:
	bne a0, a2, be_else.15833; nop; nop; nop; 
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15833:
	ret; 	add a0, a2, zero; nop; nop; 
check_all_inside.2764:
	lui a3, 1048575; 	add a22, a0, a1; nop; nop; 
nop; 	addi a3, a3, 4095; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15834; nop; nop; nop; 
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15834:
	addi a5, zero, 1; 	lui a4, 4096; 	sw f2, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a4, a4, 1; 	sw f0, -3(sp); 	sw f1, -2(sp); 
nop; 	add a22, a4, a2; 	sw a1, -5(sp); 	sw a3, -4(sp); 
nop; nop; 	lw a2, 0(a22); 	sw a0, -6(sp); 
nop; nop; nop; 	lw a4, 5(a2); 
nop; nop; 	lw a4, 5(a2); 	lw f3, 0(a4); 
nop; 	fsub f3, f0, f3; 	lw a4, 5(a2); 	lw f4, 1(a4); 
nop; 	fsub f4, f1, f4; 	lw a4, 1(a2); 	lw f5, 2(a4); 
	bne a4, a5, be_else.15835; 	fsub f5, f2, f5; nop; nop; 
	addi f2, f5, 0; 	add a0, a2, zero; nop; nop; 
	addi f0, f3, 0; 	addi f1, f4, 0; nop; nop; 
	call is_rect_outside.2744; 	addi sp, sp, -9; nop; nop; 
	jump be_cont.15836; 	addi sp, sp, 9; nop; nop; 
be_else.15835:
nop; 	addi a5, zero, 2; nop; nop; 
	bne a4, a5, be_else.15837; nop; nop; nop; 
	addi f2, f5, 0; 	add a0, a2, zero; nop; nop; 
	addi f0, f3, 0; 	addi f1, f4, 0; nop; nop; 
	call is_plane_outside.2749; 	addi sp, sp, -9; nop; nop; 
	jump be_cont.15838; 	addi sp, sp, 9; nop; nop; 
be_else.15837:
	addi f2, f5, 0; 	add a0, a2, zero; nop; 	sw a2, -7(sp); 
	addi f0, f3, 0; 	addi f1, f4, 0; nop; nop; 
	call quadratic.2662; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
	addi a2, zero, 3; 	addi sp, sp, 9; nop; nop; 
nop; nop; nop; 	lw a0, -7(sp); 
nop; nop; nop; 	lw a1, 1(a0); 
	bne a1, a2, be_else.15839; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
	jump be_cont.15840; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15839:
be_cont.15840:
	addi a2, zero, 0; 	flt a1, f0, fzero; nop; 	lw a0, 6(a0); 
	bne a0, a2, be_else.15841; nop; nop; nop; 
	jump be_cont.15842; 	add a0, a1, zero; nop; nop; 
be_else.15841:
	bne a1, a2, be_else.15843; nop; nop; nop; 
	jump be_cont.15844; 	addi a0, zero, 1; nop; nop; 
be_else.15843:
nop; 	add a0, a2, zero; nop; nop; 
be_cont.15844:
be_cont.15842:
	bne a0, a2, be_else.15845; nop; nop; nop; 
	jump be_cont.15846; 	addi a0, zero, 1; nop; nop; 
be_else.15845:
nop; 	add a0, a2, zero; nop; nop; 
be_cont.15846:
be_cont.15838:
be_cont.15836:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15847; nop; nop; nop; 
nop; nop; 	lw a2, -5(sp); 	lw a0, -6(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a4, -4(sp); 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a3, 0(a22); 
	bne a3, a4, be_else.15848; nop; nop; nop; 
	ret; 	addi a0, zero, 1; nop; nop; 
be_else.15848:
nop; 	lui a4, 4096; 	lw f1, -2(sp); 	lw f0, -3(sp); 
	addi sp, sp, -11; 	addi a4, a4, 1; 	sw a0, -8(sp); 	lw f2, -1(sp); 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a3, 0(a22); 
	call is_outside.2759; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 11; nop; nop; 
	bne a0, a1, be_else.15849; nop; nop; nop; 
nop; nop; 	lw f0, -3(sp); 	lw a0, -8(sp); 
nop; 	addi a0, a0, 1; 	lw f2, -1(sp); 	lw f1, -2(sp); 
nop; nop; 	lw cl, 0(sp); 	lw a1, -5(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15849:
	ret; 	add a0, a1, zero; nop; nop; 
be_else.15847:
	ret; 	add a0, a1, zero; nop; nop; 
shadow_check_and_group.2770:
	lui a7, 1048575; 	add a22, a0, a1; 	lw a3, 3(cl); 	lw a2, 13(cl); 
nop; 	addi a7, a7, 4095; 	lw a5, 1(cl); 	lw a4, 2(cl); 
nop; nop; nop; 	lw a6, 0(a22); 
	bne a6, a7, be_else.15850; nop; nop; nop; 
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.15850:
	add a2, a3, zero; 	add a22, a0, a1; 	sw a1, -1(sp); 	sw a2, 0(sp); 
	add cl, a5, zero; 	add a1, a4, zero; 	sw a0, -3(sp); 	sw cl, -2(sp); 
nop; nop; 	lw swp, 0(cl); 	lw a6, 0(a22); 
	addi sp, sp, -7; 	add a0, a6, zero; nop; 	sw a6, -4(sp); 
	callr swp; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 7; nop; nop; 
nop; 	addi a1, a1, 122; nop; nop; 
nop; 	addi a1, zero, 0; nop; 	lw f0, 0(a1); 
	bne a0, a1, be_else.15851; nop; nop; nop; 
	jump be_cont.15852; 	add a0, a1, zero; nop; nop; 
be_else.15851:
nop; 	lui.float f1, -0.200000; nop; nop; 
nop; 	addi.float f1, f1, -0.200000; nop; nop; 
nop; 	flt a0, f0, f1; nop; nop; 
be_cont.15852:
	bne a0, a1, be_else.15853; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a2, -4(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a1, be_else.15854; nop; nop; nop; 
	ret; 	add a0, a1, zero; nop; nop; 
be_else.15854:
nop; nop; 	lw a1, -1(sp); 	lw a0, -3(sp); 
nop; 	addi a0, a0, 1; nop; 	lw cl, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15853:
	lui a0, 4096; 	lui.float f1, 0.010000; nop; nop; 
	lui a3, 1048575; 	lui a2, 4096; nop; nop; 
	addi a0, a0, 67; 	addi.float f1, f1, 0.010000; nop; nop; 
	addi a3, a3, 4095; 	addi a2, a2, 67; nop; nop; 
	lui a0, 4096; 	fadd f0, f0, f1; nop; 	lw f1, 0(a0); 
	addi a0, a0, 125; 	fmul f1, f1, f0; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	lw f2, 0(a0); 
	add a22, a2, a0; 	fadd f1, f1, f2; nop; nop; 
	lui a2, 4096; 	addi a0, zero, 1; nop; 	lw f2, 0(a22); 
	addi a2, a2, 125; 	fmul f2, f2, f0; nop; nop; 
	addi a0, zero, 2; 	add a22, a2, a0; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f3, 0(a22); 
	addi a2, a2, 67; 	fadd f2, f2, f3; nop; nop; 
	addi a0, zero, 2; 	add a22, a2, a0; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f3, 0(a22); 
	addi a2, a2, 125; 	fmul f0, f3, f0; nop; nop; 
nop; 	add a22, a2, a0; nop; 	lw a0, -1(sp); 
nop; nop; 	lw a2, 0(a0); 	lw f3, 0(a22); 
	bne a2, a3, be_else.15855; 	fadd f0, f0, f3; nop; nop; 
	jump be_cont.15856; 	addi a0, zero, 1; nop; nop; 
be_else.15855:
	addi f12, f2, 0; 	lui a3, 4096; 	sw f2, -6(sp); 	sw f0, -5(sp); 
	addi a3, a3, 1; 	addi f2, f0, 0; nop; 	sw f1, -7(sp); 
	addi f0, f1, 0; 	addi sp, sp, -9; nop; nop; 
	addi f1, f12, 0; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	call is_outside.2759; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15857; nop; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f1, -6(sp); 	lw f0, -7(sp); 
nop; nop; 	lw a2, -1(sp); 	lw f2, -5(sp); 
	addi sp, sp, -9; 	add a1, a2, zero; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.15858; 	addi sp, sp, 9; nop; nop; 
be_else.15857:
nop; 	add a0, a1, zero; nop; nop; 
be_cont.15858:
be_cont.15856:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15859; nop; nop; nop; 
nop; nop; 	lw a1, -1(sp); 	lw a0, -3(sp); 
nop; 	addi a0, a0, 1; nop; 	lw cl, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15859:
	ret; 	addi a0, zero, 1; nop; nop; 
shadow_check_one_or_group.2773:
	lui a4, 1048575; 	add a22, a0, a1; nop; 	lw a2, 2(cl); 
nop; 	addi a4, a4, 4095; nop; 	lw a3, 0(a22); 
	bne a3, a4, be_else.15860; nop; nop; nop; 
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.15860:
	add cl, a2, zero; 	lui a5, 4096; 	sw a2, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a5, a5, 71; 	sw a1, -3(sp); 	sw a4, -2(sp); 
	addi sp, sp, -7; 	add a22, a5, a3; 	lw swp, 0(cl); 	sw a0, -4(sp); 
nop; 	addi a5, zero, 0; nop; 	lw a3, 0(a22); 
	add a0, a5, zero; 	add a1, a3, zero; nop; nop; 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15861; nop; nop; nop; 
nop; 	addi a0, zero, 1; 	lw a3, -3(sp); 	lw a2, -4(sp); 
nop; 	addi a2, a2, 1; nop; 	lw a5, -2(sp); 
nop; 	add a22, a2, a3; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
	bne a4, a5, be_else.15862; nop; nop; nop; 
	ret; 	add a0, a1, zero; nop; nop; 
be_else.15862:
	add a0, a1, zero; 	lui a5, 4096; 	sw a0, -5(sp); 	lw cl, -1(sp); 
	addi sp, sp, -9; 	addi a5, a5, 71; 	lw swp, 0(cl); 	sw a2, -6(sp); 
nop; 	add a22, a5, a4; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
	callr swp; 	add a1, a4, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15863; nop; nop; nop; 
nop; nop; 	lw a1, -3(sp); 	lw a0, -6(sp); 
nop; 	addi a0, a0, 1; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15863:
	ret; nop; nop; 	lw a0, -5(sp); 
be_else.15861:
	ret; 	addi a0, zero, 1; nop; nop; 
shadow_check_one_or_matrix.2776:
	lui a9, 1048575; 	add a22, a0, a1; 	lw a3, 6(cl); 	lw a2, 7(cl); 
nop; 	addi a9, a9, 4095; 	lw a5, 2(cl); 	lw a4, 3(cl); 
nop; nop; 	lw a7, 0(a22); 	lw a6, 1(cl); 
nop; nop; nop; 	lw a8, 0(a7); 
	bne a8, a9, be_else.15864; nop; nop; nop; 
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.15864:
nop; 	addi a9, zero, 99; 	sw a3, -1(sp); 	sw a2, 0(sp); 
nop; nop; 	sw a1, -3(sp); 	sw a7, -2(sp); 
	bne a8, a9, be_else.15865; nop; 	sw a0, -5(sp); 	sw cl, -4(sp); 
	jump be_cont.15866; 	addi a0, zero, 1; nop; nop; 
be_else.15865:
	add a1, a5, zero; 	add a2, a4, zero; nop; nop; 
	add cl, a6, zero; 	add a0, a8, zero; nop; nop; 
nop; 	addi sp, sp, -7; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15867; nop; nop; nop; 
	jump be_cont.15868; 	add a0, a1, zero; nop; nop; 
be_else.15867:
	lui.float f1, -0.100000; 	lui a0, 4096; nop; nop; 
	addi.float f1, f1, -0.100000; 	addi a0, a0, 122; nop; nop; 
nop; nop; nop; 	lw f0, 0(a0); 
nop; 	flt a0, f0, f1; nop; nop; 
	bne a0, a1, be_else.15869; nop; nop; nop; 
	jump be_cont.15870; 	add a0, a1, zero; nop; nop; 
be_else.15869:
nop; 	lui a3, 1048575; nop; 	lw a0, -2(sp); 
nop; 	addi a3, a3, 4095; nop; 	lw a2, 1(a0); 
	bne a2, a3, be_else.15871; nop; nop; nop; 
	jump be_cont.15872; 	add a0, a1, zero; nop; nop; 
be_else.15871:
	add a0, a1, zero; 	lui a3, 4096; nop; 	lw cl, -1(sp); 
	addi a3, a3, 71; 	addi sp, sp, -7; nop; 	lw swp, 0(cl); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	callr swp; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15873; nop; nop; nop; 
	addi sp, sp, -7; 	addi a0, zero, 2; 	lw cl, 0(sp); 	lw a2, -2(sp); 
nop; 	add a1, a2, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.15874; 	addi sp, sp, 7; nop; nop; 
be_else.15873:
nop; 	addi a0, zero, 1; nop; nop; 
be_cont.15874:
be_cont.15872:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15875; nop; nop; nop; 
	jump be_cont.15876; 	add a0, a1, zero; nop; nop; 
be_else.15875:
nop; 	addi a0, zero, 1; nop; nop; 
be_cont.15876:
be_cont.15870:
be_cont.15868:
be_cont.15866:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15877; nop; nop; nop; 
nop; nop; 	lw a1, -3(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15877:
nop; 	lui a3, 1048575; nop; 	lw a0, -2(sp); 
nop; 	addi a3, a3, 4095; nop; 	lw a2, 1(a0); 
	bne a2, a3, be_else.15878; nop; nop; nop; 
	jump be_cont.15879; 	add a0, a1, zero; nop; nop; 
be_else.15878:
	add a0, a1, zero; 	lui a3, 4096; nop; 	lw cl, -1(sp); 
	addi a3, a3, 71; 	addi sp, sp, -7; nop; 	lw swp, 0(cl); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	callr swp; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15880; nop; nop; nop; 
	addi sp, sp, -7; 	addi a0, zero, 2; 	lw cl, 0(sp); 	lw a2, -2(sp); 
nop; 	add a1, a2, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.15881; 	addi sp, sp, 7; nop; nop; 
be_else.15880:
nop; 	addi a0, zero, 1; nop; nop; 
be_cont.15881:
be_cont.15879:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15882; nop; nop; nop; 
nop; nop; 	lw a1, -3(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15882:
	ret; 	addi a0, zero, 1; nop; nop; 
solve_each_element.2779:
	lui a7, 1048575; 	add a22, a0, a1; 	lw a4, 2(cl); 	lw a3, 10(cl); 
nop; 	addi a7, a7, 4095; 	lw a6, 0(a22); 	lw a5, 1(cl); 
	bne a6, a7, be_else.15883; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15883:
nop; nop; 	sw a2, -1(sp); 	sw a3, 0(sp); 
	add cl, a5, zero; 	add a1, a2, zero; 	sw cl, -3(sp); 	sw a1, -2(sp); 
	add a0, a6, zero; 	add a2, a4, zero; 	sw a6, -5(sp); 	sw a0, -4(sp); 
nop; 	addi sp, sp, -7; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 7; nop; nop; 
	bne a0, a1, be_else.15885; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a2, -5(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a1, be_else.15886; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15886:
nop; nop; 	lw a1, -2(sp); 	lw a0, -4(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -3(sp); 	lw a2, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15885:
	lui.float f1, 0.000000; 	lui a2, 4096; nop; nop; 
	addi.float f1, f1, 0.000000; 	addi a2, a2, 122; nop; nop; 
nop; nop; nop; 	lw f0, 0(a2); 
nop; 	flt a2, f1, f0; nop; nop; 
	bne a2, a1, be_else.15888; nop; nop; nop; 
	jump be_cont.15889; nop; nop; nop; 
be_else.15888:
nop; 	lui a2, 4096; nop; nop; 
nop; 	addi a2, a2, 124; nop; nop; 
nop; nop; nop; 	lw f1, 0(a2); 
nop; 	flt a2, f0, f1; nop; nop; 
	bne a2, a1, be_else.15890; nop; nop; nop; 
	jump be_cont.15891; nop; nop; nop; 
be_else.15890:
	lui a3, 4096; 	lui.float f1, 0.010000; 	sw a0, -6(sp); 	lw a2, -1(sp); 
	lui a5, 1048575; 	lui a4, 4096; nop; nop; 
	addi a3, a3, 146; 	addi.float f1, f1, 0.010000; nop; nop; 
	addi a5, a5, 4095; 	addi a4, a4, 146; nop; 	lw f2, 0(a3); 
	addi a3, zero, 1; 	fadd f0, f0, f1; nop; 	lw f1, 0(a2); 
	add a22, a4, a3; 	fmul f1, f1, f0; nop; 	sw f0, -10(sp); 
	lui a4, 4096; 	addi a3, zero, 2; nop; 	lw f3, 0(a22); 
	addi a4, a4, 146; 	fadd f1, f1, f2; nop; 	lw f2, 1(a2); 
	add a22, a4, a3; 	fmul f2, f2, f0; 	lw a3, -2(sp); 	sw f1, -9(sp); 
nop; 	fadd f2, f2, f3; 	lw a4, 0(a3); 	lw f4, 0(a22); 
nop; nop; 	sw f2, -8(sp); 	lw f3, 2(a2); 
nop; 	fmul f3, f3, f0; nop; nop; 
nop; 	fadd f3, f3, f4; nop; nop; 
	bne a4, a5, be_else.15892; nop; nop; 	sw f3, -7(sp); 
nop; nop; nop; nop; 
	jump be_cont.15893; 	addi a0, zero, 1; nop; nop; 
be_else.15892:
	addi f0, f1, 0; 	lui a5, 4096; nop; nop; 
	addi f1, f2, 0; 	addi sp, sp, -13; nop; nop; 
	addi f2, f3, 0; 	addi a5, a5, 1; nop; nop; 
nop; 	add a22, a5, a4; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
	call is_outside.2759; 	add a0, a4, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 13; nop; nop; 
	bne a0, a1, be_else.15894; nop; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f1, -8(sp); 	lw f0, -9(sp); 
nop; nop; 	lw a2, -2(sp); 	lw f2, -7(sp); 
	addi sp, sp, -13; 	add a1, a2, zero; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.15895; 	addi sp, sp, 13; nop; nop; 
be_else.15894:
nop; 	add a0, a1, zero; nop; nop; 
be_cont.15895:
be_cont.15893:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15896; nop; nop; nop; 
	jump be_cont.15897; nop; nop; nop; 
be_else.15896:
	lui a1, 4096; 	lui a0, 4096; nop; 	lw f0, -10(sp); 
	addi a1, a1, 125; 	addi a0, a0, 124; nop; nop; 
nop; 	lui a0, 4096; 	lw f0, -9(sp); 	sw f0, 0(a0); 
nop; 	addi a0, a0, 125; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f0, -8(sp); 	sw f0, 0(a0); 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
nop; 	lui a1, 4096; 	lw f0, -7(sp); 	sw f0, 0(a22); 
nop; 	addi a1, a1, 125; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; nop; 	lw a1, -5(sp); 
nop; 	addi a0, a0, 128; nop; 	sw f0, 0(a22); 
nop; 	lui a0, 4096; 	lw a1, -6(sp); 	sw a1, 0(a0); 
nop; 	addi a0, a0, 123; nop; nop; 
nop; nop; nop; 	sw a1, 0(a0); 
be_cont.15897:
be_cont.15891:
be_cont.15889:
nop; nop; 	lw a1, -2(sp); 	lw a0, -4(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -3(sp); 	lw a2, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
solve_one_or_network.2783:
	lui a5, 1048575; 	add a22, a0, a1; nop; 	lw a3, 2(cl); 
nop; 	addi a5, a5, 4095; nop; 	lw a4, 0(a22); 
	bne a4, a5, be_else.15898; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15898:
	add cl, a3, zero; 	lui a6, 4096; 	sw a2, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a6, a6, 71; 	sw a5, -3(sp); 	sw a3, -2(sp); 
	addi sp, sp, -7; 	add a22, a6, a4; 	sw a0, -5(sp); 	sw a1, -4(sp); 
nop; 	addi a6, zero, 0; 	lw a4, 0(a22); 	lw swp, 0(cl); 
	add a0, a6, zero; 	add a1, a4, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15900; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15900:
nop; 	lui a4, 4096; 	lw cl, -2(sp); 	lw a5, -1(sp); 
	addi sp, sp, -9; 	addi a4, a4, 71; 	lw swp, 0(cl); 	sw a0, -6(sp); 
	addi a4, zero, 0; 	add a22, a4, a2; nop; nop; 
nop; 	add a0, a4, zero; nop; 	lw a2, 0(a22); 
	add a2, a5, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -6(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15902; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15902:
nop; 	lui a4, 4096; 	lw cl, -2(sp); 	lw a5, -1(sp); 
	addi sp, sp, -9; 	addi a4, a4, 71; 	lw swp, 0(cl); 	sw a0, -7(sp); 
	addi a4, zero, 0; 	add a22, a4, a2; nop; nop; 
nop; 	add a0, a4, zero; nop; 	lw a2, 0(a22); 
	add a2, a5, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -7(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15904; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15904:
nop; 	lui a3, 4096; 	lw cl, -2(sp); 	lw a4, -1(sp); 
	addi sp, sp, -11; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a0, -8(sp); 
	addi a3, zero, 0; 	add a22, a3, a2; nop; nop; 
nop; 	add a0, a3, zero; nop; 	lw a2, 0(a22); 
	add a2, a4, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -8(sp); 
nop; 	addi a0, a0, 1; 	lw cl, 0(sp); 	lw a2, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
trace_or_matrix.2787:
	lui a9, 1048575; 	add a22, a0, a1; 	lw a4, 8(cl); 	lw a3, 9(cl); 
nop; 	addi a9, a9, 4095; 	lw a6, 2(cl); 	lw a5, 7(cl); 
nop; nop; nop; 	lw a7, 0(a22); 
nop; nop; nop; 	lw a8, 0(a7); 
	bne a8, a9, be_else.15906; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15906:
nop; 	addi a9, zero, 99; 	sw a1, -1(sp); 	sw a2, 0(sp); 
	bne a8, a9, be_else.15908; nop; 	sw a0, -3(sp); 	sw cl, -2(sp); 
nop; 	lui a4, 1048575; nop; 	lw a3, 1(a7); 
nop; 	addi a4, a4, 4095; nop; nop; 
	bne a3, a4, be_else.15910; nop; nop; nop; 
	jump be_cont.15911; nop; nop; nop; 
be_else.15910:
	add cl, a6, zero; 	lui a4, 4096; 	sw a6, -5(sp); 	sw a5, -4(sp); 
	addi sp, sp, -9; 	addi a4, a4, 71; 	lw swp, 0(cl); 	sw a7, -6(sp); 
	addi a4, zero, 0; 	add a22, a4, a3; nop; nop; 
nop; 	add a0, a4, zero; nop; 	lw a3, 0(a22); 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	lui a2, 1048575; 	addi sp, sp, 9; nop; nop; 
nop; 	addi a2, a2, 4095; nop; 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 2(a0); 
	bne a1, a2, be_else.15912; nop; nop; nop; 
	jump be_cont.15913; nop; nop; nop; 
be_else.15912:
nop; 	lui a3, 4096; 	lw cl, -5(sp); 	lw a4, 0(sp); 
	add a2, a4, zero; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a2, -7(sp); 
	add a22, a3, a1; 	addi sp, sp, -9; nop; nop; 
nop; 	addi a3, zero, 0; nop; 	lw a1, 0(a22); 
	callr swp; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -7(sp); 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 3(a0); 
	bne a1, a2, be_else.15914; nop; nop; nop; 
	jump be_cont.15915; nop; nop; nop; 
be_else.15914:
	addi sp, sp, -9; 	lui a2, 4096; 	lw cl, -5(sp); 	lw a3, 0(sp); 
nop; 	addi a2, a2, 71; nop; 	lw swp, 0(cl); 
	addi a2, zero, 0; 	add a22, a2, a1; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; 	lw a1, 0(a22); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -6(sp); 
nop; 	addi sp, sp, -9; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.15915:
be_cont.15913:
be_cont.15911:
	jump be_cont.15909; nop; nop; nop; 
be_else.15908:
	add a0, a8, zero; 	add a1, a2, zero; 	sw a6, -5(sp); 	sw a5, -4(sp); 
	add a2, a3, zero; 	add cl, a4, zero; nop; 	sw a7, -6(sp); 
nop; 	addi sp, sp, -9; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15916; nop; nop; nop; 
	jump be_cont.15917; nop; nop; nop; 
be_else.15916:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw f0, 0(a0); 
nop; 	addi a0, a0, 124; nop; nop; 
nop; nop; nop; 	lw f1, 0(a0); 
nop; 	flt a0, f0, f1; nop; nop; 
	bne a0, a1, be_else.15918; nop; nop; nop; 
	jump be_cont.15919; nop; nop; nop; 
be_else.15918:
nop; 	lui a3, 1048575; nop; 	lw a0, -6(sp); 
nop; 	addi a3, a3, 4095; nop; 	lw a2, 1(a0); 
	bne a2, a3, be_else.15920; nop; nop; nop; 
	jump be_cont.15921; nop; nop; nop; 
be_else.15920:
	add a0, a1, zero; 	lui a3, 4096; nop; 	lw cl, -5(sp); 
nop; 	addi a3, a3, 71; nop; 	lw swp, 0(cl); 
	addi sp, sp, -9; 	add a22, a3, a2; nop; 	lw a3, 0(sp); 
nop; nop; nop; 	lw a2, 0(a22); 
	add a2, a3, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
	lui a2, 1048575; 	addi sp, sp, 9; nop; nop; 
nop; 	addi a2, a2, 4095; nop; 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 2(a0); 
	bne a1, a2, be_else.15922; nop; nop; nop; 
	jump be_cont.15923; nop; nop; nop; 
be_else.15922:
nop; 	lui a3, 4096; 	lw cl, -5(sp); 	lw a4, 0(sp); 
	add a2, a4, zero; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a2, -8(sp); 
	add a22, a3, a1; 	addi sp, sp, -11; nop; nop; 
nop; 	addi a3, zero, 0; nop; 	lw a1, 0(a22); 
	callr swp; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a2, -8(sp); 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 3(a0); 
	bne a1, a2, be_else.15924; nop; nop; nop; 
	jump be_cont.15925; nop; nop; nop; 
be_else.15924:
	addi sp, sp, -11; 	lui a2, 4096; 	lw cl, -5(sp); 	lw a3, 0(sp); 
nop; 	addi a2, a2, 71; nop; 	lw swp, 0(cl); 
	addi a2, zero, 0; 	add a22, a2, a1; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; 	lw a1, 0(a22); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -6(sp); 
nop; 	addi sp, sp, -11; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
be_cont.15925:
be_cont.15923:
be_cont.15921:
be_cont.15919:
be_cont.15917:
be_cont.15909:
nop; nop; 	lw a1, -1(sp); 	lw a0, -3(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -2(sp); 	lw a2, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
solve_each_element_fast.2793:
	lui a7, 1048575; 	add a22, a0, a1; 	lw a4, 1(cl); 	lw a3, 9(cl); 
nop; 	addi a7, a7, 4095; 	lw a6, 0(a22); 	lw a5, 0(a2); 
	bne a6, a7, be_else.15926; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15926:
nop; nop; 	sw a5, -1(sp); 	sw a3, 0(sp); 
nop; 	add a1, a2, zero; 	sw a1, -3(sp); 	sw a2, -2(sp); 
	add a0, a6, zero; 	add cl, a4, zero; 	sw a0, -5(sp); 	sw cl, -4(sp); 
nop; 	addi sp, sp, -9; 	lw swp, 0(cl); 	sw a6, -6(sp); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15928; nop; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw a2, -6(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 6(a0); 
	bne a0, a1, be_else.15929; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15929:
nop; nop; 	lw a1, -3(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -4(sp); 	lw a2, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
be_else.15928:
	lui.float f1, 0.000000; 	lui a2, 4096; nop; nop; 
	addi.float f1, f1, 0.000000; 	addi a2, a2, 122; nop; nop; 
nop; nop; nop; 	lw f0, 0(a2); 
nop; 	flt a2, f1, f0; nop; nop; 
	bne a2, a1, be_else.15931; nop; nop; nop; 
	jump be_cont.15932; nop; nop; nop; 
be_else.15931:
nop; 	lui a2, 4096; nop; nop; 
nop; 	addi a2, a2, 124; nop; nop; 
nop; nop; nop; 	lw f1, 0(a2); 
nop; 	flt a2, f0, f1; nop; nop; 
	bne a2, a1, be_else.15933; nop; nop; nop; 
	jump be_cont.15934; nop; nop; nop; 
be_else.15933:
	lui a3, 4096; 	lui.float f1, 0.010000; 	sw a0, -7(sp); 	lw a2, -1(sp); 
	addi.float f1, f1, 0.010000; 	lui a4, 4096; nop; nop; 
	fadd f0, f0, f1; 	addi a3, a3, 149; nop; 	lw f1, 0(a2); 
	fmul f1, f1, f0; 	addi a4, a4, 149; 	sw f0, -11(sp); 	lw f2, 0(a3); 
	fadd f1, f1, f2; 	addi a3, zero, 1; nop; 	lw f2, 1(a2); 
	add a22, a4, a3; 	fmul f2, f2, f0; nop; 	sw f1, -10(sp); 
	lui a4, 1048575; 	lui a3, 4096; nop; 	lw f3, 0(a22); 
	addi a3, a3, 149; 	fadd f2, f2, f3; nop; 	lw f3, 2(a2); 
	addi a2, zero, 2; 	addi a4, a4, 4095; nop; 	sw f2, -9(sp); 
	add a22, a3, a2; 	fmul f3, f3, f0; nop; 	lw a2, -3(sp); 
nop; nop; 	lw a3, 0(a2); 	lw f4, 0(a22); 
nop; 	fadd f3, f3, f4; nop; nop; 
	bne a3, a4, be_else.15935; nop; nop; 	sw f3, -8(sp); 
nop; nop; nop; nop; 
	jump be_cont.15936; 	addi a0, zero, 1; nop; nop; 
be_else.15935:
	addi f0, f1, 0; 	lui a4, 4096; nop; nop; 
	addi f1, f2, 0; 	addi sp, sp, -13; nop; nop; 
	addi f2, f3, 0; 	addi a4, a4, 1; nop; nop; 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a3, 0(a22); 
	call is_outside.2759; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 13; nop; nop; 
	bne a0, a1, be_else.15937; nop; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f1, -9(sp); 	lw f0, -10(sp); 
nop; nop; 	lw a2, -3(sp); 	lw f2, -8(sp); 
	addi sp, sp, -13; 	add a1, a2, zero; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.15938; 	addi sp, sp, 13; nop; nop; 
be_else.15937:
nop; 	add a0, a1, zero; nop; nop; 
be_cont.15938:
be_cont.15936:
nop; 	addi a1, zero, 0; nop; nop; 
	bne a0, a1, be_else.15939; nop; nop; nop; 
	jump be_cont.15940; nop; nop; nop; 
be_else.15939:
	lui a1, 4096; 	lui a0, 4096; nop; 	lw f0, -11(sp); 
	addi a1, a1, 125; 	addi a0, a0, 124; nop; nop; 
nop; 	lui a0, 4096; 	lw f0, -10(sp); 	sw f0, 0(a0); 
nop; 	addi a0, a0, 125; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f0, -9(sp); 	sw f0, 0(a0); 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
nop; 	lui a1, 4096; 	lw f0, -8(sp); 	sw f0, 0(a22); 
nop; 	addi a1, a1, 125; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; nop; 	lw a1, -6(sp); 
nop; 	addi a0, a0, 128; nop; 	sw f0, 0(a22); 
nop; 	lui a0, 4096; 	lw a1, -7(sp); 	sw a1, 0(a0); 
nop; 	addi a0, a0, 123; nop; nop; 
nop; nop; nop; 	sw a1, 0(a0); 
be_cont.15940:
be_cont.15934:
be_cont.15932:
nop; nop; 	lw a1, -3(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -4(sp); 	lw a2, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
solve_one_or_network_fast.2797:
	lui a5, 1048575; 	add a22, a0, a1; nop; 	lw a3, 2(cl); 
nop; 	addi a5, a5, 4095; nop; 	lw a4, 0(a22); 
	bne a4, a5, be_else.15941; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15941:
	add cl, a3, zero; 	lui a6, 4096; 	sw a2, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a6, a6, 71; 	sw a5, -3(sp); 	sw a3, -2(sp); 
	addi sp, sp, -7; 	add a22, a6, a4; 	sw a0, -5(sp); 	sw a1, -4(sp); 
nop; 	addi a6, zero, 0; 	lw a4, 0(a22); 	lw swp, 0(cl); 
	add a0, a6, zero; 	add a1, a4, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15943; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15943:
nop; 	lui a4, 4096; 	lw cl, -2(sp); 	lw a5, -1(sp); 
	addi sp, sp, -9; 	addi a4, a4, 71; 	lw swp, 0(cl); 	sw a0, -6(sp); 
	addi a4, zero, 0; 	add a22, a4, a2; nop; nop; 
nop; 	add a0, a4, zero; nop; 	lw a2, 0(a22); 
	add a2, a5, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -6(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15945; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15945:
nop; 	lui a4, 4096; 	lw cl, -2(sp); 	lw a5, -1(sp); 
	addi sp, sp, -9; 	addi a4, a4, 71; 	lw swp, 0(cl); 	sw a0, -7(sp); 
	addi a4, zero, 0; 	add a22, a4, a2; nop; nop; 
nop; 	add a0, a4, zero; nop; 	lw a2, 0(a22); 
	add a2, a5, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -7(sp); 
nop; 	addi a0, a0, 1; nop; 	lw a3, -3(sp); 
nop; 	add a22, a0, a1; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.15947; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15947:
nop; 	lui a3, 4096; 	lw cl, -2(sp); 	lw a4, -1(sp); 
	addi sp, sp, -11; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a0, -8(sp); 
	addi a3, zero, 0; 	add a22, a3, a2; nop; nop; 
nop; 	add a0, a3, zero; nop; 	lw a2, 0(a22); 
	add a2, a4, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -8(sp); 
nop; 	addi a0, a0, 1; 	lw cl, 0(sp); 	lw a2, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
trace_or_matrix_fast.2801:
	lui a8, 1048575; 	add a22, a0, a1; 	lw a4, 7(cl); 	lw a3, 8(cl); 
nop; 	addi a8, a8, 4095; 	lw a6, 0(a22); 	lw a5, 2(cl); 
nop; nop; nop; 	lw a7, 0(a6); 
	bne a7, a8, be_else.15949; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15949:
nop; 	addi a8, zero, 99; 	sw a1, -1(sp); 	sw a2, 0(sp); 
	bne a7, a8, be_else.15951; nop; 	sw a0, -3(sp); 	sw cl, -2(sp); 
nop; 	lui a7, 1048575; nop; 	lw a3, 1(a6); 
nop; 	addi a7, a7, 4095; nop; nop; 
	bne a3, a7, be_else.15953; nop; nop; nop; 
	jump be_cont.15954; nop; nop; nop; 
be_else.15953:
	add cl, a5, zero; 	lui a7, 4096; 	sw a5, -5(sp); 	sw a4, -4(sp); 
	addi sp, sp, -9; 	addi a7, a7, 71; 	lw swp, 0(cl); 	sw a6, -6(sp); 
	addi a7, zero, 0; 	add a22, a7, a3; nop; nop; 
nop; 	add a0, a7, zero; nop; 	lw a3, 0(a22); 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	lui a2, 1048575; 	addi sp, sp, 9; nop; nop; 
nop; 	addi a2, a2, 4095; nop; 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 2(a0); 
	bne a1, a2, be_else.15955; nop; nop; nop; 
	jump be_cont.15956; nop; nop; nop; 
be_else.15955:
nop; 	lui a3, 4096; 	lw cl, -5(sp); 	lw a4, 0(sp); 
	add a2, a4, zero; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a2, -7(sp); 
	add a22, a3, a1; 	addi sp, sp, -9; nop; nop; 
nop; 	addi a3, zero, 0; nop; 	lw a1, 0(a22); 
	callr swp; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -7(sp); 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 3(a0); 
	bne a1, a2, be_else.15957; nop; nop; nop; 
	jump be_cont.15958; nop; nop; nop; 
be_else.15957:
	addi sp, sp, -9; 	lui a2, 4096; 	lw cl, -5(sp); 	lw a3, 0(sp); 
nop; 	addi a2, a2, 71; nop; 	lw swp, 0(cl); 
	addi a2, zero, 0; 	add a22, a2, a1; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; 	lw a1, 0(a22); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -6(sp); 
nop; 	addi sp, sp, -9; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.15958:
be_cont.15956:
be_cont.15954:
	jump be_cont.15952; nop; nop; nop; 
be_else.15951:
	add a0, a7, zero; 	add a1, a2, zero; 	sw a5, -5(sp); 	sw a4, -4(sp); 
	addi sp, sp, -9; 	add cl, a3, zero; nop; 	sw a6, -6(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
	bne a0, a1, be_else.15959; nop; nop; nop; 
	jump be_cont.15960; nop; nop; nop; 
be_else.15959:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 122; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw f0, 0(a0); 
nop; 	addi a0, a0, 124; nop; nop; 
nop; nop; nop; 	lw f1, 0(a0); 
nop; 	flt a0, f0, f1; nop; nop; 
	bne a0, a1, be_else.15961; nop; nop; nop; 
	jump be_cont.15962; nop; nop; nop; 
be_else.15961:
nop; 	lui a3, 1048575; nop; 	lw a0, -6(sp); 
nop; 	addi a3, a3, 4095; nop; 	lw a2, 1(a0); 
	bne a2, a3, be_else.15963; nop; nop; nop; 
	jump be_cont.15964; nop; nop; nop; 
be_else.15963:
	add a0, a1, zero; 	lui a3, 4096; nop; 	lw cl, -5(sp); 
nop; 	addi a3, a3, 71; nop; 	lw swp, 0(cl); 
	addi sp, sp, -9; 	add a22, a3, a2; nop; 	lw a3, 0(sp); 
nop; nop; nop; 	lw a2, 0(a22); 
	add a2, a3, zero; 	add a1, a2, zero; nop; nop; 
	callr swp; nop; nop; nop; 
	lui a2, 1048575; 	addi sp, sp, 9; nop; nop; 
nop; 	addi a2, a2, 4095; nop; 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 2(a0); 
	bne a1, a2, be_else.15965; nop; nop; nop; 
	jump be_cont.15966; nop; nop; nop; 
be_else.15965:
nop; 	lui a3, 4096; 	lw cl, -5(sp); 	lw a4, 0(sp); 
	add a2, a4, zero; 	addi a3, a3, 71; 	lw swp, 0(cl); 	sw a2, -8(sp); 
	add a22, a3, a1; 	addi sp, sp, -11; nop; nop; 
nop; 	addi a3, zero, 0; nop; 	lw a1, 0(a22); 
	callr swp; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a2, -8(sp); 	lw a0, -6(sp); 
nop; nop; nop; 	lw a1, 3(a0); 
	bne a1, a2, be_else.15967; nop; nop; nop; 
	jump be_cont.15968; nop; nop; nop; 
be_else.15967:
	addi sp, sp, -11; 	lui a2, 4096; 	lw cl, -5(sp); 	lw a3, 0(sp); 
nop; 	addi a2, a2, 71; nop; 	lw swp, 0(cl); 
	addi a2, zero, 0; 	add a22, a2, a1; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; 	lw a1, 0(a22); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a2, 0(sp); 	lw a1, -6(sp); 
nop; 	addi sp, sp, -11; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
be_cont.15968:
be_cont.15966:
be_cont.15964:
be_cont.15962:
be_cont.15960:
be_cont.15952:
nop; nop; 	lw a1, -1(sp); 	lw a0, -3(sp); 
nop; 	addi a0, a0, 1; 	lw cl, -2(sp); 	lw a2, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
get_nvector_second.2811:
	lui a3, 4096; 	lui a2, 4096; nop; 	lw a1, 4(cl); 
	addi a3, a3, 125; 	addi a2, a2, 125; nop; nop; 
nop; nop; 	lw a2, 5(a0); 	lw f0, 0(a2); 
nop; 	addi a2, zero, 1; nop; 	lw f1, 0(a2); 
	add a22, a3, a2; 	fsub f0, f0, f1; nop; 	lw a2, 5(a0); 
	addi a2, zero, 2; 	lui a3, 4096; 	lw f2, 1(a2); 	lw f1, 0(a22); 
	addi a3, a3, 125; 	fsub f1, f1, f2; nop; nop; 
	addi a3, zero, 0; 	add a22, a3, a2; nop; 	lw a2, 5(a0); 
nop; nop; 	lw f3, 2(a2); 	lw f2, 0(a22); 
nop; 	fsub f2, f2, f3; nop; 	lw a2, 4(a0); 
nop; nop; 	lw a2, 4(a0); 	lw f3, 0(a2); 
nop; 	fmul f3, f0, f3; 	lw a2, 4(a0); 	lw f4, 1(a2); 
nop; 	fmul f4, f1, f4; 	lw a2, 3(a0); 	lw f5, 2(a2); 
	bne a2, a3, be_else.15969; 	fmul f5, f2, f5; nop; nop; 
	lui a3, 4096; 	lui a2, 4096; nop; nop; 
	addi a3, a3, 129; 	addi a2, a2, 129; nop; nop; 
nop; 	addi a2, zero, 1; nop; 	sw f3, 0(a2); 
	addi a2, zero, 2; 	add a22, a3, a2; nop; nop; 
nop; 	lui a3, 4096; nop; 	sw f4, 0(a22); 
nop; 	addi a3, a3, 129; nop; nop; 
nop; 	add a22, a3, a2; nop; nop; 
	jump be_cont.15970; nop; nop; 	sw f5, 0(a22); 
nop; nop; nop; nop; 
be_else.15969:
nop; nop; 	lw a3, 9(a0); 	lw a2, 9(a0); 
nop; nop; 	lw a2, 9(a0); 	lw f6, 2(a2); 
	lui a2, 4096; 	fmul f6, f1, f6; nop; 	lw f7, 1(a2); 
	addi a2, a2, 129; 	fmul f7, f2, f7; nop; nop; 
	lui.float f7, 0.500000; 	fadd f6, f6, f7; nop; nop; 
nop; 	addi.float f7, f7, 0.500000; nop; nop; 
nop; 	fmul f6, f6, f7; nop; nop; 
nop; 	fadd f3, f3, f6; nop; nop; 
nop; 	addi a2, zero, 1; 	lw f3, 2(a3); 	sw f3, 0(a2); 
nop; 	fmul f3, f0, f3; nop; 	lw a3, 9(a0); 
nop; 	lui a3, 4096; nop; 	lw f6, 0(a3); 
	addi a3, a3, 129; 	fmul f2, f2, f6; nop; nop; 
	add a22, a3, a2; 	fadd f2, f3, f2; nop; 	lw a3, 9(a0); 
	addi a2, zero, 2; 	lui.float f3, 0.500000; nop; nop; 
nop; 	addi.float f3, f3, 0.500000; nop; nop; 
nop; 	fmul f2, f2, f3; nop; nop; 
nop; 	fadd f2, f4, f2; nop; nop; 
nop; nop; 	lw f2, 1(a3); 	sw f2, 0(a22); 
nop; 	fmul f0, f0, f2; nop; 	lw a3, 9(a0); 
nop; 	lui a3, 4096; nop; 	lw f2, 0(a3); 
	addi a3, a3, 129; 	fmul f1, f1, f2; nop; nop; 
	add a22, a3, a2; 	fadd f0, f0, f1; nop; nop; 
nop; 	lui.float f1, 0.500000; nop; nop; 
nop; 	addi.float f1, f1, 0.500000; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	fadd f0, f5, f0; nop; nop; 
nop; nop; nop; 	sw f0, 0(a22); 
be_cont.15970:
nop; 	add swp, a1, zero; nop; 	lw a0, 6(a0); 
	add a0, swp, zero; 	add a1, a0, zero; nop; nop; 
	jump vecunit_sgn.2519; nop; nop; nop; 
utexture.2816:
nop; nop; 	lw a3, 8(a0); 	lw a2, 0(a0); 
nop; 	lui a3, 4096; 	lw f0, 0(a3); 	lw a4, 8(a0); 
nop; 	addi a3, a3, 132; nop; nop; 
	lui a4, 4096; 	addi a3, zero, 1; 	lw f0, 1(a4); 	sw f0, 0(a3); 
nop; 	addi a4, a4, 132; nop; nop; 
	addi a3, zero, 2; 	add a22, a4, a3; nop; 	lw a4, 8(a0); 
nop; 	lui a4, 4096; 	lw f0, 2(a4); 	sw f0, 0(a22); 
nop; 	addi a4, a4, 132; nop; nop; 
	addi a3, zero, 1; 	add a22, a4, a3; nop; nop; 
	bne a2, a3, be_else.15971; nop; nop; 	sw f0, 0(a22); 
	addi a3, zero, 0; 	lui.float f2, 20.000000; 	lw a2, 5(a0); 	lw f0, 0(a1); 
nop; 	addi.float f2, f2, 20.000000; 	lw f1, 0(a2); 	lw a0, 5(a0); 
	lui.float f1, 0.050000; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 0.050000; nop; nop; 
nop; 	fmul f1, f0, f1; nop; nop; 
nop; 	floor f1, f1; nop; nop; 
	lui.float f2, 20.000000; 	fmul f1, f1, f2; nop; nop; 
	addi.float f2, f2, 20.000000; 	fsub f0, f0, f1; nop; nop; 
nop; 	lui.float f1, 10.000000; nop; nop; 
nop; 	addi.float f1, f1, 10.000000; nop; nop; 
	addi a1, zero, 1; 	flt a2, f0, f1; 	lw f1, 2(a0); 	lw f0, 2(a1); 
	lui.float f1, 0.050000; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 0.050000; nop; nop; 
nop; 	fmul f1, f0, f1; nop; nop; 
nop; 	floor f1, f1; nop; nop; 
nop; 	fmul f1, f1, f2; nop; nop; 
	lui.float f1, 10.000000; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 10.000000; nop; nop; 
	bne a2, a3, be_else.15972; 	flt a0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
	bne a0, a3, be_else.15974; nop; nop; nop; 
nop; 	lui.float f0, 255.000000; nop; nop; 
	jump be_cont.15975; 	addi.float f0, f0, 255.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.15974:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
be_cont.15975:
	jump be_cont.15973; nop; nop; nop; 
be_else.15972:
	bne a0, a3, be_else.15976; nop; nop; nop; 
nop; 	lui.float f0, 0.000000; nop; nop; 
	jump be_cont.15977; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.15976:
nop; 	lui.float f0, 255.000000; nop; nop; 
nop; 	addi.float f0, f0, 255.000000; nop; nop; 
be_cont.15977:
be_cont.15973:
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 132; nop; nop; 
nop; 	add a22, a0, a1; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.15971:
nop; 	addi a3, zero, 2; nop; nop; 
	bne a2, a3, be_else.15979; nop; nop; nop; 
	addi sp, sp, -1; 	lui.float f1, 0.250000; nop; 	lw f0, 1(a1); 
nop; 	addi.float f1, f1, 0.250000; nop; nop; 
	call sin; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
	fmul f0, f0, f0; 	addi sp, sp, 1; nop; nop; 
	lui a0, 4096; 	lui.float f1, 255.000000; nop; nop; 
	lui a1, 4096; 	lui.float f2, 1.000000; nop; nop; 
	addi a0, a0, 132; 	addi.float f1, f1, 255.000000; nop; nop; 
	addi a1, a1, 132; 	addi.float f2, f2, 1.000000; nop; nop; 
	fsub f0, f2, f0; 	fmul f1, f1, f0; nop; nop; 
	lui.float f1, 255.000000; 	addi a0, zero, 1; nop; 	sw f1, 0(a0); 
	add a22, a1, a0; 	addi.float f1, f1, 255.000000; nop; nop; 
nop; 	fmul f0, f1, f0; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.15979:
nop; 	addi a3, zero, 3; nop; nop; 
	bne a2, a3, be_else.15981; nop; nop; nop; 
nop; 	addi sp, sp, -1; 	lw a2, 5(a0); 	lw f0, 0(a1); 
nop; nop; 	lw f1, 0(a2); 	lw a0, 5(a0); 
nop; 	fsub f0, f0, f1; 	lw f1, 2(a1); 	lw f2, 2(a0); 
	fmul f0, f0, f0; 	fsub f1, f1, f2; nop; nop; 
nop; 	fmul f1, f1, f1; nop; nop; 
	lui.float f1, 10.000000; 	fadd f0, f0, f1; nop; nop; 
	addi.float f1, f1, 10.000000; 	fsqrt f0, f0; nop; nop; 
nop; 	fdiv f0, f0, f1; nop; nop; 
nop; 	floor f1, f0; nop; nop; 
	lui.float f1, 3.141593; 	fsub f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 3.141593; nop; nop; 
	call cos; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
	fmul f0, f0, f0; 	addi sp, sp, 1; nop; nop; 
	lui.float f1, 255.000000; 	addi a0, zero, 1; nop; nop; 
	addi.float f1, f1, 255.000000; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 132; 	fmul f1, f0, f1; nop; nop; 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
	lui.float f1, 1.000000; 	lui a1, 4096; nop; 	sw f1, 0(a22); 
	addi a1, a1, 132; 	addi.float f1, f1, 1.000000; nop; nop; 
	add a22, a1, a0; 	fsub f0, f1, f0; nop; nop; 
nop; 	lui.float f1, 255.000000; nop; nop; 
nop; 	addi.float f1, f1, 255.000000; nop; nop; 
nop; 	fmul f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.15981:
nop; 	addi a3, zero, 4; nop; nop; 
	bne a2, a3, be_else.15983; nop; nop; nop; 
	addi a3, zero, 0; 	lui.float f4, 0.000100; 	lw a2, 5(a0); 	lw f0, 0(a1); 
nop; 	addi.float f4, f4, 0.000100; 	sw a1, -2(sp); 	sw a0, -1(sp); 
nop; nop; 	lw a2, 4(a0); 	lw f1, 0(a2); 
nop; 	fsub f0, f0, f1; 	lw a2, 5(a0); 	lw f1, 0(a2); 
nop; 	fsqrt f1, f1; 	lw a2, 4(a0); 	lw f2, 2(a2); 
nop; 	fmul f0, f0, f1; nop; 	lw f1, 2(a1); 
nop; 	fsub f1, f1, f2; nop; 	lw f2, 2(a2); 
nop; 	fsqrt f2, f2; nop; nop; 
	fmul f2, f0, f0; 	fmul f1, f1, f2; nop; nop; 
nop; 	fmul f3, f1, f1; nop; nop; 
	fabs f3, f0; 	fadd f2, f2, f3; nop; nop; 
nop; 	flt a2, f3, f4; nop; 	sw f2, 0(sp); 
	bne a2, a3, be_else.15984; nop; nop; nop; 
	addi sp, sp, -5; 	fdiv f0, f1, f0; nop; nop; 
	call atan; 	fabs f0, f0; nop; nop; 
nop; nop; nop; nop; 
	lui.float f1, 30.000000; 	addi sp, sp, 5; nop; nop; 
nop; 	addi.float f1, f1, 30.000000; nop; nop; 
	lui.float f1, 3.141593; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 3.141593; nop; nop; 
	jump be_cont.15985; 	fdiv f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15984:
nop; 	lui.float f0, 15.000000; nop; nop; 
nop; 	addi.float f0, f0, 15.000000; nop; nop; 
be_cont.15985:
	lui.float f4, 0.000100; 	floor f1, f0; nop; 	lw a0, -2(sp); 
	addi.float f4, f4, 0.000100; 	fsub f0, f0, f1; 	lw a0, -1(sp); 	lw f1, 1(a0); 
nop; nop; 	sw f0, -3(sp); 	lw a1, 5(a0); 
nop; 	addi a1, zero, 0; 	lw f2, 1(a1); 	lw a0, 4(a0); 
nop; 	fsub f1, f1, f2; nop; 	lw f2, 1(a0); 
nop; 	fsqrt f2, f2; nop; nop; 
nop; 	fmul f1, f1, f2; nop; 	lw f2, 0(sp); 
nop; 	fabs f3, f2; nop; nop; 
nop; 	flt a0, f3, f4; nop; nop; 
	bne a0, a1, be_else.15986; nop; nop; nop; 
	addi sp, sp, -5; 	fdiv f1, f1, f2; nop; nop; 
nop; 	fabs f1, f1; nop; nop; 
	call atan; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
	lui.float f1, 30.000000; 	addi sp, sp, 5; nop; nop; 
nop; 	addi.float f1, f1, 30.000000; nop; nop; 
	lui.float f1, 3.141593; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi.float f1, f1, 3.141593; nop; nop; 
	jump be_cont.15987; 	fdiv f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.15986:
nop; 	lui.float f0, 15.000000; nop; nop; 
nop; 	addi.float f0, f0, 15.000000; nop; nop; 
be_cont.15987:
	lui.float f2, 0.500000; 	floor f1, f0; nop; 	lw f3, -3(sp); 
	fsub f0, f0, f1; 	addi a1, zero, 0; nop; nop; 
	lui.float f1, 0.150000; 	addi.float f2, f2, 0.500000; nop; nop; 
	fsub f2, f2, f3; 	addi.float f1, f1, 0.150000; nop; nop; 
nop; 	fmul f2, f2, f2; nop; nop; 
	lui.float f2, 0.500000; 	fsub f1, f1, f2; nop; nop; 
nop; 	addi.float f2, f2, 0.500000; nop; nop; 
nop; 	fsub f0, f2, f0; nop; nop; 
nop; 	fmul f0, f0, f0; nop; nop; 
nop; 	fsub f0, f1, f0; nop; nop; 
nop; 	flt a0, f0, fzero; nop; nop; 
	bne a0, a1, be_else.15988; nop; nop; nop; 
	jump be_cont.15989; nop; nop; nop; 
be_else.15988:
nop; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
be_cont.15989:
	lui.float f1, 255.000000; 	addi a0, zero, 2; nop; nop; 
	addi.float f1, f1, 255.000000; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 132; 	fmul f0, f1, f0; nop; nop; 
	add a22, a1, a0; 	lui.float f1, 0.300000; nop; nop; 
nop; 	addi.float f1, f1, 0.300000; nop; nop; 
nop; 	fdiv f0, f0, f1; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.15983:
	ret; nop; nop; nop; 
add_light.2819:
	addi a3, zero, 0; 	flt a2, fzero, f0; 	lw a0, 1(cl); 	lw a1, 2(cl); 
	bne a2, a3, be_else.15992; nop; 	sw f1, -1(sp); 	sw f2, 0(sp); 
	jump be_cont.15993; nop; nop; nop; 
be_else.15992:
	call vecaccum.2530; 	addi sp, sp, -3; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
be_cont.15993:
nop; 	addi a1, zero, 0; nop; 	lw f0, -1(sp); 
nop; 	flt a0, fzero, f0; nop; nop; 
	bne a0, a1, be_else.15994; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.15994:
	lui a0, 4096; 	fmul f0, f0, f0; nop; 	lw f1, 0(sp); 
	fmul f0, f0, f0; 	lui a1, 4096; nop; nop; 
	fmul f0, f0, f1; 	addi a0, a0, 138; nop; nop; 
	lui a0, 4096; 	addi a1, a1, 138; nop; 	lw f1, 0(a0); 
	addi a0, a0, 138; 	fadd f1, f1, f0; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f1, 0(a0); 
	lui a1, 4096; 	add a22, a1, a0; nop; nop; 
nop; 	addi a1, a1, 138; nop; 	lw f1, 0(a22); 
	add a22, a1, a0; 	fadd f1, f1, f0; nop; nop; 
	lui a1, 4096; 	addi a0, zero, 2; nop; 	sw f1, 0(a22); 
nop; 	addi a1, a1, 138; nop; nop; 
	lui a1, 4096; 	add a22, a1, a0; nop; nop; 
nop; 	addi a1, a1, 138; nop; 	lw f1, 0(a22); 
	add a22, a1, a0; 	fadd f0, f1, f0; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
trace_reflections.2823:
nop; 	addi a5, zero, 0; 	lw a3, 9(cl); 	lw a2, 13(cl); 
	blt a0, a5, ble_else.15997; nop; nop; 	lw a4, 4(cl); 
	lui.float f2, 1000000000.000000; 	lui a6, 4096; 	sw a0, -1(sp); 	sw cl, 0(sp); 
	add cl, a4, zero; 	lui a8, 4096; 	sw a2, -3(sp); 	sw f1, -2(sp); 
	addi.float f2, f2, 1000000000.000000; 	addi a6, a6, 171; 	sw f0, -5(sp); 	sw a1, -4(sp); 
	add a22, a6, a0; 	addi a8, a8, 124; 	lw swp, 0(cl); 	sw a3, -7(sp); 
	lui a8, 4096; 	add a0, a5, zero; 	sw f2, 0(a8); 	lw a6, 0(a22); 
nop; 	addi a8, a8, 121; 	sw a6, -8(sp); 	lw a7, 1(a6); 
	addi sp, sp, -11; 	add a2, a7, zero; 	sw a7, -6(sp); 	lw a8, 0(a8); 
	callr swp; 	add a1, a8, zero; nop; nop; 
nop; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 11; nop; nop; 
	addi a1, zero, 0; 	lui.float f1, -0.100000; nop; nop; 
	addi.float f1, f1, -0.100000; 	addi a0, a0, 124; nop; nop; 
nop; nop; nop; 	lw f0, 0(a0); 
nop; 	flt a0, f1, f0; nop; nop; 
	bne a0, a1, be_else.15998; nop; nop; nop; 
	jump be_cont.15999; 	add a0, a1, zero; nop; nop; 
be_else.15998:
nop; 	lui.float f1, 100000000.000000; nop; nop; 
nop; 	addi.float f1, f1, 100000000.000000; nop; nop; 
nop; 	flt a0, f0, f1; nop; nop; 
be_cont.15999:
	bne a0, a1, be_else.16000; nop; nop; nop; 
	jump be_cont.16001; nop; nop; nop; 
be_else.16000:
	lui a2, 4096; 	lui a0, 4096; nop; nop; 
	addi a2, a2, 123; 	addi a0, a0, 128; nop; nop; 
nop; nop; 	lw a2, 0(a2); 	lw a0, 0(a0); 
nop; 	slli a0, a0, 2; nop; nop; 
nop; 	add a0, a0, a2; nop; 	lw a2, -8(sp); 
nop; nop; nop; 	lw a3, 0(a2); 
	bne a0, a3, be_else.16002; nop; nop; nop; 
	add swp, a1, zero; 	lui a0, 4096; nop; 	lw cl, -7(sp); 
	addi a0, a0, 121; 	addi sp, sp, -11; nop; nop; 
nop; nop; nop; 	lw a0, 0(a0); 
	add a0, swp, zero; 	add a1, a0, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 11; nop; nop; 
	bne a0, a1, be_else.16004; nop; nop; nop; 
	lui a3, 4096; 	lui a2, 4096; 	lw cl, -3(sp); 	lw a0, -6(sp); 
	addi a3, a3, 129; 	addi a2, a2, 129; 	lw swp, 0(cl); 	lw a1, 0(a0); 
nop; 	addi a2, zero, 1; 	lw f0, 0(a2); 	lw a0, 0(a0); 
	addi a2, zero, 2; 	add a22, a3, a2; 	lw f2, 1(a1); 	lw f1, 0(a1); 
	fmul f0, f0, f1; 	lui a3, 4096; 	lw f5, 1(a0); 	lw f4, 0(a0); 
nop; 	addi a3, a3, 129; nop; 	lw f1, 0(a22); 
	add a22, a3, a2; 	fmul f1, f1, f2; 	lw a1, -8(sp); 	lw f2, 2(a1); 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 0(a22); 
nop; 	fmul f1, f1, f2; nop; 	lw f2, -5(sp); 
nop; 	fadd f0, f0, f1; 	lw a1, -4(sp); 	lw f1, 2(a1); 
nop; 	fmul f3, f1, f2; nop; nop; 
nop; 	fmul f0, f3, f0; nop; 	lw f3, 0(a1); 
nop; 	fmul f3, f3, f4; nop; 	lw f4, 1(a1); 
nop; 	fmul f4, f4, f5; nop; 	lw f5, 2(a0); 
nop; 	fadd f3, f3, f4; nop; 	lw f4, 2(a1); 
nop; 	fmul f4, f4, f5; nop; nop; 
nop; 	fadd f3, f3, f4; nop; nop; 
	addi sp, sp, -11; 	fmul f1, f1, f3; nop; 	lw f3, -2(sp); 
	callr swp; 	addi f2, f3, 0; nop; nop; 
nop; nop; nop; nop; 
	jump be_cont.16005; 	addi sp, sp, 11; nop; nop; 
be_else.16004:
be_cont.16005:
	jump be_cont.16003; nop; nop; nop; 
be_else.16002:
be_cont.16003:
be_cont.16001:
nop; nop; 	lw f0, -5(sp); 	lw a0, -1(sp); 
nop; 	addi a0, a0, -1; 	lw a1, -4(sp); 	lw f1, -2(sp); 
nop; nop; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.15997:
	ret; nop; nop; nop; 
trace_ray.2828:
nop; 	addi a12, zero, 4; 	lw a4, 67(cl); 	lw a3, 70(cl); 
nop; nop; 	lw a6, 49(cl); 	lw a5, 59(cl); 
nop; nop; 	lw a8, 26(cl); 	lw a7, 32(cl); 
nop; nop; 	lw a10, 18(cl); 	lw a9, 25(cl); 
	blt a12, a0, ble_else.16007; nop; nop; 	lw a11, 3(cl); 
	lui a13, 4096; 	lui.float f2, 1000000000.000000; 	sw cl, 0(sp); 	lw a12, 2(a2); 
	add cl, a11, zero; 	addi a14, zero, 0; 	sw a3, -2(sp); 	sw f1, -1(sp); 
	addi a13, a13, 124; 	addi.float f2, f2, 1000000000.000000; 	sw a5, -4(sp); 	sw a4, -3(sp); 
nop; nop; 	sw a10, -6(sp); 	sw a6, -5(sp); 
nop; 	add a2, a1, zero; 	sw a8, -8(sp); 	sw a2, -7(sp); 
nop; nop; 	sw a9, -10(sp); 	sw a7, -9(sp); 
nop; nop; 	sw a1, -12(sp); 	sw f0, -11(sp); 
	addi sp, sp, -17; 	add a0, a14, zero; 	sw a12, -14(sp); 	sw a0, -13(sp); 
nop; 	lui a13, 4096; 	sw f2, 0(a13); 	lw swp, 0(cl); 
nop; 	addi a13, a13, 121; nop; nop; 
nop; nop; nop; 	lw a13, 0(a13); 
	callr swp; 	add a1, a13, zero; nop; nop; 
nop; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 17; nop; nop; 
	addi a1, zero, 0; 	lui.float f1, -0.100000; nop; nop; 
	addi.float f1, f1, -0.100000; 	addi a0, a0, 124; nop; nop; 
nop; nop; nop; 	lw f0, 0(a0); 
nop; 	flt a0, f1, f0; nop; nop; 
	bne a0, a1, be_else.16008; nop; nop; nop; 
	jump be_cont.16009; 	add a0, a1, zero; nop; nop; 
be_else.16008:
nop; 	lui.float f1, 100000000.000000; nop; nop; 
nop; 	addi.float f1, f1, 100000000.000000; nop; nop; 
nop; 	flt a0, f0, f1; nop; nop; 
be_cont.16009:
	bne a0, a1, be_else.16010; nop; nop; nop; 
nop; 	lui a0, 1048575; 	lw a3, -14(sp); 	lw a2, -13(sp); 
	add a22, a2, a3; 	addi a0, a0, 4095; nop; nop; 
	bne a2, a1, be_else.16011; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.16011:
	lui a3, 4096; 	lui a2, 4096; nop; 	lw a0, -12(sp); 
	addi a3, a3, 67; 	addi a2, a2, 67; nop; 	lw f0, 0(a0); 
nop; 	addi a2, zero, 1; nop; 	lw f1, 0(a2); 
	add a22, a3, a2; 	fmul f0, f0, f1; nop; 	lw f1, 1(a0); 
nop; 	addi a2, zero, 2; nop; 	lw f2, 0(a22); 
nop; 	fmul f1, f1, f2; nop; nop; 
	lui a0, 4096; 	fadd f0, f0, f1; nop; 	lw f1, 2(a0); 
nop; 	addi a0, a0, 67; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw f2, 0(a22); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	fneg f0, f0; nop; nop; 
nop; 	flt a0, fzero, f0; nop; nop; 
	bne a0, a1, be_else.16013; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.16013:
	lui a0, 4096; 	fmul f1, f0, f0; nop; nop; 
	lui a2, 4096; 	addi a1, zero, 1; nop; nop; 
	addi a0, a0, 70; 	fmul f0, f1, f0; nop; 	lw f1, -11(sp); 
	fmul f0, f0, f1; 	addi a2, a2, 138; nop; 	lw f1, 0(a0); 
	fmul f0, f0, f1; 	lui a0, 4096; nop; nop; 
	addi a0, a0, 138; 	add a22, a2, a1; nop; nop; 
	lui a2, 4096; 	lui a1, 4096; nop; 	lw f1, 0(a0); 
	fadd f1, f1, f0; 	lui a0, 4096; nop; nop; 
	addi a2, a2, 138; 	addi a1, a1, 138; nop; nop; 
nop; 	addi a0, a0, 138; nop; nop; 
nop; 	addi a0, zero, 1; 	lw f1, 0(a22); 	sw f1, 0(a0); 
	add a22, a1, a0; 	fadd f1, f1, f0; nop; nop; 
	addi a1, zero, 2; 	addi a0, zero, 2; nop; 	sw f1, 0(a22); 
	lui a1, 4096; 	add a22, a2, a1; nop; nop; 
nop; 	addi a1, a1, 138; nop; 	lw f1, 0(a22); 
	add a22, a1, a0; 	fadd f0, f1, f0; nop; nop; 
	ret; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.16010:
	lui a2, 4096; 	lui a0, 4096; nop; 	lw f1, -11(sp); 
	addi a0, a0, 128; 	addi a5, zero, 1; nop; nop; 
nop; 	addi a2, a2, 1; nop; 	lw a0, 0(a0); 
nop; 	add a22, a2, a0; nop; 	sw a0, -17(sp); 
nop; nop; nop; 	lw a2, 0(a22); 
nop; nop; 	lw a4, 7(a2); 	lw a3, 2(a2); 
nop; nop; 	lw f0, 0(a4); 	sw a2, -18(sp); 
nop; 	fmul f0, f0, f1; 	lw a4, 1(a2); 	sw a3, -15(sp); 
	bne a4, a5, be_else.16016; nop; nop; 	sw f0, -16(sp); 
	lui a5, 4096; 	lui a4, 4096; nop; nop; 
	lui a6, 4096; 	lui.float f2, 0.000000; nop; nop; 
	addi a5, a5, 129; 	addi a4, a4, 123; nop; nop; 
	addi a6, a6, 129; 	addi.float f2, f2, 0.000000; nop; 	lw a4, 0(a4); 
nop; 	addi a5, zero, 1; nop; 	sw f2, 0(a5); 
	addi a5, zero, 2; 	add a22, a6, a5; nop; nop; 
nop; 	lui a6, 4096; nop; 	sw f2, 0(a22); 
nop; 	addi a6, a6, 129; nop; nop; 
	addi a5, a4, -1; 	add a22, a6, a5; nop; 	lw a6, -12(sp); 
nop; 	addi a4, a4, -1; nop; 	sw f2, 0(a22); 
nop; 	add a22, a4, a6; nop; nop; 
nop; nop; nop; 	lw f3, 0(a22); 
nop; 	feq a4, f3, fzero; nop; nop; 
	bne a4, a1, be_else.16018; nop; nop; nop; 
nop; 	flt a4, fzero, f3; nop; nop; 
	bne a4, a1, be_else.16020; nop; nop; nop; 
nop; 	lui.float f2, -1.000000; nop; nop; 
	jump be_cont.16021; 	addi.float f2, f2, -1.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.16020:
nop; 	lui.float f2, 1.000000; nop; nop; 
nop; 	addi.float f2, f2, 1.000000; nop; nop; 
be_cont.16021:
	jump be_cont.16019; nop; nop; nop; 
be_else.16018:
be_cont.16019:
	lui a4, 4096; 	fneg f2, f2; nop; nop; 
nop; 	addi a4, a4, 129; nop; nop; 
nop; 	add a22, a4, a5; nop; nop; 
	jump be_cont.16017; nop; nop; 	sw f2, 0(a22); 
nop; nop; nop; nop; 
be_else.16016:
nop; 	addi a5, zero, 2; nop; nop; 
	bne a4, a5, be_else.16022; nop; nop; nop; 
nop; nop; 	lw a5, 4(a2); 	lw a4, 4(a2); 
nop; 	lui a4, 4096; nop; 	lw f2, 0(a4); 
	addi a4, a4, 129; 	fneg f2, f2; nop; nop; 
	lui a5, 4096; 	addi a4, zero, 1; 	lw f2, 1(a5); 	sw f2, 0(a4); 
	addi a5, a5, 129; 	fneg f2, f2; nop; nop; 
	addi a4, zero, 2; 	add a22, a5, a4; nop; 	lw a5, 4(a2); 
nop; 	lui a5, 4096; 	lw f2, 2(a5); 	sw f2, 0(a22); 
	addi a5, a5, 129; 	fneg f2, f2; nop; nop; 
nop; 	add a22, a5, a4; nop; nop; 
	jump be_cont.16023; nop; nop; 	sw f2, 0(a22); 
nop; nop; nop; nop; 
be_else.16022:
	addi sp, sp, -21; 	add a0, a2, zero; nop; 	lw cl, -10(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
be_cont.16023:
be_cont.16017:
	addi a1, zero, 1; 	lui a0, 4096; nop; 	lw cl, -9(sp); 
	addi a0, a0, 125; 	lui a2, 4096; nop; 	lw swp, 0(cl); 
	lui a0, 4096; 	addi a2, a2, 125; nop; 	lw f0, 0(a0); 
	add a22, a2, a1; 	addi a0, a0, 146; nop; nop; 
	lui a2, 4096; 	lui a1, 4096; 	lw f0, 0(a22); 	sw f0, 0(a0); 
	addi a1, a1, 146; 	addi a0, zero, 1; nop; nop; 
	add a22, a1, a0; 	addi a2, a2, 125; nop; nop; 
	addi a1, zero, 2; 	addi a0, zero, 2; nop; 	sw f0, 0(a22); 
	lui a1, 4096; 	add a22, a2, a1; nop; nop; 
nop; 	addi a1, a1, 146; nop; 	lw f0, 0(a22); 
	addi sp, sp, -21; 	add a22, a1, a0; 	lw a1, -8(sp); 	lw a0, -18(sp); 
	callr swp; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 21; nop; nop; 
	lui a5, 4096; 	lui a4, 4096; 	lw a2, -14(sp); 	lw a0, -17(sp); 
	addi a6, zero, 0; 	lui.float f1, 0.500000; nop; nop; 
	slli a0, a0, 2; 	addi a1, a1, 123; nop; nop; 
	addi a5, a5, 125; 	addi a4, a4, 125; nop; 	lw a1, 0(a1); 
	add a0, a0, a1; 	addi.float f1, f1, 0.500000; 	lw a1, -13(sp); 	lw f0, 0(a4); 
	add a22, a1, a2; 	addi a4, zero, 1; nop; nop; 
nop; nop; 	lw a0, -7(sp); 	sw a0, 0(a22); 
nop; nop; nop; 	lw a3, 1(a0); 
nop; 	add a22, a1, a3; nop; nop; 
	addi a4, zero, 2; 	add a22, a5, a4; nop; 	lw a3, 0(a22); 
nop; 	lui a5, 4096; 	lw f0, 0(a22); 	sw f0, 0(a3); 
nop; 	addi a5, a5, 125; nop; 	sw f0, 1(a3); 
nop; 	add a22, a5, a4; nop; 	lw a4, -18(sp); 
nop; nop; 	lw a5, 7(a4); 	lw f0, 0(a22); 
nop; nop; 	lw a3, 3(a0); 	sw f0, 2(a3); 
nop; nop; nop; 	lw f0, 0(a5); 
nop; 	flt a5, f0, f1; nop; nop; 
	bne a5, a6, be_else.16024; nop; nop; nop; 
	add a22, a1, a3; 	addi a5, zero, 1; 	lw a3, 4(a0); 	lw f1, -16(sp); 
	lui a8, 4096; 	lui a7, 4096; nop; 	sw a5, 0(a22); 
	addi a7, a7, 132; 	add a22, a1, a3; nop; nop; 
	addi a7, zero, 1; 	addi a8, a8, 132; 	lw f0, 0(a7); 	lw a5, 0(a22); 
	addi a7, zero, 2; 	add a22, a8, a7; nop; 	sw f0, 0(a5); 
nop; 	lui a8, 4096; nop; 	lw f0, 0(a22); 
nop; 	addi a8, a8, 132; nop; 	sw f0, 1(a5); 
	lui a7, 4096; 	add a22, a8, a7; nop; nop; 
	add a22, a1, a3; 	addi a7, a7, 129; nop; 	lw f0, 0(a22); 
	lui a5, 4096; 	lui.float f0, 0.003906; 	lw a3, 0(a22); 	sw f0, 2(a5); 
	addi a5, a5, 129; 	addi.float f0, f0, 0.003906; nop; 	lw f2, 0(a3); 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	fmul f2, f2, f0; nop; nop; 
nop; nop; 	lw f2, 1(a3); 	sw f2, 0(a3); 
nop; 	fmul f2, f2, f0; nop; nop; 
nop; nop; 	lw f2, 2(a3); 	sw f2, 1(a3); 
nop; 	fmul f0, f2, f0; nop; nop; 
nop; nop; 	lw a3, 7(a0); 	sw f0, 2(a3); 
	addi a5, zero, 1; 	add a22, a1, a3; nop; 	lw f0, 0(a5); 
	addi a5, zero, 2; 	add a22, a7, a5; nop; 	lw a3, 0(a22); 
nop; 	lui a7, 4096; 	lw f0, 0(a22); 	sw f0, 0(a3); 
nop; 	addi a7, a7, 129; nop; 	sw f0, 1(a3); 
nop; 	add a22, a7, a5; nop; nop; 
nop; nop; nop; 	lw f0, 0(a22); 
	jump be_cont.16025; nop; nop; 	sw f0, 2(a3); 
nop; nop; nop; nop; 
be_else.16024:
nop; 	add a22, a1, a3; nop; nop; 
nop; nop; nop; 	sw a6, 0(a22); 
be_cont.16025:
	lui a5, 4096; 	lui.float f0, -2.000000; nop; 	lw a3, -12(sp); 
	addi.float f0, f0, -2.000000; 	lui a7, 4096; nop; 	lw f1, 0(a3); 
	add a0, a3, zero; 	addi a5, a5, 129; nop; nop; 
	addi a5, zero, 1; 	addi a7, a7, 129; nop; 	lw f2, 0(a5); 
	add a22, a7, a5; 	fmul f1, f1, f2; nop; 	lw f2, 1(a3); 
	lui a7, 4096; 	addi a5, zero, 2; nop; 	lw f3, 0(a22); 
	addi a7, a7, 129; 	fmul f2, f2, f3; nop; nop; 
	add a22, a7, a5; 	fadd f1, f1, f2; 	lw a5, -6(sp); 	lw f2, 2(a3); 
	add a1, a5, zero; 	addi sp, sp, -21; nop; 	lw f3, 0(a22); 
nop; 	fmul f2, f2, f3; nop; nop; 
nop; 	fadd f1, f1, f2; nop; nop; 
	call vecaccum.2530; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 21; nop; nop; 
nop; nop; 	lw f1, -11(sp); 	lw a0, -18(sp); 
nop; 	add a0, a2, zero; 	lw a1, 7(a0); 	lw cl, -5(sp); 
nop; 	lui a1, 4096; 	lw swp, 0(cl); 	lw f0, 1(a1); 
	addi a1, a1, 121; 	fmul f0, f1, f0; nop; nop; 
nop; 	addi sp, sp, -21; 	sw f0, -19(sp); 	lw a1, 0(a1); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 21; nop; nop; 
	bne a0, a1, be_else.16026; nop; nop; nop; 
	lui a2, 4096; 	lui a0, 4096; nop; 	lw cl, -4(sp); 
	addi a0, a0, 129; 	lui a3, 4096; nop; 	lw swp, 0(cl); 
	addi a3, a3, 67; 	addi a2, a2, 129; nop; 	lw f0, 0(a0); 
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 67; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	lw f1, 0(a0); 
	add a22, a2, a0; 	fmul f0, f0, f1; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f1, 0(a22); 
nop; 	addi a2, a2, 67; nop; nop; 
	addi a0, zero, 2; 	add a22, a2, a0; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f2, 0(a22); 
	addi a2, a2, 129; 	fmul f1, f1, f2; nop; nop; 
	add a22, a2, a0; 	fadd f0, f0, f1; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f1, 0(a22); 
nop; 	addi a2, a2, 67; nop; nop; 
	lui a2, 4096; 	add a22, a2, a0; nop; 	lw a0, -12(sp); 
nop; 	addi a2, a2, 67; nop; 	lw f2, 0(a22); 
	addi a2, zero, 1; 	fmul f1, f1, f2; 	lw f2, 0(a0); 	lw f3, 0(a2); 
	fmul f2, f2, f3; 	fadd f0, f0, f1; 	lw f3, 1(a0); 	lw f1, -16(sp); 
	fneg f0, f0; 	add a22, a3, a2; nop; nop; 
	lui a3, 4096; 	addi a2, zero, 2; nop; 	lw f4, 0(a22); 
	fmul f3, f3, f4; 	fmul f0, f0, f1; nop; nop; 
	fadd f2, f2, f3; 	addi a3, a3, 67; nop; 	lw f3, 2(a0); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw f4, 0(a22); 
nop; 	fmul f3, f3, f4; nop; nop; 
	addi sp, sp, -21; 	fadd f2, f2, f3; nop; 	lw f3, -19(sp); 
nop; 	fneg f2, f2; nop; nop; 
	addi f2, f3, 0; 	addi f1, f2, 0; nop; nop; 
	callr swp; nop; nop; nop; 
	jump be_cont.16027; 	addi sp, sp, 21; nop; nop; 
be_else.16026:
be_cont.16027:
	lui a1, 4096; 	lui a0, 4096; nop; 	lw cl, -3(sp); 
	addi a1, a1, 125; 	addi a0, a0, 125; nop; 	lw swp, 0(cl); 
nop; 	lui a0, 4096; nop; 	lw f0, 0(a0); 
nop; 	addi a0, a0, 149; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	sw f0, 0(a0); 
	lui a1, 4096; 	add a22, a1, a0; nop; nop; 
nop; 	addi a1, a1, 149; nop; 	lw f0, 0(a22); 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
nop; 	lui a1, 4096; nop; 	sw f0, 0(a22); 
nop; 	addi a1, a1, 125; nop; nop; 
	lui a1, 4096; 	add a22, a1, a0; nop; nop; 
nop; 	addi a1, a1, 149; nop; 	lw f0, 0(a22); 
	lui a0, 4096; 	add a22, a1, a0; nop; nop; 
nop; 	addi a0, a0, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a0, 0(a0); 
	addi sp, sp, -21; 	addi a1, a0, -1; nop; 	lw a0, -8(sp); 
	callr swp; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 21; nop; nop; 
nop; 	addi a0, a0, 351; 	lw f1, -19(sp); 	lw f0, -16(sp); 
nop; 	addi sp, sp, -21; 	lw cl, -2(sp); 	lw a1, -12(sp); 
nop; nop; 	lw swp, 0(cl); 	lw a0, 0(a0); 
	callr swp; 	addi a0, a0, -1; nop; nop; 
	lui.float f0, 0.100000; 	addi sp, sp, 21; nop; nop; 
	addi.float f0, f0, 0.100000; 	addi a1, zero, 0; nop; 	lw f1, -11(sp); 
nop; 	flt a0, f0, f1; nop; nop; 
	bne a0, a1, be_else.16028; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.16028:
nop; 	addi a0, zero, 4; nop; 	lw a1, -13(sp); 
	blt a1, a0, ble_else.16030; nop; nop; nop; 
	jump ble_cont.16031; nop; nop; nop; 
ble_else.16030:
	lui a2, 1048575; 	addi a0, a1, 1; nop; 	lw a3, -14(sp); 
	add a22, a0, a3; 	addi a2, a2, 4095; nop; nop; 
nop; nop; nop; 	sw a2, 0(a22); 
ble_cont.16031:
nop; 	addi a0, zero, 2; nop; 	lw a2, -15(sp); 
	bne a2, a0, be_else.16032; nop; nop; nop; 
nop; 	lui.float f0, 1.000000; 	lw a2, -7(sp); 	lw a0, -18(sp); 
nop; 	addi.float f0, f0, 1.000000; 	lw a0, 7(a0); 	lw cl, 0(sp); 
	lui a1, 4096; 	addi a0, a1, 1; 	lw swp, 0(cl); 	lw f2, 0(a0); 
	addi a1, a1, 124; 	fsub f0, f0, f2; nop; 	lw f2, -1(sp); 
nop; 	fmul f0, f1, f0; 	lw a1, -12(sp); 	lw f1, 0(a1); 
	jumpr swp; 	fadd f1, f2, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.16032:
	ret; nop; nop; nop; 
ble_else.16007:
	ret; nop; nop; nop; 
trace_diffuse_ray.2834:
	lui a7, 4096; 	lui.float f1, 1000000000.000000; 	lw a2, 26(cl); 	lw a1, 27(cl); 
	addi.float f1, f1, 1000000000.000000; 	addi a8, zero, 0; 	lw a4, 17(cl); 	lw a3, 19(cl); 
nop; 	addi a7, a7, 124; 	lw a6, 15(cl); 	lw a5, 16(cl); 
nop; nop; 	sw a0, -7(sp); 	sw f0, -2(sp); 
	add a0, a8, zero; 	add a2, a0, zero; 	sw a2, -1(sp); 	sw a1, 0(sp); 
nop; nop; 	sw a4, -4(sp); 	sw a3, -3(sp); 
nop; 	lui a7, 4096; 	sw f1, 0(a7); 	lw cl, 3(cl); 
	addi sp, sp, -9; 	addi a7, a7, 121; 	sw a6, -6(sp); 	sw a5, -5(sp); 
nop; nop; 	lw a7, 0(a7); 	lw swp, 0(cl); 
	callr swp; 	add a1, a7, zero; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 9; nop; nop; 
	addi a1, zero, 0; 	lui.float f1, -0.100000; nop; nop; 
	addi.float f1, f1, -0.100000; 	addi a0, a0, 124; nop; nop; 
nop; nop; nop; 	lw f0, 0(a0); 
nop; 	flt a0, f1, f0; nop; nop; 
	bne a0, a1, be_else.16035; nop; nop; nop; 
	jump be_cont.16036; 	add a0, a1, zero; nop; nop; 
be_else.16035:
nop; 	lui.float f1, 100000000.000000; nop; nop; 
nop; 	addi.float f1, f1, 100000000.000000; nop; nop; 
nop; 	flt a0, f0, f1; nop; nop; 
be_cont.16036:
	bne a0, a1, be_else.16037; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.16037:
	lui a2, 4096; 	lui a0, 4096; nop; nop; 
	addi a0, a0, 128; 	addi a4, zero, 1; nop; nop; 
nop; 	addi a2, a2, 1; nop; 	lw a0, 0(a0); 
nop; 	add a22, a2, a0; nop; 	lw a2, -7(sp); 
nop; nop; 	lw a2, 0(a2); 	lw a0, 0(a22); 
nop; nop; 	sw a0, -8(sp); 	lw a3, 1(a0); 
	bne a3, a4, be_else.16039; nop; nop; nop; 
	lui a4, 4096; 	lui a3, 4096; nop; nop; 
	lui a5, 4096; 	lui.float f0, 0.000000; nop; nop; 
	addi a4, a4, 129; 	addi a3, a3, 123; nop; nop; 
	addi a5, a5, 129; 	addi.float f0, f0, 0.000000; nop; 	lw a3, 0(a3); 
nop; 	addi a4, zero, 1; nop; 	sw f0, 0(a4); 
	addi a4, zero, 2; 	add a22, a5, a4; nop; nop; 
nop; 	lui a5, 4096; nop; 	sw f0, 0(a22); 
nop; 	addi a5, a5, 129; nop; nop; 
	addi a4, a3, -1; 	add a22, a5, a4; nop; nop; 
nop; 	addi a3, a3, -1; nop; 	sw f0, 0(a22); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw f1, 0(a22); 
nop; 	feq a2, f1, fzero; nop; nop; 
	bne a2, a1, be_else.16041; nop; nop; nop; 
nop; 	flt a2, fzero, f1; nop; nop; 
	bne a2, a1, be_else.16043; nop; nop; nop; 
nop; 	lui.float f1, -1.000000; nop; nop; 
	jump be_cont.16044; 	addi.float f1, f1, -1.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.16043:
nop; 	lui.float f1, 1.000000; nop; nop; 
nop; 	addi.float f1, f1, 1.000000; nop; nop; 
be_cont.16044:
	jump be_cont.16042; nop; nop; nop; 
be_else.16041:
nop; 	fadd f1, f0, fzero; nop; nop; 
be_cont.16042:
	lui a2, 4096; 	fneg f1, f1; nop; nop; 
nop; 	addi a2, a2, 129; nop; nop; 
nop; 	add a22, a2, a4; nop; nop; 
	jump be_cont.16040; nop; nop; 	sw f1, 0(a22); 
nop; nop; nop; nop; 
be_else.16039:
nop; 	addi a2, zero, 2; nop; nop; 
	bne a3, a2, be_else.16045; nop; nop; nop; 
nop; nop; 	lw a3, 4(a0); 	lw a2, 4(a0); 
nop; 	lui a2, 4096; nop; 	lw f0, 0(a2); 
	addi a2, a2, 129; 	fneg f0, f0; nop; nop; 
	lui a3, 4096; 	addi a2, zero, 1; 	lw f0, 1(a3); 	sw f0, 0(a2); 
	addi a3, a3, 129; 	fneg f0, f0; nop; nop; 
	addi a2, zero, 2; 	add a22, a3, a2; nop; 	lw a3, 4(a0); 
nop; 	lui a3, 4096; 	lw f0, 2(a3); 	sw f0, 0(a22); 
	addi a3, a3, 129; 	fneg f0, f0; nop; nop; 
nop; 	add a22, a3, a2; nop; nop; 
	jump be_cont.16046; nop; nop; 	sw f0, 0(a22); 
nop; nop; nop; nop; 
be_else.16045:
nop; 	addi sp, sp, -11; nop; 	lw cl, -6(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
be_cont.16046:
be_cont.16040:
nop; nop; 	lw a1, -4(sp); 	lw a0, -8(sp); 
nop; 	addi sp, sp, -11; nop; 	lw cl, -5(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 11; nop; nop; 
	addi sp, sp, -11; 	addi a0, a0, 121; nop; 	lw cl, -3(sp); 
nop; 	addi a0, zero, 0; 	lw swp, 0(cl); 	lw a1, 0(a0); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 11; nop; nop; 
	bne a0, a1, be_else.16047; nop; nop; nop; 
	lui a2, 4096; 	lui a0, 4096; nop; nop; 
	addi a2, a2, 129; 	addi a0, a0, 129; nop; nop; 
nop; 	lui a0, 4096; nop; 	lw f0, 0(a0); 
nop; 	addi a0, a0, 67; nop; nop; 
nop; 	addi a0, zero, 1; nop; 	lw f1, 0(a0); 
	add a22, a2, a0; 	fmul f0, f0, f1; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f1, 0(a22); 
nop; 	addi a2, a2, 67; nop; nop; 
	addi a0, zero, 2; 	add a22, a2, a0; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f2, 0(a22); 
	addi a2, a2, 129; 	fmul f1, f1, f2; nop; nop; 
	add a22, a2, a0; 	fadd f0, f0, f1; nop; nop; 
nop; 	lui a2, 4096; nop; 	lw f1, 0(a22); 
nop; 	addi a2, a2, 67; nop; nop; 
nop; 	add a22, a2, a0; nop; nop; 
nop; nop; nop; 	lw f2, 0(a22); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	fneg f0, f0; nop; nop; 
nop; 	flt a0, fzero, f0; nop; nop; 
	bne a0, a1, be_else.16048; nop; nop; nop; 
nop; 	lui.float f0, 0.000000; nop; nop; 
	jump be_cont.16049; 	addi.float f0, f0, 0.000000; nop; nop; 
nop; nop; nop; nop; 
be_else.16048:
be_cont.16049:
nop; nop; 	lw a0, -8(sp); 	lw f1, -2(sp); 
nop; 	fmul f0, f1, f0; 	lw a0, 7(a0); 	lw a1, 0(sp); 
nop; nop; 	lw a0, -1(sp); 	lw f1, 0(a0); 
	jump vecaccum.2530; 	fmul f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
be_else.16047:
	ret; nop; nop; nop; 
iter_trace_diffuse_rays.2837:
nop; 	addi a5, zero, 0; nop; 	lw a4, 1(cl); 
	blt a3, a5, ble_else.16051; nop; nop; nop; 
nop; 	add a22, a3, a0; 	lw f2, 1(a1); 	lw f1, 0(a1); 
nop; nop; 	sw a1, -1(sp); 	sw a2, 0(sp); 
nop; nop; 	sw cl, -3(sp); 	sw a0, -2(sp); 
nop; nop; 	lw a6, 0(a22); 	sw a3, -4(sp); 
nop; nop; nop; 	lw a6, 0(a6); 
nop; nop; nop; 	lw f0, 0(a6); 
nop; 	fmul f0, f0, f1; nop; 	lw f1, 1(a6); 
nop; 	fmul f1, f1, f2; nop; 	lw f2, 2(a1); 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 2(a6); 
nop; 	fmul f1, f1, f2; nop; nop; 
nop; 	fadd f0, f0, f1; nop; nop; 
nop; 	flt a6, f0, fzero; nop; nop; 
	bne a6, a5, be_else.16052; nop; nop; nop; 
	lui.float f1, 150.000000; 	add a22, a3, a0; nop; nop; 
	addi sp, sp, -7; 	add cl, a4, zero; nop; 	lw a5, 0(a22); 
	add a0, a5, zero; 	addi.float f1, f1, 150.000000; nop; 	lw swp, 0(cl); 
	callr swp; 	fdiv f0, f0, f1; nop; nop; 
	jump be_cont.16053; 	addi sp, sp, 7; nop; nop; 
be_else.16052:
	lui.float f1, -150.000000; 	addi a5, a3, 1; nop; nop; 
	addi sp, sp, -7; 	add cl, a4, zero; nop; nop; 
	addi.float f1, f1, -150.000000; 	add a22, a5, a0; nop; 	lw swp, 0(cl); 
nop; 	fdiv f0, f0, f1; nop; 	lw a5, 0(a22); 
	callr swp; 	add a0, a5, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
be_cont.16053:
nop; nop; 	lw a1, -1(sp); 	lw a0, -4(sp); 
nop; 	addi a3, a0, -2; 	lw cl, -3(sp); 	lw a2, 0(sp); 
nop; nop; 	lw swp, 0(cl); 	lw a0, -2(sp); 
	jumpr swp; nop; nop; nop; 
ble_else.16051:
	ret; nop; nop; nop; 
trace_diffuse_ray_80percent.2846:
nop; 	addi a4, zero, 0; 	sw a1, 0(sp); 	lw a3, 7(cl); 
nop; nop; 	sw a0, -4(sp); 	sw a2, -3(sp); 
nop; nop; 	sw a3, -1(sp); 	lw cl, 6(cl); 
	bne a0, a4, be_else.16055; nop; nop; 	sw cl, -2(sp); 
nop; nop; nop; nop; 
	jump be_cont.16056; nop; nop; nop; 
be_else.16055:
	lui a5, 4096; 	lui a4, 4096; 	lw swp, 0(cl); 	lw f0, 0(a2); 
	add a0, a2, zero; 	lui a6, 4096; nop; nop; 
	addi a5, a5, 149; 	addi a4, a4, 164; nop; nop; 
	addi a5, zero, 1; 	addi a6, a6, 149; 	sw f0, 0(a5); 	lw a4, 0(a4); 
	addi a5, zero, 2; 	add a22, a6, a5; 	sw a4, -5(sp); 	lw f0, 1(a2); 
	addi sp, sp, -7; 	lui a6, 4096; 	lw f0, 2(a2); 	sw f0, 0(a22); 
nop; 	addi a6, a6, 149; nop; nop; 
	lui a5, 4096; 	add a22, a6, a5; nop; nop; 
nop; 	addi a5, a5, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a5, 0(a5); 
nop; 	addi a5, a5, -1; nop; nop; 
	callr swp; 	add a1, a5, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -5(sp); 
nop; 	addi sp, sp, -7; 	lw cl, -1(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
be_cont.16056:
nop; 	addi a0, zero, 1; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.16057; nop; nop; nop; 
	jump be_cont.16058; nop; nop; nop; 
be_else.16057:
	lui a2, 4096; 	addi a0, zero, 1; nop; 	lw cl, -2(sp); 
	lui a4, 4096; 	lui a3, 4096; nop; 	lw swp, 0(cl); 
	addi a3, a3, 149; 	addi a2, a2, 164; nop; nop; 
	add a22, a2, a0; 	addi a4, a4, 149; nop; 	lw a2, -3(sp); 
nop; nop; 	lw f0, 0(a2); 	lw a0, 0(a22); 
	add a0, a2, zero; 	addi a3, zero, 1; 	sw a0, -6(sp); 	sw f0, 0(a3); 
	add a22, a4, a3; 	addi sp, sp, -9; nop; 	lw f0, 1(a2); 
	lui a4, 4096; 	addi a3, zero, 2; 	lw f0, 2(a2); 	sw f0, 0(a22); 
nop; 	addi a4, a4, 149; nop; nop; 
	lui a3, 4096; 	add a22, a4, a3; nop; nop; 
nop; 	addi a3, a3, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; nop; nop; 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -6(sp); 
nop; 	addi sp, sp, -9; 	lw cl, -1(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16058:
nop; 	addi a0, zero, 2; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.16059; nop; nop; nop; 
	jump be_cont.16060; nop; nop; nop; 
be_else.16059:
	lui a2, 4096; 	addi a0, zero, 2; nop; 	lw cl, -2(sp); 
	lui a4, 4096; 	lui a3, 4096; nop; 	lw swp, 0(cl); 
	addi a3, a3, 149; 	addi a2, a2, 164; nop; nop; 
	add a22, a2, a0; 	addi a4, a4, 149; nop; 	lw a2, -3(sp); 
nop; nop; 	lw f0, 0(a2); 	lw a0, 0(a22); 
	add a0, a2, zero; 	addi a3, zero, 1; 	sw a0, -7(sp); 	sw f0, 0(a3); 
	add a22, a4, a3; 	addi sp, sp, -9; nop; 	lw f0, 1(a2); 
	lui a4, 4096; 	addi a3, zero, 2; 	lw f0, 2(a2); 	sw f0, 0(a22); 
nop; 	addi a4, a4, 149; nop; nop; 
	lui a3, 4096; 	add a22, a4, a3; nop; nop; 
nop; 	addi a3, a3, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; nop; nop; 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -7(sp); 
nop; 	addi sp, sp, -9; 	lw cl, -1(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16060:
nop; 	addi a0, zero, 3; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.16061; nop; nop; nop; 
	jump be_cont.16062; nop; nop; nop; 
be_else.16061:
	lui a2, 4096; 	addi a0, zero, 3; nop; 	lw cl, -2(sp); 
	lui a4, 4096; 	lui a3, 4096; nop; 	lw swp, 0(cl); 
	addi a3, a3, 149; 	addi a2, a2, 164; nop; nop; 
	add a22, a2, a0; 	addi a4, a4, 149; nop; 	lw a2, -3(sp); 
nop; nop; 	lw f0, 0(a2); 	lw a0, 0(a22); 
	add a0, a2, zero; 	addi a3, zero, 1; 	sw a0, -8(sp); 	sw f0, 0(a3); 
	add a22, a4, a3; 	addi sp, sp, -11; nop; 	lw f0, 1(a2); 
	lui a4, 4096; 	addi a3, zero, 2; 	lw f0, 2(a2); 	sw f0, 0(a22); 
nop; 	addi a4, a4, 149; nop; nop; 
	lui a3, 4096; 	add a22, a4, a3; nop; nop; 
nop; 	addi a3, a3, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; nop; nop; 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -8(sp); 
nop; 	addi sp, sp, -11; 	lw cl, -1(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
be_cont.16062:
nop; 	addi a0, zero, 4; nop; 	lw a1, -4(sp); 
	bne a1, a0, be_else.16063; nop; nop; nop; 
	ret; nop; nop; nop; 
be_else.16063:
	lui a1, 4096; 	addi a0, zero, 4; nop; 	lw cl, -2(sp); 
	lui a3, 4096; 	lui a2, 4096; nop; 	lw swp, 0(cl); 
	addi a2, a2, 149; 	addi a1, a1, 164; nop; nop; 
	add a22, a1, a0; 	addi a3, a3, 149; nop; 	lw a1, -3(sp); 
nop; nop; 	lw f0, 0(a1); 	lw a0, 0(a22); 
	add a0, a1, zero; 	addi a2, zero, 1; 	sw a0, -9(sp); 	sw f0, 0(a2); 
	add a22, a3, a2; 	addi sp, sp, -11; nop; 	lw f0, 1(a1); 
	lui a3, 4096; 	addi a2, zero, 2; 	lw f0, 2(a1); 	sw f0, 0(a22); 
nop; 	addi a3, a3, 149; nop; nop; 
	lui a2, 4096; 	add a22, a3, a2; nop; nop; 
nop; 	addi a2, a2, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a2, 0(a2); 
nop; 	addi a2, a2, -1; nop; nop; 
	callr swp; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw a1, 0(sp); 	lw a0, -9(sp); 
nop; nop; 	lw cl, -1(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
calc_diffuse_using_1point.2850:
	lui a10, 4096; 	lui a9, 4096; 	lw a3, 4(cl); 	lw a2, 5(cl); 
	addi a10, a10, 135; 	addi a9, a9, 135; 	lw a5, 5(a0); 	lw a4, 1(cl); 
	add a22, a1, a5; 	add cl, a3, zero; 	lw a7, 1(a0); 	lw a6, 7(a0); 
nop; nop; 	sw a1, -2(sp); 	lw a8, 4(a0); 
nop; nop; 	sw a4, 0(sp); 	sw a2, -1(sp); 
nop; nop; 	lw swp, 0(cl); 	lw a5, 0(a22); 
nop; 	addi sp, sp, -5; 	sw a8, -3(sp); 	lw a0, 6(a0); 
nop; nop; 	lw a0, 0(a0); 	lw f0, 0(a5); 
nop; 	addi a9, zero, 1; 	lw f0, 1(a5); 	sw f0, 0(a9); 
	addi a9, zero, 2; 	add a22, a10, a9; nop; nop; 
nop; 	lui a5, 4096; 	lw f0, 2(a5); 	sw f0, 0(a22); 
nop; 	addi a5, a5, 135; nop; nop; 
nop; 	add a22, a5, a9; nop; nop; 
nop; 	add a22, a1, a6; nop; 	sw f0, 0(a22); 
nop; 	add a22, a1, a7; nop; 	lw a5, 0(a22); 
nop; 	add a1, a5, zero; nop; 	lw a6, 0(a22); 
	callr swp; 	add a2, a6, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 5; nop; nop; 
nop; nop; 	lw a1, -3(sp); 	lw a0, -2(sp); 
nop; 	add a22, a0, a1; 	lw a0, -1(sp); 	lw a2, 0(sp); 
	jump vecaccumv.2543; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; nop; 
calc_diffuse_using_5points.2853:
	addi a7, a0, -1; 	add a22, a0, a1; 	lw a6, 1(cl); 	lw a5, 28(cl); 
	lui a10, 4096; 	addi a9, a0, 1; nop; 	lw a1, 0(a22); 
	add a22, a7, a2; 	lui a11, 4096; nop; 	lw a1, 5(a1); 
	addi a11, a11, 135; 	addi a10, a10, 135; nop; 	lw a7, 0(a22); 
nop; 	add a22, a0, a2; nop; 	lw a7, 5(a7); 
nop; 	add a22, a9, a2; nop; 	lw a8, 0(a22); 
nop; 	add a22, a0, a3; 	lw a9, 0(a22); 	lw a8, 5(a8); 
nop; 	add a22, a4, a1; 	lw a3, 0(a22); 	lw a9, 5(a9); 
nop; nop; 	lw a1, 0(a22); 	lw a3, 5(a3); 
nop; nop; nop; 	lw f0, 0(a1); 
nop; 	addi a10, zero, 1; 	lw f0, 1(a1); 	sw f0, 0(a10); 
	addi a10, zero, 2; 	add a22, a11, a10; nop; nop; 
nop; 	lui a1, 4096; 	lw f0, 2(a1); 	sw f0, 0(a22); 
nop; 	addi a1, a1, 135; nop; nop; 
	lui a10, 4096; 	add a22, a1, a10; nop; nop; 
	add a22, a4, a7; 	addi a10, a10, 135; nop; 	sw f0, 0(a22); 
nop; 	lui a7, 4096; nop; 	lw a1, 0(a22); 
nop; 	addi a7, a7, 135; nop; 	lw f1, 0(a1); 
nop; 	lui a7, 4096; nop; 	lw f0, 0(a7); 
	addi a7, a7, 135; 	fadd f0, f0, f1; nop; 	lw f1, 1(a1); 
nop; 	addi a7, zero, 1; nop; 	sw f0, 0(a7); 
	lui a10, 4096; 	add a22, a10, a7; nop; nop; 
nop; 	addi a10, a10, 135; nop; 	lw f0, 0(a22); 
	add a22, a10, a7; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
	lui a10, 4096; 	addi a7, zero, 2; nop; 	sw f0, 0(a22); 
	addi a10, a10, 135; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 135; 	add a22, a10, a7; nop; nop; 
	lui a7, 4096; 	add a22, a1, a7; nop; 	lw f0, 0(a22); 
	addi a7, a7, 135; 	fadd f0, f0, f1; nop; nop; 
	lui a8, 4096; 	add a22, a4, a8; 	lw f0, 0(a7); 	sw f0, 0(a22); 
	addi a8, a8, 135; 	lui a7, 4096; nop; 	lw a1, 0(a22); 
nop; 	addi a7, a7, 135; nop; 	lw f1, 0(a1); 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 1(a1); 
nop; 	addi a7, zero, 1; nop; 	sw f0, 0(a7); 
	lui a8, 4096; 	add a22, a8, a7; nop; nop; 
nop; 	addi a8, a8, 135; nop; 	lw f0, 0(a22); 
	add a22, a8, a7; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
	lui a8, 4096; 	addi a7, zero, 2; nop; 	sw f0, 0(a22); 
	addi a8, a8, 135; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 135; 	add a22, a8, a7; nop; nop; 
	add a22, a1, a7; 	lui a8, 4096; nop; 	lw f0, 0(a22); 
	fadd f0, f0, f1; 	lui a7, 4096; nop; nop; 
	addi a7, a7, 135; 	addi a8, a8, 135; nop; 	sw f0, 0(a22); 
	lui a7, 4096; 	add a22, a4, a9; nop; 	lw f0, 0(a7); 
nop; 	addi a7, a7, 135; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw f1, 0(a1); 
nop; 	fadd f0, f0, f1; nop; 	lw f1, 1(a1); 
nop; 	addi a7, zero, 1; nop; 	sw f0, 0(a7); 
	lui a8, 4096; 	add a22, a8, a7; nop; nop; 
nop; 	addi a8, a8, 135; nop; 	lw f0, 0(a22); 
	add a22, a8, a7; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
	lui a8, 4096; 	addi a7, zero, 2; nop; 	sw f0, 0(a22); 
	addi a8, a8, 135; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 135; 	add a22, a8, a7; nop; nop; 
	lui a7, 4096; 	add a22, a1, a7; nop; 	lw f0, 0(a22); 
	addi a7, a7, 135; 	fadd f0, f0, f1; nop; nop; 
	lui a3, 4096; 	add a22, a4, a3; nop; 	sw f0, 0(a22); 
nop; 	addi a3, a3, 135; nop; 	lw a1, 0(a22); 
nop; 	lui a3, 4096; 	lw f1, 0(a1); 	lw f0, 0(a3); 
	addi a3, a3, 135; 	fadd f0, f0, f1; nop; 	lw f1, 1(a1); 
nop; 	addi a3, zero, 1; nop; 	sw f0, 0(a3); 
	lui a7, 4096; 	add a22, a7, a3; nop; nop; 
nop; 	addi a7, a7, 135; nop; 	lw f0, 0(a22); 
	add a22, a7, a3; 	fadd f0, f0, f1; nop; 	lw f1, 2(a1); 
	lui a7, 4096; 	addi a3, zero, 2; nop; 	sw f0, 0(a22); 
	addi a7, a7, 135; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 135; 	add a22, a7, a3; nop; nop; 
nop; 	add a22, a1, a3; nop; 	lw f0, 0(a22); 
nop; 	fadd f0, f0, f1; nop; nop; 
	add a2, a6, zero; 	add a22, a0, a2; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 4(a0); 
	add a0, a5, zero; 	add a22, a4, a0; nop; nop; 
	jump vecaccumv.2543; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; nop; 
do_without_neighbors.2859:
nop; 	addi a6, zero, 4; 	lw a3, 5(cl); 	lw a2, 7(cl); 
	blt a6, a1, ble_else.16065; nop; 	lw a5, 1(cl); 	lw a4, 4(cl); 
nop; 	addi a7, zero, 0; nop; 	lw a6, 2(a0); 
nop; 	add a22, a1, a6; nop; nop; 
nop; nop; nop; 	lw a6, 0(a22); 
	blt a6, a7, ble_else.16066; nop; nop; nop; 
nop; nop; 	sw cl, 0(sp); 	lw a6, 3(a0); 
nop; 	add a22, a1, a6; 	sw a0, -2(sp); 	sw a2, -1(sp); 
nop; nop; 	lw a6, 0(a22); 	sw a1, -3(sp); 
	bne a6, a7, be_else.16067; nop; nop; nop; 
	jump be_cont.16068; nop; nop; nop; 
be_else.16067:
	lui a12, 4096; 	lui a11, 4096; 	lw a8, 7(a0); 	lw a6, 5(a0); 
	add a22, a1, a6; 	add cl, a4, zero; 	lw a10, 4(a0); 	lw a9, 1(a0); 
	addi a12, a12, 135; 	addi a11, a11, 135; 	sw a3, -5(sp); 	sw a5, -4(sp); 
nop; 	addi sp, sp, -9; 	sw a10, -6(sp); 	lw a6, 0(a22); 
nop; nop; 	lw f0, 0(a6); 	lw swp, 0(cl); 
nop; 	addi a11, zero, 1; 	lw f0, 1(a6); 	sw f0, 0(a11); 
	addi a11, zero, 2; 	add a22, a12, a11; nop; nop; 
nop; 	lui a6, 4096; 	lw f0, 2(a6); 	sw f0, 0(a22); 
nop; 	addi a6, a6, 135; nop; nop; 
nop; 	add a22, a6, a11; nop; 	lw a6, 6(a0); 
nop; 	add a22, a1, a8; 	lw a6, 0(a6); 	sw f0, 0(a22); 
	add a22, a1, a9; 	add a0, a6, zero; nop; 	lw a8, 0(a22); 
nop; 	add a1, a8, zero; nop; 	lw a9, 0(a22); 
	callr swp; 	add a2, a9, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -6(sp); 	lw a0, -3(sp); 
	addi sp, sp, -9; 	add a22, a0, a1; 	lw a3, -4(sp); 	lw a2, -5(sp); 
	add a2, a3, zero; 	add a0, a2, zero; nop; 	lw a1, 0(a22); 
	call vecaccumv.2543; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16068:
nop; nop; nop; 	lw a0, -3(sp); 
	addi a0, zero, 4; 	addi a1, a0, 1; nop; nop; 
	blt a0, a1, ble_else.16069; nop; nop; nop; 
nop; 	addi a3, zero, 0; nop; 	lw a0, -2(sp); 
nop; nop; nop; 	lw a2, 2(a0); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	blt a2, a3, ble_else.16070; nop; nop; nop; 
nop; nop; 	sw a1, -7(sp); 	lw a2, 3(a0); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a3, be_else.16071; nop; nop; nop; 
	jump be_cont.16072; nop; nop; nop; 
be_else.16071:
nop; 	addi sp, sp, -9; nop; 	lw cl, -1(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16072:
nop; nop; 	lw cl, 0(sp); 	lw a0, -7(sp); 
nop; 	addi a1, a0, 1; 	lw a0, -2(sp); 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16070:
	ret; nop; nop; nop; 
ble_else.16069:
	ret; nop; nop; nop; 
ble_else.16066:
	ret; nop; nop; nop; 
ble_else.16065:
	ret; nop; nop; nop; 
neighbors_are_available.2869:
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a5, 2(a5); 
nop; 	add a22, a4, a5; nop; nop; 
nop; 	add a22, a0, a1; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 2(a1); 
nop; 	add a22, a4, a1; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
	bne a1, a5, be_else.16077; nop; nop; nop; 
nop; 	add a22, a0, a3; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 2(a1); 
nop; 	add a22, a4, a1; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
	bne a1, a5, be_else.16078; nop; nop; nop; 
	addi a3, a0, -1; 	addi a1, zero, 1; nop; nop; 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a3, 0(a22); 
nop; nop; nop; 	lw a3, 2(a3); 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a3, 0(a22); 
	bne a3, a5, be_else.16079; nop; nop; nop; 
nop; 	addi a0, a0, 1; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 2(a0); 
nop; 	add a22, a4, a0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
	bne a0, a5, be_else.16080; nop; nop; nop; 
	ret; 	add a0, a1, zero; nop; nop; 
be_else.16080:
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.16079:
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.16078:
	ret; 	addi a0, zero, 0; nop; nop; 
be_else.16077:
	ret; 	addi a0, zero, 0; nop; nop; 
try_exploit_neighbors.2875:
	addi a10, zero, 4; 	add a22, a0, a3; 	lw a7, 2(cl); 	lw a6, 3(cl); 
	blt a10, a5, ble_else.16081; nop; 	lw a9, 0(a22); 	lw a8, 1(cl); 
nop; 	addi a12, zero, 0; nop; 	lw a11, 2(a9); 
nop; 	add a22, a5, a11; nop; nop; 
nop; nop; nop; 	lw a11, 0(a22); 
	blt a11, a12, ble_else.16082; nop; nop; nop; 
nop; 	add a1, a2, zero; 	sw cl, -1(sp); 	sw a1, 0(sp); 
nop; 	add a2, a3, zero; 	sw a2, -3(sp); 	sw a4, -2(sp); 
nop; nop; 	sw a9, -5(sp); 	sw a6, -4(sp); 
nop; nop; 	sw a8, -7(sp); 	sw a7, -6(sp); 
nop; nop; 	sw a5, -9(sp); 	sw a10, -8(sp); 
	addi sp, sp, -13; 	add a3, a4, zero; 	sw a3, -11(sp); 	sw a0, -10(sp); 
	call neighbors_are_available.2869; 	add a4, a5, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 13; nop; nop; 
	bne a0, a1, be_else.16083; nop; nop; nop; 
nop; nop; 	lw a2, -11(sp); 	lw a0, -10(sp); 
nop; 	add a22, a0, a2; 	lw a2, -8(sp); 	lw a3, -9(sp); 
	blt a2, a3, ble_else.16084; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a2, 2(a0); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	blt a2, a1, ble_else.16085; nop; nop; nop; 
nop; nop; 	sw a0, -12(sp); 	lw a2, 3(a0); 
nop; 	add a22, a3, a2; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
	bne a2, a1, be_else.16086; nop; nop; nop; 
	jump be_cont.16087; nop; nop; nop; 
be_else.16086:
	addi sp, sp, -15; 	add a1, a3, zero; nop; 	lw cl, -7(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
be_cont.16087:
nop; nop; 	lw cl, -6(sp); 	lw a0, -9(sp); 
nop; 	addi a1, a0, 1; 	lw a0, -12(sp); 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16085:
	ret; nop; nop; nop; 
ble_else.16084:
	ret; nop; nop; nop; 
be_else.16083:
nop; nop; 	lw a4, -9(sp); 	lw a0, -5(sp); 
nop; nop; nop; 	lw a0, 3(a0); 
nop; 	add a22, a4, a0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
	bne a0, a1, be_else.16090; nop; nop; nop; 
	jump be_cont.16091; nop; nop; nop; 
be_else.16090:
nop; nop; 	lw a1, -3(sp); 	lw a0, -10(sp); 
nop; nop; 	lw a3, -2(sp); 	lw a2, -11(sp); 
nop; 	addi sp, sp, -15; nop; 	lw cl, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
be_cont.16091:
nop; nop; 	lw a1, 0(sp); 	lw a0, -9(sp); 
nop; 	addi a5, a0, 1; 	lw a3, -11(sp); 	lw a2, -3(sp); 
nop; nop; 	lw cl, -1(sp); 	lw a4, -2(sp); 
nop; nop; 	lw swp, 0(cl); 	lw a0, -10(sp); 
	jumpr swp; nop; nop; nop; 
ble_else.16082:
	ret; nop; nop; nop; 
ble_else.16081:
	ret; nop; nop; nop; 
write_ppm_header.2882:
	addi sp, sp, -1; 	addi a0, zero, 80; nop; nop; 
	call print_char; nop; nop; nop; 
	addi a0, zero, 51; 	addi sp, sp, 1; nop; nop; 
	call print_char; 	addi sp, sp, -1; nop; nop; 
nop; nop; nop; nop; 
	addi a0, zero, 10; 	addi sp, sp, 1; nop; nop; 
nop; 	addi sp, sp, -3; nop; 	sw a0, 0(sp); 
	call print_char; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 3; nop; nop; 
	addi sp, sp, -3; 	addi a0, a0, 141; nop; nop; 
	call print_int; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	addi a0, zero, 32; 	addi sp, sp, 3; nop; nop; 
nop; 	addi sp, sp, -3; nop; 	sw a0, -1(sp); 
	call print_char; nop; nop; nop; 
	addi a0, zero, 1; 	addi sp, sp, 3; nop; nop; 
	addi sp, sp, -3; 	lui a1, 4096; nop; nop; 
nop; 	addi a1, a1, 141; nop; nop; 
nop; 	add a22, a1, a0; nop; nop; 
	call print_int; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; 	addi sp, sp, -3; nop; 	lw a0, -1(sp); 
	call print_char; nop; nop; nop; 
	addi a0, zero, 255; 	addi sp, sp, 3; nop; nop; 
	call print_int; 	addi sp, sp, -3; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
	jump print_char; nop; nop; 	lw a0, 0(sp); 
nop; nop; nop; nop; 
pretrace_diffuse_rays.2888:
nop; 	addi a4, zero, 4; 	lw a3, 9(cl); 	lw a2, 10(cl); 
	blt a4, a1, ble_else.16094; nop; nop; nop; 
nop; 	addi a5, zero, 0; nop; 	lw a4, 2(a0); 
nop; 	add a22, a1, a4; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
	blt a4, a5, ble_else.16095; nop; nop; nop; 
nop; nop; 	sw cl, 0(sp); 	lw a4, 3(a0); 
nop; 	add a22, a1, a4; nop; 	sw a1, -1(sp); 
nop; nop; nop; 	lw a4, 0(a22); 
	bne a4, a5, be_else.16096; nop; nop; nop; 
	jump be_cont.16097; nop; nop; nop; 
be_else.16096:
	lui.float f0, 0.000000; 	lui a5, 4096; 	sw a0, -2(sp); 	lw a4, 6(a0); 
	lui a7, 4096; 	lui a6, 4096; 	lw a4, 0(a4); 	sw a2, -6(sp); 
	add cl, a3, zero; 	lui a8, 4096; nop; nop; 
	addi.float f0, f0, 0.000000; 	addi a5, a5, 135; nop; 	lw swp, 0(cl); 
	addi a7, a7, 164; 	addi a6, a6, 135; nop; 	sw f0, 0(a5); 
	addi a5, zero, 1; 	addi a8, a8, 149; nop; nop; 
	addi a5, zero, 2; 	add a22, a6, a5; nop; nop; 
nop; 	lui a6, 4096; nop; 	sw f0, 0(a22); 
nop; 	addi a6, a6, 135; nop; nop; 
nop; 	add a22, a6, a5; 	lw a6, 1(a0); 	lw a5, 7(a0); 
	lui a7, 4096; 	add a22, a7, a4; nop; 	sw f0, 0(a22); 
	add a22, a1, a5; 	addi a7, a7, 149; nop; 	lw a4, 0(a22); 
nop; 	add a22, a1, a6; 	sw a4, -5(sp); 	lw a5, 0(a22); 
nop; nop; 	sw a5, -4(sp); 	lw a6, 0(a22); 
	addi sp, sp, -9; 	add a0, a6, zero; 	sw a6, -3(sp); 	lw f0, 0(a6); 
nop; 	addi a7, zero, 1; 	lw f0, 1(a6); 	sw f0, 0(a7); 
	addi a7, zero, 2; 	add a22, a8, a7; nop; nop; 
nop; 	lui a8, 4096; 	lw f0, 2(a6); 	sw f0, 0(a22); 
nop; 	addi a8, a8, 149; nop; nop; 
	lui a7, 4096; 	add a22, a8, a7; nop; nop; 
nop; 	addi a7, a7, 0; nop; 	sw f0, 0(a22); 
nop; nop; nop; 	lw a7, 0(a7); 
nop; 	addi a7, a7, -1; nop; nop; 
	callr swp; 	add a1, a7, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a3, zero, 118; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -4(sp); 	lw a0, -5(sp); 
nop; 	addi sp, sp, -9; 	lw cl, -6(sp); 	lw a2, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	lui a3, 4096; 	addi sp, sp, 9; nop; nop; 
	addi a3, a3, 135; 	lui a4, 4096; 	lw a2, -1(sp); 	lw a0, -2(sp); 
	addi a3, zero, 1; 	addi a4, a4, 135; 	lw f0, 0(a3); 	lw a1, 5(a0); 
nop; 	add a22, a2, a1; nop; nop; 
	addi a3, zero, 2; 	add a22, a4, a3; nop; 	lw a1, 0(a22); 
nop; 	lui a4, 4096; 	lw f0, 0(a22); 	sw f0, 0(a1); 
nop; 	addi a4, a4, 135; nop; 	sw f0, 1(a1); 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw f0, 0(a22); 
nop; nop; nop; 	sw f0, 2(a1); 
be_cont.16097:
nop; nop; 	lw cl, 0(sp); 	lw a1, -1(sp); 
nop; 	addi a1, a1, 1; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16095:
	ret; nop; nop; nop; 
ble_else.16094:
	ret; nop; nop; nop; 
pretrace_pixels.2891:
nop; 	addi a6, zero, 0; 	lw a4, 19(cl); 	lw a3, 24(cl); 
	blt a1, a6, ble_else.16100; nop; nop; 	lw a5, 4(cl); 
	addi a8, zero, 1; 	lui a7, 4096; 	sw f1, -1(sp); 	sw f2, 0(sp); 
	addi a7, a7, 145; 	lui a9, 4096; 	sw cl, -3(sp); 	sw f0, -2(sp); 
nop; 	addi a9, a9, 152; 	sw a2, -5(sp); 	sw a3, -4(sp); 
	lui a8, 4096; 	add a22, a9, a8; 	sw a4, -7(sp); 	sw a5, -6(sp); 
	addi a8, a8, 161; 	lui a9, 4096; 	sw a0, -9(sp); 	sw a1, -8(sp); 
	addi sp, sp, -11; 	add a0, a5, zero; nop; 	lw f3, 0(a7); 
	lui a7, 4096; 	addi a9, a9, 152; nop; nop; 
nop; 	addi a7, a7, 143; nop; nop; 
nop; nop; nop; 	lw a7, 0(a7); 
	add a1, a6, zero; 	sub a7, a1, a7; nop; nop; 
	lui a7, 4096; 	itof f4, a7; nop; nop; 
	addi a7, a7, 152; 	fmul f3, f3, f4; nop; nop; 
nop; 	lui a7, 4096; nop; 	lw f4, 0(a7); 
	addi a7, a7, 161; 	fmul f4, f3, f4; nop; nop; 
nop; 	fadd f4, f4, f0; nop; nop; 
nop; 	addi a7, zero, 1; 	lw f4, 0(a22); 	sw f4, 0(a7); 
	add a22, a8, a7; 	fmul f4, f3, f4; nop; nop; 
	addi a8, zero, 2; 	addi a7, zero, 2; nop; nop; 
nop; 	fadd f4, f4, f1; nop; nop; 
	lui a8, 4096; 	add a22, a9, a8; nop; 	sw f4, 0(a22); 
nop; 	addi a8, a8, 161; nop; 	lw f4, 0(a22); 
	add a22, a8, a7; 	fmul f3, f3, f4; nop; nop; 
nop; 	fadd f3, f3, f2; nop; nop; 
	call vecunit_sgn.2519; nop; nop; 	sw f3, 0(a22); 
nop; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 11; nop; nop; 
	lui a1, 4096; 	lui.float f1, 0.000000; 	lw cl, -7(sp); 	lw a4, -6(sp); 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	lw swp, 0(cl); 
	addi.float f1, f1, 0.000000; 	addi a0, a0, 138; nop; nop; 
	addi a2, a2, 64; 	addi a1, a1, 138; nop; 	sw f1, 0(a0); 
nop; 	addi a0, zero, 1; nop; nop; 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
nop; 	lui a1, 4096; nop; 	sw f1, 0(a22); 
nop; 	addi a1, a1, 138; nop; nop; 
	lui a0, 4096; 	add a22, a1, a0; nop; nop; 
	addi a0, a0, 64; 	addi a1, zero, 1; nop; 	sw f1, 0(a22); 
	lui a0, 4096; 	add a22, a2, a1; nop; 	lw f0, 0(a0); 
	lui a2, 4096; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 146; 	addi a0, a0, 146; nop; nop; 
	addi a0, zero, 1; 	addi a2, a2, 64; 	lw f0, 0(a22); 	sw f0, 0(a0); 
	addi a0, zero, 2; 	add a22, a1, a0; nop; nop; 
nop; 	addi a1, zero, 2; nop; 	sw f0, 0(a22); 
	lui a1, 4096; 	add a22, a2, a1; nop; nop; 
nop; 	addi a1, a1, 146; nop; 	lw f0, 0(a22); 
	addi sp, sp, -11; 	add a22, a1, a0; 	lw a1, -9(sp); 	lw a0, -8(sp); 
	add a22, a0, a1; 	lui.float f0, 1.000000; nop; 	sw f0, 0(a22); 
	add a0, a3, zero; 	add a1, a4, zero; nop; 	lw a2, 0(a22); 
	callr swp; 	addi.float f0, f0, 1.000000; nop; nop; 
nop; nop; nop; nop; 
	lui a3, 4096; 	addi sp, sp, 11; nop; nop; 
	addi a3, a3, 138; 	lui a4, 4096; 	lw a1, -9(sp); 	lw a0, -8(sp); 
	addi a4, a4, 138; 	add a22, a0, a1; 	lw f0, 0(a3); 	lw cl, -4(sp); 
nop; 	addi a3, zero, 1; 	lw swp, 0(cl); 	lw a2, 0(a22); 
	addi a3, zero, 2; 	add a22, a4, a3; nop; 	lw a2, 0(a2); 
nop; 	lui a4, 4096; 	lw f0, 0(a22); 	sw f0, 0(a2); 
nop; 	addi a4, a4, 138; nop; 	sw f0, 1(a2); 
	addi a4, zero, 0; 	add a22, a4, a3; nop; 	lw a3, -5(sp); 
	add a22, a0, a1; 	addi sp, sp, -11; nop; 	lw f0, 0(a22); 
	add a1, a4, zero; 	add a22, a0, a1; 	lw a2, 0(a22); 	sw f0, 2(a2); 
nop; nop; nop; 	lw a2, 6(a2); 
nop; nop; 	lw a2, 0(a22); 	sw a3, 0(a2); 
	callr swp; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a2, zero, 5; 	addi sp, sp, 11; nop; nop; 
nop; nop; nop; 	lw a0, -8(sp); 
nop; 	addi a1, a0, -1; nop; 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; nop; nop; 
	blt a0, a2, ble_else.16101; nop; nop; nop; 
	jump ble_cont.16102; 	addi a2, a0, -5; nop; nop; 
ble_else.16101:
nop; 	add a2, a0, zero; nop; nop; 
ble_cont.16102:
nop; nop; 	lw f1, -1(sp); 	lw f0, -2(sp); 
nop; nop; 	lw a0, -9(sp); 	lw f2, 0(sp); 
nop; nop; nop; 	lw cl, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16100:
	ret; nop; nop; nop; 
pretrace_line.2898:
	lui a4, 4096; 	lui a3, 4096; nop; 	lw cl, 10(cl); 
	addi a4, a4, 143; 	addi a3, a3, 145; nop; 	lw swp, 0(cl); 
nop; 	addi a3, zero, 1; nop; 	lw f0, 0(a3); 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
nop; 	sub a1, a1, a4; nop; nop; 
	lui a1, 4096; 	itof f1, a1; nop; nop; 
	addi a1, a1, 155; 	fmul f0, f0, f1; nop; nop; 
nop; 	lui a1, 4096; nop; 	lw f1, 0(a1); 
	addi a1, a1, 158; 	fmul f1, f0, f1; nop; nop; 
nop; 	lui a1, 4096; nop; 	lw f2, 0(a1); 
	addi a1, a1, 155; 	fadd f1, f1, f2; nop; nop; 
	lui a1, 4096; 	add a22, a1, a3; nop; nop; 
nop; 	addi a1, a1, 158; nop; 	lw f2, 0(a22); 
	add a22, a1, a3; 	fmul f2, f0, f2; nop; nop; 
	lui a3, 4096; 	addi a1, zero, 2; nop; 	lw f3, 0(a22); 
	addi a3, a3, 155; 	fadd f2, f2, f3; nop; nop; 
	addi f12, f2, 0; 	add a22, a3, a1; nop; nop; 
nop; 	lui a3, 4096; nop; 	lw f3, 0(a22); 
	addi a3, a3, 158; 	fmul f0, f0, f3; nop; nop; 
	lui a1, 4096; 	add a22, a3, a1; nop; nop; 
nop; 	addi a1, a1, 141; nop; 	lw f3, 0(a22); 
nop; 	fadd f0, f0, f3; nop; 	lw a1, 0(a1); 
	addi f2, f0, 0; 	addi a1, a1, -1; nop; nop; 
	addi f1, f12, 0; 	addi f0, f1, 0; nop; nop; 
	jumpr swp; nop; nop; nop; 
scan_pixel.2902:
nop; 	lui a8, 4096; 	lw a6, 8(cl); 	lw a5, 9(cl); 
nop; 	addi a8, a8, 141; nop; 	lw a7, 7(cl); 
nop; nop; nop; 	lw a8, 0(a8); 
	blt a0, a8, ble_else.16104; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.16104:
	lui a9, 4096; 	add a22, a0, a3; nop; nop; 
	addi a9, a9, 138; 	lui a10, 4096; nop; 	lw a8, 0(a22); 
nop; 	addi a10, a10, 138; nop; 	lw a8, 0(a8); 
nop; nop; nop; 	lw f0, 0(a8); 
nop; 	addi a9, zero, 1; 	lw f0, 1(a8); 	sw f0, 0(a9); 
	addi a9, zero, 2; 	add a22, a10, a9; nop; nop; 
nop; 	lui a8, 4096; 	lw f0, 2(a8); 	sw f0, 0(a22); 
nop; 	addi a8, a8, 138; nop; nop; 
	addi a8, zero, 1; 	add a22, a8, a9; nop; nop; 
nop; 	lui a9, 4096; nop; 	sw f0, 0(a22); 
nop; 	addi a9, a9, 141; nop; nop; 
	addi a9, a1, 1; 	add a22, a9, a8; nop; nop; 
nop; nop; nop; 	lw a8, 0(a22); 
	blt a9, a8, ble_else.16106; nop; nop; nop; 
nop; 	addi a8, zero, 0; nop; nop; 
	jump ble_cont.16107; 	add a9, a8, zero; nop; nop; 
nop; nop; nop; nop; 
ble_else.16106:
nop; 	addi a8, zero, 0; nop; nop; 
	blt a8, a1, ble_else.16108; nop; nop; nop; 
	jump ble_cont.16109; 	add a9, a8, zero; nop; nop; 
ble_else.16108:
	addi a10, a0, 1; 	lui a9, 4096; nop; nop; 
nop; 	addi a9, a9, 141; nop; nop; 
nop; nop; nop; 	lw a9, 0(a9); 
	blt a10, a9, ble_else.16110; nop; nop; nop; 
	jump ble_cont.16111; 	add a9, a8, zero; nop; nop; 
ble_else.16110:
	blt a8, a0, ble_else.16112; nop; nop; nop; 
	jump ble_cont.16113; 	add a9, a8, zero; nop; nop; 
ble_else.16112:
nop; 	addi a9, zero, 1; nop; nop; 
ble_cont.16113:
ble_cont.16111:
ble_cont.16109:
ble_cont.16107:
nop; nop; 	sw a3, -1(sp); 	sw a4, 0(sp); 
nop; nop; 	sw a1, -3(sp); 	sw a2, -2(sp); 
	bne a9, a8, be_else.16114; nop; 	sw a0, -5(sp); 	sw cl, -4(sp); 
nop; 	add a22, a0, a3; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a9, 2(a5); 
nop; nop; nop; 	lw a9, 0(a9); 
	blt a9, a8, ble_else.16116; nop; nop; nop; 
nop; nop; 	sw a5, -6(sp); 	lw a9, 3(a5); 
nop; nop; 	lw a9, 0(a9); 	sw a6, -7(sp); 
	bne a9, a8, be_else.16118; nop; nop; nop; 
	jump be_cont.16119; nop; nop; nop; 
be_else.16118:
	add a0, a5, zero; 	add a1, a8, zero; nop; nop; 
	addi sp, sp, -9; 	add cl, a7, zero; nop; nop; 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16119:
	addi sp, sp, -9; 	addi a1, zero, 1; 	lw cl, -7(sp); 	lw a0, -6(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16117; 	addi sp, sp, 9; nop; nop; 
ble_else.16116:
ble_cont.16117:
	jump be_cont.16115; nop; nop; nop; 
be_else.16114:
	addi sp, sp, -9; 	add cl, a5, zero; nop; nop; 
nop; 	add a5, a8, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
be_cont.16115:
	addi a1, zero, 255; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 138; nop; nop; 
nop; nop; nop; 	lw f0, 0(a0); 
nop; 	ftoi a0, f0; nop; nop; 
	blt a1, a0, ble_else.16120; nop; nop; nop; 
nop; 	addi a1, zero, 0; nop; nop; 
	blt a0, a1, ble_else.16122; nop; nop; nop; 
	jump ble_cont.16123; nop; nop; nop; 
ble_else.16122:
nop; 	add a0, a1, zero; nop; nop; 
ble_cont.16123:
	jump ble_cont.16121; nop; nop; nop; 
ble_else.16120:
nop; 	addi a0, zero, 255; nop; nop; 
ble_cont.16121:
	call print_int; 	addi sp, sp, -9; nop; nop; 
	addi a0, zero, 32; 	addi sp, sp, 9; nop; nop; 
	call print_char; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
	addi a0, zero, 1; 	addi sp, sp, 9; nop; nop; 
nop; 	lui a1, 4096; nop; nop; 
nop; 	addi a1, a1, 138; nop; nop; 
	addi a1, zero, 255; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw f0, 0(a22); 
nop; 	ftoi a0, f0; nop; nop; 
	blt a1, a0, ble_else.16124; nop; nop; nop; 
nop; 	addi a1, zero, 0; nop; nop; 
	blt a0, a1, ble_else.16126; nop; nop; nop; 
	jump ble_cont.16127; nop; nop; nop; 
ble_else.16126:
nop; 	add a0, a1, zero; nop; nop; 
ble_cont.16127:
	jump ble_cont.16125; nop; nop; nop; 
ble_else.16124:
nop; 	addi a0, zero, 255; nop; nop; 
ble_cont.16125:
	call print_int; 	addi sp, sp, -9; nop; nop; 
	addi a0, zero, 32; 	addi sp, sp, 9; nop; nop; 
	call print_char; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
	addi a0, zero, 2; 	addi sp, sp, 9; nop; nop; 
nop; 	lui a1, 4096; nop; nop; 
nop; 	addi a1, a1, 138; nop; nop; 
	addi a1, zero, 255; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw f0, 0(a22); 
nop; 	ftoi a0, f0; nop; nop; 
	blt a1, a0, ble_else.16128; nop; nop; nop; 
nop; 	addi a1, zero, 0; nop; nop; 
	blt a0, a1, ble_else.16130; nop; nop; nop; 
	jump ble_cont.16131; nop; nop; nop; 
ble_else.16130:
nop; 	add a0, a1, zero; nop; nop; 
ble_cont.16131:
	jump ble_cont.16129; nop; nop; nop; 
ble_else.16128:
nop; 	addi a0, zero, 255; nop; nop; 
ble_cont.16129:
	call print_int; 	addi sp, sp, -9; nop; nop; 
	addi a0, zero, 10; 	addi sp, sp, 9; nop; nop; 
	call print_char; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -3(sp); 	lw a0, -5(sp); 
nop; 	addi a0, a0, 1; 	lw a3, -1(sp); 	lw a2, -2(sp); 
nop; nop; 	lw cl, -4(sp); 	lw a4, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
scan_line.2908:
	lui a8, 4096; 	addi a7, zero, 1; 	lw a6, 3(cl); 	lw a5, 4(cl); 
nop; 	addi a8, a8, 141; nop; nop; 
nop; 	add a22, a8, a7; nop; nop; 
nop; nop; nop; 	lw a8, 0(a22); 
	blt a0, a8, ble_else.16132; nop; nop; nop; 
	ret; nop; nop; nop; 
ble_else.16132:
nop; 	lui a8, 4096; 	sw a4, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a8, a8, 141; 	sw a2, -3(sp); 	sw a3, -2(sp); 
nop; 	add a22, a8, a7; 	sw a0, -5(sp); 	sw a1, -4(sp); 
nop; nop; 	lw a7, 0(a22); 	sw a5, -6(sp); 
nop; 	addi a7, a7, -1; nop; nop; 
	blt a0, a7, ble_else.16134; nop; nop; nop; 
	jump ble_cont.16135; nop; nop; nop; 
ble_else.16134:
	add a2, a4, zero; 	addi a7, a0, 1; nop; nop; 
	addi sp, sp, -9; 	add cl, a6, zero; nop; nop; 
	add a1, a7, zero; 	add a0, a3, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
ble_cont.16135:
nop; 	addi a0, zero, 0; 	lw a2, -4(sp); 	lw a1, -5(sp); 
nop; nop; 	lw a4, -2(sp); 	lw a3, -3(sp); 
nop; 	addi sp, sp, -9; nop; 	lw cl, -6(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a2, zero, 5; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a1, -1(sp); 	lw a0, -5(sp); 
	addi a1, a1, 2; 	addi a0, a0, 1; nop; nop; 
	blt a1, a2, ble_else.16136; nop; nop; nop; 
	jump ble_cont.16137; 	addi a4, a1, -5; nop; nop; 
ble_else.16136:
nop; 	add a4, a1, zero; nop; nop; 
ble_cont.16137:
nop; nop; 	lw a2, -2(sp); 	lw a1, -3(sp); 
nop; nop; 	lw cl, 0(sp); 	lw a3, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
create_float5x3array.2914:
	lui.float f0, 0.000000; 	addi a0, zero, 3; nop; nop; 
	addi sp, sp, -3; 	addi.float f0, f0, 0.000000; nop; 	sw a0, 0(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 3; nop; nop; 
	addi sp, sp, -3; 	addi a0, zero, 5; nop; nop; 
	call create_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 3; nop; nop; 
	addi sp, sp, -3; 	addi.float f0, f0, 0.000000; 	sw a0, -1(sp); 	lw a1, 0(sp); 
	call create_float_array; 	add a0, a1, zero; nop; nop; 
nop; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 3; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; 	lw a1, -1(sp); 
nop; 	addi sp, sp, -3; 	lw a0, 0(sp); 	sw a0, 1(a1); 
	call create_float_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 3; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; 	lw a1, -1(sp); 
nop; 	addi sp, sp, -3; 	lw a0, 0(sp); 	sw a0, 2(a1); 
	call create_float_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 3; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; 	lw a1, -1(sp); 
nop; 	addi sp, sp, -3; 	lw a0, 0(sp); 	sw a0, 3(a1); 
	call create_float_array; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; nop; nop; 	lw a1, -1(sp); 
nop; 	add a0, a1, zero; nop; 	sw a0, 4(a1); 
	ret; nop; nop; nop; 
init_line_elements.2918:
nop; 	addi a2, zero, 0; nop; nop; 
	blt a1, a2, ble_else.16138; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; 	sw a0, -1(sp); 	sw a1, 0(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -3; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 3; nop; nop; 
nop; 	addi sp, sp, -5; nop; 	sw a0, -2(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 5; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -4(sp); 	sw a0, -3(sp); 
	add a1, a2, zero; 	addi sp, sp, -7; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -7; 	sw a0, -5(sp); 	lw a1, -4(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 7; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	sw a0, -6(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	sw a0, -7(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 9; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -8(sp); 
	add a1, a2, zero; 	addi sp, sp, -11; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; 	addi sp, sp, -11; nop; 	sw a0, -9(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 11; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -1(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -9(sp); 
nop; nop; 	lw a0, -8(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -7(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -6(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -5(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -3(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -2(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, 0(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16139; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -10(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -13; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; 	addi sp, sp, -13; nop; 	sw a0, -11(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 13; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -13(sp); 	sw a0, -12(sp); 
	add a1, a2, zero; 	addi sp, sp, -15; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 15; nop; nop; 
nop; 	addi sp, sp, -17; 	sw a0, -14(sp); 	lw a1, -13(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; 	addi sp, sp, -17; nop; 	sw a0, -15(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; 	addi sp, sp, -19; nop; 	sw a0, -16(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 19; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -17(sp); 
	add a1, a2, zero; 	addi sp, sp, -19; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 19; nop; nop; 
nop; 	addi sp, sp, -21; nop; 	sw a0, -18(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 21; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -1(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -18(sp); 
nop; nop; 	lw a0, -17(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -16(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -15(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -14(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -12(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -11(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -10(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16140; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -19(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -21; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
nop; 	addi sp, sp, -23; nop; 	sw a0, -20(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 23; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -22(sp); 	sw a0, -21(sp); 
	add a1, a2, zero; 	addi sp, sp, -25; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 25; nop; nop; 
nop; 	addi sp, sp, -25; 	sw a0, -23(sp); 	lw a1, -22(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 25; nop; nop; 
nop; 	addi sp, sp, -27; nop; 	sw a0, -24(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 27; nop; nop; 
nop; 	addi sp, sp, -27; nop; 	sw a0, -25(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 27; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -26(sp); 
	add a1, a2, zero; 	addi sp, sp, -29; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 29; nop; nop; 
nop; 	addi sp, sp, -29; nop; 	sw a0, -27(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 29; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -1(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -27(sp); 
nop; nop; 	lw a0, -26(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -25(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -24(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -23(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -21(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -20(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -19(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16141; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -28(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -31; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 31; nop; nop; 
nop; 	addi sp, sp, -31; nop; 	sw a0, -29(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 31; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -31(sp); 	sw a0, -30(sp); 
	add a1, a2, zero; 	addi sp, sp, -33; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 33; nop; nop; 
nop; 	addi sp, sp, -35; 	sw a0, -32(sp); 	lw a1, -31(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 35; nop; nop; 
nop; 	addi sp, sp, -35; nop; 	sw a0, -33(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 35; nop; nop; 
nop; 	addi sp, sp, -37; nop; 	sw a0, -34(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 37; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -35(sp); 
	add a1, a2, zero; 	addi sp, sp, -37; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 37; nop; nop; 
nop; 	addi sp, sp, -39; nop; 	sw a0, -36(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 39; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -1(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -36(sp); 
nop; nop; 	lw a0, -35(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -34(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -33(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -32(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -30(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -29(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -28(sp); 	sw a0, 0(a1); 
	addi a1, a1, -1; 	add a22, a1, a2; nop; nop; 
nop; 	add a0, a2, zero; nop; 	sw a0, 0(a22); 
	jump init_line_elements.2918; nop; nop; nop; 
ble_else.16141:
	ret; 	add a0, a2, zero; nop; nop; 
ble_else.16140:
	ret; 	add a0, a2, zero; nop; nop; 
ble_else.16139:
	ret; 	add a0, a2, zero; nop; nop; 
ble_else.16138:
	ret; nop; nop; nop; 
calc_dirvec.2928:
nop; 	addi a3, zero, 5; nop; nop; 
	blt a0, a3, ble_else.16142; nop; nop; nop; 
	fmul f3, f1, f1; 	fmul f2, f0, f0; nop; nop; 
	fadd f2, f2, f3; 	lui a0, 4096; nop; nop; 
	addi a0, a0, 164; 	lui.float f3, 1.000000; nop; nop; 
	add a22, a0, a1; 	addi.float f3, f3, 1.000000; nop; nop; 
	lui.float f3, 1.000000; 	fadd f2, f2, f3; nop; 	lw a0, 0(a22); 
	addi.float f3, f3, 1.000000; 	fsqrt f2, f2; nop; nop; 
	fdiv f0, f0, f2; 	add a22, a2, a0; nop; nop; 
	fdiv f2, f3, f2; 	fdiv f1, f1, f2; nop; 	lw a1, 0(a22); 
	fneg f4, f1; 	fneg f3, f1; nop; 	lw a1, 0(a1); 
nop; 	fneg f5, f2; 	sw f1, 1(a1); 	sw f0, 0(a1); 
nop; 	addi a1, a2, 40; nop; 	sw f2, 2(a1); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 0(a1); 
nop; nop; 	sw f2, 1(a1); 	sw f0, 0(a1); 
	fneg f3, f0; 	addi a1, a2, 80; nop; 	sw f3, 2(a1); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 0(a1); 
nop; 	fneg f3, f0; 	sw f3, 1(a1); 	sw f2, 0(a1); 
	fneg f4, f1; 	addi a1, a2, 1; nop; 	sw f4, 2(a1); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 0(a1); 
	fneg f4, f2; 	fneg f3, f0; 	sw f4, 1(a1); 	sw f3, 0(a1); 
	addi a1, a2, 41; 	fneg f2, f2; nop; 	sw f5, 2(a1); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
nop; nop; nop; 	lw a1, 0(a1); 
nop; nop; 	sw f4, 1(a1); 	sw f3, 0(a1); 
nop; 	addi a1, a2, 81; nop; 	sw f1, 2(a1); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; 	lw a0, 0(a0); 
nop; nop; 	sw f0, 1(a0); 	sw f2, 0(a0); 
	ret; nop; nop; 	sw f1, 2(a0); 
nop; nop; nop; nop; 
ble_else.16142:
	lui.float f1, 0.100000; 	fmul f0, f1, f1; 	sw a1, -1(sp); 	sw a2, 0(sp); 
nop; 	addi.float f1, f1, 0.100000; 	sw f3, -3(sp); 	sw cl, -2(sp); 
	lui.float f1, 1.000000; 	fadd f0, f0, f1; 	sw f2, -6(sp); 	sw a0, -4(sp); 
	addi.float f1, f1, 1.000000; 	fsqrt f0, f0; nop; nop; 
	addi sp, sp, -9; 	fdiv f1, f1, f0; nop; 	sw f0, -5(sp); 
	call atan; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; nop; 	lw f1, -6(sp); 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi sp, sp, -9; nop; 	sw f0, -7(sp); 
	call sin; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; 	addi sp, sp, -11; 	sw f0, -8(sp); 	lw f1, -7(sp); 
	call cos; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
	lui.float f2, 0.100000; 	addi sp, sp, 11; nop; nop; 
nop; 	addi.float f2, f2, 0.100000; 	lw a0, -4(sp); 	lw f1, -8(sp); 
	addi a0, a0, 1; 	fdiv f0, f1, f0; nop; 	lw f1, -5(sp); 
nop; 	fmul f0, f0, f1; nop; 	sw a0, -10(sp); 
nop; 	fmul f1, f0, f0; nop; 	sw f0, -9(sp); 
	lui.float f2, 1.000000; 	fadd f1, f1, f2; nop; nop; 
	addi.float f2, f2, 1.000000; 	fsqrt f1, f1; nop; nop; 
	addi sp, sp, -13; 	fdiv f2, f2, f1; nop; 	sw f1, -11(sp); 
	call atan; 	addi f0, f2, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; nop; 	lw f1, -3(sp); 
nop; 	fmul f0, f0, f1; nop; nop; 
nop; 	addi sp, sp, -15; nop; 	sw f0, -12(sp); 
	call sin; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
nop; 	addi sp, sp, -15; 	sw f0, -13(sp); 	lw f1, -12(sp); 
	call cos; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
nop; nop; 	lw f2, -6(sp); 	lw f1, -13(sp); 
nop; 	fdiv f0, f1, f0; 	lw a0, -10(sp); 	lw f3, -3(sp); 
nop; nop; 	lw a2, 0(sp); 	lw a1, -1(sp); 
nop; nop; 	lw f1, -11(sp); 	lw cl, -2(sp); 
nop; 	fmul f1, f0, f1; 	lw f0, -9(sp); 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
calc_dirvecs.2936:
nop; 	addi a4, zero, 0; nop; 	lw a3, 1(cl); 
	blt a0, a4, ble_else.16144; nop; nop; nop; 
	lui.float f2, 0.200000; 	itof f1, a0; 	sw f0, -1(sp); 	sw cl, 0(sp); 
	add cl, a3, zero; 	addi f3, f0, 0; 	sw a3, -3(sp); 	sw a1, -2(sp); 
	add a0, a4, zero; 	addi.float f2, f2, 0.200000; 	sw a0, -5(sp); 	sw a2, -4(sp); 
	fmul f1, f1, f2; 	addi sp, sp, -7; nop; 	lw swp, 0(cl); 
nop; 	lui.float f2, 0.900000; nop; nop; 
nop; 	addi.float f2, f2, 0.900000; nop; nop; 
	lui.float f1, 0.000000; 	fsub f2, f1, f2; nop; nop; 
nop; 	addi.float f1, f1, 0.000000; nop; nop; 
	callr swp; 	addi f0, f1, 0; nop; nop; 
nop; nop; nop; nop; 
	lui.float f1, 0.200000; 	addi sp, sp, 7; nop; nop; 
	addi.float f1, f1, 0.200000; 	addi a3, zero, 0; 	lw a1, -4(sp); 	lw a0, -5(sp); 
	addi a2, a1, 2; 	itof f0, a0; 	lw a4, -2(sp); 	lw f3, -1(sp); 
	fmul f0, f0, f1; 	add a0, a3, zero; nop; 	lw cl, -3(sp); 
	addi sp, sp, -7; 	add a1, a4, zero; nop; 	lw swp, 0(cl); 
nop; 	lui.float f1, 0.100000; nop; nop; 
nop; 	addi.float f1, f1, 0.100000; nop; nop; 
	lui.float f0, 0.000000; 	fadd f2, f0, f1; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; nop; nop; 
	callr swp; 	addi f1, f0, 0; nop; nop; 
nop; nop; nop; nop; 
	addi a2, zero, 5; 	addi sp, sp, 7; nop; nop; 
nop; nop; 	lw a1, -2(sp); 	lw a0, -5(sp); 
	addi a1, a1, 1; 	addi a0, a0, -1; nop; nop; 
	blt a1, a2, ble_else.16145; nop; nop; nop; 
	jump ble_cont.16146; 	addi a1, a1, -5; nop; nop; 
ble_else.16145:
ble_cont.16146:
nop; nop; 	lw a2, -4(sp); 	lw f0, -1(sp); 
nop; nop; nop; 	lw cl, 0(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16144:
	ret; nop; nop; nop; 
calc_dirvec_rows.2941:
nop; 	addi a4, zero, 0; nop; 	lw a3, 1(cl); 
	blt a0, a4, ble_else.16148; nop; nop; nop; 
	lui.float f1, 0.200000; 	itof f0, a0; 	sw a2, -1(sp); 	sw cl, 0(sp); 
	add cl, a3, zero; 	addi a4, zero, 4; 	sw a0, -3(sp); 	sw a1, -2(sp); 
	addi sp, sp, -5; 	addi.float f1, f1, 0.200000; nop; 	lw swp, 0(cl); 
	fmul f0, f0, f1; 	add a0, a4, zero; nop; nop; 
nop; 	lui.float f1, 0.900000; nop; nop; 
nop; 	addi.float f1, f1, 0.900000; nop; nop; 
	callr swp; 	fsub f0, f0, f1; nop; nop; 
nop; nop; nop; nop; 
	addi a2, zero, 5; 	addi sp, sp, 5; nop; nop; 
nop; nop; 	lw a1, -2(sp); 	lw a0, -3(sp); 
	addi a1, a1, 2; 	addi a0, a0, -1; nop; nop; 
	blt a1, a2, ble_else.16149; nop; nop; nop; 
	jump ble_cont.16150; 	addi a1, a1, -5; nop; nop; 
ble_else.16149:
ble_cont.16150:
nop; nop; 	lw cl, 0(sp); 	lw a2, -1(sp); 
nop; 	addi a2, a2, 4; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16148:
	ret; nop; nop; nop; 
create_dirvec_elements.2947:
nop; 	addi a2, zero, 0; nop; nop; 
	blt a1, a2, ble_else.16152; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; 	sw a1, -2(sp); 	sw cl, 0(sp); 
	add a0, a3, zero; 	addi.float f0, f0, 0.000000; 	sw a3, -1(sp); 	sw a0, -3(sp); 
	call create_float_array; 	addi sp, sp, -5; nop; nop; 
nop; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 5; nop; nop; 
	addi sp, sp, -7; 	lui a0, 4096; nop; 	sw a1, -4(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 7; nop; nop; 
nop; 	addi hp, hp, 2; 	lw a2, -3(sp); 	sw a0, 1(a1); 
nop; nop; nop; 	lw a0, -4(sp); 
nop; 	add a0, a1, zero; 	lw a1, -2(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16153; nop; nop; nop; 
	addi sp, sp, -7; 	lui.float f0, 0.000000; 	sw a0, -5(sp); 	lw a1, -1(sp); 
	add a0, a1, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 7; nop; nop; 
	addi sp, sp, -9; 	lui a0, 4096; nop; 	sw a1, -6(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 9; nop; nop; 
nop; 	addi hp, hp, 2; 	lw a2, -3(sp); 	sw a0, 1(a1); 
nop; nop; 	lw a0, -6(sp); 	lw cl, 0(sp); 
nop; 	add a0, a1, zero; 	lw swp, 0(cl); 	sw a0, 0(a1); 
nop; nop; nop; 	lw a1, -5(sp); 
	addi a1, a1, -1; 	add a22, a1, a2; nop; nop; 
nop; 	add a0, a2, zero; nop; 	sw a0, 0(a22); 
	jumpr swp; nop; nop; nop; 
ble_else.16153:
	ret; nop; nop; nop; 
ble_else.16152:
	ret; nop; nop; nop; 
create_dirvecs.2950:
nop; 	addi a2, zero, 0; nop; 	lw a1, 5(cl); 
	blt a0, a2, ble_else.16156; nop; nop; nop; 
	addi a4, zero, 3; 	addi a3, zero, 120; 	sw a1, -1(sp); 	sw cl, 0(sp); 
	add a0, a4, zero; 	lui.float f0, 0.000000; 	sw a3, -3(sp); 	sw a0, -2(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -5; nop; nop; 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 5; nop; nop; 
	addi sp, sp, -7; 	lui a0, 4096; nop; 	sw a1, -4(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 7; nop; nop; 
nop; 	addi hp, hp, 2; 	lw a0, -4(sp); 	sw a0, 1(a1); 
nop; 	addi sp, sp, -7; 	lw a0, -3(sp); 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 7; nop; nop; 
	addi a1, a1, 164; 	lui.float f0, 0.000000; nop; 	lw a2, -2(sp); 
	addi.float f0, f0, 0.000000; 	add a22, a1, a2; nop; nop; 
	lui a0, 4096; 	addi a1, zero, 3; nop; 	sw a0, 0(a22); 
nop; 	addi a0, a0, 164; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
nop; nop; nop; 	lw a0, 0(a22); 
	addi sp, sp, -7; 	add a0, a1, zero; nop; 	sw a0, -5(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 7; nop; nop; 
	addi sp, sp, -9; 	lui a0, 4096; nop; 	sw a1, -6(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 9; nop; nop; 
nop; 	addi hp, hp, 2; 	lw cl, -1(sp); 	sw a0, 1(a1); 
nop; nop; nop; 	lw a0, -6(sp); 
	addi sp, sp, -9; 	add a0, a1, zero; 	lw a1, -5(sp); 	sw a0, 0(a1); 
	addi a0, zero, 117; 	add swp, a1, zero; nop; 	sw a0, 118(a1); 
	add a0, swp, zero; 	add a1, a0, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 9; nop; nop; 
nop; nop; nop; 	lw a0, -2(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16157; nop; nop; nop; 
	addi a2, zero, 3; 	addi a1, zero, 120; nop; 	sw a0, -7(sp); 
	add a0, a2, zero; 	lui.float f0, 0.000000; nop; 	sw a1, -8(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -11; nop; nop; 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 11; nop; nop; 
	addi sp, sp, -11; 	lui a0, 4096; nop; 	sw a1, -9(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 11; nop; nop; 
nop; 	addi hp, hp, 2; 	lw a0, -9(sp); 	sw a0, 1(a1); 
nop; 	addi sp, sp, -11; 	lw a0, -8(sp); 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 11; nop; nop; 
	addi sp, sp, -11; 	addi a1, a1, 164; 	lw cl, -1(sp); 	lw a2, -7(sp); 
	addi a1, zero, 118; 	add a22, a1, a2; nop; 	lw swp, 0(cl); 
nop; 	lui a0, 4096; nop; 	sw a0, 0(a22); 
nop; 	addi a0, a0, 164; nop; nop; 
nop; 	add a22, a0, a2; nop; nop; 
	callr swp; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 11; nop; nop; 
nop; nop; 	lw cl, 0(sp); 	lw a0, -7(sp); 
nop; 	addi a0, a0, -1; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16157:
	ret; nop; nop; nop; 
ble_else.16156:
	ret; nop; nop; nop; 
init_dirvec_constants.2952:
nop; 	addi a3, zero, 0; nop; 	lw a2, 3(cl); 
	blt a1, a3, ble_else.16160; nop; nop; nop; 
	lui a5, 4096; 	add a22, a1, a0; 	sw a2, -1(sp); 	sw cl, 0(sp); 
nop; 	addi a5, a5, 0; 	sw a1, -3(sp); 	sw a0, -2(sp); 
nop; nop; 	lw a5, 0(a5); 	lw a4, 0(a22); 
nop; 	addi a5, a5, -1; nop; nop; 
	blt a5, a3, ble_else.16161; nop; nop; nop; 
	addi a10, zero, 1; 	lui a6, 4096; 	lw a8, 0(a4); 	lw a7, 1(a4); 
nop; 	addi a6, a6, 1; nop; 	sw a4, -4(sp); 
nop; 	add a22, a6, a5; nop; nop; 
nop; nop; nop; 	lw a6, 0(a22); 
nop; nop; nop; 	lw a9, 1(a6); 
	bne a9, a10, be_else.16163; nop; nop; nop; 
	add a0, a8, zero; 	add a1, a6, zero; 	sw a7, -6(sp); 	sw a5, -5(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16164; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16163:
nop; 	addi a10, zero, 2; nop; nop; 
	bne a9, a10, be_else.16165; nop; nop; nop; 
	add a0, a8, zero; 	add a1, a6, zero; 	sw a7, -6(sp); 	sw a5, -5(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16166; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16165:
	add a0, a8, zero; 	add a1, a6, zero; 	sw a7, -6(sp); 	sw a5, -5(sp); 
	call setup_second_table.2731; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -6(sp); 	lw a1, -5(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16166:
be_cont.16164:
	addi sp, sp, -9; 	addi a1, a1, -1; 	lw cl, -1(sp); 	lw a0, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16162; 	addi sp, sp, 9; nop; nop; 
ble_else.16161:
ble_cont.16162:
nop; 	addi a1, zero, 0; nop; 	lw a0, -3(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16167; nop; nop; nop; 
nop; 	lui a4, 4096; 	sw a0, -7(sp); 	lw a2, -2(sp); 
	addi a4, a4, 0; 	add a22, a0, a2; nop; nop; 
nop; nop; 	lw a4, 0(a4); 	lw a3, 0(a22); 
nop; 	addi a4, a4, -1; nop; nop; 
	blt a4, a1, ble_else.16168; nop; nop; nop; 
	addi a9, zero, 1; 	lui a5, 4096; 	lw a7, 0(a3); 	lw a6, 1(a3); 
nop; 	addi a5, a5, 1; nop; 	sw a3, -8(sp); 
nop; 	add a22, a5, a4; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a8, 1(a5); 
	bne a8, a9, be_else.16170; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -10(sp); 	sw a4, -9(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16171; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16170:
nop; 	addi a9, zero, 2; nop; nop; 
	bne a8, a9, be_else.16172; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -10(sp); 	sw a4, -9(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16173; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16172:
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -10(sp); 	sw a4, -9(sp); 
	call setup_second_table.2731; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16173:
be_cont.16171:
	addi sp, sp, -13; 	addi a1, a1, -1; 	lw cl, -1(sp); 	lw a0, -8(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16169; 	addi sp, sp, 13; nop; nop; 
ble_else.16168:
ble_cont.16169:
nop; 	addi a1, zero, 0; nop; 	lw a0, -7(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16174; nop; nop; nop; 
nop; 	lui a4, 4096; 	sw a0, -11(sp); 	lw a2, -2(sp); 
	addi a4, a4, 0; 	add a22, a0, a2; nop; nop; 
nop; nop; 	lw a4, 0(a4); 	lw a3, 0(a22); 
nop; 	addi a4, a4, -1; nop; nop; 
	blt a4, a1, ble_else.16175; nop; nop; nop; 
	addi a9, zero, 1; 	lui a5, 4096; 	lw a7, 0(a3); 	lw a6, 1(a3); 
nop; 	addi a5, a5, 1; nop; 	sw a3, -12(sp); 
nop; 	add a22, a5, a4; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a8, 1(a5); 
	bne a8, a9, be_else.16177; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -14(sp); 	sw a4, -13(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -14(sp); 	lw a1, -13(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16178; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16177:
nop; 	addi a9, zero, 2; nop; nop; 
	bne a8, a9, be_else.16179; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -14(sp); 	sw a4, -13(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -14(sp); 	lw a1, -13(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16180; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16179:
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -14(sp); 	sw a4, -13(sp); 
	call setup_second_table.2731; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -14(sp); 	lw a1, -13(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16180:
be_cont.16178:
	addi sp, sp, -17; 	addi a1, a1, -1; 	lw cl, -1(sp); 	lw a0, -12(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16176; 	addi sp, sp, 17; nop; nop; 
ble_else.16175:
ble_cont.16176:
nop; 	addi a1, zero, 0; nop; 	lw a0, -11(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16181; nop; nop; nop; 
nop; 	lui a3, 4096; 	lw cl, -1(sp); 	lw a1, -2(sp); 
	addi a3, a3, 0; 	add a22, a0, a1; 	lw swp, 0(cl); 	sw a0, -15(sp); 
nop; 	addi sp, sp, -17; 	lw a3, 0(a3); 	lw a2, 0(a22); 
	add a0, a2, zero; 	addi a3, a3, -1; nop; nop; 
	callr swp; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw cl, 0(sp); 	lw a0, -15(sp); 
nop; 	addi a1, a0, -1; 	lw a0, -2(sp); 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16181:
	ret; nop; nop; nop; 
ble_else.16174:
	ret; nop; nop; nop; 
ble_else.16167:
	ret; nop; nop; nop; 
ble_else.16160:
	ret; nop; nop; nop; 
init_vecset_constants.2955:
nop; 	addi a3, zero, 0; 	lw a2, 4(cl); 	lw a1, 10(cl); 
	blt a0, a3, ble_else.16186; nop; nop; nop; 
	lui a6, 4096; 	lui a4, 4096; 	sw a0, -1(sp); 	sw cl, 0(sp); 
	addi a6, a6, 0; 	addi a4, a4, 164; 	sw a2, -3(sp); 	sw a1, -2(sp); 
nop; 	add a22, a4, a0; nop; 	lw a6, 0(a6); 
nop; 	addi a6, a6, -1; nop; 	lw a4, 0(a22); 
	blt a6, a3, ble_else.16187; nop; 	sw a4, -4(sp); 	lw a5, 119(a4); 
	addi a11, zero, 1; 	lui a7, 4096; 	lw a9, 0(a5); 	lw a8, 1(a5); 
nop; 	addi a7, a7, 1; nop; 	sw a5, -5(sp); 
nop; 	add a22, a7, a6; nop; nop; 
nop; nop; nop; 	lw a7, 0(a22); 
nop; nop; nop; 	lw a10, 1(a7); 
	bne a10, a11, be_else.16189; nop; nop; nop; 
	add a0, a9, zero; 	add a1, a7, zero; 	sw a8, -7(sp); 	sw a6, -6(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -7(sp); 	lw a1, -6(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16190; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16189:
nop; 	addi a11, zero, 2; nop; nop; 
	bne a10, a11, be_else.16191; nop; nop; nop; 
	add a0, a9, zero; 	add a1, a7, zero; 	sw a8, -7(sp); 	sw a6, -6(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -7(sp); 	lw a1, -6(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16192; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16191:
	add a0, a9, zero; 	add a1, a7, zero; 	sw a8, -7(sp); 	sw a6, -6(sp); 
	call setup_second_table.2731; 	addi sp, sp, -9; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 9; nop; nop; 
nop; nop; 	lw a2, -7(sp); 	lw a1, -6(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16192:
be_cont.16190:
	addi sp, sp, -9; 	addi a1, a1, -1; 	lw cl, -3(sp); 	lw a0, -5(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16188; 	addi sp, sp, 9; nop; nop; 
ble_else.16187:
ble_cont.16188:
	addi a3, zero, 0; 	lui a2, 4096; nop; 	lw a0, -4(sp); 
nop; 	addi a2, a2, 0; nop; 	lw a1, 118(a0); 
nop; nop; nop; 	lw a2, 0(a2); 
nop; 	addi a2, a2, -1; nop; nop; 
	blt a2, a3, ble_else.16193; nop; nop; nop; 
	addi a8, zero, 1; 	lui a4, 4096; 	lw a6, 0(a1); 	lw a5, 1(a1); 
nop; 	addi a4, a4, 1; nop; 	sw a1, -8(sp); 
nop; 	add a22, a4, a2; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
nop; nop; nop; 	lw a7, 1(a4); 
	bne a7, a8, be_else.16195; nop; nop; nop; 
	add a0, a6, zero; 	add a1, a4, zero; 	sw a5, -10(sp); 	sw a2, -9(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16196; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16195:
nop; 	addi a8, zero, 2; nop; nop; 
	bne a7, a8, be_else.16197; nop; nop; nop; 
	add a0, a6, zero; 	add a1, a4, zero; 	sw a5, -10(sp); 	sw a2, -9(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16198; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16197:
	add a0, a6, zero; 	add a1, a4, zero; 	sw a5, -10(sp); 	sw a2, -9(sp); 
	call setup_second_table.2731; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16198:
be_cont.16196:
	addi sp, sp, -13; 	addi a1, a1, -1; 	lw cl, -3(sp); 	lw a0, -8(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16194; 	addi sp, sp, 13; nop; nop; 
ble_else.16193:
ble_cont.16194:
	addi sp, sp, -13; 	lui a2, 4096; 	lw cl, -3(sp); 	lw a0, -4(sp); 
nop; 	addi a2, a2, 0; 	lw swp, 0(cl); 	lw a1, 117(a0); 
nop; 	add a0, a1, zero; nop; 	lw a2, 0(a2); 
nop; 	addi a2, a2, -1; nop; nop; 
	callr swp; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 116; 	addi sp, sp, 13; nop; nop; 
nop; 	addi sp, sp, -13; 	lw cl, -2(sp); 	lw a0, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 13; nop; nop; 
nop; nop; nop; 	lw a0, -1(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16199; nop; nop; nop; 
	lui a4, 4096; 	lui a2, 4096; nop; 	sw a0, -11(sp); 
	addi a4, a4, 0; 	addi a2, a2, 164; nop; nop; 
nop; 	add a22, a2, a0; nop; 	lw a4, 0(a4); 
nop; 	addi a4, a4, -1; nop; 	lw a2, 0(a22); 
	blt a4, a1, ble_else.16200; nop; 	sw a2, -12(sp); 	lw a3, 119(a2); 
	addi a9, zero, 1; 	lui a5, 4096; 	lw a7, 0(a3); 	lw a6, 1(a3); 
nop; 	addi a5, a5, 1; nop; 	sw a3, -13(sp); 
nop; 	add a22, a5, a4; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a8, 1(a5); 
	bne a8, a9, be_else.16202; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -15(sp); 	sw a4, -14(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -15(sp); 	lw a1, -14(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16203; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16202:
nop; 	addi a9, zero, 2; nop; nop; 
	bne a8, a9, be_else.16204; nop; nop; nop; 
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -15(sp); 	sw a4, -14(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -15(sp); 	lw a1, -14(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16205; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16204:
	add a0, a7, zero; 	add a1, a5, zero; 	sw a6, -15(sp); 	sw a4, -14(sp); 
	call setup_second_table.2731; 	addi sp, sp, -17; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 17; nop; nop; 
nop; nop; 	lw a2, -15(sp); 	lw a1, -14(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16205:
be_cont.16203:
	addi sp, sp, -17; 	addi a1, a1, -1; 	lw cl, -3(sp); 	lw a0, -13(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16201; 	addi sp, sp, 17; nop; nop; 
ble_else.16200:
ble_cont.16201:
	addi sp, sp, -17; 	lui a2, 4096; 	lw cl, -3(sp); 	lw a0, -12(sp); 
nop; 	addi a2, a2, 0; 	lw swp, 0(cl); 	lw a1, 118(a0); 
nop; 	add a0, a1, zero; nop; 	lw a2, 0(a2); 
nop; 	addi a2, a2, -1; nop; nop; 
	callr swp; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 117; 	addi sp, sp, 17; nop; nop; 
nop; 	addi sp, sp, -17; 	lw cl, -2(sp); 	lw a0, -12(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 17; nop; nop; 
nop; nop; nop; 	lw a0, -11(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16206; nop; nop; nop; 
	addi a3, zero, 119; 	lui a2, 4096; 	sw a0, -17(sp); 	lw cl, -3(sp); 
	addi a2, a2, 164; 	lui a5, 4096; 	lw swp, 0(cl); 	sw a3, -16(sp); 
	addi a5, a5, 0; 	add a22, a2, a0; nop; nop; 
nop; nop; 	lw a5, 0(a5); 	lw a2, 0(a22); 
	addi sp, sp, -21; 	addi a5, a5, -1; 	sw a2, -18(sp); 	lw a4, 119(a2); 
	add a0, a4, zero; 	add a1, a5, zero; nop; nop; 
	callr swp; nop; nop; nop; 
	addi a1, zero, 118; 	addi sp, sp, 21; nop; nop; 
nop; 	addi sp, sp, -21; 	lw cl, -2(sp); 	lw a0, -18(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 21; nop; nop; 
nop; nop; nop; 	lw a0, -17(sp); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16207; nop; nop; nop; 
nop; 	lui a1, 4096; 	lw cl, -2(sp); 	lw a2, -16(sp); 
	addi sp, sp, -21; 	addi a1, a1, 164; 	lw swp, 0(cl); 	sw a0, -19(sp); 
nop; 	add a22, a1, a0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a22); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
nop; nop; 	lw cl, 0(sp); 	lw a0, -19(sp); 
nop; 	addi a0, a0, -1; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
ble_else.16207:
	ret; nop; nop; nop; 
ble_else.16206:
	ret; nop; nop; nop; 
ble_else.16199:
	ret; nop; nop; nop; 
ble_else.16186:
	ret; nop; nop; nop; 
setup_rect_reflection.2966:
	lui a3, 4096; 	slli a0, a0, 2; 	lw a1, 7(a1); 	lw a2, 9(cl); 
	lui a4, 4096; 	lui.float f0, 1.000000; 	sw a0, -1(sp); 	lw f1, 0(a1); 
	addi a3, a3, 351; 	lui.float f5, 0.000000; nop; 	sw a2, -5(sp); 
	addi.float f0, f0, 1.000000; 	lui a1, 4096; nop; 	lw a3, 0(a3); 
	addi.float f5, f5, 0.000000; 	addi a4, a4, 67; nop; 	sw a3, -2(sp); 
	addi a1, a1, 67; 	fsub f0, f0, f1; nop; nop; 
	addi f0, f5, 0; 	addi a1, zero, 1; 	sw f0, -4(sp); 	lw f1, 0(a1); 
	add a22, a4, a1; 	fneg f1, f1; nop; nop; 
	lui a4, 4096; 	addi a1, zero, 2; 	sw f1, 0(sp); 	lw f2, 0(a22); 
	addi a4, a4, 67; 	fneg f2, f2; nop; nop; 
	addi a1, a0, 1; 	add a22, a4, a1; nop; 	sw f2, -7(sp); 
nop; 	lui a4, 4096; 	sw a1, -3(sp); 	lw f3, 0(a22); 
	addi a4, a4, 67; 	fneg f3, f3; nop; nop; 
nop; 	addi a4, zero, 3; 	sw f3, -6(sp); 	lw f4, 0(a4); 
	addi sp, sp, -11; 	add a0, a4, zero; nop; 	sw f4, -8(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 11; nop; nop; 
	addi sp, sp, -11; 	lui a0, 4096; nop; 	sw a1, -9(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 11; nop; nop; 
	addi a4, zero, 0; 	lui a3, 4096; 	lw a2, -9(sp); 	sw a0, 1(a1); 
	addi a3, a3, 0; 	addi hp, hp, 2; 	lw f1, -6(sp); 	lw f0, -8(sp); 
nop; nop; 	sw a2, 0(a1); 	sw a1, -10(sp); 
nop; nop; 	sw f1, 2(a2); 	sw f0, 0(a2); 
nop; nop; 	lw f0, -7(sp); 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; nop; 	sw f0, 1(a2); 
	blt a3, a4, ble_else.16212; nop; nop; nop; 
	addi a7, zero, 1; 	lui a5, 4096; nop; nop; 
nop; 	addi a5, a5, 1; nop; nop; 
nop; 	add a22, a5, a3; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a6, 1(a5); 
	bne a6, a7, be_else.16214; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -12(sp); 	sw a3, -11(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -15; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
nop; nop; 	lw a2, -12(sp); 	lw a1, -11(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16215; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16214:
nop; 	addi a7, zero, 2; nop; nop; 
	bne a6, a7, be_else.16216; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -12(sp); 	sw a3, -11(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -15; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
nop; nop; 	lw a2, -12(sp); 	lw a1, -11(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16217; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16216:
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -12(sp); 	sw a3, -11(sp); 
	call setup_second_table.2731; 	addi sp, sp, -15; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 15; nop; nop; 
nop; nop; 	lw a2, -12(sp); 	lw a1, -11(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16217:
be_cont.16215:
	addi sp, sp, -15; 	addi a1, a1, -1; 	lw cl, -5(sp); 	lw a0, -10(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16213; 	addi sp, sp, 15; nop; nop; 
ble_else.16212:
ble_cont.16213:
	addi a4, zero, 1; 	add a0, hp, zero; 	lw a1, -10(sp); 	lw f0, -4(sp); 
	lui.float f2, 0.000000; 	lui a5, 4096; 	sw f0, 2(a0); 	lw a2, -2(sp); 
	addi a5, a5, 67; 	addi hp, hp, 6; 	lw a1, -3(sp); 	sw a1, 1(a0); 
	lui a1, 4096; 	addi.float f2, f2, 0.000000; nop; 	sw a1, 0(a0); 
	addi f0, f2, 0; 	addi a1, a1, 171; nop; nop; 
nop; 	add a22, a1, a2; nop; 	lw a1, -1(sp); 
	addi a0, a2, 1; 	addi a3, a1, 2; nop; 	sw a0, 0(a22); 
	addi a4, zero, 3; 	add a22, a5, a4; 	sw a3, -14(sp); 	sw a0, -13(sp); 
nop; 	add a0, a4, zero; nop; 	lw f1, 0(a22); 
nop; 	addi sp, sp, -17; nop; 	sw f1, -15(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 17; nop; nop; 
	addi sp, sp, -19; 	lui a0, 4096; nop; 	sw a1, -16(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 19; nop; nop; 
	addi a4, zero, 0; 	lui a3, 4096; 	lw a2, -16(sp); 	sw a0, 1(a1); 
	addi a3, a3, 0; 	addi hp, hp, 2; 	lw f1, -15(sp); 	lw f0, 0(sp); 
nop; nop; 	sw a2, 0(a1); 	sw a1, -17(sp); 
nop; nop; 	sw f1, 1(a2); 	sw f0, 0(a2); 
nop; nop; 	lw f1, -6(sp); 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; nop; 	sw f1, 2(a2); 
	blt a3, a4, ble_else.16218; nop; nop; nop; 
	addi a7, zero, 1; 	lui a5, 4096; nop; nop; 
nop; 	addi a5, a5, 1; nop; nop; 
nop; 	add a22, a5, a3; nop; nop; 
nop; nop; nop; 	lw a5, 0(a22); 
nop; nop; nop; 	lw a6, 1(a5); 
	bne a6, a7, be_else.16220; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -19(sp); 	sw a3, -18(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -21; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
nop; nop; 	lw a2, -19(sp); 	lw a1, -18(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16221; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16220:
nop; 	addi a7, zero, 2; nop; nop; 
	bne a6, a7, be_else.16222; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -19(sp); 	sw a3, -18(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -21; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
nop; nop; 	lw a2, -19(sp); 	lw a1, -18(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16223; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16222:
	add a0, a2, zero; 	add a1, a5, zero; 	sw a0, -19(sp); 	sw a3, -18(sp); 
	call setup_second_table.2731; 	addi sp, sp, -21; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 21; nop; nop; 
nop; nop; 	lw a2, -19(sp); 	lw a1, -18(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16223:
be_cont.16221:
	addi sp, sp, -21; 	addi a1, a1, -1; 	lw cl, -5(sp); 	lw a0, -17(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16219; 	addi sp, sp, 21; nop; nop; 
ble_else.16218:
ble_cont.16219:
	addi a3, zero, 2; 	add a0, hp, zero; 	lw a1, -17(sp); 	lw f0, -4(sp); 
	lui.float f2, 0.000000; 	lui a4, 4096; 	sw f0, 2(a0); 	lw a2, -13(sp); 
	addi a4, a4, 67; 	addi hp, hp, 6; 	lw a1, -14(sp); 	sw a1, 1(a0); 
	lui a1, 4096; 	addi.float f2, f2, 0.000000; nop; 	sw a1, 0(a0); 
	addi f0, f2, 0; 	addi a1, a1, 171; nop; nop; 
nop; 	add a22, a1, a2; nop; 	lw a2, -1(sp); 
	add a22, a4, a3; 	addi a2, a2, 3; 	lw a0, -2(sp); 	sw a0, 0(a22); 
	addi a1, a0, 2; 	addi a3, zero, 3; 	sw a2, -21(sp); 	lw f1, 0(a22); 
	addi sp, sp, -25; 	add a0, a3, zero; 	sw f1, -22(sp); 	sw a1, -20(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 25; nop; nop; 
	addi sp, sp, -25; 	lui a0, 4096; nop; 	sw a1, -23(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 25; nop; nop; 
	addi a4, zero, 0; 	lui a3, 4096; 	lw a2, -23(sp); 	sw a0, 1(a1); 
	addi a3, a3, 0; 	addi hp, hp, 2; 	sw a1, -24(sp); 	lw f0, 0(sp); 
nop; nop; 	sw f0, 0(a2); 	sw a2, 0(a1); 
nop; nop; 	lw f0, -7(sp); 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; 	lw f0, -22(sp); 	sw f0, 1(a2); 
	blt a3, a4, ble_else.16224; nop; nop; 	sw f0, 2(a2); 
	addi a6, zero, 1; 	lui a4, 4096; nop; nop; 
nop; 	addi a4, a4, 1; nop; nop; 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
nop; nop; nop; 	lw a5, 1(a4); 
	bne a5, a6, be_else.16226; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -26(sp); 	sw a3, -25(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -29; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 29; nop; nop; 
nop; nop; 	lw a2, -26(sp); 	lw a1, -25(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16227; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16226:
nop; 	addi a6, zero, 2; nop; nop; 
	bne a5, a6, be_else.16228; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -26(sp); 	sw a3, -25(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -29; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 29; nop; nop; 
nop; nop; 	lw a2, -26(sp); 	lw a1, -25(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16229; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16228:
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -26(sp); 	sw a3, -25(sp); 
	call setup_second_table.2731; 	addi sp, sp, -29; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 29; nop; nop; 
nop; nop; 	lw a2, -26(sp); 	lw a1, -25(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16229:
be_cont.16227:
	addi sp, sp, -29; 	addi a1, a1, -1; 	lw cl, -5(sp); 	lw a0, -24(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16225; 	addi sp, sp, 29; nop; nop; 
ble_else.16224:
ble_cont.16225:
	addi hp, hp, 6; 	add a0, hp, zero; 	lw a1, -24(sp); 	lw f0, -4(sp); 
nop; nop; 	sw f0, 2(a0); 	lw a2, -20(sp); 
nop; nop; 	lw a1, -21(sp); 	sw a1, 1(a0); 
nop; 	lui a1, 4096; nop; 	sw a1, 0(a0); 
nop; 	addi a1, a1, 171; nop; nop; 
	lui a1, 4096; 	add a22, a1, a2; nop; nop; 
nop; 	addi a1, a1, 351; 	lw a0, -2(sp); 	sw a0, 0(a22); 
nop; 	addi a0, a0, 3; nop; nop; 
	ret; nop; nop; 	sw a0, 0(a1); 
nop; nop; nop; nop; 
setup_surface_reflection.2969:
	lui a3, 4096; 	slli a0, a0, 2; 	lw a4, 7(a1); 	lw a2, 11(cl); 
	lui a5, 4096; 	lui.float f0, 1.000000; 	sw a2, -3(sp); 	lw f1, 0(a4); 
	addi a0, a0, 1; 	lui a6, 4096; nop; 	lw a4, 4(a1); 
	addi.float f0, f0, 1.000000; 	addi a3, a3, 351; 	lw f3, 1(a4); 	lw f2, 0(a4); 
	addi a6, a6, 67; 	addi a5, a5, 67; 	lw a3, 0(a3); 	sw a0, -1(sp); 
	addi a5, zero, 1; 	fsub f0, f0, f1; 	lw f1, 0(a5); 	sw a3, 0(sp); 
	add a22, a6, a5; 	fmul f1, f1, f2; nop; 	sw f0, -2(sp); 
	lui a6, 4096; 	addi a5, zero, 2; nop; 	lw f2, 0(a22); 
	addi a6, a6, 67; 	fmul f2, f2, f3; 	lw a4, 4(a1); 	lw f3, 2(a4); 
	add a22, a6, a5; 	fadd f1, f1, f2; nop; nop; 
nop; 	lui a5, 4096; nop; 	lw f2, 0(a22); 
	addi a5, a5, 67; 	fmul f2, f2, f3; nop; 	lw f3, 0(a4); 
	fadd f1, f1, f2; 	lui a4, 4096; nop; nop; 
	addi a4, a4, 67; 	lui.float f2, 2.000000; nop; nop; 
nop; 	addi.float f2, f2, 2.000000; nop; nop; 
nop; 	fmul f2, f2, f3; 	lw a4, 4(a1); 	lw f3, 0(a4); 
	addi a4, zero, 1; 	fmul f2, f2, f1; 	lw f4, 1(a4); 	lw a1, 4(a1); 
	add a22, a5, a4; 	fsub f2, f2, f3; nop; 	lw f5, 2(a1); 
	lui a4, 4096; 	lui.float f3, 2.000000; nop; 	sw f2, -6(sp); 
	addi.float f3, f3, 2.000000; 	addi a1, zero, 2; nop; nop; 
	fmul f3, f3, f4; 	addi a4, a4, 67; nop; 	lw f4, 0(a22); 
	add a22, a4, a1; 	fmul f3, f3, f1; nop; nop; 
	fsub f3, f3, f4; 	addi a1, zero, 3; nop; nop; 
	add a0, a1, zero; 	lui.float f4, 2.000000; nop; 	sw f3, -5(sp); 
nop; 	addi.float f4, f4, 2.000000; nop; nop; 
nop; 	fmul f4, f4, f5; nop; nop; 
nop; 	fmul f1, f4, f1; nop; 	lw f4, 0(a22); 
	lui.float f4, 0.000000; 	fsub f1, f1, f4; nop; nop; 
	addi sp, sp, -9; 	addi.float f4, f4, 0.000000; nop; 	sw f1, -4(sp); 
	call create_float_array; 	addi f0, f4, 0; nop; nop; 
nop; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 9; nop; nop; 
	addi sp, sp, -9; 	lui a0, 4096; nop; 	sw a1, -7(sp); 
nop; 	addi a0, a0, 0; nop; nop; 
	call create_array; nop; nop; 	lw a0, 0(a0); 
nop; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 9; nop; nop; 
	addi a4, zero, 0; 	lui a3, 4096; 	lw a2, -7(sp); 	sw a0, 1(a1); 
	addi a3, a3, 0; 	addi hp, hp, 2; 	sw a1, -8(sp); 	lw f0, -6(sp); 
nop; nop; 	sw f0, 0(a2); 	sw a2, 0(a1); 
nop; nop; 	lw f0, -5(sp); 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; 	lw f0, -4(sp); 	sw f0, 1(a2); 
	blt a3, a4, ble_else.16231; nop; nop; 	sw f0, 2(a2); 
	addi a6, zero, 1; 	lui a4, 4096; nop; nop; 
nop; 	addi a4, a4, 1; nop; nop; 
nop; 	add a22, a4, a3; nop; nop; 
nop; nop; nop; 	lw a4, 0(a22); 
nop; nop; nop; 	lw a5, 1(a4); 
	bne a5, a6, be_else.16233; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -10(sp); 	sw a3, -9(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16234; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16233:
nop; 	addi a6, zero, 2; nop; nop; 
	bne a5, a6, be_else.16235; nop; nop; nop; 
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -10(sp); 	sw a3, -9(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16236; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16235:
	add a0, a2, zero; 	add a1, a4, zero; 	sw a0, -10(sp); 	sw a3, -9(sp); 
	call setup_second_table.2731; 	addi sp, sp, -13; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 13; nop; nop; 
nop; nop; 	lw a2, -10(sp); 	lw a1, -9(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16236:
be_cont.16234:
	addi sp, sp, -13; 	addi a1, a1, -1; 	lw cl, -3(sp); 	lw a0, -8(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16232; 	addi sp, sp, 13; nop; nop; 
ble_else.16231:
ble_cont.16232:
	addi hp, hp, 6; 	add a0, hp, zero; 	lw a1, -8(sp); 	lw f0, -2(sp); 
nop; nop; 	sw f0, 2(a0); 	lw a2, 0(sp); 
nop; nop; 	lw a1, -1(sp); 	sw a1, 1(a0); 
nop; 	lui a1, 4096; nop; 	sw a1, 0(a0); 
nop; 	addi a1, a1, 171; nop; nop; 
	lui a1, 4096; 	add a22, a1, a2; nop; nop; 
	addi a0, a2, 1; 	addi a1, a1, 351; nop; 	sw a0, 0(a22); 
	ret; nop; nop; 	sw a0, 0(a1); 
nop; nop; nop; nop; 
rt.2974:
	lui a19, 4096; 	lui a18, 4096; 	lw a3, 40(cl); 	lw a2, 41(cl); 
	itof f1, a0; 	lui.float f0, 128.000000; 	lw a5, 38(cl); 	lw a4, 39(cl); 
	addi a19, a19, 141; 	addi a18, a18, 141; 	lw a7, 28(cl); 	lw a6, 35(cl); 
nop; 	addi.float f0, f0, 128.000000; 	lw a9, 24(cl); 	lw a8, 25(cl); 
nop; 	fdiv f0, f0, f1; 	lw a11, 20(cl); 	lw a10, 21(cl); 
nop; nop; 	lw a13, 17(cl); 	lw a12, 19(cl); 
nop; nop; 	lw a15, 14(cl); 	lw a14, 16(cl); 
nop; nop; 	lw a17, 12(cl); 	lw a16, 13(cl); 
nop; nop; 	sw a3, -1(sp); 	sw a2, 0(sp); 
nop; nop; 	sw a5, -3(sp); 	sw a4, -2(sp); 
nop; 	addi a18, zero, 1; 	sw a6, -4(sp); 	sw a0, 0(a18); 
	srli a18, a0, 1; 	add a22, a19, a18; 	sw a8, -6(sp); 	sw a7, -5(sp); 
	lui a0, 4096; 	lui a19, 4096; 	sw a10, -8(sp); 	sw a9, -7(sp); 
	addi a0, a0, 145; 	addi a19, a19, 143; 	sw a12, -10(sp); 	sw a11, -9(sp); 
nop; nop; 	sw a14, -12(sp); 	sw a13, -11(sp); 
nop; nop; 	sw a16, -14(sp); 	sw a15, -13(sp); 
nop; 	srli a1, a1, 1; 	sw a1, 0(a22); 	sw a17, -15(sp); 
	lui a19, 4096; 	addi a18, zero, 1; 	sw f0, 0(a0); 	sw a18, 0(a19); 
	lui.float f0, 0.000000; 	lui a0, 4096; nop; nop; 
	addi a0, a0, 141; 	addi a19, a19, 143; nop; nop; 
	add a22, a19, a18; 	addi.float f0, f0, 0.000000; nop; 	lw a0, 0(a0); 
	addi sp, sp, -19; 	addi a1, zero, 3; 	sw a0, -16(sp); 	sw a1, 0(a22); 
	call create_float_array; 	add a0, a1, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 19; nop; nop; 
nop; 	addi sp, sp, -19; nop; 	sw a0, -17(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 19; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -19(sp); 	sw a0, -18(sp); 
	add a1, a2, zero; 	addi sp, sp, -21; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 21; nop; nop; 
nop; 	addi sp, sp, -23; 	sw a0, -20(sp); 	lw a1, -19(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 23; nop; nop; 
nop; 	addi sp, sp, -23; nop; 	sw a0, -21(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 23; nop; nop; 
nop; 	addi sp, sp, -25; nop; 	sw a0, -22(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 25; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -23(sp); 
	add a1, a2, zero; 	addi sp, sp, -25; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 25; nop; nop; 
nop; 	addi sp, sp, -27; nop; 	sw a0, -24(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 27; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a0, -24(sp); 	sw a0, 7(a1); 
nop; nop; 	lw a0, -23(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -22(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -21(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -20(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -18(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -17(sp); 	sw a0, 1(a1); 
nop; 	addi sp, sp, -27; 	lw a0, -16(sp); 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 27; nop; nop; 
	addi a1, a1, 141; 	addi a2, zero, 0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a1); 
nop; 	addi a1, a1, -2; nop; nop; 
	blt a1, a2, ble_else.16238; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; 	sw a0, -26(sp); 	sw a1, -25(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -29; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 29; nop; nop; 
nop; 	addi sp, sp, -29; nop; 	sw a0, -27(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 29; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -29(sp); 	sw a0, -28(sp); 
	add a1, a2, zero; 	addi sp, sp, -31; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 31; nop; nop; 
nop; 	addi sp, sp, -33; 	sw a0, -30(sp); 	lw a1, -29(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 33; nop; nop; 
nop; 	addi sp, sp, -33; nop; 	sw a0, -31(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 33; nop; nop; 
nop; 	addi sp, sp, -35; nop; 	sw a0, -32(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 35; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -33(sp); 
	add a1, a2, zero; 	addi sp, sp, -35; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 35; nop; nop; 
nop; 	addi sp, sp, -37; nop; 	sw a0, -34(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 37; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -26(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -34(sp); 
nop; nop; 	lw a0, -33(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -32(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -31(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -30(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -28(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -27(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -25(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16240; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -35(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -37; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 37; nop; nop; 
nop; 	addi sp, sp, -39; nop; 	sw a0, -36(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 39; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -38(sp); 	sw a0, -37(sp); 
	add a1, a2, zero; 	addi sp, sp, -41; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 41; nop; nop; 
nop; 	addi sp, sp, -41; 	sw a0, -39(sp); 	lw a1, -38(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 41; nop; nop; 
nop; 	addi sp, sp, -43; nop; 	sw a0, -40(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 43; nop; nop; 
nop; 	addi sp, sp, -43; nop; 	sw a0, -41(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 43; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -42(sp); 
	add a1, a2, zero; 	addi sp, sp, -45; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 45; nop; nop; 
nop; 	addi sp, sp, -45; nop; 	sw a0, -43(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 45; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -26(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -43(sp); 
nop; nop; 	lw a0, -42(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -41(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -40(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -39(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -37(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -36(sp); 	sw a0, 1(a1); 
	addi sp, sp, -45; 	add a0, a1, zero; 	lw a1, -35(sp); 	sw a0, 0(a1); 
	addi a1, a1, -1; 	add a22, a1, a2; nop; nop; 
nop; 	add a0, a2, zero; nop; 	sw a0, 0(a22); 
	call init_line_elements.2918; nop; nop; nop; 
	jump ble_cont.16241; 	addi sp, sp, 45; nop; nop; 
ble_else.16240:
nop; 	add a0, a2, zero; nop; nop; 
ble_cont.16241:
	jump ble_cont.16239; nop; nop; nop; 
ble_else.16238:
ble_cont.16239:
	addi a2, zero, 3; 	lui a1, 4096; nop; 	sw a0, -44(sp); 
	addi a1, a1, 141; 	lui.float f0, 0.000000; nop; nop; 
	addi.float f0, f0, 0.000000; 	add a0, a2, zero; nop; 	lw a1, 0(a1); 
nop; 	addi sp, sp, -47; nop; 	sw a1, -45(sp); 
	call create_float_array; nop; nop; nop; 
nop; 	addi sp, sp, 47; nop; nop; 
nop; 	addi sp, sp, -49; nop; 	sw a0, -46(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 49; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -48(sp); 	sw a0, -47(sp); 
	add a1, a2, zero; 	addi sp, sp, -51; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 51; nop; nop; 
nop; 	addi sp, sp, -51; 	sw a0, -49(sp); 	lw a1, -48(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 51; nop; nop; 
nop; 	addi sp, sp, -53; nop; 	sw a0, -50(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 53; nop; nop; 
nop; 	addi sp, sp, -53; nop; 	sw a0, -51(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 53; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -52(sp); 
	add a1, a2, zero; 	addi sp, sp, -55; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 55; nop; nop; 
nop; 	addi sp, sp, -55; nop; 	sw a0, -53(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 55; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a0, -53(sp); 	sw a0, 7(a1); 
nop; nop; 	lw a0, -52(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -51(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -50(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -49(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -47(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -46(sp); 	sw a0, 1(a1); 
nop; 	addi sp, sp, -55; 	lw a0, -45(sp); 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 55; nop; nop; 
	addi a1, a1, 141; 	addi a2, zero, 0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a1); 
nop; 	addi a1, a1, -2; nop; nop; 
	blt a1, a2, ble_else.16242; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; 	sw a0, -55(sp); 	sw a1, -54(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -57; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 57; nop; nop; 
nop; 	addi sp, sp, -59; nop; 	sw a0, -56(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 59; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -58(sp); 	sw a0, -57(sp); 
	add a1, a2, zero; 	addi sp, sp, -61; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 61; nop; nop; 
nop; 	addi sp, sp, -61; 	sw a0, -59(sp); 	lw a1, -58(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 61; nop; nop; 
nop; 	addi sp, sp, -63; nop; 	sw a0, -60(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 63; nop; nop; 
nop; 	addi sp, sp, -63; nop; 	sw a0, -61(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 63; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -62(sp); 
	add a1, a2, zero; 	addi sp, sp, -65; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 65; nop; nop; 
nop; 	addi sp, sp, -65; nop; 	sw a0, -63(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 65; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -55(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -63(sp); 
nop; nop; 	lw a0, -62(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -61(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -60(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -59(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -57(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -56(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -54(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16244; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -64(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -67; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 67; nop; nop; 
nop; 	addi sp, sp, -67; nop; 	sw a0, -65(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 67; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -67(sp); 	sw a0, -66(sp); 
	add a1, a2, zero; 	addi sp, sp, -69; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 69; nop; nop; 
nop; 	addi sp, sp, -71; 	sw a0, -68(sp); 	lw a1, -67(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 71; nop; nop; 
nop; 	addi sp, sp, -71; nop; 	sw a0, -69(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 71; nop; nop; 
nop; 	addi sp, sp, -73; nop; 	sw a0, -70(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 73; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -71(sp); 
	add a1, a2, zero; 	addi sp, sp, -73; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 73; nop; nop; 
nop; 	addi sp, sp, -75; nop; 	sw a0, -72(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 75; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -55(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -72(sp); 
nop; nop; 	lw a0, -71(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -70(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -69(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -68(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -66(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -65(sp); 	sw a0, 1(a1); 
	addi sp, sp, -75; 	add a0, a1, zero; 	lw a1, -64(sp); 	sw a0, 0(a1); 
	addi a1, a1, -1; 	add a22, a1, a2; nop; nop; 
nop; 	add a0, a2, zero; nop; 	sw a0, 0(a22); 
	call init_line_elements.2918; nop; nop; nop; 
	jump ble_cont.16245; 	addi sp, sp, 75; nop; nop; 
ble_else.16244:
nop; 	add a0, a2, zero; nop; nop; 
ble_cont.16245:
	jump ble_cont.16243; nop; nop; nop; 
ble_else.16242:
ble_cont.16243:
	addi a2, zero, 3; 	lui a1, 4096; nop; 	sw a0, -73(sp); 
	addi a1, a1, 141; 	lui.float f0, 0.000000; nop; nop; 
	addi.float f0, f0, 0.000000; 	add a0, a2, zero; nop; 	lw a1, 0(a1); 
nop; 	addi sp, sp, -77; nop; 	sw a1, -74(sp); 
	call create_float_array; nop; nop; nop; 
nop; 	addi sp, sp, 77; nop; nop; 
nop; 	addi sp, sp, -77; nop; 	sw a0, -75(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 77; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -77(sp); 	sw a0, -76(sp); 
	add a1, a2, zero; 	addi sp, sp, -79; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 79; nop; nop; 
nop; 	addi sp, sp, -81; 	sw a0, -78(sp); 	lw a1, -77(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 81; nop; nop; 
nop; 	addi sp, sp, -81; nop; 	sw a0, -79(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 81; nop; nop; 
nop; 	addi sp, sp, -83; nop; 	sw a0, -80(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 83; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -81(sp); 
	add a1, a2, zero; 	addi sp, sp, -83; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 83; nop; nop; 
nop; 	addi sp, sp, -85; nop; 	sw a0, -82(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 85; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a0, -82(sp); 	sw a0, 7(a1); 
nop; nop; 	lw a0, -81(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -80(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -79(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -78(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -76(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -75(sp); 	sw a0, 1(a1); 
nop; 	addi sp, sp, -85; 	lw a0, -74(sp); 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 85; nop; nop; 
	addi a1, a1, 141; 	addi a2, zero, 0; nop; nop; 
nop; nop; nop; 	lw a1, 0(a1); 
nop; 	addi a1, a1, -2; nop; nop; 
	blt a1, a2, ble_else.16246; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; 	sw a0, -84(sp); 	sw a1, -83(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -87; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 87; nop; nop; 
nop; 	addi sp, sp, -87; nop; 	sw a0, -85(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 87; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -87(sp); 	sw a0, -86(sp); 
	add a1, a2, zero; 	addi sp, sp, -89; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 89; nop; nop; 
nop; 	addi sp, sp, -91; 	sw a0, -88(sp); 	lw a1, -87(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 91; nop; nop; 
nop; 	addi sp, sp, -91; nop; 	sw a0, -89(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 91; nop; nop; 
nop; 	addi sp, sp, -93; nop; 	sw a0, -90(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 93; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -91(sp); 
	add a1, a2, zero; 	addi sp, sp, -93; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 93; nop; nop; 
nop; 	addi sp, sp, -95; nop; 	sw a0, -92(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 95; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -84(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -92(sp); 
nop; nop; 	lw a0, -91(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -90(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -89(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -88(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -86(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -85(sp); 	sw a0, 1(a1); 
nop; 	add a0, a1, zero; 	lw a1, -83(sp); 	sw a0, 0(a1); 
nop; 	add a22, a1, a2; nop; nop; 
	addi a1, zero, 0; 	addi a0, a1, -1; nop; 	sw a0, 0(a22); 
	blt a0, a1, ble_else.16248; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi a3, zero, 3; nop; 	sw a0, -93(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -95; nop; nop; 
	call create_float_array; 	add a0, a3, zero; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 95; nop; nop; 
nop; 	addi sp, sp, -97; nop; 	sw a0, -94(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 5; 	addi sp, sp, 97; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; 	sw a1, -96(sp); 	sw a0, -95(sp); 
	add a1, a2, zero; 	addi sp, sp, -99; nop; nop; 
	call create_array; nop; nop; nop; 
	addi a2, zero, 0; 	addi sp, sp, 99; nop; nop; 
nop; 	addi sp, sp, -99; 	sw a0, -97(sp); 	lw a1, -96(sp); 
	add a1, a2, zero; 	add a0, a1, zero; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 99; nop; nop; 
nop; 	addi sp, sp, -101; nop; 	sw a0, -98(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
nop; 	addi sp, sp, 101; nop; nop; 
nop; 	addi sp, sp, -101; nop; 	sw a0, -99(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 101; nop; nop; 
	add a0, a1, zero; 	addi a2, zero, 0; nop; 	sw a0, -100(sp); 
	add a1, a2, zero; 	addi sp, sp, -103; nop; nop; 
	call create_array; nop; nop; nop; 
nop; 	addi sp, sp, 103; nop; nop; 
nop; 	addi sp, sp, -103; nop; 	sw a0, -101(sp); 
	call create_float5x3array.2914; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 103; nop; nop; 
nop; 	addi hp, hp, 8; 	lw a2, -84(sp); 	sw a0, 7(a1); 
nop; nop; nop; 	lw a0, -101(sp); 
nop; nop; 	lw a0, -100(sp); 	sw a0, 6(a1); 
nop; nop; 	lw a0, -99(sp); 	sw a0, 5(a1); 
nop; nop; 	lw a0, -98(sp); 	sw a0, 4(a1); 
nop; nop; 	lw a0, -97(sp); 	sw a0, 3(a1); 
nop; nop; 	lw a0, -95(sp); 	sw a0, 2(a1); 
nop; nop; 	lw a0, -94(sp); 	sw a0, 1(a1); 
	addi sp, sp, -103; 	add a0, a1, zero; 	lw a1, -93(sp); 	sw a0, 0(a1); 
	addi a1, a1, -1; 	add a22, a1, a2; nop; nop; 
nop; 	add a0, a2, zero; nop; 	sw a0, 0(a22); 
	call init_line_elements.2918; nop; nop; nop; 
	jump ble_cont.16249; 	addi sp, sp, 103; nop; nop; 
ble_else.16248:
nop; 	add a0, a2, zero; nop; nop; 
ble_cont.16249:
	jump ble_cont.16247; nop; nop; nop; 
ble_else.16246:
ble_cont.16247:
nop; 	addi sp, sp, -105; 	sw a0, -102(sp); 	lw cl, -15(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 105; nop; nop; 
nop; 	addi sp, sp, -105; nop; 	lw cl, -14(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 0; 	addi sp, sp, 105; nop; nop; 
nop; 	addi sp, sp, -105; nop; 	lw cl, -13(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a1, zero, 0; 	addi sp, sp, 105; nop; nop; 
	bne a0, a1, be_else.16250; nop; nop; nop; 
nop; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 0; nop; nop; 
	jump be_cont.16251; nop; nop; 	sw a1, 0(a0); 
nop; nop; nop; nop; 
be_else.16250:
	addi sp, sp, -105; 	addi a0, zero, 1; nop; 	lw cl, -12(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
nop; 	addi sp, sp, 105; nop; nop; 
be_cont.16251:
	addi sp, sp, -105; 	addi a0, zero, 0; nop; 	lw cl, -11(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 0; 	addi sp, sp, 105; nop; nop; 
	call read_or_network.2635; 	addi sp, sp, -105; nop; nop; 
nop; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 105; nop; nop; 
	addi sp, sp, -105; 	addi a1, a1, 121; nop; 	lw cl, -10(sp); 
nop; nop; 	lw swp, 0(cl); 	sw a0, 0(a1); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 105; nop; nop; 
nop; 	addi sp, sp, -105; nop; 	lw cl, -9(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 9; 	addi sp, sp, 105; nop; nop; 
	addi sp, sp, -105; 	addi a1, zero, 0; nop; 	lw cl, -8(sp); 
nop; 	add a2, a1, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 4; 	addi sp, sp, 105; nop; nop; 
	lui a3, 4096; 	lui a1, 4096; nop; 	lw cl, -7(sp); 
	addi a3, a3, 0; 	addi a1, a1, 164; nop; 	lw swp, 0(cl); 
	addi a1, zero, 119; 	add a22, a1, a0; nop; 	lw a3, 0(a3); 
nop; 	addi a3, a3, -1; 	sw a1, -103(sp); 	lw a0, 0(a22); 
	addi sp, sp, -107; 	add a1, a3, zero; 	sw a0, -104(sp); 	lw a2, 119(a0); 
	callr swp; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 118; 	addi sp, sp, 107; nop; nop; 
nop; 	addi sp, sp, -107; 	lw cl, -6(sp); 	lw a0, -104(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 3; 	addi sp, sp, 107; nop; nop; 
nop; 	lui a1, 4096; nop; 	lw cl, -6(sp); 
nop; 	addi a1, a1, 164; nop; 	lw swp, 0(cl); 
	addi sp, sp, -107; 	add a22, a1, a0; nop; 	lw a1, -103(sp); 
	callr swp; nop; nop; 	lw a0, 0(a22); 
nop; nop; nop; nop; 
	addi a0, zero, 2; 	addi sp, sp, 107; nop; nop; 
nop; 	addi sp, sp, -107; nop; 	lw cl, -5(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	lui a0, 4096; 	addi sp, sp, 107; nop; nop; 
	lui a2, 4096; 	lui a1, 4096; nop; nop; 
	addi a1, a1, 67; 	addi a0, a0, 169; nop; nop; 
	addi a1, zero, 1; 	addi a2, a2, 67; 	lw f0, 0(a1); 	lw a0, 0(a0); 
	addi a1, zero, 2; 	add a22, a2, a1; nop; 	sw f0, 0(a0); 
nop; 	lui a2, 4096; nop; 	lw f0, 0(a22); 
nop; 	addi a2, a2, 67; nop; 	sw f0, 1(a0); 
	addi a1, zero, 0; 	add a22, a2, a1; nop; nop; 
nop; nop; nop; 	lw f0, 0(a22); 
nop; 	lui a0, 4096; nop; 	sw f0, 2(a0); 
nop; 	addi a0, a0, 0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a0); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16252; nop; nop; nop; 
	lui a3, 4096; 	lui a2, 4096; nop; nop; 
	addi a6, zero, 1; 	lui a4, 4096; nop; nop; 
	addi a3, a3, 169; 	addi a2, a2, 1; nop; nop; 
	add a22, a2, a0; 	addi a4, a4, 169; nop; 	lw a3, 1(a3); 
nop; nop; 	lw a4, 0(a4); 	lw a2, 0(a22); 
nop; nop; nop; 	lw a5, 1(a2); 
	bne a5, a6, be_else.16254; nop; nop; nop; 
	add a0, a4, zero; 	add a1, a2, zero; 	sw a3, -106(sp); 	sw a0, -105(sp); 
	call setup_rect_table.2725; 	addi sp, sp, -109; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 109; nop; nop; 
nop; nop; 	lw a2, -106(sp); 	lw a1, -105(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16255; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16254:
nop; 	addi a6, zero, 2; nop; nop; 
	bne a5, a6, be_else.16256; nop; nop; nop; 
	add a0, a4, zero; 	add a1, a2, zero; 	sw a3, -106(sp); 	sw a0, -105(sp); 
	call setup_surface_table.2728; 	addi sp, sp, -109; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 109; nop; nop; 
nop; nop; 	lw a2, -106(sp); 	lw a1, -105(sp); 
nop; 	add a22, a1, a2; nop; nop; 
	jump be_cont.16257; nop; nop; 	sw a0, 0(a22); 
nop; nop; nop; nop; 
be_else.16256:
	add a0, a4, zero; 	add a1, a2, zero; 	sw a3, -106(sp); 	sw a0, -105(sp); 
	call setup_second_table.2731; 	addi sp, sp, -109; nop; nop; 
nop; nop; nop; nop; 
nop; 	addi sp, sp, 109; nop; nop; 
nop; nop; 	lw a2, -106(sp); 	lw a1, -105(sp); 
nop; 	add a22, a1, a2; nop; nop; 
nop; nop; nop; 	sw a0, 0(a22); 
be_cont.16257:
be_cont.16255:
	addi sp, sp, -109; 	addi a1, a1, -1; 	lw cl, -7(sp); 	lw a0, -4(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump ble_cont.16253; 	addi sp, sp, 109; nop; nop; 
ble_else.16252:
ble_cont.16253:
	addi a1, zero, 0; 	lui a0, 4096; nop; nop; 
nop; 	addi a0, a0, 0; nop; nop; 
nop; nop; nop; 	lw a0, 0(a0); 
nop; 	addi a0, a0, -1; nop; nop; 
	blt a0, a1, ble_else.16258; nop; nop; nop; 
	addi a4, zero, 2; 	lui a2, 4096; nop; nop; 
nop; 	addi a2, a2, 1; nop; nop; 
nop; 	add a22, a2, a0; nop; nop; 
nop; nop; nop; 	lw a2, 0(a22); 
nop; nop; nop; 	lw a3, 2(a2); 
	bne a3, a4, be_else.16260; nop; nop; nop; 
nop; 	lui.float f1, 1.000000; nop; 	lw a3, 7(a2); 
nop; 	addi.float f1, f1, 1.000000; nop; 	lw f0, 0(a3); 
nop; 	flt a3, f0, f1; nop; nop; 
	bne a3, a1, be_else.16262; nop; nop; nop; 
	jump be_cont.16263; nop; nop; nop; 
be_else.16262:
nop; 	addi a5, zero, 1; nop; 	lw a3, 1(a2); 
	bne a3, a5, be_else.16264; nop; nop; nop; 
	addi sp, sp, -109; 	add a1, a2, zero; nop; 	lw cl, -3(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.16265; 	addi sp, sp, 109; nop; nop; 
be_else.16264:
	bne a3, a4, be_else.16266; nop; nop; nop; 
	addi sp, sp, -109; 	add a1, a2, zero; nop; 	lw cl, -2(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	jump be_cont.16267; 	addi sp, sp, 109; nop; nop; 
be_else.16266:
be_cont.16267:
be_cont.16265:
be_cont.16263:
	jump be_cont.16261; nop; nop; nop; 
be_else.16260:
be_cont.16261:
	jump ble_cont.16259; nop; nop; nop; 
ble_else.16258:
ble_cont.16259:
	addi sp, sp, -109; 	addi a1, zero, 0; 	lw cl, -1(sp); 	lw a0, -73(sp); 
nop; 	add a2, a1, zero; nop; 	lw swp, 0(cl); 
	callr swp; nop; nop; nop; 
	addi a4, zero, 2; 	addi sp, sp, 109; nop; nop; 
nop; 	addi a0, zero, 0; 	lw a2, -73(sp); 	lw a1, -44(sp); 
nop; nop; 	lw cl, 0(sp); 	lw a3, -102(sp); 
nop; nop; nop; 	lw swp, 0(cl); 
	jumpr swp; nop; nop; nop; 
min_caml_start:
	addi a1, zero, 1; 	addi sp, sp, -28; nop; nop; 
	addi a2, zero, 0; 	lui a0, 4096; nop; nop; 
	addi a0, a0, 0; 	addi sp, sp, -1; nop; nop; 
	call create_global_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 1; nop; nop; 
	addi.float f0, f0, 0.000000; 	addi a1, zero, 0; nop; 	sw a0, 0(sp); 
	add a0, a1, zero; 	addi sp, sp, -3; nop; nop; 
	call create_float_array; nop; nop; nop; 
	addi a1, zero, 60; 	addi sp, sp, 3; nop; nop; 
	addi a3, zero, 0; 	add a2, hp, zero; nop; nop; 
	addi hp, hp, 12; 	addi sp, sp, -3; 	sw a0, 9(a2); 	sw a0, 10(a2); 
nop; nop; 	sw a0, 7(a2); 	sw a0, 8(a2); 
nop; nop; 	sw a0, 5(a2); 	sw a3, 6(a2); 
nop; 	lui a0, 4096; 	sw a3, 3(a2); 	sw a0, 4(a2); 
nop; 	addi a0, a0, 1; 	sw a3, 1(a2); 	sw a3, 2(a2); 
	call create_global_array; nop; nop; 	sw a3, 0(a2); 
nop; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 3; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -1(sp); 
	addi a2, a2, 61; 	addi sp, sp, -3; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 3; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -2(sp); 
	addi a2, a2, 64; 	addi sp, sp, -5; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 5; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -3(sp); 
	addi a2, a2, 67; 	addi sp, sp, -5; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 5; nop; nop; 
	lui a2, 4096; 	lui.float f0, 255.000000; nop; 	sw a0, -4(sp); 
	addi.float f0, f0, 255.000000; 	addi sp, sp, -7; nop; nop; 
nop; 	addi a2, a2, 70; nop; nop; 
	call create_global_float_array; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 50; 	addi sp, sp, 7; nop; nop; 
	lui a3, 1048575; 	addi a2, zero, 1; 	sw a1, -6(sp); 	sw a0, -5(sp); 
	addi a3, a3, 4095; 	addi sp, sp, -9; nop; nop; 
	add a1, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_array; nop; nop; nop; 
	add a2, a0, zero; 	addi sp, sp, 9; nop; nop; 
	addi sp, sp, -9; 	lui a0, 4096; nop; 	lw a1, -6(sp); 
	call create_global_array; 	addi a0, a0, 71; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 9; nop; nop; 
	lui a3, 4096; 	addi a2, zero, 1; 	sw a1, -8(sp); 	sw a0, -7(sp); 
	addi a3, a3, 71; 	addi sp, sp, -11; nop; nop; 
nop; 	add a0, a2, zero; nop; 	lw a3, 0(a3); 
	call create_array; 	add a1, a3, zero; nop; nop; 
nop; nop; nop; nop; 
	add a2, a0, zero; 	addi sp, sp, 11; nop; nop; 
	addi sp, sp, -11; 	lui a0, 4096; nop; 	lw a1, -8(sp); 
	call create_global_array; 	addi a0, a0, 121; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 11; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -9(sp); 
	addi a2, a2, 122; 	addi sp, sp, -11; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 11; nop; nop; 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	sw a0, -10(sp); 
	addi a2, a2, 123; 	addi sp, sp, -13; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_global_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 13; nop; nop; 
	lui a2, 4096; 	lui.float f0, 1000000000.000000; nop; 	sw a0, -11(sp); 
	addi.float f0, f0, 1000000000.000000; 	addi sp, sp, -13; nop; nop; 
nop; 	addi a2, a2, 124; nop; nop; 
	call create_global_float_array; 	add a0, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 13; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -12(sp); 
	addi a2, a2, 125; 	addi sp, sp, -15; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 15; nop; nop; 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	sw a0, -13(sp); 
	addi a2, a2, 128; 	addi sp, sp, -15; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_global_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 15; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -14(sp); 
	addi a2, a2, 129; 	addi sp, sp, -17; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 17; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -15(sp); 
	addi a2, a2, 132; 	addi sp, sp, -17; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 17; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -16(sp); 
	addi a2, a2, 135; 	addi sp, sp, -19; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 19; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -17(sp); 
	addi a2, a2, 138; 	addi sp, sp, -19; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 2; 	addi sp, sp, 19; nop; nop; 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	sw a0, -18(sp); 
	addi a2, a2, 141; 	addi sp, sp, -21; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_global_array; nop; nop; nop; 
	addi a1, zero, 2; 	addi sp, sp, 21; nop; nop; 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	sw a0, -19(sp); 
	addi a2, a2, 143; 	addi sp, sp, -21; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_global_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 21; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -20(sp); 
	addi a2, a2, 145; 	addi sp, sp, -23; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 23; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -21(sp); 
	addi a2, a2, 146; 	addi sp, sp, -23; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 23; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -22(sp); 
	addi a2, a2, 149; 	addi sp, sp, -25; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 25; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -23(sp); 
	addi a2, a2, 152; 	addi sp, sp, -25; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 25; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -24(sp); 
	addi a2, a2, 155; 	addi sp, sp, -27; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 27; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -25(sp); 
	addi a2, a2, 158; 	addi sp, sp, -27; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 27; nop; nop; 
	lui.float f0, 0.000000; 	lui a2, 4096; nop; 	sw a0, -26(sp); 
	addi a2, a2, 161; 	addi sp, sp, -29; nop; nop; 
	add a0, a2, zero; 	addi.float f0, f0, 0.000000; nop; nop; 
	call create_global_float_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 29; nop; nop; 
	addi.float f0, f0, 0.000000; 	addi a1, zero, 0; nop; 	sw a0, -27(sp); 
	add a0, a1, zero; 	addi sp, sp, -29; nop; nop; 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 29; nop; nop; 
	addi sp, sp, -31; 	addi a0, zero, 0; nop; 	sw a1, -28(sp); 
	call create_array; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 31; nop; nop; 
	addi sp, sp, -31; 	addi hp, hp, 2; 	lw a0, -28(sp); 	sw a0, 1(a1); 
nop; 	addi a0, zero, 0; nop; 	sw a0, 0(a1); 
	call create_array; nop; nop; nop; 
	add a2, a0, zero; 	addi sp, sp, 31; nop; nop; 
	lui a0, 4096; 	addi a1, zero, 5; nop; nop; 
	addi a0, a0, 164; 	addi sp, sp, -31; nop; nop; 
	call create_global_array; nop; nop; nop; 
	lui.float f0, 0.000000; 	addi sp, sp, 31; nop; nop; 
	addi.float f0, f0, 0.000000; 	addi a1, zero, 0; nop; 	sw a0, -29(sp); 
	add a0, a1, zero; 	addi sp, sp, -31; nop; nop; 
	call create_float_array; nop; nop; nop; 
	addi a1, zero, 3; 	addi sp, sp, 31; nop; nop; 
	add a0, a1, zero; 	lui.float f0, 0.000000; nop; 	sw a0, -30(sp); 
	addi.float f0, f0, 0.000000; 	addi sp, sp, -33; nop; nop; 
	call create_float_array; nop; nop; nop; 
	addi a1, zero, 60; 	addi sp, sp, 33; nop; nop; 
	addi sp, sp, -33; 	add a0, a1, zero; 	sw a0, -31(sp); 	lw a2, -30(sp); 
	call create_array; 	add a1, a2, zero; nop; nop; 
nop; nop; nop; nop; 
	lui a1, 4096; 	addi sp, sp, 33; nop; nop; 
	addi a1, a1, 169; 	lui.float f0, 0.000000; nop; nop; 
nop; 	addi.float f0, f0, 0.000000; 	lw a0, -31(sp); 	sw a0, 1(a1); 
	addi a1, zero, 0; 	lui a0, 4096; nop; 	sw a0, 0(a1); 
nop; 	addi a0, a0, 169; nop; nop; 
	addi sp, sp, -35; 	add a0, a1, zero; nop; 	sw a0, -32(sp); 
	call create_float_array; nop; nop; nop; 
	add a1, a0, zero; 	addi sp, sp, 35; nop; nop; 
	addi sp, sp, -35; 	addi a0, zero, 0; nop; 	sw a1, -33(sp); 
	call create_array; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 35; nop; nop; 
	lui a3, 4096; 	lui.float f0, 0.000000; 	lw a0, -33(sp); 	sw a0, 1(a1); 
	addi sp, sp, -35; 	addi hp, hp, 2; nop; 	sw a0, 0(a1); 
	addi a3, a3, 171; 	addi.float f0, f0, 0.000000; nop; nop; 
	add a2, hp, zero; 	add a0, a1, zero; nop; nop; 
	addi hp, hp, 6; 	addi a1, zero, 180; 	sw a0, 1(a2); 	sw f0, 2(a2); 
nop; 	addi a0, zero, 0; nop; nop; 
nop; 	add a0, a3, zero; nop; 	sw a0, 0(a2); 
	call create_global_array; nop; nop; nop; 
	addi a1, zero, 1; 	addi sp, sp, 35; nop; nop; 
	addi a3, zero, 0; 	lui a2, 4096; nop; 	sw a0, -34(sp); 
	addi a2, a2, 351; 	addi sp, sp, -37; nop; nop; 
	add a2, a3, zero; 	add a0, a2, zero; nop; nop; 
	call create_global_array; nop; nop; nop; 
	add a1, hp, zero; 	addi sp, sp, 37; nop; nop; 
	lui.label a7, read_light.2622; 	lui.label a2, read_screen_settings.2620; 	lw a4, -2(sp); 	lw a3, -26(sp); 
	lui.label a12, read_object.2629; 	lui.label a10, read_nth_object.2627; 	lw a6, -24(sp); 	lw a5, -25(sp); 
	lui.label a16, solver_rect_surface.2641; 	lui.label a14, read_and_network.2637; 	sw a1, -35(sp); 	lw a8, -4(sp); 
	lui.label a19, solver.2681; 	lui.label a18, solver_second.2675; 	sw a4, 19(a1); 	sw a3, 20(a1); 
	lui.label cl, solver_fast.2704; 	lui.label a20, solver_second_fast.2698; 	sw a4, 16(a1); 	sw a3, 17(a1); 
	addi hp, hp, 22; 	lui.label swp, check_all_inside.2764; 	sw a4, 13(a1); 	sw a3, 14(a1); 
	addi.label a7, a7, read_light.2622; 	addi.label a2, a2, read_screen_settings.2620; 	sw a3, 5(a1); 	sw a3, 6(a1); 
	addi.label a12, a12, read_object.2629; 	addi.label a10, a10, read_nth_object.2627; 	sw a4, 3(a1); 	sw a3, 4(a1); 
	addi.label a16, a16, solver_rect_surface.2641; 	addi.label a14, a14, read_and_network.2637; 	sw a4, 1(a1); 	sw a4, 2(a1); 
	addi.label a19, a19, solver.2681; 	addi.label a18, a18, solver_second.2675; 	sw a5, 11(a1); 	sw a5, 12(a1); 
	addi.label cl, cl, solver_fast.2704; 	addi.label a20, a20, solver_second_fast.2698; 	sw a6, 9(a1); 	sw a5, 10(a1); 
	lui.label a3, trace_or_matrix.2787; 	addi.label swp, swp, check_all_inside.2764; 	sw a6, 7(a1); 	sw a6, 8(a1); 
	lui.label a5, solve_one_or_network.2783; 	add a4, hp, zero; 	lw a2, -3(sp); 	sw a2, 0(a1); 
	addi hp, hp, 6; 	addi.label a3, a3, trace_or_matrix.2787; 	sw a2, 18(a1); 	sw a2, 21(a1); 
	add a9, hp, zero; 	addi.label a5, a5, solve_one_or_network.2783; 	sw a7, 0(a4); 	sw a2, 15(a1); 
	lui.label a2, trace_reflections.2823; 	lui.label a1, shadow_check_and_group.2770; 	sw a8, 2(a4); 	sw a8, 3(a4); 
	addi.label a1, a1, shadow_check_and_group.2770; 	addi hp, hp, 2; 	sw a4, -36(sp); 	sw a8, 1(a4); 
	add a11, hp, zero; 	addi.label a2, a2, trace_reflections.2823; 	sw a10, 0(a9); 	lw a7, -5(sp); 
nop; 	addi hp, hp, 10; 	lw a10, -1(sp); 	sw a9, -37(sp); 
	addi hp, hp, 4; 	add a13, hp, zero; 	sw a12, 0(a11); 	sw a7, 4(a4); 
	addi hp, hp, 2; 	add a15, hp, zero; 	sw a9, 5(a11); 	sw a9, 7(a11); 
	addi hp, hp, 2; 	add a17, hp, zero; 	sw a9, 1(a11); 	sw a9, 3(a11); 
nop; nop; 	sw a10, 1(a9); 	sw a11, -38(sp); 
nop; nop; 	lw a12, 0(sp); 	lw a4, -32(sp); 
nop; nop; 	sw a13, -39(sp); 	sw a14, 0(a13); 
	addi hp, hp, 8; 	add a18, hp, zero; 	sw a18, 0(a17); 	sw a16, 0(a15); 
nop; nop; 	sw a12, 6(a11); 	sw a12, 8(a11); 
nop; 	lui.label a11, shadow_check_one_or_group.2773; 	sw a12, 2(a11); 	sw a12, 4(a11); 
nop; 	addi.label a11, a11, shadow_check_one_or_group.2773; 	lw a16, -10(sp); 	lw a14, -7(sp); 
nop; 	lui.label a19, solver_surface_fast.2692; 	sw a17, 6(a18); 	sw a19, 0(a18); 
nop; 	addi.label a19, a19, solver_surface_fast.2692; 	sw a15, 3(a18); 	sw a15, 4(a18); 
nop; nop; 	sw a10, 1(a18); 	sw a15, 2(a18); 
nop; 	lui.label a13, shadow_check_one_or_matrix.2776; 	sw a14, 1(a13); 	sw a14, 2(a13); 
	add a15, hp, zero; 	addi.label a13, a13, shadow_check_one_or_matrix.2776; 	sw a16, 1(a17); 	sw a16, 1(a15); 
	addi hp, hp, 4; 	lui.label a17, solver_rect_fast.2685; 	sw a16, 3(a15); 	sw a16, 5(a18); 
nop; 	addi.label a17, a17, solver_rect_fast.2685; 	sw a16, 1(a15); 	sw a16, 2(a15); 
	addi hp, hp, 2; 	add a17, hp, zero; nop; 	sw a17, 0(a15); 
	addi hp, hp, 4; 	add a19, hp, zero; 	sw a16, 1(a17); 	sw a19, 0(a17); 
	addi hp, hp, 6; 	add a20, hp, zero; 	sw a16, 2(a19); 	sw a20, 0(a19); 
nop; 	lui.label cl, solver_fast2.2722; 	sw cl, 0(a20); 	sw a16, 1(a19); 
	lui.label a19, solver_second_fast2.2715; 	addi.label cl, cl, solver_fast2.2722; 	sw a17, 3(a20); 	sw a19, 4(a20); 
	addi.label a19, a19, solver_second_fast2.2715; 	add a17, hp, zero; 	sw a10, 1(a20); 	sw a15, 2(a20); 
nop; 	addi hp, hp, 4; 	sw a16, 2(a17); 	sw a19, 0(a17); 
	addi hp, hp, 6; 	add a19, hp, zero; nop; 	sw a16, 1(a17); 
	lui.label a17, iter_setup_dirvec_constants.2734; 	lui.label cl, setup_startp_constants.2739; 	sw a17, 4(a19); 	sw cl, 0(a19); 
	addi.label cl, cl, setup_startp_constants.2739; 	addi.label a17, a17, iter_setup_dirvec_constants.2734; 	sw a15, 2(a19); 	sw a16, 3(a19); 
	addi hp, hp, 4; 	add a15, hp, zero; nop; 	sw a10, 1(a19); 
	addi hp, hp, 2; 	add a17, hp, zero; 	sw a10, 2(a15); 	sw a17, 0(a15); 
nop; nop; 	sw a15, -40(sp); 	sw a10, 1(a15); 
	addi hp, hp, 4; 	add cl, hp, zero; 	sw a10, 1(a17); 	sw cl, 0(a17); 
	addi hp, hp, 14; 	add swp, hp, zero; 	sw a10, 2(cl); 	sw swp, 0(cl); 
	addi hp, hp, 6; 	add a9, hp, zero; 	sw a1, 0(swp); 	sw a10, 1(cl); 
nop; nop; 	sw a10, 12(swp); 	sw cl, 13(swp); 
nop; nop; 	sw a8, 8(swp); 	sw a8, 10(swp); 
nop; nop; 	sw a10, 5(swp); 	sw a8, 6(swp); 
nop; nop; 	sw a4, 2(swp); 	sw a16, 4(swp); 
nop; nop; 	lw a1, -13(sp); 	sw a20, 1(swp); 
	addi hp, hp, 12; 	add a11, hp, zero; 	sw swp, 4(a9); 	sw a11, 0(a9); 
nop; nop; 	sw swp, 2(a9); 	sw a14, 3(a9); 
nop; nop; 	sw a1, 11(swp); 	sw a14, 1(a9); 
nop; nop; 	sw a1, 7(swp); 	sw a1, 9(swp); 
nop; 	lui.label a13, solve_each_element.2779; 	sw a13, 0(a11); 	sw a1, 3(swp); 
nop; 	addi.label a13, a13, solve_each_element.2779; 	sw swp, 9(a11); 	sw a9, 10(a11); 
	addi hp, hp, 18; 	add a9, hp, zero; 	sw a9, 7(a11); 	sw a14, 8(a11); 
	addi hp, hp, 10; 	add a15, hp, zero; 	sw a14, 5(a11); 	sw swp, 6(a11); 
nop; nop; 	sw a1, 3(a11); 	sw a16, 4(a11); 
nop; nop; 	sw a20, 1(a11); 	sw a4, 2(a11); 
nop; nop; 	sw a1, 14(a9); 	sw a13, 0(a9); 
nop; nop; 	sw a1, 12(a9); 	sw a1, 13(a9); 
nop; nop; 	sw a10, 9(a9); 	sw cl, 10(a9); 
nop; nop; 	sw a10, 3(a9); 	sw a16, 4(a9); 
nop; nop; 	lw swp, -12(sp); 	sw a18, 1(a9); 
	addi hp, hp, 20; 	add a5, hp, zero; 	sw a9, 8(a15); 	sw a5, 0(a15); 
nop; nop; 	sw a9, 6(a15); 	sw a14, 7(a15); 
nop; nop; 	sw a9, 4(a15); 	sw a14, 5(a15); 
nop; nop; 	sw a9, 2(a15); 	sw a14, 3(a15); 
nop; nop; 	lw a4, -22(sp); 	sw a14, 1(a15); 
nop; nop; 	lw a13, -11(sp); 	lw a20, -14(sp); 
nop; nop; 	sw swp, 5(a9); 	sw swp, 11(a9); 
	addi hp, hp, 16; 	add a3, hp, zero; 	sw a15, 18(a5); 	sw a3, 0(a5); 
nop; nop; 	sw a14, 16(a5); 	sw a9, 17(a5); 
nop; nop; 	sw a14, 14(a5); 	sw a9, 15(a5); 
nop; nop; 	sw a14, 12(a5); 	sw a9, 13(a5); 
nop; nop; 	sw a16, 10(a5); 	sw swp, 11(a5); 
	add a15, hp, zero; 	lui.label a18, solve_one_or_network_fast.2797; 	sw a15, 7(a5); 	sw a18, 8(a5); 
	addi.label a18, a18, solve_one_or_network_fast.2797; 	addi hp, hp, 10; 	sw a14, 5(a5); 	sw a9, 6(a5); 
nop; nop; 	sw a14, 3(a5); 	sw a9, 4(a5); 
nop; nop; 	sw a14, 1(a5); 	sw a9, 2(a5); 
nop; nop; 	sw a4, 8(a9); 	sw a5, -42(sp); 
nop; nop; 	sw a4, 6(a9); 	sw a4, 7(a9); 
nop; 	lui.label a5, trace_ray.2828; 	sw a4, 9(a5); 	sw a4, 2(a9); 
	lui.label a9, solve_each_element_fast.2793; 	addi.label a5, a5, trace_ray.2828; 	sw a20, 15(a9); 	sw a13, 16(a9); 
nop; 	addi.label a9, a9, solve_each_element_fast.2793; 	sw a20, 14(a3); 	sw a13, 15(a3); 
nop; nop; 	sw a1, 12(a3); 	sw a1, 13(a3); 
nop; nop; 	sw swp, 10(a3); 	sw a1, 11(a3); 
nop; 	lui.label cl, trace_or_matrix_fast.2801; 	sw a10, 8(a3); 	sw cl, 9(a3); 
nop; 	addi.label cl, cl, trace_or_matrix_fast.2801; 	sw a16, 3(a3); 	sw swp, 4(a3); 
nop; nop; 	sw a19, 1(a3); 	sw a10, 2(a3); 
nop; nop; 	sw a14, 7(a15); 	sw a3, 8(a15); 
nop; nop; 	sw a14, 5(a15); 	sw a3, 6(a15); 
nop; nop; 	sw a14, 3(a15); 	sw a3, 4(a15); 
nop; nop; 	sw a14, 1(a15); 	sw a3, 2(a15); 
	addi hp, hp, 18; 	add a18, hp, zero; 	sw a9, 0(a3); 	sw a18, 0(a15); 
nop; 	lui.label cl, add_light.2819; 	sw cl, 0(a18); 	lw a9, -23(sp); 
nop; 	addi.label cl, cl, add_light.2819; 	sw a3, 16(a18); 	sw a15, 17(a18); 
nop; nop; 	sw a3, 14(a18); 	sw a14, 15(a18); 
nop; nop; 	sw a3, 12(a18); 	sw a14, 13(a18); 
nop; nop; 	sw swp, 10(a18); 	sw a14, 11(a18); 
nop; 	lui.label a16, utexture.2816; 	sw a19, 8(a18); 	sw a16, 9(a18); 
nop; 	addi.label a16, a16, utexture.2816; 	sw a3, 6(a18); 	sw a15, 7(a18); 
nop; nop; 	sw a3, 4(a18); 	sw a14, 5(a18); 
nop; nop; 	sw a3, 2(a18); 	sw a14, 3(a18); 
nop; 	lui.label a14, get_nvector_second.2811; 	sw a18, -41(sp); 	sw a14, 1(a18); 
nop; 	addi.label a14, a14, get_nvector_second.2811; 	sw a9, 6(a3); 	sw a9, 7(a3); 
	addi hp, hp, 12; 	add a3, hp, zero; nop; 	sw a9, 5(a3); 
	addi hp, hp, 10; 	add a15, hp, zero; 	sw a1, 3(a3); 	sw a14, 0(a3); 
	addi hp, hp, 10; 	add a19, hp, zero; 	sw a1, 1(a3); 	sw a1, 2(a3); 
	addi hp, hp, 14; 	add a6, hp, zero; 	sw a16, 0(a15); 	lw a14, -15(sp); 
nop; nop; 	lw a16, -16(sp); 	sw cl, 0(a19); 
nop; nop; 	sw a14, 9(a3); 	sw a14, 10(a3); 
nop; nop; 	sw a14, 7(a3); 	sw a14, 8(a3); 
nop; nop; 	sw a14, 5(a3); 	sw a14, 6(a3); 
nop; nop; 	sw a2, 0(a6); 	sw a14, 4(a3); 
nop; nop; 	sw a14, 12(a6); 	sw a19, 13(a6); 
nop; nop; 	sw a14, 10(a6); 	sw a14, 11(a6); 
nop; nop; 	sw a13, 7(a6); 	sw a11, 9(a6); 
nop; nop; 	sw swp, 5(a6); 	sw a20, 6(a6); 
nop; nop; 	sw swp, 2(a6); 	sw a18, 4(a6); 
nop; nop; 	sw a16, 9(a15); 	lw cl, -18(sp); 
nop; nop; 	sw a16, 7(a15); 	sw a16, 8(a15); 
nop; nop; 	sw a16, 5(a15); 	sw a16, 6(a15); 
nop; nop; 	sw a16, 3(a15); 	sw a16, 4(a15); 
nop; nop; 	sw a16, 1(a15); 	sw a16, 2(a15); 
nop; nop; 	lw a2, -9(sp); 	sw a16, 2(a19); 
nop; nop; 	sw cl, 8(a19); 	lw a18, -34(sp); 
nop; nop; 	sw cl, 6(a19); 	sw cl, 7(a19); 
nop; nop; 	sw cl, 4(a19); 	sw cl, 5(a19); 
nop; nop; 	sw cl, 1(a19); 	sw cl, 3(a19); 
nop; nop; 	sw a2, 3(a6); 	sw a2, 8(a6); 
	addi hp, hp, 72; 	add a18, hp, zero; nop; 	sw a18, 1(a6); 
nop; nop; 	sw swp, 71(a18); 	sw a5, 0(a18); 
nop; 	lui.label a6, trace_diffuse_ray.2834; 	sw a0, 69(a18); 	sw a6, 70(a18); 
nop; 	addi.label a6, a6, trace_diffuse_ray.2834; 	sw a17, 67(a18); 	sw a1, 68(a18); 
nop; nop; 	sw a9, 65(a18); 	sw a12, 66(a18); 
nop; nop; 	sw a9, 63(a18); 	sw a1, 64(a18); 
nop; nop; 	sw a9, 61(a18); 	sw a1, 62(a18); 
nop; nop; 	sw a19, 59(a18); 	sw a1, 60(a18); 
nop; nop; 	sw a8, 57(a18); 	sw a8, 58(a18); 
nop; nop; 	sw a8, 55(a18); 	sw a8, 56(a18); 
nop; nop; 	sw a8, 53(a18); 	sw a14, 54(a18); 
nop; nop; 	sw a8, 51(a18); 	sw a14, 52(a18); 
nop; nop; 	sw a11, 49(a18); 	sw a14, 50(a18); 
nop; nop; 	sw a14, 47(a18); 	sw a2, 48(a18); 
nop; nop; 	sw a14, 45(a18); 	sw a14, 46(a18); 
nop; nop; 	sw a14, 43(a18); 	sw a14, 44(a18); 
nop; nop; 	sw a14, 41(a18); 	sw a14, 42(a18); 
nop; nop; 	sw a16, 39(a18); 	sw a16, 40(a18); 
nop; nop; 	sw a1, 37(a18); 	sw a16, 38(a18); 
nop; nop; 	sw a1, 35(a18); 	sw a1, 36(a18); 
nop; nop; 	sw a1, 33(a18); 	sw a13, 34(a18); 
nop; nop; 	sw a4, 31(a18); 	sw a15, 32(a18); 
nop; nop; 	sw a4, 29(a18); 	sw a1, 30(a18); 
nop; nop; 	sw a4, 27(a18); 	sw a1, 28(a18); 
nop; nop; 	sw a3, 25(a18); 	sw a1, 26(a18); 
nop; nop; 	sw a14, 23(a18); 	sw a14, 24(a18); 
nop; nop; 	sw a14, 21(a18); 	sw a14, 22(a18); 
nop; nop; 	sw a14, 19(a18); 	sw a14, 20(a18); 
nop; nop; 	sw a13, 17(a18); 	sw a14, 18(a18); 
nop; nop; 	sw a20, 15(a18); 	sw a10, 16(a18); 
nop; nop; 	sw cl, 13(a18); 	sw cl, 14(a18); 
nop; nop; 	sw cl, 11(a18); 	sw cl, 12(a18); 
nop; nop; 	sw cl, 9(a18); 	sw cl, 10(a18); 
nop; nop; 	sw a8, 7(a18); 	sw a7, 8(a18); 
nop; nop; 	sw a8, 5(a18); 	sw a8, 6(a18); 
nop; nop; 	sw a2, 2(a18); 	sw swp, 4(a18); 
nop; nop; 	lw a5, -42(sp); 	sw swp, 1(a18); 
	addi hp, hp, 28; 	add a5, hp, zero; nop; 	sw a5, 3(a18); 
nop; 	lui.label a16, pretrace_diffuse_rays.2888; 	sw a16, 27(a5); 	sw a6, 0(a5); 
nop; 	addi.label a16, a16, pretrace_diffuse_rays.2888; 	sw a14, 24(a5); 	sw a8, 25(a5); 
nop; nop; 	sw a14, 22(a5); 	sw a8, 23(a5); 
nop; nop; 	sw a14, 20(a5); 	sw a8, 21(a5); 
nop; 	lui.label a11, calc_diffuse_using_1point.2850; 	sw a2, 18(a5); 	sw a11, 19(a5); 
nop; 	addi.label a11, a11, calc_diffuse_using_1point.2850; 	sw a15, 16(a5); 	sw a1, 17(a5); 
nop; 	lui.label a3, iter_trace_diffuse_rays.2837; 	sw a14, 14(a5); 	sw a3, 15(a5); 
nop; 	addi.label a3, a3, iter_trace_diffuse_rays.2837; 	sw a14, 12(a5); 	sw a14, 13(a5); 
nop; nop; 	sw a14, 10(a5); 	sw a14, 11(a5); 
nop; 	lui.label a14, do_without_neighbors.2859; 	sw a14, 8(a5); 	sw a14, 9(a5); 
	lui.label a13, calc_diffuse_using_5points.2853; 	addi.label a14, a14, do_without_neighbors.2859; 	sw a10, 6(a5); 	sw a13, 7(a5); 
	lui.label a20, setup_surface_reflection.2969; 	addi.label a13, a13, calc_diffuse_using_5points.2853; 	sw swp, 4(a5); 	sw a20, 5(a5); 
nop; 	addi.label a20, a20, setup_surface_reflection.2969; 	sw swp, 1(a5); 	sw a2, 2(a5); 
nop; nop; 	lw a1, -41(sp); 	lw a6, -17(sp); 
	addi hp, hp, 4; 	add a1, hp, zero; 	sw a1, 3(a5); 	sw a6, 26(a5); 
	addi hp, hp, 36; 	add a3, hp, zero; 	sw a5, 2(a1); 	sw a3, 0(a1); 
	lui.label a5, trace_diffuse_ray_80percent.2846; 	add a7, hp, zero; 	sw a1, 35(a3); 	sw a5, 1(a1); 
	addi.label a5, a5, trace_diffuse_ray_80percent.2846; 	addi hp, hp, 8; 	sw a12, 33(a3); 	sw a17, 34(a3); 
nop; nop; 	sw a9, 31(a3); 	sw a9, 32(a3); 
nop; nop; 	sw a1, 28(a3); 	sw a9, 30(a3); 
nop; nop; 	sw a12, 26(a3); 	sw a17, 27(a3); 
nop; nop; 	sw a9, 24(a3); 	sw a9, 25(a3); 
nop; nop; 	sw a1, 21(a3); 	sw a9, 23(a3); 
nop; nop; 	sw a12, 19(a3); 	sw a17, 20(a3); 
nop; nop; 	sw a9, 17(a3); 	sw a9, 18(a3); 
nop; nop; 	sw a1, 14(a3); 	sw a9, 16(a3); 
nop; nop; 	sw a12, 12(a3); 	sw a17, 13(a3); 
nop; nop; 	sw a9, 10(a3); 	sw a9, 11(a3); 
nop; nop; 	sw a1, 7(a3); 	sw a9, 9(a3); 
nop; nop; 	sw a12, 5(a3); 	sw a17, 6(a3); 
nop; nop; 	sw a9, 3(a3); 	sw a9, 4(a3); 
	addi hp, hp, 30; 	add a11, hp, zero; 	sw a11, 0(a7); 	sw a9, 2(a3); 
nop; nop; 	sw cl, 5(a7); 	sw a6, 6(a7); 
nop; nop; 	sw a6, 3(a7); 	sw a3, 4(a7); 
nop; nop; 	sw a6, 1(a7); 	sw a6, 2(a7); 
	addi hp, hp, 8; 	add a13, hp, zero; 	sw a13, 0(a11); 	sw a5, 0(a3); 
nop; nop; 	sw cl, 28(a11); 	sw a6, 29(a11); 
nop; nop; 	sw a6, 26(a11); 	sw a6, 27(a11); 
nop; nop; 	sw a6, 24(a11); 	sw a6, 25(a11); 
nop; nop; 	sw a6, 22(a11); 	sw a6, 23(a11); 
nop; nop; 	sw a6, 20(a11); 	sw a6, 21(a11); 
nop; nop; 	sw a6, 18(a11); 	sw a6, 19(a11); 
nop; nop; 	sw a6, 16(a11); 	sw a6, 17(a11); 
nop; nop; 	sw a6, 14(a11); 	sw a6, 15(a11); 
nop; nop; 	sw a6, 12(a11); 	sw a6, 13(a11); 
nop; nop; 	sw a6, 10(a11); 	sw a6, 11(a11); 
nop; nop; 	sw a6, 8(a11); 	sw a6, 9(a11); 
nop; nop; 	sw a6, 6(a11); 	sw a6, 7(a11); 
nop; nop; 	sw a6, 4(a11); 	sw a6, 5(a11); 
nop; nop; 	sw a6, 2(a11); 	sw a6, 3(a11); 
nop; nop; 	lw a5, -29(sp); 	sw a6, 1(a11); 
nop; 	lui.label a14, try_exploit_neighbors.2875; 	sw a7, 7(a13); 	sw a14, 0(a13); 
nop; 	addi.label a14, a14, try_exploit_neighbors.2875; 	sw cl, 5(a13); 	sw a6, 6(a13); 
nop; nop; 	sw a6, 3(a13); 	sw a3, 4(a13); 
nop; nop; 	sw a6, 1(a13); 	sw a6, 2(a13); 
nop; nop; 	sw a5, 22(a3); 	sw a5, 29(a3); 
nop; nop; 	sw a5, 8(a3); 	sw a5, 15(a3); 
	addi hp, hp, 4; 	add a3, hp, zero; nop; 	sw a5, 1(a3); 
	add a11, hp, zero; 	lui.label a14, write_ppm_header.2882; 	sw a11, 3(a3); 	sw a14, 0(a3); 
	addi.label a14, a14, write_ppm_header.2882; 	addi hp, hp, 4; 	sw a7, 1(a3); 	sw a13, 2(a3); 
	addi hp, hp, 14; 	add a15, hp, zero; 	lw a14, -19(sp); 	sw a14, 0(a11); 
nop; nop; 	sw a14, 1(a11); 	sw a14, 2(a11); 
nop; nop; 	sw a6, 13(a15); 	sw a16, 0(a15); 
nop; nop; 	sw a6, 11(a15); 	sw a6, 12(a15); 
	lui.label a17, init_vecset_constants.2955; 	add a1, hp, zero; 	sw a17, 9(a15); 	sw a1, 10(a15); 
	addi.label a17, a17, init_vecset_constants.2955; 	addi hp, hp, 26; 	sw a9, 7(a15); 	sw a12, 8(a15); 
nop; nop; 	sw a9, 5(a15); 	sw a9, 6(a15); 
nop; nop; 	sw a6, 3(a15); 	sw a5, 4(a15); 
nop; 	lui.label a6, pretrace_pixels.2891; 	sw a6, 1(a15); 	sw a6, 2(a15); 
	lui.label a15, pretrace_line.2898; 	addi.label a6, a6, pretrace_pixels.2891; 	sw cl, 23(a1); 	sw a15, 24(a1); 
nop; 	addi.label a15, a15, pretrace_line.2898; 	sw cl, 21(a1); 	sw cl, 22(a1); 
nop; 	lui.label a18, setup_rect_reflection.2966; 	sw a4, 18(a1); 	sw a18, 19(a1); 
nop; 	addi.label a18, a18, setup_rect_reflection.2966; 	sw a4, 14(a1); 	sw a4, 16(a1); 
nop; nop; 	sw cl, 11(a1); 	sw cl, 12(a1); 
nop; nop; 	lw a9, -3(sp); 	sw cl, 10(a1); 
nop; nop; 	lw a4, -24(sp); 	sw a6, 0(a1); 
nop; nop; 	sw a9, 15(a1); 	sw a9, 17(a1); 
	addi hp, hp, 12; 	add a9, hp, zero; 	lw a6, -27(sp); 	sw a9, 13(a1); 
nop; nop; 	sw a4, 5(a1); 	sw a4, 7(a1); 
nop; nop; 	sw a6, 20(a1); 	sw a4, 3(a1); 
nop; nop; 	sw a6, 8(a1); 	sw a6, 9(a1); 
nop; nop; 	sw a6, 4(a1); 	sw a6, 6(a1); 
nop; nop; 	sw a1, 10(a9); 	sw a15, 0(a9); 
nop; nop; 	lw a4, -20(sp); 	sw a14, 9(a9); 
nop; nop; 	lw a15, -25(sp); 	lw a6, -21(sp); 
nop; nop; 	sw a4, 2(a9); 	sw a4, 2(a1); 
nop; nop; 	sw a15, 7(a9); 	sw a6, 1(a1); 
nop; 	lui.label a15, scan_pixel.2902; 	sw a15, 3(a9); 	sw a15, 5(a9); 
nop; 	addi.label a15, a15, scan_pixel.2902; 	lw a1, -26(sp); 	sw a6, 1(a9); 
nop; nop; 	sw a1, 6(a9); 	sw a1, 8(a9); 
	addi hp, hp, 14; 	add a1, hp, zero; nop; 	sw a1, 4(a9); 
nop; 	lui.label a15, create_dirvecs.2950; 	sw cl, 12(a1); 	sw a15, 0(a1); 
nop; 	addi.label a15, a15, create_dirvecs.2950; 	sw cl, 10(a1); 	sw cl, 11(a1); 
	lui.label a13, calc_dirvecs.2936; 	add a3, hp, zero; 	sw a13, 8(a1); 	sw a3, 9(a1); 
	addi.label a13, a13, calc_dirvecs.2936; 	addi hp, hp, 6; 	sw a14, 6(a1); 	sw a7, 7(a1); 
nop; 	lui.label a7, scan_line.2908; 	sw cl, 4(a1); 	sw a14, 5(a1); 
nop; 	addi.label a7, a7, scan_line.2908; 	sw cl, 2(a1); 	sw cl, 3(a1); 
	addi hp, hp, 2; 	add a1, hp, zero; 	sw a1, 4(a3); 	sw a14, 1(a1); 
nop; nop; 	sw a14, 2(a3); 	sw a9, 3(a3); 
nop; 	lui.label a7, calc_dirvec.2928; 	sw a7, 0(a3); 	sw a14, 1(a3); 
nop; 	addi.label a7, a7, calc_dirvec.2928; nop; 	sw a5, 1(a1); 
	addi hp, hp, 4; 	add a7, hp, zero; nop; 	sw a7, 0(a1); 
nop; 	lui.label a13, calc_dirvec_rows.2941; 	sw a1, 2(a7); 	sw a13, 0(a7); 
	add a1, hp, zero; 	addi.label a13, a13, calc_dirvec_rows.2941; nop; 	sw a1, 1(a7); 
	lui.label a13, create_dirvec_elements.2947; 	addi hp, hp, 2; 	sw a7, 1(a1); 	sw a13, 0(a1); 
	addi.label a13, a13, create_dirvec_elements.2947; 	add a7, hp, zero; nop; nop; 
nop; 	addi hp, hp, 4; 	sw a12, 2(a7); 	sw a13, 0(a7); 
	addi hp, hp, 10; 	add a13, hp, zero; nop; 	sw a12, 1(a7); 
nop; 	lui.label a15, init_dirvec_constants.2952; 	sw a7, 9(a13); 	sw a15, 0(a13); 
nop; 	addi.label a15, a15, init_dirvec_constants.2952; 	sw a5, 7(a13); 	sw a5, 8(a13); 
	addi hp, hp, 12; 	add a7, hp, zero; 	sw a7, 5(a13); 	sw a12, 6(a13); 
	addi hp, hp, 24; 	add a16, hp, zero; 	sw a5, 3(a13); 	sw a12, 4(a13); 
nop; nop; 	sw a12, 1(a13); 	sw a5, 2(a13); 
nop; nop; 	sw a12, 10(a7); 	sw a15, 0(a7); 
nop; nop; 	sw a12, 7(a7); 	sw a10, 8(a7); 
nop; nop; 	sw a12, 4(a7); 	sw a10, 5(a7); 
nop; nop; 	sw a12, 1(a7); 	sw a10, 2(a7); 
	addi hp, hp, 24; 	add a17, hp, zero; 	sw a7, 23(a16); 	sw a17, 0(a16); 
	addi hp, hp, 14; 	add a19, hp, zero; 	sw a7, 21(a16); 	sw a5, 22(a16); 
	addi hp, hp, 42; 	add cl, hp, zero; 	sw a5, 18(a16); 	sw a12, 19(a16); 
nop; nop; 	sw a12, 15(a16); 	sw a7, 17(a16); 
nop; nop; 	sw a12, 12(a16); 	sw a10, 13(a16); 
nop; nop; 	sw a7, 10(a16); 	sw a5, 11(a16); 
nop; nop; 	sw a10, 6(a16); 	sw a12, 8(a16); 
nop; nop; 	sw a10, 3(a16); 	sw a12, 5(a16); 
nop; nop; 	sw a5, 1(a16); 	sw a12, 2(a16); 
nop; nop; 	sw a18, 0(a17); 	lw a15, -40(sp); 
nop; nop; 	sw a10, 20(a17); 	sw a0, 23(a17); 
nop; nop; 	sw a12, 18(a17); 	sw a12, 19(a17); 
nop; nop; 	sw a10, 14(a17); 	sw a8, 17(a17); 
nop; nop; 	sw a12, 12(a17); 	sw a12, 13(a17); 
nop; nop; 	sw a10, 8(a17); 	sw a8, 11(a17); 
nop; nop; 	sw a12, 6(a17); 	sw a12, 7(a17); 
nop; nop; 	sw a8, 4(a17); 	sw a8, 5(a17); 
nop; nop; 	sw a8, 2(a17); 	sw a8, 3(a17); 
nop; nop; 	sw a20, 0(a19); 	sw a0, 1(a17); 
nop; nop; 	sw a10, 10(a19); 	sw a0, 13(a19); 
nop; nop; 	sw a12, 8(a19); 	sw a12, 9(a19); 
nop; nop; 	sw a8, 6(a19); 	sw a8, 7(a19); 
nop; nop; 	sw a8, 4(a19); 	sw a8, 5(a19); 
nop; nop; 	sw a8, 2(a19); 	sw a8, 3(a19); 
nop; 	lui.label a0, rt.2974; 	sw a3, 41(cl); 	sw a0, 1(a19); 
nop; 	addi.label a0, a0, rt.2974; 	sw a19, 39(cl); 	sw a9, 40(cl); 
nop; nop; 	sw a10, 37(cl); 	sw a17, 38(cl); 
nop; nop; 	sw a10, 33(cl); 	sw a12, 36(cl); 
nop; nop; 	sw a8, 31(cl); 	sw a12, 32(cl); 
nop; nop; 	sw a8, 29(cl); 	sw a8, 30(cl); 
nop; nop; 	sw a7, 27(cl); 	sw a16, 28(cl); 
nop; nop; 	sw a7, 25(cl); 	sw a5, 26(cl); 
nop; nop; 	sw a5, 22(cl); 	sw a12, 23(cl); 
nop; 	addi a1, zero, 128; 	sw a13, 20(cl); 	sw a1, 21(cl); 
nop; nop; 	sw a2, 18(cl); 	sw a11, 19(cl); 
nop; nop; 	sw a14, 11(cl); 	sw a12, 15(cl); 
nop; nop; 	sw a14, 9(cl); 	sw a14, 10(cl); 
nop; nop; 	sw a14, 7(cl); 	sw a14, 8(cl); 
nop; nop; 	sw a6, 5(cl); 	sw a14, 6(cl); 
nop; nop; 	sw a4, 3(cl); 	sw a4, 4(cl); 
nop; nop; 	sw a14, 1(cl); 	sw a14, 2(cl); 
nop; nop; 	lw a18, -34(sp); 	lw swp, 0(cl); 
nop; nop; 	sw a15, 9(a7); 	sw a15, 11(a7); 
nop; nop; 	sw a15, 3(a7); 	sw a15, 6(a7); 
nop; nop; 	sw a15, 16(a16); 	sw a15, 20(a16); 
nop; nop; 	sw a15, 9(a16); 	sw a15, 14(a16); 
nop; nop; 	sw a15, 4(a16); 	sw a15, 7(a16); 
nop; nop; 	sw a15, 15(a17); 	sw a15, 21(a17); 
nop; nop; 	sw a15, 11(a19); 	sw a15, 9(a17); 
nop; nop; 	sw a15, 24(cl); 	sw a15, 34(cl); 
nop; nop; 	sw a18, 22(a17); 	sw a0, 0(cl); 
nop; nop; 	sw a18, 10(a17); 	sw a18, 16(a17); 
nop; nop; 	lw a0, -32(sp); 	sw a18, 12(a19); 
nop; nop; 	lw a0, -39(sp); 	sw a0, 35(cl); 
nop; nop; 	lw a0, -38(sp); 	sw a0, 17(cl); 
nop; nop; 	lw a0, -37(sp); 	sw a0, 16(cl); 
nop; nop; 	lw a0, -36(sp); 	sw a0, 14(cl); 
nop; 	addi sp, sp, -45; 	lw a0, -35(sp); 	sw a0, 13(cl); 
nop; 	addi a0, zero, 128; nop; 	sw a0, 12(cl); 
	callr swp; nop; nop; nop; 
	addi a0, zero, 0; 	addi sp, sp, 45; nop; nop; 
