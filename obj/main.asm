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
	.globl _uart_read
	.globl _uart_write
	.globl _uart_write_c
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
;	src/main.c: 4: static void UART1_ClearIdle(void)
;	-----------------------------------------
;	 function UART1_ClearIdle
;	-----------------------------------------
_UART1_ClearIdle:
	push	a
;	src/main.c: 8: tmp = USART1_SR;  // MUST read SR first
	ld	a, 0x5230
	ld	(0x01, sp), a
;	src/main.c: 9: tmp = USART1_DR;  // THEN read DR
	ld	a, 0x5231
	ld	(0x01, sp), a
;	src/main.c: 10: (void)tmp;
;	src/main.c: 11: }
	pop	a
	ret
;	src/main.c: 13: void uart_write_c(unsigned char c)
;	-----------------------------------------
;	 function uart_write_c
;	-----------------------------------------
_uart_write_c:
	push	a
	ld	(0x01, sp), a
;	src/main.c: 15: while(!(USART1_SR & USART_SR_TXE));
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	src/main.c: 16: USART1_DR = c;
	ldw	x, #0x5231
	ld	a, (0x01, sp)
	ld	(x), a
;	src/main.c: 17: }
	pop	a
	ret
;	src/main.c: 19: void uart_write(const char *str)
;	-----------------------------------------
;	 function uart_write
;	-----------------------------------------
_uart_write:
;	src/main.c: 21: while(*str)
00101$:
	ld	a, (x)
	jrne	00121$
	ret
00121$:
;	src/main.c: 23: uart_write_c(*str);
	pushw	x
	call	_uart_write_c
	popw	x
;	src/main.c: 24: str++;
	incw	x
	jra	00101$
;	src/main.c: 26: }
	ret
;	src/main.c: 28: unsigned char uart_read(unsigned char *buf, unsigned char len)
;	-----------------------------------------
;	 function uart_read
;	-----------------------------------------
_uart_read:
	sub	sp, #4
	ldw	(0x02, sp), x
	ld	(0x01, sp), a
;	src/main.c: 34: while (1)
	clr	(0x04, sp)
00108$:
;	src/main.c: 36: if (USART1_SR & USART_SR_RXNE)	// Data register not empty
	btjf	0x5230, #5, 00104$
;	src/main.c: 38: data = USART1_DR;	// clear RXNE
	ld	a, 0x5231
;	src/main.c: 39: if (i < len)
	push	a
	ld	a, (0x05, sp)
	cp	a, (0x02, sp)
	pop	a
	jrnc	00104$
;	src/main.c: 41: buf[i] = data;
	clrw	x
	exg	a, xl
	ld	a, (0x04, sp)
	exg	a, xl
	addw	x, (0x02, sp)
	ld	(x), a
;	src/main.c: 42: i++;
	inc	(0x04, sp)
00104$:
;	src/main.c: 45: if (USART1_SR & USART_SR_IDLE)
	btjf	0x5230, #4, 00108$
;	src/main.c: 47: UART1_ClearIdle();
	call	_UART1_ClearIdle
;	src/main.c: 53: buf[i] = '\0';
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	addw	x, (0x02, sp)
	clr	(x)
;	src/main.c: 54: return (i);
	ld	a, (0x04, sp)
;	src/main.c: 55: }
	addw	sp, #4
	ret
;	src/main.c: 57: void delay_ms(unsigned long ms)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	sub	sp, #4
;	src/main.c: 59: unsigned long cycles = 1318 * ms;
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#0x26
	push	#0x05
	clrw	x
	pushw	x
;	src/main.c: 60: while(cycles--);
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
;	src/main.c: 61: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 63: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #20
;	src/main.c: 66: unsigned char	buf[20] = {0};
	clr	(0x01, sp)
	clr	(0x02, sp)
	clr	(0x03, sp)
	clr	(0x04, sp)
	clr	(0x05, sp)
	clr	(0x06, sp)
	clr	(0x07, sp)
	clr	(0x08, sp)
	clr	(0x09, sp)
	clr	(0x0a, sp)
	clr	(0x0b, sp)
	clr	(0x0c, sp)
	clr	(0x0d, sp)
	clr	(0x0e, sp)
	clr	(0x0f, sp)
	clr	(0x10, sp)
	clr	(0x11, sp)
	clr	(0x12, sp)
	clr	(0x13, sp)
	clr	(0x14, sp)
;	src/main.c: 67: CLK_CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 68: CLK_PCKENR1 = 0xFF; // Enable peripherals
	mov	0x50c7+0, #0xff
;	src/main.c: 73: USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
	ld	a, 0x5235
	or	a, #0x08
;	src/main.c: 74: USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
	ld	0x5235, a
	or	a, #0x04
	ld	0x5235, a
;	src/main.c: 75: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	ld	a, 0x5236
	and	a, #0xcf
	ld	0x5236, a
;	src/main.c: 76: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	mov	0x5233+0, #0x03
	mov	0x5232+0, #0x68
;	src/main.c: 78: while(1)
00107$:
;	src/main.c: 81: i = uart_read((unsigned char *) buf, 20);
	ld	a, #0x14
	ldw	x, sp
	incw	x
	call	_uart_read
;	src/main.c: 82: if (i)
	tnz	a
	jreq	00113$
;	src/main.c: 83: uart_write((unsigned char *) buf);
	ldw	x, sp
	incw	x
	call	_uart_write
;	src/main.c: 85: while (i < 20)
00113$:
	clrw	y
00103$:
	cpw	y, #0x0014
	jrsge	00105$
;	src/main.c: 86: buf[i--] = 0;
	ldw	x, y
	pushw	x
	ldw	x, sp
	addw	x, #3
	addw	x, (1, sp)
	addw	sp, #2
	decw	y
	clr	(x)
	jra	00103$
00105$:
;	src/main.c: 87: uart_write("Nothing\n");
	ldw	x, #(___str_0+0)
	call	_uart_write
;	src/main.c: 88: delay_ms(1000);
	push	#0xe8
	push	#0x03
	clrw	x
	pushw	x
	call	_delay_ms
	jra	00107$
;	src/main.c: 90: }
	addw	sp, #20
	ret
	.area CODE
	.area CONST
	.area CONST
___str_0:
	.ascii "Nothing"
	.db 0x0a
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
