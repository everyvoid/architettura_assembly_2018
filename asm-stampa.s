.section .data

int_gen:
	.byte 0 
int_wm:
	.byte 0
int_dw:
	.byte 0
somma:
	.byte 0

.global leggi

leggi:

pushl %ebp
movl %esp, %ebp

pushl %eax
pushl %ebx
pushl %ecx
pushl %edi
pushl %esi

leal int_gen, %eax
pushl %eax
leal int_wm, %eax
pushl %eax
leal int_dw, %eax
pushl %eax
leal somma, %eax
pushl %eax
leal ciclo, %eax
pushl %eax

elabora:

movl 8(%ebp), %esi
movl 12(%ebp), %edi

xorl %eax, %eax
xorl %ebx, %ebx
xorl %ecx, %ecx

cmpb $0, int_gen  #se int_gen è a 0 controllo res_gen
jne intW:

cmpb $0x30, (%esi)
je fine
jmp all_on: #aumentare di 4 esi

intW: #controllo int_wm

cmpb $0, int_wm
jne intD

cmpb $0x30, 1(%esi)
je intD
movb $1, int_wm

intD:

cmpb $0, int_dw
jne calcola #inizio a calcolare

cmpb $0x30, 2(%esi)
je calcola
movb $1, int_dw
smp calcola

sum1:
addl $2000, %eax
sum2:
addl $300, %eax
sum3:
addl $1200, %eax
sum4:
addl $1000, %eax
sum5:
addl 1800, %eax
sum6:
addl $240, %eax
sum7:
addl $400, %eax
sum8:
addl $200, %eax


calcola:

leal somma , %eax

cmpb $0x31, 4(%esi)
je sum1
cmpb $0x31, 5(%esi)
je sum2
cmpb $0x31, 6(%esi)
je sum3
cmpb $0x31, 7(%esi)
je sum4
movb 8(%esi), %ebx
and int_wm, %bx
jnz sum1
xorl %ebx, %ebx
movb 9(%esi), %ebx
and int_dw, %bx
jnz sum5
xorl %ebx, %ebx
cmpb $0x31, 10(%esi)
je sum6
cmpb $0x31, 11(%esi)
je sum7
cmpb $0x31, 12(%esi)
je sum8
cmpb $0x31, 13(%esi)
je sum7








popl %esi
popl %edi
popl %ecx
popl %ebx
popl %eax
popl %ebp

ret
