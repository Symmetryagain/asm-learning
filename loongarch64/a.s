	.file	"a.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.ascii	"hello,LoongArch64!\000"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB0 = .
	.cfi_startproc
	addi.d	$r3,$r3,-16
	.cfi_def_cfa_offset 16
	st.d	$r1,$r3,8
	stptr.d	$r22,$r3,0
	.cfi_offset 1, -8
	.cfi_offset 22, -16
	addi.d	$r22,$r3,16
	.cfi_def_cfa 22, 0
	la.local	$r4,.LC0
	bl	%plt(printf)
	or	$r12,$r0,$r0
	or	$r4,$r12,$r0
	ld.d	$r1,$r3,8
	.cfi_restore 1
	ldptr.d	$r22,$r3,0
	.cfi_restore 22
	addi.d	$r3,$r3,16
	.cfi_def_cfa_register 3
	jr	$r1
	.cfi_endproc
.LFE0:
	.size	main, .-main


	.ident	"GCC: (GNU) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
