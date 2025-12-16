                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ISO C Compiler
                                      3 ; Version 4.5.0 #15242 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	
                                      7 ;--------------------------------------------------------
                                      8 ; Public variables in this module
                                      9 ;--------------------------------------------------------
                                     10 	.globl _main
                                     11 	.globl _delay_ms
                                     12 	.globl _uart_write
                                     13 ;--------------------------------------------------------
                                     14 ; ram data
                                     15 ;--------------------------------------------------------
                                     16 	.area DATA
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area INITIALIZED
                                     21 ;--------------------------------------------------------
                                     22 ; Stack segment in internal ram
                                     23 ;--------------------------------------------------------
                                     24 	.area SSEG
      000001                         25 __start__stack:
      000001                         26 	.ds	1
                                     27 
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 07             46 	int s_GSINIT ; reset
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
      008007 CD 80 AD         [ 4]   54 	call	___sdcc_external_startup
      00800A 4D               [ 1]   55 	tnz	a
      00800B 27 03            [ 1]   56 	jreq	__sdcc_init_data
      00800D CC 80 04         [ 2]   57 	jp	__sdcc_program_startup
      008010                         58 __sdcc_init_data:
                                     59 ; stm8_genXINIT() start
      008010 AE 00 00         [ 2]   60 	ldw x, #l_DATA
      008013 27 07            [ 1]   61 	jreq	00002$
      008015                         62 00001$:
      008015 72 4F 00 00      [ 1]   63 	clr (s_DATA - 1, x)
      008019 5A               [ 2]   64 	decw x
      00801A 26 F9            [ 1]   65 	jrne	00001$
      00801C                         66 00002$:
      00801C AE 00 00         [ 2]   67 	ldw	x, #l_INITIALIZER
      00801F 27 09            [ 1]   68 	jreq	00004$
      008021                         69 00003$:
      008021 D6 80 3A         [ 1]   70 	ld	a, (s_INITIALIZER - 1, x)
      008024 D7 00 00         [ 1]   71 	ld	(s_INITIALIZED - 1, x), a
      008027 5A               [ 2]   72 	decw	x
      008028 26 F7            [ 1]   73 	jrne	00003$
      00802A                         74 00004$:
                                     75 ; stm8_genXINIT() end
                                     76 	.area GSFINAL
      00802A CC 80 04         [ 2]   77 	jp	__sdcc_program_startup
                                     78 ;--------------------------------------------------------
                                     79 ; Home
                                     80 ;--------------------------------------------------------
                                     81 	.area HOME
                                     82 	.area HOME
      008004                         83 __sdcc_program_startup:
      008004 CC 80 7F         [ 2]   84 	jp	_main
                                     85 ;	return from main will return to caller
                                     86 ;--------------------------------------------------------
                                     87 ; code
                                     88 ;--------------------------------------------------------
                                     89 	.area CODE
                                     90 ;	src/main.c: 4: void uart_write(const char *str)
                                     91 ;	-----------------------------------------
                                     92 ;	 function uart_write
                                     93 ;	-----------------------------------------
      00803B                         94 _uart_write:
                                     95 ;	src/main.c: 6: while(*str)
      00803B                         96 00104$:
      00803B F6               [ 1]   97 	ld	a, (x)
      00803C 26 01            [ 1]   98 	jrne	00131$
      00803E 81               [ 4]   99 	ret
      00803F                        100 00131$:
                                    101 ;	src/main.c: 8: while(!(USART1_SR & USART_SR_TXE));
      00803F                        102 00101$:
      00803F C6 52 30         [ 1]  103 	ld	a, 0x5230
      008042 2A FB            [ 1]  104 	jrpl	00101$
                                    105 ;	src/main.c: 9: USART1_DR = *str;
      008044 F6               [ 1]  106 	ld	a, (x)
      008045 C7 52 31         [ 1]  107 	ld	0x5231, a
                                    108 ;	src/main.c: 10: str++;
      008048 5C               [ 1]  109 	incw	x
      008049 20 F0            [ 2]  110 	jra	00104$
                                    111 ;	src/main.c: 12: }
      00804B 81               [ 4]  112 	ret
                                    113 ;	src/main.c: 14: void delay_ms(unsigned long ms)
                                    114 ;	-----------------------------------------
                                    115 ;	 function delay_ms
                                    116 ;	-----------------------------------------
      00804C                        117 _delay_ms:
      00804C 52 04            [ 2]  118 	sub	sp, #4
                                    119 ;	src/main.c: 16: unsigned long cycles = 960 * ms;
      00804E 1E 09            [ 2]  120 	ldw	x, (0x09, sp)
      008050 89               [ 2]  121 	pushw	x
      008051 1E 09            [ 2]  122 	ldw	x, (0x09, sp)
      008053 89               [ 2]  123 	pushw	x
      008054 4B C0            [ 1]  124 	push	#0xc0
      008056 4B 03            [ 1]  125 	push	#0x03
      008058 5F               [ 1]  126 	clrw	x
      008059 89               [ 2]  127 	pushw	x
                                    128 ;	src/main.c: 17: while(cycles--);
      00805A CD 80 AF         [ 4]  129 	call	__mullong
      00805D 5B 08            [ 2]  130 	addw	sp, #8
      00805F                        131 00101$:
      00805F 1F 03            [ 2]  132 	ldw	(0x03, sp), x
      008061 17 01            [ 2]  133 	ldw	(0x01, sp), y
      008063 1D 00 01         [ 2]  134 	subw	x, #0x0001
      008066 24 02            [ 1]  135 	jrnc	00114$
      008068 90 5A            [ 2]  136 	decw	y
      00806A                        137 00114$:
      00806A 0D 04            [ 1]  138 	tnz	(0x04, sp)
      00806C 26 F1            [ 1]  139 	jrne	00101$
      00806E 0D 03            [ 1]  140 	tnz	(0x03, sp)
      008070 26 ED            [ 1]  141 	jrne	00101$
      008072 0D 02            [ 1]  142 	tnz	(0x02, sp)
      008074 26 E9            [ 1]  143 	jrne	00101$
      008076 0D 01            [ 1]  144 	tnz	(0x01, sp)
      008078 26 E5            [ 1]  145 	jrne	00101$
                                    146 ;	src/main.c: 18: }
      00807A 1E 05            [ 2]  147 	ldw	x, (5, sp)
      00807C 5B 0A            [ 2]  148 	addw	sp, #10
      00807E FC               [ 2]  149 	jp	(x)
                                    150 ;	src/main.c: 20: int main(void)
                                    151 ;	-----------------------------------------
                                    152 ;	 function main
                                    153 ;	-----------------------------------------
      00807F                        154 _main:
                                    155 ;	src/main.c: 22: CLK_CKDIVR = 0x00;
      00807F 35 00 50 C6      [ 1]  156 	mov	0x50c6+0, #0x00
                                    157 ;	src/main.c: 23: CLK_PCKENR1 = 0xFF; // Enable peripherals
      008083 35 FF 50 C7      [ 1]  158 	mov	0x50c7+0, #0xff
                                    159 ;	src/main.c: 28: USART1_CR2 = USART_CR2_TEN; // Allow TX & RX
      008087 35 08 52 35      [ 1]  160 	mov	0x5235+0, #0x08
                                    161 ;	src/main.c: 29: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
      00808B C6 52 36         [ 1]  162 	ld	a, 0x5236
      00808E A4 CF            [ 1]  163 	and	a, #0xcf
      008090 C7 52 36         [ 1]  164 	ld	0x5236, a
                                    165 ;	src/main.c: 30: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
      008093 35 03 52 33      [ 1]  166 	mov	0x5233+0, #0x03
      008097 35 68 52 32      [ 1]  167 	mov	0x5232+0, #0x68
                                    168 ;	src/main.c: 32: while(1)
      00809B                        169 00102$:
                                    170 ;	src/main.c: 34: uart_write("Hello World!\n");
      00809B AE 80 2D         [ 2]  171 	ldw	x, #(___str_0+0)
      00809E CD 80 3B         [ 4]  172 	call	_uart_write
                                    173 ;	src/main.c: 35: delay_ms(1000);	
      0080A1 4B E8            [ 1]  174 	push	#0xe8
      0080A3 4B 03            [ 1]  175 	push	#0x03
      0080A5 5F               [ 1]  176 	clrw	x
      0080A6 89               [ 2]  177 	pushw	x
      0080A7 CD 80 4C         [ 4]  178 	call	_delay_ms
      0080AA 20 EF            [ 2]  179 	jra	00102$
                                    180 ;	src/main.c: 37: }
      0080AC 81               [ 4]  181 	ret
                                    182 	.area CODE
                                    183 	.area CONST
                                    184 	.area CONST
      00802D                        185 ___str_0:
      00802D 48 65 6C 6C 6F 20 57   186 	.ascii "Hello World!"
             6F 72 6C 64 21
      008039 0A                     187 	.db 0x0a
      00803A 00                     188 	.db 0x00
                                    189 	.area CODE
                                    190 	.area INITIALIZER
                                    191 	.area CABS (ABS)
