	.file	"trie.c"

	.text
	.globl	node
	.bss
	.align 32
	.type	node, @object
	.size	node, 18000000
node:
	.zero	18000000

	.globl	root
	.align 4
	.type	root, @object
	.size	root, 4
root:
	.zero	4

	.globl	cnt
	.align 4
	.type	cnt, @object
	.size	cnt, 4
cnt:
	.zero	4

	.text
	.globl	add
	.type	add, @function
add:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp

	movl	cnt(%rip), %eax
	addl	$1, %eax
	movl	%eax, cnt(%rip)
	movl	cnt(%rip), %eax # ++cnt

	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	leaq	104+node(%rip), %rax
	movl	$0, (%rdx,%rax)
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	cnt(%rip), %eax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	addq	%rax, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rdx
	leaq	node(%rip), %rax
	movl	$0, (%rdx,%rax)
	addl	$1, -4(%rbp)
.L2:
	cmpl	$25, -4(%rbp)
	jle	.L3
	movl	cnt(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	leaq	112+node(%rip), %rax
	movq	$0, (%rdx,%rax)
	movl	cnt(%rip), %eax
	popq	%rbp
	ret
	.size	add, .-add


	.globl	insert
	.type	insert, @function
insert:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -20(%rbp)
	movl	root(%rip), %eax
	movl	%eax, -32(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L6
.L12:
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movslq	%eax, %rcx
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	addq	%rax, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rdx
	leaq	node(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L7
	movl	$0, %eax
	call	add
	movq	-16(%rbp), %rdx
	movl	%eax, (%rdx)
.L7:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -32(%rbp)
	movl	-20(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -28(%rbp)
	jne	.L8
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	leaq	104+node(%rip), %rax
	movl	(%rdx,%rax), %eax
	testl	%eax, %eax
	jne	.L9
	movl	-20(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L10
.L11:
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -24(%rbp)
.L10:
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L11
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rcx
	leaq	112+node(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rcx,%rdx)
.L9:
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	leaq	104+node(%rip), %rax
	movl	(%rdx,%rax), %eax
	leal	1(%rax), %ecx
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	leaq	104+node(%rip), %rax
	movl	%ecx, (%rdx,%rax)
.L8:
	addl	$1, -28(%rbp)
.L6:
	movl	-28(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L12
	nop
	nop
	leave
	ret

	.size	insert, .-insert


	.globl	main
	.type	main, @function
main:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
