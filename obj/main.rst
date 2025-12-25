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
                                     12 	.globl _uart_read
                                     13 	.globl _uart_write
                                     14 	.globl _uart_write_c
                                     15 ;--------------------------------------------------------
                                     16 ; ram data
                                     17 ;--------------------------------------------------------
                                     18 	.area DATA
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area INITIALIZED
                                     23 ;--------------------------------------------------------
                                     24 ; Stack segment in internal ram
                                     25 ;--------------------------------------------------------
                                     26 	.area SSEG
      000001                         27 __start__stack:
      000001                         28 	.ds	1
                                     29 
                                     30 ;--------------------------------------------------------
                                     31 ; absolute external ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DABS (ABS)
                                     34 
                                     35 ; default segment ordering for linker
                                     36 	.area HOME
                                     37 	.area GSINIT
                                     38 	.area GSFINAL
                                     39 	.area CONST
                                     40 	.area INITIALIZER
                                     41 	.area CODE
                                     42 
                                     43 ;--------------------------------------------------------
                                     44 ; interrupt vector
                                     45 ;--------------------------------------------------------
                                     46 	.area HOME
      008000                         47 __interrupt_vect:
      008000 82 00 80 07             48 	int s_GSINIT ; reset
                                     49 ;--------------------------------------------------------
                                     50 ; global & static initialisations
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
                                     53 	.area GSINIT
                                     54 	.area GSFINAL
                                     55 	.area GSINIT
      008007 CD 81 55         [ 4]   56 	call	___sdcc_external_startup
      00800A 4D               [ 1]   57 	tnz	a
      00800B 27 03            [ 1]   58 	jreq	__sdcc_init_data
      00800D CC 80 04         [ 2]   59 	jp	__sdcc_program_startup
      008010                         60 __sdcc_init_data:
                                     61 ; stm8_genXINIT() start
      008010 AE 00 00         [ 2]   62 	ldw x, #l_DATA
      008013 27 07            [ 1]   63 	jreq	00002$
      008015                         64 00001$:
      008015 72 4F 00 00      [ 1]   65 	clr (s_DATA - 1, x)
      008019 5A               [ 2]   66 	decw x
      00801A 26 F9            [ 1]   67 	jrne	00001$
      00801C                         68 00002$:
      00801C AE 00 00         [ 2]   69 	ldw	x, #l_INITIALIZER
      00801F 27 09            [ 1]   70 	jreq	00004$
      008021                         71 00003$:
      008021 D6 80 35         [ 1]   72 	ld	a, (s_INITIALIZER - 1, x)
      008024 D7 00 00         [ 1]   73 	ld	(s_INITIALIZED - 1, x), a
      008027 5A               [ 2]   74 	decw	x
      008028 26 F7            [ 1]   75 	jrne	00003$
      00802A                         76 00004$:
                                     77 ; stm8_genXINIT() end
                                     78 	.area GSFINAL
      00802A CC 80 04         [ 2]   79 	jp	__sdcc_program_startup
                                     80 ;--------------------------------------------------------
                                     81 ; Home
                                     82 ;--------------------------------------------------------
                                     83 	.area HOME
                                     84 	.area HOME
      008004                         85 __sdcc_program_startup:
      008004 CC 80 CB         [ 2]   86 	jp	_main
                                     87 ;	return from main will return to caller
                                     88 ;--------------------------------------------------------
                                     89 ; code
                                     90 ;--------------------------------------------------------
                                     91 	.area CODE
                                     92 ;	src/main.c: 4: static void UART1_ClearIdle(void)
                                     93 ;	-----------------------------------------
                                     94 ;	 function UART1_ClearIdle
                                     95 ;	-----------------------------------------
      008036                         96 _UART1_ClearIdle:
      008036 88               [ 1]   97 	push	a
                                     98 ;	src/main.c: 8: tmp = USART1_SR;  // MUST read SR first
      008037 C6 52 30         [ 1]   99 	ld	a, 0x5230
      00803A 6B 01            [ 1]  100 	ld	(0x01, sp), a
                                    101 ;	src/main.c: 9: tmp = USART1_DR;  // THEN read DR
      00803C C6 52 31         [ 1]  102 	ld	a, 0x5231
      00803F 6B 01            [ 1]  103 	ld	(0x01, sp), a
                                    104 ;	src/main.c: 10: (void)tmp;
                                    105 ;	src/main.c: 11: }
      008041 84               [ 1]  106 	pop	a
      008042 81               [ 4]  107 	ret
                                    108 ;	src/main.c: 13: void uart_write_c(unsigned char c)
                                    109 ;	-----------------------------------------
                                    110 ;	 function uart_write_c
                                    111 ;	-----------------------------------------
      008043                        112 _uart_write_c:
      008043 88               [ 1]  113 	push	a
      008044 6B 01            [ 1]  114 	ld	(0x01, sp), a
                                    115 ;	src/main.c: 15: while(!(USART1_SR & USART_SR_TXE));
      008046                        116 00101$:
      008046 C6 52 30         [ 1]  117 	ld	a, 0x5230
      008049 2A FB            [ 1]  118 	jrpl	00101$
                                    119 ;	src/main.c: 16: USART1_DR = c;
      00804B AE 52 31         [ 2]  120 	ldw	x, #0x5231
      00804E 7B 01            [ 1]  121 	ld	a, (0x01, sp)
      008050 F7               [ 1]  122 	ld	(x), a
                                    123 ;	src/main.c: 17: }
      008051 84               [ 1]  124 	pop	a
      008052 81               [ 4]  125 	ret
                                    126 ;	src/main.c: 19: void uart_write(const char *str)
                                    127 ;	-----------------------------------------
                                    128 ;	 function uart_write
                                    129 ;	-----------------------------------------
      008053                        130 _uart_write:
                                    131 ;	src/main.c: 21: while(*str)
      008053                        132 00101$:
      008053 F6               [ 1]  133 	ld	a, (x)
      008054 26 01            [ 1]  134 	jrne	00121$
      008056 81               [ 4]  135 	ret
      008057                        136 00121$:
                                    137 ;	src/main.c: 23: uart_write_c(*str);
      008057 89               [ 2]  138 	pushw	x
      008058 CD 80 43         [ 4]  139 	call	_uart_write_c
      00805B 85               [ 2]  140 	popw	x
                                    141 ;	src/main.c: 24: str++;
      00805C 5C               [ 1]  142 	incw	x
      00805D 20 F4            [ 2]  143 	jra	00101$
                                    144 ;	src/main.c: 26: }
      00805F 81               [ 4]  145 	ret
                                    146 ;	src/main.c: 28: unsigned char uart_read(unsigned char *buf, unsigned char len)
                                    147 ;	-----------------------------------------
                                    148 ;	 function uart_read
                                    149 ;	-----------------------------------------
      008060                        150 _uart_read:
      008060 52 04            [ 2]  151 	sub	sp, #4
      008062 1F 02            [ 2]  152 	ldw	(0x02, sp), x
      008064 6B 01            [ 1]  153 	ld	(0x01, sp), a
                                    154 ;	src/main.c: 34: while (1)
      008066 0F 04            [ 1]  155 	clr	(0x04, sp)
      008068                        156 00108$:
                                    157 ;	src/main.c: 36: if (USART1_SR & USART_SR_RXNE)	// Data register not empty
      008068 72 0B 52 30 16   [ 2]  158 	btjf	0x5230, #5, 00104$
                                    159 ;	src/main.c: 38: data = USART1_DR;	// clear RXNE
      00806D C6 52 31         [ 1]  160 	ld	a, 0x5231
                                    161 ;	src/main.c: 39: if (i < len)
      008070 88               [ 1]  162 	push	a
      008071 7B 05            [ 1]  163 	ld	a, (0x05, sp)
      008073 11 02            [ 1]  164 	cp	a, (0x02, sp)
      008075 84               [ 1]  165 	pop	a
      008076 24 0B            [ 1]  166 	jrnc	00104$
                                    167 ;	src/main.c: 41: buf[i] = data;
      008078 5F               [ 1]  168 	clrw	x
      008079 41               [ 1]  169 	exg	a, xl
      00807A 7B 04            [ 1]  170 	ld	a, (0x04, sp)
      00807C 41               [ 1]  171 	exg	a, xl
      00807D 72 FB 02         [ 2]  172 	addw	x, (0x02, sp)
      008080 F7               [ 1]  173 	ld	(x), a
                                    174 ;	src/main.c: 42: i++;
      008081 0C 04            [ 1]  175 	inc	(0x04, sp)
      008083                        176 00104$:
                                    177 ;	src/main.c: 45: if (USART1_SR & USART_SR_IDLE)
      008083 72 09 52 30 E0   [ 2]  178 	btjf	0x5230, #4, 00108$
                                    179 ;	src/main.c: 47: UART1_ClearIdle();
      008088 CD 80 36         [ 4]  180 	call	_UART1_ClearIdle
                                    181 ;	src/main.c: 53: buf[i] = '\0';
      00808B 5F               [ 1]  182 	clrw	x
      00808C 7B 04            [ 1]  183 	ld	a, (0x04, sp)
      00808E 97               [ 1]  184 	ld	xl, a
      00808F 72 FB 02         [ 2]  185 	addw	x, (0x02, sp)
      008092 7F               [ 1]  186 	clr	(x)
                                    187 ;	src/main.c: 54: return (i);
      008093 7B 04            [ 1]  188 	ld	a, (0x04, sp)
                                    189 ;	src/main.c: 55: }
      008095 5B 04            [ 2]  190 	addw	sp, #4
      008097 81               [ 4]  191 	ret
                                    192 ;	src/main.c: 57: void delay_ms(unsigned long ms)
                                    193 ;	-----------------------------------------
                                    194 ;	 function delay_ms
                                    195 ;	-----------------------------------------
      008098                        196 _delay_ms:
      008098 52 04            [ 2]  197 	sub	sp, #4
                                    198 ;	src/main.c: 59: unsigned long cycles = 1318 * ms;
      00809A 1E 09            [ 2]  199 	ldw	x, (0x09, sp)
      00809C 89               [ 2]  200 	pushw	x
      00809D 1E 09            [ 2]  201 	ldw	x, (0x09, sp)
      00809F 89               [ 2]  202 	pushw	x
      0080A0 4B 26            [ 1]  203 	push	#0x26
      0080A2 4B 05            [ 1]  204 	push	#0x05
      0080A4 5F               [ 1]  205 	clrw	x
      0080A5 89               [ 2]  206 	pushw	x
                                    207 ;	src/main.c: 60: while(cycles--);
      0080A6 CD 81 57         [ 4]  208 	call	__mullong
      0080A9 5B 08            [ 2]  209 	addw	sp, #8
      0080AB                        210 00101$:
      0080AB 1F 03            [ 2]  211 	ldw	(0x03, sp), x
      0080AD 17 01            [ 2]  212 	ldw	(0x01, sp), y
      0080AF 1D 00 01         [ 2]  213 	subw	x, #0x0001
      0080B2 24 02            [ 1]  214 	jrnc	00114$
      0080B4 90 5A            [ 2]  215 	decw	y
      0080B6                        216 00114$:
      0080B6 0D 04            [ 1]  217 	tnz	(0x04, sp)
      0080B8 26 F1            [ 1]  218 	jrne	00101$
      0080BA 0D 03            [ 1]  219 	tnz	(0x03, sp)
      0080BC 26 ED            [ 1]  220 	jrne	00101$
      0080BE 0D 02            [ 1]  221 	tnz	(0x02, sp)
      0080C0 26 E9            [ 1]  222 	jrne	00101$
      0080C2 0D 01            [ 1]  223 	tnz	(0x01, sp)
      0080C4 26 E5            [ 1]  224 	jrne	00101$
                                    225 ;	src/main.c: 61: }
      0080C6 1E 05            [ 2]  226 	ldw	x, (5, sp)
      0080C8 5B 0A            [ 2]  227 	addw	sp, #10
      0080CA FC               [ 2]  228 	jp	(x)
                                    229 ;	src/main.c: 63: int main(void)
                                    230 ;	-----------------------------------------
                                    231 ;	 function main
                                    232 ;	-----------------------------------------
      0080CB                        233 _main:
      0080CB 52 14            [ 2]  234 	sub	sp, #20
                                    235 ;	src/main.c: 66: unsigned char	buf[20] = {0};
      0080CD 0F 01            [ 1]  236 	clr	(0x01, sp)
      0080CF 0F 02            [ 1]  237 	clr	(0x02, sp)
      0080D1 0F 03            [ 1]  238 	clr	(0x03, sp)
      0080D3 0F 04            [ 1]  239 	clr	(0x04, sp)
      0080D5 0F 05            [ 1]  240 	clr	(0x05, sp)
      0080D7 0F 06            [ 1]  241 	clr	(0x06, sp)
      0080D9 0F 07            [ 1]  242 	clr	(0x07, sp)
      0080DB 0F 08            [ 1]  243 	clr	(0x08, sp)
      0080DD 0F 09            [ 1]  244 	clr	(0x09, sp)
      0080DF 0F 0A            [ 1]  245 	clr	(0x0a, sp)
      0080E1 0F 0B            [ 1]  246 	clr	(0x0b, sp)
      0080E3 0F 0C            [ 1]  247 	clr	(0x0c, sp)
      0080E5 0F 0D            [ 1]  248 	clr	(0x0d, sp)
      0080E7 0F 0E            [ 1]  249 	clr	(0x0e, sp)
      0080E9 0F 0F            [ 1]  250 	clr	(0x0f, sp)
      0080EB 0F 10            [ 1]  251 	clr	(0x10, sp)
      0080ED 0F 11            [ 1]  252 	clr	(0x11, sp)
      0080EF 0F 12            [ 1]  253 	clr	(0x12, sp)
      0080F1 0F 13            [ 1]  254 	clr	(0x13, sp)
      0080F3 0F 14            [ 1]  255 	clr	(0x14, sp)
                                    256 ;	src/main.c: 67: CLK_CKDIVR = 0x00;
      0080F5 35 00 50 C6      [ 1]  257 	mov	0x50c6+0, #0x00
                                    258 ;	src/main.c: 68: CLK_PCKENR1 = 0xFF; // Enable peripherals
      0080F9 35 FF 50 C7      [ 1]  259 	mov	0x50c7+0, #0xff
                                    260 ;	src/main.c: 73: USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
      0080FD C6 52 35         [ 1]  261 	ld	a, 0x5235
      008100 AA 08            [ 1]  262 	or	a, #0x08
                                    263 ;	src/main.c: 74: USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
      008102 C7 52 35         [ 1]  264 	ld	0x5235, a
      008105 AA 04            [ 1]  265 	or	a, #0x04
      008107 C7 52 35         [ 1]  266 	ld	0x5235, a
                                    267 ;	src/main.c: 75: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
      00810A C6 52 36         [ 1]  268 	ld	a, 0x5236
      00810D A4 CF            [ 1]  269 	and	a, #0xcf
      00810F C7 52 36         [ 1]  270 	ld	0x5236, a
                                    271 ;	src/main.c: 76: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
      008112 35 03 52 33      [ 1]  272 	mov	0x5233+0, #0x03
      008116 35 68 52 32      [ 1]  273 	mov	0x5232+0, #0x68
                                    274 ;	src/main.c: 78: while(1)
      00811A                        275 00107$:
                                    276 ;	src/main.c: 81: i = uart_read((unsigned char *) buf, 20);
      00811A A6 14            [ 1]  277 	ld	a, #0x14
      00811C 96               [ 1]  278 	ldw	x, sp
      00811D 5C               [ 1]  279 	incw	x
      00811E CD 80 60         [ 4]  280 	call	_uart_read
                                    281 ;	src/main.c: 82: if (i)
      008121 4D               [ 1]  282 	tnz	a
      008122 27 05            [ 1]  283 	jreq	00113$
                                    284 ;	src/main.c: 83: uart_write((unsigned char *) buf);
      008124 96               [ 1]  285 	ldw	x, sp
      008125 5C               [ 1]  286 	incw	x
      008126 CD 80 53         [ 4]  287 	call	_uart_write
                                    288 ;	src/main.c: 85: while (i < 20)
      008129                        289 00113$:
      008129 90 5F            [ 1]  290 	clrw	y
      00812B                        291 00103$:
      00812B 90 A3 00 14      [ 2]  292 	cpw	y, #0x0014
      00812F 2E 10            [ 1]  293 	jrsge	00105$
                                    294 ;	src/main.c: 86: buf[i--] = 0;
      008131 93               [ 1]  295 	ldw	x, y
      008132 89               [ 2]  296 	pushw	x
      008133 96               [ 1]  297 	ldw	x, sp
      008134 1C 00 03         [ 2]  298 	addw	x, #3
      008137 72 FB 01         [ 2]  299 	addw	x, (1, sp)
      00813A 5B 02            [ 2]  300 	addw	sp, #2
      00813C 90 5A            [ 2]  301 	decw	y
      00813E 7F               [ 1]  302 	clr	(x)
      00813F 20 EA            [ 2]  303 	jra	00103$
      008141                        304 00105$:
                                    305 ;	src/main.c: 87: uart_write("Nothing\n");
      008141 AE 80 2D         [ 2]  306 	ldw	x, #(___str_0+0)
      008144 CD 80 53         [ 4]  307 	call	_uart_write
                                    308 ;	src/main.c: 88: delay_ms(1000);
      008147 4B E8            [ 1]  309 	push	#0xe8
      008149 4B 03            [ 1]  310 	push	#0x03
      00814B 5F               [ 1]  311 	clrw	x
      00814C 89               [ 2]  312 	pushw	x
      00814D CD 80 98         [ 4]  313 	call	_delay_ms
      008150 20 C8            [ 2]  314 	jra	00107$
                                    315 ;	src/main.c: 90: }
      008152 5B 14            [ 2]  316 	addw	sp, #20
      008154 81               [ 4]  317 	ret
                                    318 	.area CODE
                                    319 	.area CONST
                                    320 	.area CONST
      00802D                        321 ___str_0:
      00802D 4E 6F 74 68 69 6E 67   322 	.ascii "Nothing"
      008034 0A                     323 	.db 0x0a
      008035 00                     324 	.db 0x00
                                    325 	.area CODE
                                    326 	.area INITIALIZER
                                    327 	.area CABS (ABS)
