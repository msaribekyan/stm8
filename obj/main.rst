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
                                     13 	.globl _uart_read_c
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
                                     24 ;--------------------------------------------------------
                                     25 ; Stack segment in internal ram
                                     26 ;--------------------------------------------------------
                                     27 	.area SSEG
      000001                         28 __start__stack:
      000001                         29 	.ds	1
                                     30 
                                     31 ;--------------------------------------------------------
                                     32 ; absolute external ram data
                                     33 ;--------------------------------------------------------
                                     34 	.area DABS (ABS)
                                     35 
                                     36 ; default segment ordering for linker
                                     37 	.area HOME
                                     38 	.area GSINIT
                                     39 	.area GSFINAL
                                     40 	.area CONST
                                     41 	.area INITIALIZER
                                     42 	.area CODE
                                     43 
                                     44 ;--------------------------------------------------------
                                     45 ; interrupt vector
                                     46 ;--------------------------------------------------------
                                     47 	.area HOME
      008000                         48 __interrupt_vect:
      008000 82 00 80 07             49 	int s_GSINIT ; reset
                                     50 ;--------------------------------------------------------
                                     51 ; global & static initialisations
                                     52 ;--------------------------------------------------------
                                     53 	.area HOME
                                     54 	.area GSINIT
                                     55 	.area GSFINAL
                                     56 	.area GSINIT
      008007 CD 81 31         [ 4]   57 	call	___sdcc_external_startup
      00800A 4D               [ 1]   58 	tnz	a
      00800B 27 03            [ 1]   59 	jreq	__sdcc_init_data
      00800D CC 80 04         [ 2]   60 	jp	__sdcc_program_startup
      008010                         61 __sdcc_init_data:
                                     62 ; stm8_genXINIT() start
      008010 AE 00 00         [ 2]   63 	ldw x, #l_DATA
      008013 27 07            [ 1]   64 	jreq	00002$
      008015                         65 00001$:
      008015 72 4F 00 00      [ 1]   66 	clr (s_DATA - 1, x)
      008019 5A               [ 2]   67 	decw x
      00801A 26 F9            [ 1]   68 	jrne	00001$
      00801C                         69 00002$:
      00801C AE 00 00         [ 2]   70 	ldw	x, #l_INITIALIZER
      00801F 27 09            [ 1]   71 	jreq	00004$
      008021                         72 00003$:
      008021 D6 80 3A         [ 1]   73 	ld	a, (s_INITIALIZER - 1, x)
      008024 D7 00 00         [ 1]   74 	ld	(s_INITIALIZED - 1, x), a
      008027 5A               [ 2]   75 	decw	x
      008028 26 F7            [ 1]   76 	jrne	00003$
      00802A                         77 00004$:
                                     78 ; stm8_genXINIT() end
                                     79 	.area GSFINAL
      00802A CC 80 04         [ 2]   80 	jp	__sdcc_program_startup
                                     81 ;--------------------------------------------------------
                                     82 ; Home
                                     83 ;--------------------------------------------------------
                                     84 	.area HOME
                                     85 	.area HOME
      008004                         86 __sdcc_program_startup:
      008004 CC 80 BD         [ 2]   87 	jp	_main
                                     88 ;	return from main will return to caller
                                     89 ;--------------------------------------------------------
                                     90 ; code
                                     91 ;--------------------------------------------------------
                                     92 	.area CODE
                                     93 ;	src/main.c: 4: void uart_write_c(unsigned char c)
                                     94 ;	-----------------------------------------
                                     95 ;	 function uart_write_c
                                     96 ;	-----------------------------------------
      00803B                         97 _uart_write_c:
      00803B 88               [ 1]   98 	push	a
      00803C 6B 01            [ 1]   99 	ld	(0x01, sp), a
                                    100 ;	src/main.c: 6: while(!(USART1_SR & USART_SR_TXE));
      00803E                        101 00101$:
      00803E C6 52 30         [ 1]  102 	ld	a, 0x5230
      008041 2A FB            [ 1]  103 	jrpl	00101$
                                    104 ;	src/main.c: 7: USART1_DR = c;
      008043 AE 52 31         [ 2]  105 	ldw	x, #0x5231
      008046 7B 01            [ 1]  106 	ld	a, (0x01, sp)
      008048 F7               [ 1]  107 	ld	(x), a
                                    108 ;	src/main.c: 8: }
      008049 84               [ 1]  109 	pop	a
      00804A 81               [ 4]  110 	ret
                                    111 ;	src/main.c: 10: void uart_write(const char *str)
                                    112 ;	-----------------------------------------
                                    113 ;	 function uart_write
                                    114 ;	-----------------------------------------
      00804B                        115 _uart_write:
                                    116 ;	src/main.c: 12: while(*str)
      00804B                        117 00101$:
      00804B F6               [ 1]  118 	ld	a, (x)
      00804C 26 01            [ 1]  119 	jrne	00121$
      00804E 81               [ 4]  120 	ret
      00804F                        121 00121$:
                                    122 ;	src/main.c: 14: uart_write_c(*str);
      00804F 89               [ 2]  123 	pushw	x
      008050 CD 80 3B         [ 4]  124 	call	_uart_write_c
      008053 85               [ 2]  125 	popw	x
                                    126 ;	src/main.c: 15: str++;
      008054 5C               [ 1]  127 	incw	x
      008055 20 F4            [ 2]  128 	jra	00101$
                                    129 ;	src/main.c: 17: }
      008057 81               [ 4]  130 	ret
                                    131 ;	src/main.c: 19: void uart_read_c(unsigned char *c)
                                    132 ;	-----------------------------------------
                                    133 ;	 function uart_read_c
                                    134 ;	-----------------------------------------
      008058                        135 _uart_read_c:
                                    136 ;	src/main.c: 21: while (!(USART1_SR & USART_SR_RXNE));    // USART_SR[5]:RXNE   Read data register not empty
      008058                        137 00101$:
      008058 72 0B 52 30 FB   [ 2]  138 	btjf	0x5230, #5, 00101$
                                    139 ;	src/main.c: 23: *c = USART1_DR;
      00805D C6 52 31         [ 1]  140 	ld	a, 0x5231
      008060 F7               [ 1]  141 	ld	(x), a
                                    142 ;	src/main.c: 24: }
      008061 81               [ 4]  143 	ret
                                    144 ;	src/main.c: 26: void uart_read(unsigned char *buf, unsigned char len)
                                    145 ;	-----------------------------------------
                                    146 ;	 function uart_read
                                    147 ;	-----------------------------------------
      008062                        148 _uart_read:
      008062 52 04            [ 2]  149 	sub	sp, #4
      008064 1F 02            [ 2]  150 	ldw	(0x02, sp), x
      008066 6B 01            [ 1]  151 	ld	(0x01, sp), a
                                    152 ;	src/main.c: 31: while (!(USART1_SR & USART_SR_IDLE) && i < len)
      008068 0F 04            [ 1]  153 	clr	(0x04, sp)
      00806A                        154 00102$:
      00806A C6 52 30         [ 1]  155 	ld	a, 0x5230
                                    156 ;	src/main.c: 33: uart_read_c(buf + i);
      00806D 5F               [ 1]  157 	clrw	x
      00806E 41               [ 1]  158 	exg	a, xl
      00806F 7B 04            [ 1]  159 	ld	a, (0x04, sp)
      008071 41               [ 1]  160 	exg	a, xl
      008072 72 FB 02         [ 2]  161 	addw	x, (0x02, sp)
                                    162 ;	src/main.c: 31: while (!(USART1_SR & USART_SR_IDLE) && i < len)
      008075 A5 10            [ 1]  163 	bcp	a, #0x10
      008077 26 0D            [ 1]  164 	jrne	00104$
      008079 7B 04            [ 1]  165 	ld	a, (0x04, sp)
      00807B 11 01            [ 1]  166 	cp	a, (0x01, sp)
      00807D 24 07            [ 1]  167 	jrnc	00104$
                                    168 ;	src/main.c: 33: uart_read_c(buf + i);
      00807F CD 80 58         [ 4]  169 	call	_uart_read_c
                                    170 ;	src/main.c: 34: i++;
      008082 0C 04            [ 1]  171 	inc	(0x04, sp)
      008084 20 E4            [ 2]  172 	jra	00102$
      008086                        173 00104$:
                                    174 ;	src/main.c: 36: buf[i] = '\0';
      008086 7F               [ 1]  175 	clr	(x)
                                    176 ;	src/main.c: 37: }
      008087 5B 04            [ 2]  177 	addw	sp, #4
      008089 81               [ 4]  178 	ret
                                    179 ;	src/main.c: 39: void delay_ms(unsigned long ms)
                                    180 ;	-----------------------------------------
                                    181 ;	 function delay_ms
                                    182 ;	-----------------------------------------
      00808A                        183 _delay_ms:
      00808A 52 04            [ 2]  184 	sub	sp, #4
                                    185 ;	src/main.c: 41: unsigned long cycles = 960 * ms;
      00808C 1E 09            [ 2]  186 	ldw	x, (0x09, sp)
      00808E 89               [ 2]  187 	pushw	x
      00808F 1E 09            [ 2]  188 	ldw	x, (0x09, sp)
      008091 89               [ 2]  189 	pushw	x
      008092 4B C0            [ 1]  190 	push	#0xc0
      008094 4B 03            [ 1]  191 	push	#0x03
      008096 5F               [ 1]  192 	clrw	x
      008097 89               [ 2]  193 	pushw	x
                                    194 ;	src/main.c: 42: while(cycles--);
      008098 CD 81 33         [ 4]  195 	call	__mullong
      00809B 5B 08            [ 2]  196 	addw	sp, #8
      00809D                        197 00101$:
      00809D 1F 03            [ 2]  198 	ldw	(0x03, sp), x
      00809F 17 01            [ 2]  199 	ldw	(0x01, sp), y
      0080A1 1D 00 01         [ 2]  200 	subw	x, #0x0001
      0080A4 24 02            [ 1]  201 	jrnc	00114$
      0080A6 90 5A            [ 2]  202 	decw	y
      0080A8                        203 00114$:
      0080A8 0D 04            [ 1]  204 	tnz	(0x04, sp)
      0080AA 26 F1            [ 1]  205 	jrne	00101$
      0080AC 0D 03            [ 1]  206 	tnz	(0x03, sp)
      0080AE 26 ED            [ 1]  207 	jrne	00101$
      0080B0 0D 02            [ 1]  208 	tnz	(0x02, sp)
      0080B2 26 E9            [ 1]  209 	jrne	00101$
      0080B4 0D 01            [ 1]  210 	tnz	(0x01, sp)
      0080B6 26 E5            [ 1]  211 	jrne	00101$
                                    212 ;	src/main.c: 43: }
      0080B8 1E 05            [ 2]  213 	ldw	x, (5, sp)
      0080BA 5B 0A            [ 2]  214 	addw	sp, #10
      0080BC FC               [ 2]  215 	jp	(x)
                                    216 ;	src/main.c: 45: int main(void)
                                    217 ;	-----------------------------------------
                                    218 ;	 function main
                                    219 ;	-----------------------------------------
      0080BD                        220 _main:
      0080BD 52 14            [ 2]  221 	sub	sp, #20
                                    222 ;	src/main.c: 48: unsigned char	buf[20] = {0};
      0080BF 0F 01            [ 1]  223 	clr	(0x01, sp)
      0080C1 0F 02            [ 1]  224 	clr	(0x02, sp)
      0080C3 0F 03            [ 1]  225 	clr	(0x03, sp)
      0080C5 0F 04            [ 1]  226 	clr	(0x04, sp)
      0080C7 0F 05            [ 1]  227 	clr	(0x05, sp)
      0080C9 0F 06            [ 1]  228 	clr	(0x06, sp)
      0080CB 0F 07            [ 1]  229 	clr	(0x07, sp)
      0080CD 0F 08            [ 1]  230 	clr	(0x08, sp)
      0080CF 0F 09            [ 1]  231 	clr	(0x09, sp)
      0080D1 0F 0A            [ 1]  232 	clr	(0x0a, sp)
      0080D3 0F 0B            [ 1]  233 	clr	(0x0b, sp)
      0080D5 0F 0C            [ 1]  234 	clr	(0x0c, sp)
      0080D7 0F 0D            [ 1]  235 	clr	(0x0d, sp)
      0080D9 0F 0E            [ 1]  236 	clr	(0x0e, sp)
      0080DB 0F 0F            [ 1]  237 	clr	(0x0f, sp)
      0080DD 0F 10            [ 1]  238 	clr	(0x10, sp)
      0080DF 0F 11            [ 1]  239 	clr	(0x11, sp)
      0080E1 0F 12            [ 1]  240 	clr	(0x12, sp)
      0080E3 0F 13            [ 1]  241 	clr	(0x13, sp)
      0080E5 0F 14            [ 1]  242 	clr	(0x14, sp)
                                    243 ;	src/main.c: 49: CLK_CKDIVR = 0x00;
      0080E7 35 00 50 C6      [ 1]  244 	mov	0x50c6+0, #0x00
                                    245 ;	src/main.c: 50: CLK_PCKENR1 = 0xFF; // Enable peripherals
      0080EB 35 FF 50 C7      [ 1]  246 	mov	0x50c7+0, #0xff
                                    247 ;	src/main.c: 55: USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
      0080EF C6 52 35         [ 1]  248 	ld	a, 0x5235
      0080F2 AA 08            [ 1]  249 	or	a, #0x08
                                    250 ;	src/main.c: 56: USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
      0080F4 C7 52 35         [ 1]  251 	ld	0x5235, a
      0080F7 AA 04            [ 1]  252 	or	a, #0x04
      0080F9 C7 52 35         [ 1]  253 	ld	0x5235, a
                                    254 ;	src/main.c: 57: USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
      0080FC C6 52 36         [ 1]  255 	ld	a, 0x5236
      0080FF A4 CF            [ 1]  256 	and	a, #0xcf
      008101 C7 52 36         [ 1]  257 	ld	0x5236, a
                                    258 ;	src/main.c: 58: USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
      008104 35 03 52 33      [ 1]  259 	mov	0x5233+0, #0x03
      008108 35 68 52 32      [ 1]  260 	mov	0x5232+0, #0x68
                                    261 ;	src/main.c: 60: while(1)
      00810C                        262 00104$:
                                    263 ;	src/main.c: 63: if (!(USART1_SR & USART_SR_RXNE))
      00810C 72 0A 52 30 0C   [ 2]  264 	btjt	0x5230, #5, 00102$
                                    265 ;	src/main.c: 65: uart_read((unsigned char *) buf, 20);
      008111 A6 14            [ 1]  266 	ld	a, #0x14
      008113 96               [ 1]  267 	ldw	x, sp
      008114 5C               [ 1]  268 	incw	x
      008115 CD 80 62         [ 4]  269 	call	_uart_read
                                    270 ;	src/main.c: 66: uart_write((unsigned char *) buf);
      008118 96               [ 1]  271 	ldw	x, sp
      008119 5C               [ 1]  272 	incw	x
      00811A CD 80 4B         [ 4]  273 	call	_uart_write
      00811D                        274 00102$:
                                    275 ;	src/main.c: 69: uart_write("Hello World!\n");
      00811D AE 80 2D         [ 2]  276 	ldw	x, #(___str_0+0)
      008120 CD 80 4B         [ 4]  277 	call	_uart_write
                                    278 ;	src/main.c: 70: delay_ms(1000);	
      008123 4B E8            [ 1]  279 	push	#0xe8
      008125 4B 03            [ 1]  280 	push	#0x03
      008127 5F               [ 1]  281 	clrw	x
      008128 89               [ 2]  282 	pushw	x
      008129 CD 80 8A         [ 4]  283 	call	_delay_ms
      00812C 20 DE            [ 2]  284 	jra	00104$
                                    285 ;	src/main.c: 72: }
      00812E 5B 14            [ 2]  286 	addw	sp, #20
      008130 81               [ 4]  287 	ret
                                    288 	.area CODE
                                    289 	.area CONST
                                    290 	.area CONST
      00802D                        291 ___str_0:
      00802D 48 65 6C 6C 6F 20 57   292 	.ascii "Hello World!"
             6F 72 6C 64 21
      008039 0A                     293 	.db 0x0a
      00803A 00                     294 	.db 0x00
                                    295 	.area CODE
                                    296 	.area INITIALIZER
                                    297 	.area CABS (ABS)
