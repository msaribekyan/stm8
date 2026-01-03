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
	.globl _uart1_isr
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
_buf:
	.ds 20
_len:
	.ds 1
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
	int 0x000000 ; trap
	int 0x000000 ; int0
	int 0x000000 ; int1
	int 0x000000 ; int2
	int 0x000000 ; int3
	int 0x000000 ; int4
	int 0x000000 ; int5
	int 0x000000 ; int6
	int 0x000000 ; int7
	int 0x000000 ; int8
	int 0x000000 ; int9
	int 0x000000 ; int10
	int 0x000000 ; int11
	int 0x000000 ; int12
	int 0x000000 ; int13
	int 0x000000 ; int14
	int 0x000000 ; int15
	int 0x000000 ; int16
	int 0x000000 ; int17
	int _uart1_isr ; int18
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
;	src/main.c: 11: static void UART1_ClearIdle(void)
;	-----------------------------------------
;	 function UART1_ClearIdle
;	-----------------------------------------
_UART1_ClearIdle:
	push	a
;	src/main.c: 15: tmp = USART1_SR;  // MUST read SR first
	ld	a, 0x5230
	ld	(0x01, sp), a
;	src/main.c: 16: tmp = USART1_DR;  // THEN read DR
	ld	a, 0x5231
	ld	(0x01, sp), a
;	src/main.c: 17: (void)tmp;
;	src/main.c: 18: }
	pop	a
	ret
;	src/main.c: 20: void uart_write_c(unsigned char c)
;	-----------------------------------------
;	 function uart_write_c
;	-----------------------------------------
_uart_write_c:
	push	a
	ld	(0x01, sp), a
;	src/main.c: 22: while(!(USART1_SR & USART_SR_TXE));
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	src/main.c: 23: USART1_DR = c;
	ldw	x, #0x5231
	ld	a, (0x01, sp)
	ld	(x), a
;	src/main.c: 24: }
	pop	a
	ret
;	src/main.c: 26: void uart_write(const char *str)
;	-----------------------------------------
;	 function uart_write
;	-----------------------------------------
_uart_write:
;	src/main.c: 28: while(*str)
00101$:
	ld	a, (x)
	jrne	00121$
	ret
00121$:
;	src/main.c: 30: uart_write_c(*str);
	pushw	x
	call	_uart_write_c
	popw	x
;	src/main.c: 31: str++;
	incw	x
	jra	00101$
;	src/main.c: 33: }
	ret
;	src/main.c: 35: unsigned char uart_read(unsigned char *buf, unsigned char len)
;	-----------------------------------------
;	 function uart_read
;	-----------------------------------------
_uart_read:
	sub	sp, #4
	ldw	(0x02, sp), x
	ld	(0x01, sp), a
;	src/main.c: 41: while (1)
	clr	(0x04, sp)
00108$:
;	src/main.c: 43: if (USART1_SR & USART_SR_RXNE)	// Data register not empty
	btjf	0x5230, #5, 00104$
;	src/main.c: 45: data = USART1_DR;	// clear RXNE
	ld	a, 0x5231
;	src/main.c: 46: if (i < len)
	push	a
	ld	a, (0x05, sp)
	cp	a, (0x02, sp)
	pop	a
	jrnc	00104$
;	src/main.c: 48: buf[i] = data;
	clrw	x
	exg	a, xl
	ld	a, (0x04, sp)
	exg	a, xl
	addw	x, (0x02, sp)
	ld	(x), a
;	src/main.c: 49: i++;
	inc	(0x04, sp)
00104$:
;	src/main.c: 52: if (USART1_SR & USART_SR_IDLE)
	btjf	0x5230, #4, 00108$
;	src/main.c: 54: UART1_ClearIdle();
	call	_UART1_ClearIdle
;	src/main.c: 60: buf[i] = '\0';
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	addw	x, (0x02, sp)
	clr	(x)
;	src/main.c: 61: return (i);
	ld	a, (0x04, sp)
;	src/main.c: 62: }
	addw	sp, #4
	ret
;	src/main.c: 64: ISR(uart1_isr, UART1_R_RXNE_vector) {
;	-----------------------------------------
;	 function uart1_isr
;	-----------------------------------------
_uart1_isr:
;	src/main.c: 65: len = uart_read((unsigned char *) buf, 20);
	ld	a, #0x14
	ldw	x, #(_buf+0)
	call	_uart_read
	ld	_len+0, a
;	src/main.c: 66: }
	iret
;	src/main.c: 68: void delay_ms(unsigned long ms)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	sub	sp, #4
;	src/main.c: 70: unsigned long cycles = 1318 * ms;
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#0x26
	push	#0x05
	clrw	x
	pushw	x
;	src/main.c: 71: while(cycles--);
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
;	src/main.c: 72: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 74: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	src/main.c: 76: CLK_CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 77: CLK_PCKENR1 = 0xFF; // Enable peripherals
	mov	0x50c7+0, #0xff
;	src/main.c: 82: USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
	ld	a, 0x5235
	or	a, #0x08
;	src/main.c: 83: USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
	ld	0x5235, a
	or	a, #0x04
	ld	0x5235, a
;	src/main.c: 84: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	ld	a, 0x5236
	and	a, #0xcf
	ld	0x5236, a
;	src/main.c: 85: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	mov	0x5233+0, #0x03
	mov	0x5232+0, #0x68
;	src/main.c: 87: USART1_CR2 |= USART_CR2_RIEN;
	ld	a, 0x5235
	or	a, #0x20
	ld	0x5235, a
;	src/main.c: 89: rim();
	rim
;	src/main.c: 91: while(1)
00107$:
;	src/main.c: 93: if (len != 0)
	ld	a, _len+0
	jreq	00107$
;	src/main.c: 95: uart_write((unsigned char *) buf);
	ldw	x, #(_buf+0)
	call	_uart_write
;	src/main.c: 96: len = 0;
	clr	_len+0
;	src/main.c: 97: while (len < 20)
00101$:
	ld	a, _len+0
	cp	a, #0x14
	jrnc	00103$
;	src/main.c: 98: buf[len++] = 0;
	ld	a, _len+0
	inc	_len+0
	clrw	x
	ld	xl, a
	clr	((_buf+0), x)
	jra	00101$
00103$:
;	src/main.c: 99: len = 0;
	clr	_len+0
	jra	00107$
;	src/main.c: 102: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
__xinit__buf:
	.db #0x00	; 0
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
__xinit__len:
	.db #0x00	; 0
	.area CABS (ABS)
