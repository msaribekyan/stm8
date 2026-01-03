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
                                     12 	.globl _uart1_isr
                                     13 	.globl _uart_read
                                     14 	.globl _uart_write
                                     15 	.globl _uart_write_c
                                     16 ;--------------------------------------------------------
                                     17 ; ram data
                                     18 ;--------------------------------------------------------
                                     19 	.area DATA
                                     20 ;--------------------------------------------------------
                                     21 ; ram data
                                     22 ;--------------------------------------------------------
                                     23 	.area INITIALIZED
      000001                         24 _buf:
      000001                         25 	.ds 20
      000015                         26 _len:
      000015                         27 	.ds 1
                                     28 ;--------------------------------------------------------
                                     29 ; Stack segment in internal ram
                                     30 ;--------------------------------------------------------
                                     31 	.area SSEG
      000016                         32 __start__stack:
      000016                         33 	.ds	1
                                     34 
                                     35 ;--------------------------------------------------------
                                     36 ; absolute external ram data
                                     37 ;--------------------------------------------------------
                                     38 	.area DABS (ABS)
                                     39 
                                     40 ; default segment ordering for linker
                                     41 	.area HOME
                                     42 	.area GSINIT
                                     43 	.area GSFINAL
                                     44 	.area CONST
                                     45 	.area INITIALIZER
                                     46 	.area CODE
                                     47 
                                     48 ;--------------------------------------------------------
                                     49 ; interrupt vector
                                     50 ;--------------------------------------------------------
                                     51 	.area HOME
      008000                         52 __interrupt_vect:
      008000 82 00 80 57             53 	int s_GSINIT ; reset
      008004 82 00 00 00             54 	int 0x000000 ; trap
      008008 82 00 00 00             55 	int 0x000000 ; int0
      00800C 82 00 00 00             56 	int 0x000000 ; int1
      008010 82 00 00 00             57 	int 0x000000 ; int2
      008014 82 00 00 00             58 	int 0x000000 ; int3
      008018 82 00 00 00             59 	int 0x000000 ; int4
      00801C 82 00 00 00             60 	int 0x000000 ; int5
      008020 82 00 00 00             61 	int 0x000000 ; int6
      008024 82 00 00 00             62 	int 0x000000 ; int7
      008028 82 00 00 00             63 	int 0x000000 ; int8
      00802C 82 00 00 00             64 	int 0x000000 ; int9
      008030 82 00 00 00             65 	int 0x000000 ; int10
      008034 82 00 00 00             66 	int 0x000000 ; int11
      008038 82 00 00 00             67 	int 0x000000 ; int12
      00803C 82 00 00 00             68 	int 0x000000 ; int13
      008040 82 00 00 00             69 	int 0x000000 ; int14
      008044 82 00 00 00             70 	int 0x000000 ; int15
      008048 82 00 00 00             71 	int 0x000000 ; int16
      00804C 82 00 00 00             72 	int 0x000000 ; int17
      008050 82 00 80 F4             73 	int _uart1_isr ; int18
                                     74 ;--------------------------------------------------------
                                     75 ; global & static initialisations
                                     76 ;--------------------------------------------------------
                                     77 	.area HOME
                                     78 	.area GSINIT
                                     79 	.area GSFINAL
                                     80 	.area GSINIT
      008057 CD 81 8D         [ 4]   81 	call	___sdcc_external_startup
      00805A 4D               [ 1]   82 	tnz	a
      00805B 27 03            [ 1]   83 	jreq	__sdcc_init_data
      00805D CC 80 54         [ 2]   84 	jp	__sdcc_program_startup
      008060                         85 __sdcc_init_data:
                                     86 ; stm8_genXINIT() start
      008060 AE 00 00         [ 2]   87 	ldw x, #l_DATA
      008063 27 07            [ 1]   88 	jreq	00002$
      008065                         89 00001$:
      008065 72 4F 00 00      [ 1]   90 	clr (s_DATA - 1, x)
      008069 5A               [ 2]   91 	decw x
      00806A 26 F9            [ 1]   92 	jrne	00001$
      00806C                         93 00002$:
      00806C AE 00 15         [ 2]   94 	ldw	x, #l_INITIALIZER
      00806F 27 09            [ 1]   95 	jreq	00004$
      008071                         96 00003$:
      008071 D6 80 7C         [ 1]   97 	ld	a, (s_INITIALIZER - 1, x)
      008074 D7 00 00         [ 1]   98 	ld	(s_INITIALIZED - 1, x), a
      008077 5A               [ 2]   99 	decw	x
      008078 26 F7            [ 1]  100 	jrne	00003$
      00807A                        101 00004$:
                                    102 ; stm8_genXINIT() end
                                    103 	.area GSFINAL
      00807A CC 80 54         [ 2]  104 	jp	__sdcc_program_startup
                                    105 ;--------------------------------------------------------
                                    106 ; Home
                                    107 ;--------------------------------------------------------
                                    108 	.area HOME
                                    109 	.area HOME
      008054                        110 __sdcc_program_startup:
      008054 CC 81 33         [ 2]  111 	jp	_main
                                    112 ;	return from main will return to caller
                                    113 ;--------------------------------------------------------
                                    114 ; code
                                    115 ;--------------------------------------------------------
                                    116 	.area CODE
                                    117 ;	src/main.c: 11: static void UART1_ClearIdle(void)
                                    118 ;	-----------------------------------------
                                    119 ;	 function UART1_ClearIdle
                                    120 ;	-----------------------------------------
      008092                        121 _UART1_ClearIdle:
      008092 88               [ 1]  122 	push	a
                                    123 ;	src/main.c: 15: tmp = USART1_SR;  // MUST read SR first
      008093 C6 52 30         [ 1]  124 	ld	a, 0x5230
      008096 6B 01            [ 1]  125 	ld	(0x01, sp), a
                                    126 ;	src/main.c: 16: tmp = USART1_DR;  // THEN read DR
      008098 C6 52 31         [ 1]  127 	ld	a, 0x5231
      00809B 6B 01            [ 1]  128 	ld	(0x01, sp), a
                                    129 ;	src/main.c: 17: (void)tmp;
                                    130 ;	src/main.c: 18: }
      00809D 84               [ 1]  131 	pop	a
      00809E 81               [ 4]  132 	ret
                                    133 ;	src/main.c: 20: void uart_write_c(unsigned char c)
                                    134 ;	-----------------------------------------
                                    135 ;	 function uart_write_c
                                    136 ;	-----------------------------------------
      00809F                        137 _uart_write_c:
      00809F 88               [ 1]  138 	push	a
      0080A0 6B 01            [ 1]  139 	ld	(0x01, sp), a
                                    140 ;	src/main.c: 22: while(!(USART1_SR & USART_SR_TXE));
      0080A2                        141 00101$:
      0080A2 C6 52 30         [ 1]  142 	ld	a, 0x5230
      0080A5 2A FB            [ 1]  143 	jrpl	00101$
                                    144 ;	src/main.c: 23: USART1_DR = c;
      0080A7 AE 52 31         [ 2]  145 	ldw	x, #0x5231
      0080AA 7B 01            [ 1]  146 	ld	a, (0x01, sp)
      0080AC F7               [ 1]  147 	ld	(x), a
                                    148 ;	src/main.c: 24: }
      0080AD 84               [ 1]  149 	pop	a
      0080AE 81               [ 4]  150 	ret
                                    151 ;	src/main.c: 26: void uart_write(const char *str)
                                    152 ;	-----------------------------------------
                                    153 ;	 function uart_write
                                    154 ;	-----------------------------------------
      0080AF                        155 _uart_write:
                                    156 ;	src/main.c: 28: while(*str)
      0080AF                        157 00101$:
      0080AF F6               [ 1]  158 	ld	a, (x)
      0080B0 26 01            [ 1]  159 	jrne	00121$
      0080B2 81               [ 4]  160 	ret
      0080B3                        161 00121$:
                                    162 ;	src/main.c: 30: uart_write_c(*str);
      0080B3 89               [ 2]  163 	pushw	x
      0080B4 CD 80 9F         [ 4]  164 	call	_uart_write_c
      0080B7 85               [ 2]  165 	popw	x
                                    166 ;	src/main.c: 31: str++;
      0080B8 5C               [ 1]  167 	incw	x
      0080B9 20 F4            [ 2]  168 	jra	00101$
                                    169 ;	src/main.c: 33: }
      0080BB 81               [ 4]  170 	ret
                                    171 ;	src/main.c: 35: unsigned char uart_read(unsigned char *buf, unsigned char len)
                                    172 ;	-----------------------------------------
                                    173 ;	 function uart_read
                                    174 ;	-----------------------------------------
      0080BC                        175 _uart_read:
      0080BC 52 04            [ 2]  176 	sub	sp, #4
      0080BE 1F 02            [ 2]  177 	ldw	(0x02, sp), x
      0080C0 6B 01            [ 1]  178 	ld	(0x01, sp), a
                                    179 ;	src/main.c: 41: while (1)
      0080C2 0F 04            [ 1]  180 	clr	(0x04, sp)
      0080C4                        181 00108$:
                                    182 ;	src/main.c: 43: if (USART1_SR & USART_SR_RXNE)	// Data register not empty
      0080C4 72 0B 52 30 16   [ 2]  183 	btjf	0x5230, #5, 00104$
                                    184 ;	src/main.c: 45: data = USART1_DR;	// clear RXNE
      0080C9 C6 52 31         [ 1]  185 	ld	a, 0x5231
                                    186 ;	src/main.c: 46: if (i < len)
      0080CC 88               [ 1]  187 	push	a
      0080CD 7B 05            [ 1]  188 	ld	a, (0x05, sp)
      0080CF 11 02            [ 1]  189 	cp	a, (0x02, sp)
      0080D1 84               [ 1]  190 	pop	a
      0080D2 24 0B            [ 1]  191 	jrnc	00104$
                                    192 ;	src/main.c: 48: buf[i] = data;
      0080D4 5F               [ 1]  193 	clrw	x
      0080D5 41               [ 1]  194 	exg	a, xl
      0080D6 7B 04            [ 1]  195 	ld	a, (0x04, sp)
      0080D8 41               [ 1]  196 	exg	a, xl
      0080D9 72 FB 02         [ 2]  197 	addw	x, (0x02, sp)
      0080DC F7               [ 1]  198 	ld	(x), a
                                    199 ;	src/main.c: 49: i++;
      0080DD 0C 04            [ 1]  200 	inc	(0x04, sp)
      0080DF                        201 00104$:
                                    202 ;	src/main.c: 52: if (USART1_SR & USART_SR_IDLE)
      0080DF 72 09 52 30 E0   [ 2]  203 	btjf	0x5230, #4, 00108$
                                    204 ;	src/main.c: 54: UART1_ClearIdle();
      0080E4 CD 80 92         [ 4]  205 	call	_UART1_ClearIdle
                                    206 ;	src/main.c: 60: buf[i] = '\0';
      0080E7 5F               [ 1]  207 	clrw	x
      0080E8 7B 04            [ 1]  208 	ld	a, (0x04, sp)
      0080EA 97               [ 1]  209 	ld	xl, a
      0080EB 72 FB 02         [ 2]  210 	addw	x, (0x02, sp)
      0080EE 7F               [ 1]  211 	clr	(x)
                                    212 ;	src/main.c: 61: return (i);
      0080EF 7B 04            [ 1]  213 	ld	a, (0x04, sp)
                                    214 ;	src/main.c: 62: }
      0080F1 5B 04            [ 2]  215 	addw	sp, #4
      0080F3 81               [ 4]  216 	ret
                                    217 ;	src/main.c: 64: ISR(uart1_isr, UART1_R_RXNE_vector) {
                                    218 ;	-----------------------------------------
                                    219 ;	 function uart1_isr
                                    220 ;	-----------------------------------------
      0080F4                        221 _uart1_isr:
                                    222 ;	src/main.c: 65: len = uart_read((unsigned char *) buf, 20);
      0080F4 A6 14            [ 1]  223 	ld	a, #0x14
      0080F6 AE 00 01         [ 2]  224 	ldw	x, #(_buf+0)
      0080F9 CD 80 BC         [ 4]  225 	call	_uart_read
      0080FC C7 00 15         [ 1]  226 	ld	_len+0, a
                                    227 ;	src/main.c: 66: }
      0080FF 80               [11]  228 	iret
                                    229 ;	src/main.c: 68: void delay_ms(unsigned long ms)
                                    230 ;	-----------------------------------------
                                    231 ;	 function delay_ms
                                    232 ;	-----------------------------------------
      008100                        233 _delay_ms:
      008100 52 04            [ 2]  234 	sub	sp, #4
                                    235 ;	src/main.c: 70: unsigned long cycles = 1318 * ms;
      008102 1E 09            [ 2]  236 	ldw	x, (0x09, sp)
      008104 89               [ 2]  237 	pushw	x
      008105 1E 09            [ 2]  238 	ldw	x, (0x09, sp)
      008107 89               [ 2]  239 	pushw	x
      008108 4B 26            [ 1]  240 	push	#0x26
      00810A 4B 05            [ 1]  241 	push	#0x05
      00810C 5F               [ 1]  242 	clrw	x
      00810D 89               [ 2]  243 	pushw	x
                                    244 ;	src/main.c: 71: while(cycles--);
      00810E CD 81 8F         [ 4]  245 	call	__mullong
      008111 5B 08            [ 2]  246 	addw	sp, #8
      008113                        247 00101$:
      008113 1F 03            [ 2]  248 	ldw	(0x03, sp), x
      008115 17 01            [ 2]  249 	ldw	(0x01, sp), y
      008117 1D 00 01         [ 2]  250 	subw	x, #0x0001
      00811A 24 02            [ 1]  251 	jrnc	00114$
      00811C 90 5A            [ 2]  252 	decw	y
      00811E                        253 00114$:
      00811E 0D 04            [ 1]  254 	tnz	(0x04, sp)
      008120 26 F1            [ 1]  255 	jrne	00101$
      008122 0D 03            [ 1]  256 	tnz	(0x03, sp)
      008124 26 ED            [ 1]  257 	jrne	00101$
      008126 0D 02            [ 1]  258 	tnz	(0x02, sp)
      008128 26 E9            [ 1]  259 	jrne	00101$
      00812A 0D 01            [ 1]  260 	tnz	(0x01, sp)
      00812C 26 E5            [ 1]  261 	jrne	00101$
                                    262 ;	src/main.c: 72: }
      00812E 1E 05            [ 2]  263 	ldw	x, (5, sp)
      008130 5B 0A            [ 2]  264 	addw	sp, #10
      008132 FC               [ 2]  265 	jp	(x)
                                    266 ;	src/main.c: 74: int main(void)
                                    267 ;	-----------------------------------------
                                    268 ;	 function main
                                    269 ;	-----------------------------------------
      008133                        270 _main:
                                    271 ;	src/main.c: 76: CLK_CKDIVR = 0x00;
      008133 35 00 50 C6      [ 1]  272 	mov	0x50c6+0, #0x00
                                    273 ;	src/main.c: 77: CLK_PCKENR1 = 0xFF; // Enable peripherals
      008137 35 FF 50 C7      [ 1]  274 	mov	0x50c7+0, #0xff
                                    275 ;	src/main.c: 82: USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
      00813B C6 52 35         [ 1]  276 	ld	a, 0x5235
      00813E AA 08            [ 1]  277 	or	a, #0x08
                                    278 ;	src/main.c: 83: USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
      008140 C7 52 35         [ 1]  279 	ld	0x5235, a
      008143 AA 04            [ 1]  280 	or	a, #0x04
      008145 C7 52 35         [ 1]  281 	ld	0x5235, a
                                    282 ;	src/main.c: 84: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
      008148 C6 52 36         [ 1]  283 	ld	a, 0x5236
      00814B A4 CF            [ 1]  284 	and	a, #0xcf
      00814D C7 52 36         [ 1]  285 	ld	0x5236, a
                                    286 ;	src/main.c: 85: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
      008150 35 03 52 33      [ 1]  287 	mov	0x5233+0, #0x03
      008154 35 68 52 32      [ 1]  288 	mov	0x5232+0, #0x68
                                    289 ;	src/main.c: 87: USART1_CR2 |= USART_CR2_RIEN;
      008158 C6 52 35         [ 1]  290 	ld	a, 0x5235
      00815B AA 20            [ 1]  291 	or	a, #0x20
      00815D C7 52 35         [ 1]  292 	ld	0x5235, a
                                    293 ;	src/main.c: 89: rim();
      008160 9A               [ 1]  294 	rim
                                    295 ;	src/main.c: 91: while(1)
      008161                        296 00107$:
                                    297 ;	src/main.c: 93: if (len != 0)
      008161 C6 00 15         [ 1]  298 	ld	a, _len+0
      008164 27 FB            [ 1]  299 	jreq	00107$
                                    300 ;	src/main.c: 95: uart_write((unsigned char *) buf);
      008166 AE 00 01         [ 2]  301 	ldw	x, #(_buf+0)
      008169 CD 80 AF         [ 4]  302 	call	_uart_write
                                    303 ;	src/main.c: 96: len = 0;
      00816C 72 5F 00 15      [ 1]  304 	clr	_len+0
                                    305 ;	src/main.c: 97: while (len < 20)
      008170                        306 00101$:
      008170 C6 00 15         [ 1]  307 	ld	a, _len+0
      008173 A1 14            [ 1]  308 	cp	a, #0x14
      008175 24 0F            [ 1]  309 	jrnc	00103$
                                    310 ;	src/main.c: 98: buf[len++] = 0;
      008177 C6 00 15         [ 1]  311 	ld	a, _len+0
      00817A 72 5C 00 15      [ 1]  312 	inc	_len+0
      00817E 5F               [ 1]  313 	clrw	x
      00817F 97               [ 1]  314 	ld	xl, a
      008180 72 4F 00 01      [ 1]  315 	clr	((_buf+0), x)
      008184 20 EA            [ 2]  316 	jra	00101$
      008186                        317 00103$:
                                    318 ;	src/main.c: 99: len = 0;
      008186 72 5F 00 15      [ 1]  319 	clr	_len+0
      00818A 20 D5            [ 2]  320 	jra	00107$
                                    321 ;	src/main.c: 102: }
      00818C 81               [ 4]  322 	ret
                                    323 	.area CODE
                                    324 	.area CONST
                                    325 	.area INITIALIZER
      00807D                        326 __xinit__buf:
      00807D 00                     327 	.db #0x00	; 0
      00807E 00                     328 	.db 0x00
      00807F 00                     329 	.db 0x00
      008080 00                     330 	.db 0x00
      008081 00                     331 	.db 0x00
      008082 00                     332 	.db 0x00
      008083 00                     333 	.db 0x00
      008084 00                     334 	.db 0x00
      008085 00                     335 	.db 0x00
      008086 00                     336 	.db 0x00
      008087 00                     337 	.db 0x00
      008088 00                     338 	.db 0x00
      008089 00                     339 	.db 0x00
      00808A 00                     340 	.db 0x00
      00808B 00                     341 	.db 0x00
      00808C 00                     342 	.db 0x00
      00808D 00                     343 	.db 0x00
      00808E 00                     344 	.db 0x00
      00808F 00                     345 	.db 0x00
      008090 00                     346 	.db 0x00
      008091                        347 __xinit__len:
      008091 00                     348 	.db #0x00	; 0
                                    349 	.area CABS (ABS)
