.section .data

int_gen:
	.byte 0 
int_wm:
	.byte 0
int_dw:
	.byte 0
somma:
	.word 0
ciclo:
	.byte 0
soglia:
	.byte 0

.section .text
	.global leggi
	
/* lettura riga */
leggi:

	pushl %ebp                  # preparo stack
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

	movl 8(%ebp), %esi          # indirizzo input
	movl 12(%ebp), %edi         # indirizzo output

	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %ecx, %ecx


/* elaboro dati input controllando i res con gli int */
elabora:

	cmpb $0, int_gen  #se int_gen è a 0 controllo res_gen
	jne intW

	cmpb $0x30, (%esi)
	je all_off
	jmp all_on #aumentare di 4 esi

intG_W_D:
  movb $1, int_gen
  movb $1, int_wm
  movb $1, int_dw

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
	jmp calcola

	
sum1:
	addl $2000, (%eax)
sum2:
	addl $300, (%eax)
sum3:
	addl $1200, (%eax)
sum4:
	addl $1000, (%eax)
sum5:
	addl $1800, (%eax)
sum6:
	addl $240, (%eax)
sum7:
	addl $400, (%eax)
sum8:
	addl $200, (%eax)


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
	movb 8(%esi), %bl
	andb int_wm, %bl
  cmpb $1, %bl
	je sum1
	xorl %ebx, %ebx
	movb 9(%esi), %bl
	andb int_dw, %bl
  cmpb $1, %bl
	je sum5
	xorl %ebx, %ebx
	cmpb $0x31, 10(%esi)
	je sum6
	cmpb $0x31, 11(%esi)
	je sum7
	cmpb $0x31, 12(%esi)
	je sum8
	cmpb $0x31, 13(%esi)
	je sum7


soglia_func:
	xorl %eax, %eax
	cmpl $4500, somma
	jg overload
	
	cmpl $3000, somma
	jg stato_2

	cmpl $1500, somma
	jg stato_1
	movb $0, ciclo
	movb $0, soglia
	jmp salva


overload:
	movl $3, soglia
	incb ciclo
	cmpb $4, ciclo
	je dw_goes_off
	cmpb $5, ciclo
	je wm_goes_off
	cmpb $6, ciclo
	je sys_goes_off
	jmp salva
	
	
stato_2:
	movb $0, ciclo
	movb $2, soglia
	jmp salva


stato_1:
	movb $0, ciclo
	movb $1, soglia
	jmp salva


/* int_dw off */
dw_goes_off:
	movb $0, int_dw
	jmp salva


/* int_wm OFF */
wm_goes_off:
	movb $0, int_wm
	jmp salva


/* sistema OFF */
sys_goes_off:
	movb $0, int_dw
	movb $0, int_wm
	movb $0, int_gen
	movb $0, soglia 
  movb $0, ciclo


/* controllo cosa scrivere */
salva:
	cmpb $0, int_gen
	je all_off
	cmpb $0, int_wm
	je off_wm
	cmpb $0, int_dw
	je off_dw 


/* scrivo TUTTO ON */
all_on:
	movb $0x31, (%edi)
	movb $0x31, 1(%edi)
	movb $0x31, 2(%edi)
	movb $0x2D, 3(%edi)
	cmpb $3, soglia
	jne soglia_2
	movb $0x4F, 4(%edi)
	movb $0x4C, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive TUTTO OFF */
all_off:
	movb $0x30, (%edi)
	movb $0x30, 1(%edi)
	movb $0x30, 2(%edi)
	movb $0x2D, 3(%edi)
	movb $0x30, 4(%edi)
	movb $0x30, 5(%edi)
	movb $0xA, 6(%edi)
  jmp ricomincia


/* scrive int_wm OFF */
off_wm:
	cmpb $0, int_dw
	je off_wm_dw
	movb $0x31, (%edi)
	movb $0x30, 1(%edi)
	movb $0x31, 2(%edi)
	movb $0x2D, 3(%edi)
	cmpb $3, soglia
	jne soglia_2
	movb $0x4F, 4(%edi)
	movb $0x4C, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive int_dw OFF */
off_dw:
	movb $0x31, (%edi)
	movb $0x31, 1(%edi)
	movb $0x30, 2(%edi)
	movb $0x2D, 3(%edi)
	cmpb $3, soglia
	jne soglia_2
	movb $0x4F, 4(%edi)
	movb $0x4C, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive int_dw OFF e int_wm OFF */
off_wm_dw:
	movb $0x31, (%edi)
	movb $0x30, 1(%edi)
	movb $0x30, 2(%edi)
	movb $0x2D, 3(%edi)
	cmpb $3, soglia
	jne soglia_2
	movb $0x4F, 4(%edi)
	movb $0x4C, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive F2 */
soglia_2:
	cmpb $2, soglia
	jne soglia_1
	movb $0x46, 4(%edi)
	movb $0x33, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive F1 */
soglia_1:
	cmpb $1, soglia
	jne soglia_0
	movb $0x46, 4(%edi)
	movb $0x32, 5(%edi)
	movb $0xA, 6(%edi)
	jmp ricomincia


/* scrive F0 */
soglia_0:
	movb $0x46, 4(%edi)
	movb $0x31, 5(%edi)
	movb $0xA, 6(%edi)
 

/* cicla la riga successiva */
ricomincia:
	cmpb $0x00, 14(%esi)                # controllo se è la fine del buffer
	je fine
	addl $7, %edi                       # output line shift
	addl $15, %esi                      # input line shift
	jmp elabora


/* fine programma */
fine:
	popl %esi
	popl %edi
	popl %ecx
	popl %ebx
	popl %eax
	movl %ebp, %esp
	popl %ebp

ret
