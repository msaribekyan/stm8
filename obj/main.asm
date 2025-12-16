;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Linux)
;--------------------------------------------------------
	.module main
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay_ms
	.globl _uart_write
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
	call	___sdcc_external_startup
	tnz	a
	jreq	__sdcc_init_data
	jp	__sdcc_program_startup
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	src/main.c: 4: void uart_write(const char *str)
;	-----------------------------------------
;	 function uart_write
;	-----------------------------------------
_uart_write:
;	src/main.c: 6: while(*str)
00104$:
	ld	a, (x)
	jrne	00131$
	ret
00131$:
;	src/main.c: 8: while(!(USART1_SR & USART_SR_TXE));
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	src/main.c: 9: USART1_DR = *str;
	ld	a, (x)
	ld	0x5231, a
;	src/main.c: 10: str++;
	incw	x
	jra	00104$
;	src/main.c: 12: }
	ret
;	src/main.c: 14: void delay_ms(unsigned long ms)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	sub	sp, #4
;	src/main.c: 16: unsigned long cycles = 960 * ms;
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#0xc0
	push	#0x03
	clrw	x
	pushw	x
;	src/main.c: 17: while(cycles--);
	call	__mullong
	addw	sp, #8
00101$:
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
	subw	x, #0x0001
	jrnc	00114$
	decw	y
00114$:
	tnz	(0x04, sp)
	jrne	00101$
	tnz	(0x03, sp)
	jrne	00101$
	tnz	(0x02, sp)
	jrne	00101$
	tnz	(0x01, sp)
	jrne	00101$
;	src/main.c: 18: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 20: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	src/main.c: 22: CLK_CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 23: CLK_PCKENR1 = 0xFF; // Enable peripherals
	mov	0x50c7+0, #0xff
;	src/main.c: 28: USART1_CR2 = USART_CR2_TEN; // Allow TX & RX
	mov	0x5235+0, #0x08
;	src/main.c: 29: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	ld	a, 0x5236
	and	a, #0xcf
	ld	0x5236, a
;	src/main.c: 30: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	mov	0x5233+0, #0x03
	mov	0x5232+0, #0x68
;	src/main.c: 32: while(1)
00102$:
;	src/main.c: 34: uart_write("Hello World!\n");
	ldw	x, #(___str_0+0)
	call	_uart_write
;	src/main.c: 35: delay_ms(1000);	
	push	#0xe8
	push	#0x03
	clrw	x
	pushw	x
	call	_delay_ms
	jra	00102$
;	src/main.c: 37: }
	ret
	.area CODE
	.area CONST
	.area CONST
___str_0:
	.ascii "Hello World!"
	.db 0x0a
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
